
function Get-SystemInfo {

    $Computer = Get-CimInstance -ClassName Win32_ComputerSystem
    $OS       = Get-CimInstance -ClassName Win32_OperatingSystem
    $BIOS     = Get-CimInstance -ClassName Win32_BIOS

    
    [PSCustomObject]@ {

        ComputerName      = $Computer.Name
        Manufacturer      = $Computer.Manufacturer
        Model             = $Computer.Model
        UserName          = $Computer.UserName
        OperatingSystem   = $OS.Caption
        version           = $OS.Version
        Architecture      = $OS.OSArchitecture
        SerialNumber      = $BIOS.SerialNumber
        PowershellVersion = $PSVersionTable.PSVersion.ToString()
        LastBootUpTime    = $OS.LastBootUpTime

    }
    
}

