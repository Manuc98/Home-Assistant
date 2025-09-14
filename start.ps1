# Script de Inicialização da Casa Inteligente - PowerShell
# Automatiza o processo de configuração e inicialização no Windows

Write-Host "🏠 Iniciando Casa Inteligente - Home Assistant" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan

# Função para log com timestamp
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $color = switch ($Level) {
        "ERROR" { "Red" }
        "SUCCESS" { "Green" }
        "WARNING" { "Yellow" }
        default { "Blue" }
    }
    Write-Host "[$timestamp] [$Level] $Message" -ForegroundColor $color
}

# Verificar se Docker está instalado
Write-Log "Verificando dependências..."
try {
    docker --version | Out-Null
    docker-compose --version | Out-Null
    Write-Log "Docker e Docker Compose encontrados" -Level "SUCCESS"
} catch {
    Write-Log "Docker ou Docker Compose não está instalado. Instale o Docker Desktop primeiro." -Level "ERROR"
    exit 1
}

# Verificar se Docker Desktop está rodando
Write-Log "Verificando se Docker Desktop está rodando..."
try {
    docker ps | Out-Null
    Write-Log "Docker Desktop está rodando" -Level "SUCCESS"
} catch {
    Write-Log "Docker Desktop não está rodando!" -Level "ERROR"
    Write-Log "Por favor, inicie o Docker Desktop e aguarde até que esteja totalmente carregado." -Level "WARNING"
    Write-Log "Você pode iniciar o Docker Desktop através do menu Iniciar ou clicando no ícone na bandeja do sistema." -Level "WARNING"
    
    # Tentar abrir o Docker Desktop
    $response = Read-Host "Deseja que eu tente abrir o Docker Desktop automaticamente? (s/n)"
    if ($response -match "^[Ss]$") {
        try {
            Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"
            Write-Log "Docker Desktop iniciado. Aguarde alguns minutos para ele carregar completamente." -Level "SUCCESS"
            Write-Host "Pressione Enter quando o Docker Desktop estiver rodando..." -ForegroundColor Yellow
            Read-Host
        } catch {
            Write-Log "Não foi possível abrir o Docker Desktop automaticamente." -Level "WARNING"
            Write-Log "Por favor, abra manualmente o Docker Desktop e execute este script novamente." -Level "WARNING"
            exit 1
        }
    } else {
        Write-Log "Execute este script novamente após iniciar o Docker Desktop." -Level "WARNING"
        exit 1
    }
}

# Verificar se o arquivo secrets.yaml existe
if (-not (Test-Path "config/secrets.yaml")) {
    Write-Log "Arquivo secrets.yaml não encontrado" -Level "WARNING"
    Write-Log "Criando arquivo de exemplo..."
    
    $secretsContent = @"
# Arquivo de Segredos - Casa Inteligente
# IMPORTANTE: Configure suas chaves de API aqui!

# MQTT
mqtt_username: admin
mqtt_password: sua_senha_mqtt_aqui

# Telegram
telegram_api_key: seu_bot_token_telegram_aqui
telegram_chat_id: seu_chat_id_telegram_aqui

# Email
email_sender: seu_email@gmail.com
email_username: seu_email@gmail.com
email_password: sua_senha_app_gmail_aqui
email_recipient: seu_email_destinatario@gmail.com

# OpenWeatherMap
openweather_api_key: sua_chave_openweathermap_aqui

# Forecast Solar
forecast_solar_api_key: sua_chave_forecast_solar_aqui

# Google
google_client_id: seu_client_id_google_aqui
google_client_secret: seu_client_secret_google_aqui

# InfluxDB
influxdb_password: homeassistant123

# Backup
backup_password: sua_senha_backup_aqui

# WiFi credentials (para dispositivos IoT)
wifi_ssid: seu_wifi_ssid
wifi_password: sua_senha_wifi

# Chaves de API adicionais
spotify_client_id: seu_spotify_client_id
spotify_client_secret: seu_spotify_client_secret

# Integração com bancos
bank_api_key: sua_chave_api_banco_aqui

# Serviços de emergência
emergency_contact: +351912345678
police_number: 112
fire_number: 112
medical_number: 112
"@
    
    $secretsContent | Out-File -FilePath "config/secrets.yaml" -Encoding UTF8
    Write-Log "Arquivo secrets.yaml criado. Configure suas chaves de API antes de continuar." -Level "WARNING"
    Write-Host "Pressione Enter após configurar o arquivo secrets.yaml..." -ForegroundColor Yellow
    Read-Host
}

