

function Get-SystemInfo {
       # Adicionámos [CmdletBinding()], permitindo utilizar funcionalidades avançadas de funções PowerShell.
    [CmdletBinding()]

      # Adicionámos param() para estruturar correctamente a função.
    param()

    try {
        # Informações do computador

        # Utilizámos -ErrorAction Stop para garantir que os erros das operações CIM são encaminhados para o catch.

        $Computer = Get-CimInstance -ClassName Win32_ComputerSystem -ErrorAction Stop

        # Informações do sistema operativo
        $OS = Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction Stop

        # Informações da BIOS
        $BIOS = Get-CimInstance -ClassName Win32_BIOS -ErrorAction Stop

        # Criar objecto personalizado
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
        Write-Error "Erro ao obter informações do sistema: $_.Exception.Message"
    }
}

Get-SystemInfo
