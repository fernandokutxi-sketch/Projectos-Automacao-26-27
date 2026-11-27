# ==========================================
# MODULO: SOFTWARE INSTALADO
# ==========================================

function Get-SoftwareInfo {

    $Paths = @(
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"

        "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"

        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )

    $Software = foreach ($Path in $Paths) {

        Get-ItemProperty -Path $Path `
            -ErrorAction SilentlyContinue |
            Where-Object {
                $_.DisplayName
            } |
            Select-Object @{
                Name = "Name"
                Expression = { $_.DisplayName }
            }, @{
                Name = "Version"
                Expression = { $_.DisplayVersion }
            }, @{
                Name = "Publisher"
                Expression = { $_.Publisher }
            }
    }

    return $Software |
        Sort-Object Name -Unique
}


Get-SoftwareInfo