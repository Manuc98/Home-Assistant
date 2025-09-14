# Script para aguardar Docker Desktop carregar
Write-Host "🐳 Aguardando Docker Desktop carregar..." -ForegroundColor Cyan
Write-Host "Isso pode levar alguns minutos na primeira execução." -ForegroundColor Yellow

$maxAttempts = 30  # 5 minutos
$attempt = 0

while ($attempt -lt $maxAttempts) {
    try {
        docker ps | Out-Null
        Write-Host "✅ Docker Desktop está rodando!" -ForegroundColor Green
        Write-Host "🎉 Pronto para usar!" -ForegroundColor Green
        exit 0
    } catch {
        $attempt++
        Write-Host "Tentativa $attempt/$maxAttempts - Aguardando Docker..." -ForegroundColor Blue
        Start-Sleep -Seconds 10
    }
}

Write-Host "⏰ Docker Desktop demorou para carregar." -ForegroundColor Yellow
Write-Host "Verifique o ícone na bandeja do sistema e aguarde até ficar verde." -ForegroundColor Yellow
