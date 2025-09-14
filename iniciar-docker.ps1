# Script para Iniciar Docker Desktop
# Inicia o Docker Desktop e aguarda até que esteja pronto

Write-Host "🐳 Iniciando Docker Desktop..." -ForegroundColor Cyan
Write-Host "=============================" -ForegroundColor Cyan

# Função para verificar se Docker está rodando
function Test-DockerRunning {
    try {
        docker ps | Out-Null
        return $true
    } catch {
        return $false
    }
}

# Verificar se Docker já está rodando
if (Test-DockerRunning) {
    Write-Host "✅ Docker Desktop já está rodando!" -ForegroundColor Green
    exit 0
}

# Tentar iniciar o Docker Desktop
Write-Host "🚀 Iniciando Docker Desktop..." -ForegroundColor Yellow

$dockerPaths = @(
    "C:\Program Files\Docker\Docker\Docker Desktop.exe",
    "C:\Program Files (x86)\Docker\Docker\Docker Desktop.exe",
    "${env:ProgramFiles}\Docker\Docker\Docker Desktop.exe",
    "${env:ProgramFiles(x86)}\Docker\Docker\Docker Desktop.exe"
)

$dockerStarted = $false

foreach ($path in $dockerPaths) {
    if (Test-Path $path) {
        try {
            Start-Process -FilePath $path -WindowStyle Hidden
            Write-Host "✅ Docker Desktop iniciado: $path" -ForegroundColor Green
            $dockerStarted = $true
            break
        } catch {
            Write-Host "❌ Erro ao iniciar Docker Desktop em: $path" -ForegroundColor Red
        }
    }
}

if (-not $dockerStarted) {
    Write-Host "❌ Docker Desktop não foi encontrado!" -ForegroundColor Red
    Write-Host "Por favor, instale o Docker Desktop de: https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
    exit 1
}

# Aguardar Docker Desktop carregar
Write-Host "⏳ Aguardando Docker Desktop carregar..." -ForegroundColor Yellow
Write-Host "Isso pode levar alguns minutos na primeira execução." -ForegroundColor Yellow

$maxAttempts = 60  # 5 minutos máximo
$attempt = 0

while ($attempt -lt $maxAttempts) {
    Start-Sleep -Seconds 5
    $attempt++
    
    Write-Host "Tentativa $attempt/$maxAttempts - Verificando Docker..." -ForegroundColor Blue
    
    if (Test-DockerRunning) {
        Write-Host "✅ Docker Desktop está rodando!" -ForegroundColor Green
        Write-Host "🎉 Pronto para usar! Execute o script de instalação da Casa Inteligente." -ForegroundColor Green
        exit 0
    }
    
    # Mostrar progresso
    $progress = [math]::Round(($attempt / $maxAttempts) * 100, 0)
    Write-Progress -Activity "Aguardando Docker Desktop" -Status "Carregando..." -PercentComplete $progress
}

Write-Progress -Activity "Aguardando Docker Desktop" -Completed

Write-Host "⏰ Timeout aguardando Docker Desktop carregar" -ForegroundColor Yellow
Write-Host "O Docker Desktop pode estar ainda inicializando em segundo plano." -ForegroundColor Yellow
Write-Host "Verifique o ícone na bandeja do sistema e aguarde até ficar verde." -ForegroundColor Yellow

$response = Read-Host "Deseja continuar aguardando? (s/n)"
if ($response -match "^[Ss]$") {
    Write-Host "⏳ Continuando aguardando..." -ForegroundColor Yellow
    
    while ($true) {
        Start-Sleep -Seconds 10
        
        if (Test-DockerRunning) {
            Write-Host "✅ Docker Desktop está rodando!" -ForegroundColor Green
            Write-Host "🎉 Pronto para usar! Execute o script de instalação da Casa Inteligente." -ForegroundColor Green
            exit 0
        }
        
        Write-Host "Ainda aguardando Docker Desktop..." -ForegroundColor Blue
    }
} else {
    Write-Host "👋 Execute este script novamente quando o Docker Desktop estiver rodando." -ForegroundColor Yellow
}