# Criar diretórios necessários
Write-Log "Criando estrutura de diretórios..."
$directories = @(
    "config/www",
    "config/custom_components",
    "mosquitto/data",
    "mosquitto/log",
    "zigbee2mqtt/data",
    "zigbee2mqtt/log",
    "influxdb/data",
    "influxdb/config",
    "grafana/data",
    "nginx/ssl"
)

foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
}

Write-Log "Estrutura de diretórios criada" -Level "SUCCESS"

# Gerar certificados SSL auto-assinados (para desenvolvimento)
if (-not (Test-Path "nginx/ssl/casa-inteligente.crt")) {
    Write-Log "Gerando certificados SSL auto-assinados..."
    
    # Verificar se OpenSSL está disponível
    try {
        openssl version | Out-Null
        $opensslCmd = "openssl"
    } catch {
        # Tentar usar o OpenSSL do Git
        if (Test-Path "C:\Program Files\Git\usr\bin\openssl.exe") {
            $opensslCmd = "C:\Program Files\Git\usr\bin\openssl.exe"
        } else {
            Write-Log "OpenSSL não encontrado. Certificados SSL não foram gerados." -Level "WARNING"
            Write-Log "Você pode gerar certificados SSL posteriormente ou usar HTTP." -Level "WARNING"
        }
    }
    
    if ($opensslCmd) {
        $opensslArgs = @(
            "req", "-x509", "-nodes", "-days", "365", "-newkey", "rsa:2048",
            "-keyout", "nginx/ssl/casa-inteligente.key",
            "-out", "nginx/ssl/casa-inteligente.crt",
            "-subj", "/C=PT/ST=Lisbon/L=Lisbon/O=Casa Inteligente/CN=casa-inteligente.local"
        )
        
        & $opensslCmd @opensslArgs
        Write-Log "Certificados SSL gerados" -Level "SUCCESS"
    }
} else {
    Write-Log "Certificados SSL já existem"
}

# Verificar se as portas estão disponíveis
Write-Log "Verificando portas disponíveis..."
$ports = @(80, 443, 8123, 1883, 8086, 3000, 8080, 9001)
$portsInUse = @()

foreach ($port in $ports) {
    try {
        $connection = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
        if ($connection) {
            Write-Log "Porta $port já está em uso" -Level "WARNING"
            $portsInUse += $port
        } else {
            Write-Log "Porta $port disponível" -Level "SUCCESS"
        }
    } catch {
        Write-Log "Porta $port disponível" -Level "SUCCESS"
    }
}

# Avisar sobre portas em uso
if ($portsInUse.Count -gt 0) {
    Write-Log "As seguintes portas estão em uso: $($portsInUse -join ', ')" -Level "WARNING"
    Write-Log "Isso pode causar conflitos. Considere parar os serviços que usam essas portas." -Level "WARNING"
    
    $response = Read-Host "Deseja continuar mesmo assim? (s/n)"
    if ($response -notmatch "^[Ss]$") {
        Write-Log "Instalação cancelada pelo usuário." -Level "WARNING"
        exit 0
    }
}

# Parar containers existentes
Write-Log "Parando containers existentes..."
try {
    docker-compose down
    Write-Log "Containers parados com sucesso" -Level "SUCCESS"
} catch {
    Write-Log "Nenhum container estava rodando" -Level "SUCCESS"
}

# Construir e iniciar os serviços
Write-Log "Construindo e iniciando serviços..."
try {
    docker-compose -f docker-compose.yml -f docker-compose.override.yml up -d --build
    Write-Log "Serviços iniciados com sucesso" -Level "SUCCESS"
} catch {
    Write-Log "Erro ao iniciar serviços. Verificando logs..." -Level "ERROR"
    docker-compose -f docker-compose.yml -f docker-compose.override.yml logs
    Write-Log "Por favor, verifique os logs acima e tente novamente." -Level "ERROR"
    exit 1
}

# Aguardar serviços iniciarem
Write-Log "Aguardando serviços iniciarem..."
Start-Sleep -Seconds 30

