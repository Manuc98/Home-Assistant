# Script para configurar a Casa Inteligente como serviço do Windows
# Executa automaticamente na inicialização do sistema

Write-Host "🔧 Configurando Casa Inteligente como Serviço Automático..." -ForegroundColor Cyan

# Criar tarefa agendada para iniciar automaticamente
$taskName = "CasaInteligente"
$scriptPath = Join-Path $PWD "iniciar-automatico.ps1"

# Remover tarefa existente se houver
try {
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue
    Write-Host "Tarefa existente removida" -ForegroundColor Yellow
} catch {
    Write-Host "Nenhuma tarefa existente encontrada" -ForegroundColor Green
}

# Criar nova tarefa
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ExecutionPolicy Bypass -File `"$scriptPath`""
$trigger = New-ScheduledTaskTrigger -AtStartup
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

try {
    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings -Principal $principal -Description "Casa Inteligente - Home Assistant"
    Write-Host "✅ Serviço configurado com sucesso!" -ForegroundColor Green
    Write-Host "A Casa Inteligente iniciará automaticamente quando o Windows ligar" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Erro ao configurar serviço: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Execute como Administrador para configurar o serviço automático" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Para iniciar manualmente agora:" -ForegroundColor Yellow
Write-Host ".\iniciar-automatico.ps1" -ForegroundColor White
