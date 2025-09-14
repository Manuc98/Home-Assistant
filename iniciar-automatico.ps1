# Script de Inicialização Automática da Casa Inteligente
# Executa tudo automaticamente sem intervenção do usuário

Write-Host "🏠 Iniciando Casa Inteligente Automaticamente..." -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan

# Função para log
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

# Verificar Docker
Write-Log "Verificando Docker Desktop..."
try {
    docker ps | Out-Null
    Write-Log "Docker Desktop está rodando" -Level "SUCCESS"
} catch {
    Write-Log "Iniciando Docker Desktop..." -Level "WARNING"
    try {
        Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe" -WindowStyle Hidden
        Write-Log "Docker Desktop iniciado. Aguardando carregar..." -Level "INFO"
        Start-Sleep -Seconds 60
    } catch {
        Write-Log "Erro ao iniciar Docker Desktop" -Level "ERROR"
        exit 1
    }
}

# Aguardar Docker carregar completamente
Write-Log "Aguardando Docker Desktop carregar completamente..."
$maxAttempts = 30
$attempt = 0

while ($attempt -lt $maxAttempts) {
    try {
        docker ps | Out-Null
        Write-Log "Docker Desktop pronto!" -Level "SUCCESS"
        break
    } catch {
        $attempt++
        Write-Log "Tentativa $attempt/$maxAttempts - Aguardando Docker..." -Level "INFO"
        Start-Sleep -Seconds 10
    }
}

if ($attempt -eq $maxAttempts) {
    Write-Log "Timeout aguardando Docker Desktop" -Level "ERROR"
    exit 1
}

# Parar containers existentes
Write-Log "Parando containers existentes..."
try {
    docker-compose down
    Write-Log "Containers parados" -Level "SUCCESS"
} catch {
    Write-Log "Nenhum container estava rodando" -Level "SUCCESS"
}

# Iniciar serviços
Write-Log "Iniciando todos os serviços..."
try {
    docker-compose up -d
    Write-Log "Serviços iniciados com sucesso" -Level "SUCCESS"
} catch {
    Write-Log "Erro ao iniciar serviços" -Level "ERROR"
    exit 1
}

# Aguardar serviços estabilizarem
Write-Log "Aguardando serviços estabilizarem..."
Start-Sleep -Seconds 60

# Verificar status
Write-Log "Verificando status dos serviços..."
docker-compose ps

# Verificar se Home Assistant está respondendo
Write-Log "Verificando Home Assistant..."
$maxAttempts = 20
$attempt = 0

while ($attempt -lt $maxAttempts) {
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8123" -TimeoutSec 5 -UseBasicParsing
        if ($response.StatusCode -eq 200) {
            Write-Log "Home Assistant está funcionando!" -Level "SUCCESS"
            break
        }
    } catch {
        $attempt++
        Write-Log "Tentativa $attempt/$maxAttempts - Aguardando Home Assistant..." -Level "INFO"
        Start-Sleep -Seconds 15
    }
}

# Abrir Home Assistant no navegador
Write-Log "Abrindo Home Assistant no navegador..."
try {
    Start-Process "http://localhost:8123"
    Write-Log "Home Assistant aberto no navegador" -Level "SUCCESS"
} catch {
    Write-Log "Erro ao abrir navegador" -Level "WARNING"
}

# Criar arquivo de status
$statusFile = "sistema_status.txt"
$status = @"
Casa Inteligente - Status do Sistema
====================================
Data/Hora: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Status: FUNCIONANDO

Serviços:
- Home Assistant: http://localhost:8123
- InfluxDB: http://localhost:8086
- Grafana: http://localhost:3000 (pode demorar para carregar)

Comandos Úteis:
- Ver status: docker-compose ps
- Ver logs: docker-compose logs homeassistant
- Parar: docker-compose down
- Iniciar: docker-compose up -d

Próximos Passos:
1. Configure sua conta no Home Assistant
2. Configure suas chaves de API em config/secrets.yaml
3. Adicione seus dispositivos IoT
4. Personalize as automações

Sistema pronto para uso! 🏠✨
"@

$status | Out-File -FilePath $statusFile -Encoding UTF8

Write-Log "Sistema iniciado com sucesso!" -Level "SUCCESS"
Write-Log "Status salvo em: $statusFile" -Level "SUCCESS"
Write-Log "Acesse: http://localhost:8123" -Level "SUCCESS"

Write-Host ""
Write-Host "🎉 Casa Inteligente está funcionando!" -ForegroundColor Green
Write-Host "🌐 Acesse: http://localhost:8123" -ForegroundColor Cyan
Write-Host "📋 Status salvo em: $statusFile" -ForegroundColor Yellow
Write-Host ""
Write-Host "Boa noite! Amanhã sua casa estará pronta! 🏠✨" -ForegroundColor Magenta
