function Get-FolderSize {
    Param(
        [string]$Drive = "H:\"
    )
    (Get-ChildItem -Path "H:\" -Recurse -Force | Measure-Object -Sum Length).Sum
}