# Verificar status dos serviços
Write-Log "Verificando status dos serviços..."
try {
    docker-compose -f docker-compose.yml -f docker-compose.override.yml ps
} catch {
    Write-Log "Erro ao verificar status dos serviços" -Level "ERROR"
}

# Verificar logs do Home Assistant
Write-Log "Verificando logs do Home Assistant..."
try {
    $logs = docker-compose -f docker-compose.yml -f docker-compose.override.yml logs homeassistant
    if ($logs -match "Home Assistant initialized") {
        Write-Log "Home Assistant inicializado com sucesso" -Level "SUCCESS"
    } else {
        Write-Log "Home Assistant pode estar ainda inicializando..." -Level "WARNING"
        Write-Log "Verifique os logs com: docker-compose logs homeassistant" -Level "WARNING"
    }
} catch {
    Write-Log "Erro ao verificar logs do Home Assistant" -Level "WARNING"
}

# Configurar hosts locais (opcional)
Write-Log "Configurando hosts locais..."
$hostsFile = "$env:SystemRoot\System32\drivers\etc\hosts"
$hostsContent = Get-Content $hostsFile

if ($hostsContent -notmatch "casa-inteligente.local") {
    $newHosts = @(
        "127.0.0.1 casa-inteligente.local",
        "127.0.0.1 grafana.casa-inteligente.local",
        "127.0.0.1 zigbee.casa-inteligente.local",
        "127.0.0.1 influxdb.casa-inteligente.local"
    )
    
    try {
        $newHosts | Add-Content $hostsFile
        Write-Log "Hosts locais configurados" -Level "SUCCESS"
    } catch {
        Write-Log "Não foi possível configurar hosts locais automaticamente. Configure manualmente se necessário." -Level "WARNING"
    }
} else {
    Write-Log "Hosts locais já configurados"
}

# Exibir informações de acesso
Write-Host ""
Write-Host "🎉 Casa Inteligente iniciada com sucesso!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""
Write-Host "📱 Acessos disponíveis:" -ForegroundColor Cyan
Write-Host "  • Home Assistant: https://casa-inteligente.local:8123" -ForegroundColor White
Write-Host "  • Grafana: https://grafana.casa-inteligente.local:3000" -ForegroundColor White
Write-Host "  • Zigbee2MQTT: https://zigbee.casa-inteligente.local:8080" -ForegroundColor White
Write-Host "  • InfluxDB: https://influxdb.casa-inteligente.local:8086" -ForegroundColor White
Write-Host ""
Write-Host "🔑 Credenciais padrão:" -ForegroundColor Yellow
Write-Host "  • Home Assistant: Configure na primeira execução" -ForegroundColor White
Write-Host "  • Grafana: admin / admin123" -ForegroundColor White
Write-Host "  • InfluxDB: admin / homeassistant123" -ForegroundColor White
Write-Host ""
Write-Host "📋 Comandos úteis:" -ForegroundColor Magenta
Write-Host "  • Ver logs: docker-compose logs -f homeassistant" -ForegroundColor White
Write-Host "  • Parar serviços: docker-compose down" -ForegroundColor White
Write-Host "  • Reiniciar: docker-compose restart" -ForegroundColor White
Write-Host "  • Atualizar: docker-compose pull; docker-compose up -d" -ForegroundColor White
Write-Host ""
Write-Host "⚠️  IMPORTANTE:" -ForegroundColor Red
Write-Host "  • Configure suas chaves de API no arquivo config/secrets.yaml" -ForegroundColor White
Write-Host "  • Adicione seus dispositivos IoT através da interface" -ForegroundColor White
Write-Host "  • Configure as automações conforme suas necessidades" -ForegroundColor White
Write-Host ""
Write-Host "📚 Documentação completa disponível no README.md" -ForegroundColor Cyan
Write-Host ""
Write-Host "🚀 Sua casa inteligente está pronta para uso!" -ForegroundColor Green
Write-Host ""

# Opção para abrir o navegador
$response = Read-Host "Deseja abrir o Home Assistant no navegador? (s/n)"
if ($response -match "^[Ss]$") {
    Start-Process "https://casa-inteligente.local:8123"
}

Write-Host ""
Write-Host "🏠 Casa Inteligente configurada e rodando!" -ForegroundColor Green
Write-Host "   Aproveite sua nova casa inteligente! ✨" -ForegroundColor Cyan
