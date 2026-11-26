
function Get-SystemInfo {
    try {
        $Computer = Get-CimInstance - ClassName Win32_ComputerSystem
        $OS = Get-CimInstance - ClassName Win32_OperatingSystem
        $BIOS = Get-CimInstance - ClassName Win32_BIOS

        [PSCustomObject]@{
            NomeComputador   = $Computer.Name
            Fabricante       = $Computer.Manufacturer
            Modelo           = $Computer.Model
            SistemaOperativo = $OS.Caption
            Versao           = $OS.Version
            Arquitetura      = $OS.OSArchitecture
            MemoriaRAM_GB    = [math]::Round($Computer.TotalPhysicalMemory / 1GB, 2)
            NumeroSerie      = $BIOS.SerialNumber
            DataArranque     = $OS.LastBootUpTime
        }
    }
    catch {
        Write-Error "Erro ao obter informações do sistema: $_"
    }

}

