# Script de Diagnóstico da Casa Inteligente
# Identifica e resolve problemas comuns

Write-Host "🔍 Diagnóstico da Casa Inteligente" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan

# Função para log com timestamp
function Write-Diagnostico {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $color = switch ($Level) {
        "ERROR" { "Red" }
        "SUCCESS" { "Green" }
        "WARNING" { "Yellow" }
        "INFO" { "Blue" }
        default { "White" }
    }
    Write-Host "[$timestamp] [$Level] $Message" -ForegroundColor $color
}

Write-Diagnostico "Iniciando diagnóstico completo do sistema..." "INFO"

# ==========================================
# VERIFICAÇÃO DO DOCKER
# ==========================================
Write-Host "`n🐳 VERIFICAÇÃO DO DOCKER" -ForegroundColor Magenta
Write-Host "========================" -ForegroundColor Magenta

# Verificar se Docker está instalado
try {
    $dockerVersion = docker --version
    Write-Diagnostico "Docker instalado: $dockerVersion" "SUCCESS"
} catch {
    Write-Diagnostico "Docker não está instalado!" "ERROR"
    Write-Host "Solução: Instale o Docker Desktop de https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
    exit 1
}

# Verificar se Docker Compose está instalado
try {
    $composeVersion = docker-compose --version
    Write-Diagnostico "Docker Compose instalado: $composeVersion" "SUCCESS"
} catch {
    Write-Diagnostico "Docker Compose não está instalado!" "ERROR"
    Write-Host "Solução: Instale o Docker Desktop que inclui o Docker Compose" -ForegroundColor Yellow
    exit 1
}

# Verificar se Docker Desktop está rodando
try {
    docker ps | Out-Null
    Write-Diagnostico "Docker Desktop está rodando" "SUCCESS"
} catch {
    Write-Diagnostico "Docker Desktop não está rodando!" "ERROR"
    Write-Host "Soluções:" -ForegroundColor Yellow
    Write-Host "1. Inicie o Docker Desktop através do menu Iniciar" -ForegroundColor Yellow
    Write-Host "2. Aguarde até que o ícone da bandeja do sistema fique verde" -ForegroundColor Yellow
    Write-Host "3. Reinicie o computador se necessário" -ForegroundColor Yellow
    
    $response = Read-Host "Deseja tentar iniciar o Docker Desktop automaticamente? (s/n)"
    if ($response -match "^[Ss]$") {
        try {
            Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"
            Write-Diagnostico "Docker Desktop iniciado. Aguarde alguns minutos..." "INFO"
            Start-Sleep -Seconds 10
        } catch {
            Write-Diagnostico "Não foi possível iniciar o Docker Desktop automaticamente" "WARNING"
        }
    }
    exit 1
}

# ==========================================
# VERIFICAÇÃO DE ARQUIVOS
# ==========================================
Write-Host "`n📁 VERIFICAÇÃO DE ARQUIVOS" -ForegroundColor Magenta
Write-Host "==========================" -ForegroundColor Magenta

$requiredFiles = @(
    "docker-compose.yml",
    "config/configuration.yaml",
    "config/secrets.yaml.example"
)

foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Diagnostico "Arquivo encontrado: $file" "SUCCESS"
    } else {
        Write-Diagnostico "Arquivo não encontrado: $file" "ERROR"
    }
}

# Verificar se secrets.yaml existe
if (Test-Path "config/secrets.yaml") {
    Write-Diagnostico "Arquivo secrets.yaml encontrado" "SUCCESS"
} else {
    Write-Diagnostico "Arquivo secrets.yaml não encontrado" "WARNING"
    Write-Host "Solução: Copie config/secrets.yaml.example para config/secrets.yaml e configure suas chaves" -ForegroundColor Yellow
}

# ==========================================
# VERIFICAÇÃO DE PORTAS
# ==========================================
Write-Host "`n🌐 VERIFICAÇÃO DE PORTAS" -ForegroundColor Magenta
Write-Host "========================" -ForegroundColor Magenta

$ports = @(80, 443, 8123, 1883, 8086, 3000, 8080, 9001)
$portsInUse = @()

foreach ($port in $ports) {
    try {
        $connection = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
        if ($connection) {
            Write-Diagnostico "Porta $port está em uso" "WARNING"
            $portsInUse += $port
        } else {
            Write-Diagnostico "Porta $port disponível" "SUCCESS"
        }
    } catch {
        Write-Diagnostico "Porta $port disponível" "SUCCESS"
    }
}

if ($portsInUse.Count -gt 0) {
    Write-Host "Portas em uso: $($portsInUse -join ', ')" -ForegroundColor Yellow
    Write-Host "Isso pode causar conflitos. Considere parar os serviços que usam essas portas." -ForegroundColor Yellow
}

# ==========================================
# VERIFICAÇÃO DE CONTAINERS
# ==========================================
Write-Host "`n📦 VERIFICAÇÃO DE CONTAINERS" -ForegroundColor Magenta
Write-Host "============================" -ForegroundColor Magenta

try {
    $containers = docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    Write-Diagnostico "Containers encontrados:" "INFO"
    Write-Host $containers -ForegroundColor White
} catch {
    Write-Diagnostico "Erro ao verificar containers" "ERROR"
}

