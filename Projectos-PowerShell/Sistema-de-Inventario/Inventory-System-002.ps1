Clear-Host

$ProjectPath = $PSScriptRoot
$ModulesPath = Join-Path $ProjectPath "Modules"
$ReportPath  = Join-Path $ProjectPath "Reports"

# Carregar as funções dos módulos
. "$ModulesPath\SystemInfo.ps1"
. "$ModulesPath\HardwareInfo.ps1"
. "$ModulesPath\NetworkInfo.ps1"
. "$ModulesPath\DiskInfo.ps1"
. "$ModulesPath\SoftwareInfo.ps1"

if (-not (Test-Path $ReportPath)) {
    New-Item -Path $ReportPath -ItemType Directory -Force |
        Out-Null
}

$Date = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

Write-Host "====================================="
Write-Host "       PC INVENTORY SYSTEM"
Write-Host "====================================="

try {
    Write-Host "`nA recolher informacoes..."

    $System   = Get-SystemInfo
    $Hardware = Get-HardwareInfo
    $Network  = @(Get-NetworkInfo)
    $Disks    = @(Get-DiskInfo)
    $Software = @(Get-SoftwareInfo)

    # Exportar ficheiros CSV
    $System | Export-Csv "$ReportPath\System_$Date.csv" -NoTypeInformation -Encoding UTF8
    $Hardware | Export-Csv "$ReportPath\Hardware_$Date.csv" -NoTypeInformation -Encoding UTF8
    $Network | Export-Csv "$ReportPath\Network_$Date.csv" -NoTypeInformation -Encoding UTF8
    $Disks | Export-Csv "$ReportPath\Disks_$Date.csv" -NoTypeInformation -Encoding UTF8
    $Software | Export-Csv "$ReportPath\Software_$Date.csv" -NoTypeInformation -Encoding UTF8

    # Criar relatório HTML
    $HTML = @()
    $HTML += "<h1>PC INVENTORY SYSTEM</h1>"
    $HTML += "<p>Data: $(Get-Date)</p>"
    $HTML += "<h2>Informacoes do Sistema</h2>"
    $HTML += $System | ConvertTo-Html -Fragment
    $HTML += "<h2>Hardware</h2>"
    $HTML += $Hardware | ConvertTo-Html -Fragment
    $HTML += "<h2>Rede</h2>"
    $HTML += $Network | ConvertTo-Html -Fragment
    $HTML += "<h2>Discos</h2>"
    $HTML += $Disks | ConvertTo-Html -Fragment
    $HTML += "<h2>Software Instalado</h2>"
    $HTML += $Software | ConvertTo-Html -Fragment

    $HTML | ConvertTo-Html -Title "PC Inventory Report" |
        Out-File "$ReportPath\Inventory_$Date.html" -Encoding UTF8

    # Criar relatório TXT
    $TXTPath = "$ReportPath\Inventory_$Date.txt"
    "PC INVENTORY SYSTEM" | Out-File $TXTPath
    "Data: $(Get-Date)" | Out-File $TXTPath -Append

    "`n===== SISTEMA =====" | Out-File $TXTPath -Append
    ($System | Format-List | Out-String) | Out-File $TXTPath -Append

    "`n===== HARDWARE =====" | Out-File $TXTPath -Append
    ($Hardware | Format-List | Out-String) | Out-File $TXTPath -Append

    "`n===== REDE =====" | Out-File $TXTPath -Append
    ($Network | Format-Table -AutoSize | Out-String) | Out-File $TXTPath -Append

    "`n===== DISCOS =====" | Out-File $TXTPath -Append
    ($Disks | Format-Table -AutoSize | Out-String) | Out-File $TXTPath -Append

    "`n===== SOFTWARE =====" | Out-File $TXTPath -Append
    ($Software | Format-Table -AutoSize | Out-String) | Out-File $TXTPath -Append

    Write-Host "`nINVENTARIO CONCLUIDO!"
    Write-Host "Computador: $($System.ComputerName)"
    Write-Host "Processador: $($Hardware.Processor)"
    Write-Host "Memoria RAM: $($Hardware.RAM_GB) GB"
    Write-Host "Discos encontrados: $($Disks.Count)"
    Write-Host "Programas encontrados: $($Software.Count)"
    Write-Host "`nRelatorios guardados em: $ReportPath"
}
catch {
    Write-Host "`nERRO AO EXECUTAR O INVENTARIO!"
    Write-Host $_.Exception.Message
}