# ==========================================
# VERIFICAÇÃO DE REDE
# ==========================================
Write-Host "`n🌍 VERIFICAÇÃO DE REDE" -ForegroundColor Magenta
Write-Host "======================" -ForegroundColor Magenta

# Verificar conectividade com Docker Hub
try {
    $response = Invoke-WebRequest -Uri "https://hub.docker.com" -TimeoutSec 10 -UseBasicParsing
    Write-Diagnostico "Conectividade com Docker Hub: OK" "SUCCESS"
} catch {
    Write-Diagnostico "Problemas de conectividade com Docker Hub" "WARNING"
    Write-Host "Verifique sua conexão com a internet" -ForegroundColor Yellow
}

# ==========================================
# VERIFICAÇÃO DE RECURSOS DO SISTEMA
# ==========================================
Write-Host "`n💻 RECURSOS DO SISTEMA" -ForegroundColor Magenta
Write-Host "======================" -ForegroundColor Magenta

# Memória RAM
$ram = Get-WmiObject -Class Win32_ComputerSystem
$ramGB = [math]::Round($ram.TotalPhysicalMemory / 1GB, 2)
Write-Diagnostico "RAM Total: $ramGB GB" "INFO"

if ($ramGB -lt 4) {
    Write-Diagnostico "RAM insuficiente (recomendado: 4GB+)" "WARNING"
}

# Espaço em disco
$disk = Get-WmiObject -Class Win32_LogicalDisk -Filter "DeviceID='C:'"
$diskFreeGB = [math]::Round($disk.FreeSpace / 1GB, 2)
$diskTotalGB = [math]::Round($disk.Size / 1GB, 2)
Write-Diagnostico "Disco C: $diskFreeGB GB livres de $diskTotalGB GB" "INFO"

if ($diskFreeGB -lt 10) {
    Write-Diagnostico "Espaço em disco baixo (recomendado: 10GB+ livres)" "WARNING"
}

# ==========================================
# VERIFICAÇÃO DE HOSTS LOCAIS
# ==========================================
Write-Host "`n🏠 HOSTS LOCAIS" -ForegroundColor Magenta
Write-Host "===============" -ForegroundColor Magenta

$hostsFile = "$env:SystemRoot\System32\drivers\etc\hosts"
$hostsContent = Get-Content $hostsFile

$requiredHosts = @(
    "casa-inteligente.local",
    "grafana.casa-inteligente.local",
    "zigbee.casa-inteligente.local",
    "influxdb.casa-inteligente.local"
)

foreach ($host in $requiredHosts) {
    if ($hostsContent -match $host) {
        Write-Diagnostico "Host configurado: $host" "SUCCESS"
    } else {
        Write-Diagnostico "Host não configurado: $host" "WARNING"
    }
}

# ==========================================
# VERIFICAÇÃO DE LOGS
# ==========================================
Write-Host "`n📋 LOGS DO SISTEMA" -ForegroundColor Magenta
Write-Host "===================" -ForegroundColor Magenta

try {
    $logs = docker-compose logs --tail=10
    if ($logs) {
        Write-Diagnostico "Últimos logs do sistema:" "INFO"
        Write-Host $logs -ForegroundColor White
    } else {
        Write-Diagnostico "Nenhum log encontrado" "INFO"
    }
} catch {
    Write-Diagnostico "Erro ao obter logs" "WARNING"
}

# ==========================================
# RECOMENDAÇÕES
# ==========================================
Write-Host "`n💡 RECOMENDAÇÕES" -ForegroundColor Magenta
Write-Host "================" -ForegroundColor Magenta

$recommendations = @()

if ($portsInUse.Count -gt 0) {
    $recommendations += "Pare os serviços que usam as portas: $($portsInUse -join ', ')"
}

if (-not (Test-Path "config/secrets.yaml")) {
    $recommendations += "Configure o arquivo config/secrets.yaml com suas chaves de API"
}

if ($ramGB -lt 4) {
    $recommendations += "Considere aumentar a RAM para melhor performance"
}

if ($diskFreeGB -lt 10) {
    $recommendations += "Libere espaço em disco (recomendado: 10GB+ livres)"
}

if ($recommendations.Count -eq 0) {
    Write-Diagnostico "Sistema está em boas condições!" "SUCCESS"
} else {
    Write-Diagnostico "Recomendações:" "WARNING"
    foreach ($rec in $recommendations) {
        Write-Host "• $rec" -ForegroundColor Yellow
    }
}

# ==========================================
# COMANDOS DE SOLUÇÃO
# ==========================================
Write-Host "`n🔧 COMANDOS DE SOLUÇÃO" -ForegroundColor Magenta
Write-Host "======================" -ForegroundColor Magenta

Write-Host "Comandos úteis para resolver problemas:" -ForegroundColor Cyan
Write-Host "• docker-compose down                    # Parar todos os serviços" -ForegroundColor White
Write-Host "• docker-compose up -d                   # Iniciar serviços" -ForegroundColor White
Write-Host "• docker-compose logs homeassistant     # Ver logs do Home Assistant" -ForegroundColor White
Write-Host "• docker system prune -f                # Limpar sistema Docker" -ForegroundColor White
Write-Host "• docker-compose restart                # Reiniciar serviços" -ForegroundColor White

Write-Host "`n🎯 Diagnóstico concluído!" -ForegroundColor Green
Write-Host "Execute este script novamente após fazer as correções recomendadas." -ForegroundColor Yellow
