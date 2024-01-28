# ***** PowerShell Configuration *****
# PSReadline config
Import-Module PSReadLine
# highlight dirs
Import-Module DirColors
# Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
# Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -BellStyle None
# gsudo enable
Import-Module gsudoModule
# terminal icons
Import-Module -Name Terminal-Icons

# ***** Scoop Configuration *****
# enable scoop search
Invoke-Expression (&scoop-search --hook)

# ***** StarShip Configuration *****
Invoke-Expression (&starship init powershell)
# 设置 Tab 键补全
Set-PSReadlineKeyHandler -Key Tab -Function Complete
# 设置向上和向下键为后向和前向搜索历史记录
# Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
# Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
# 和 *nix 保持一致，cursor 位于行尾
Set-PSReadLineKeyHandler -Key UpArrow -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::HistorySearchBackward()
    [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
}
Set-PSReadLineKeyHandler -Key DownArrow -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::HistorySearchForward()
    [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
}
# starship theme
$ENV:STARSHIP_CONFIG = "$HOME\.config\modified.toml"

# ***** VCPKG Configuration *****
Import-Module 'D:\src\vcpkg\scripts\posh-vcpkg'

# ***** CONDA Configuration *****
#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
If (Test-Path "D:\env\anaconda3\Scripts\conda.exe") {
    (& "D:\env\anaconda3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | ? { $_ } | Invoke-Expression
}
#endregion

# ***** WINGET Configuration *****
# winget auto-completion
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
    $Local:word = $wordToComplete.Replace('"', '""')
    $Local:ast = $commandAst.ToString().Replace('"', '""')
    winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

# ***** SELF-DEFINED ALIASES *****
# alias for sublime text
New-Alias -Name subl -Value "D:\tools\green\SublimeText\subl.exe"
# alias for wsl compact script
New-Alias -Name wsl_compact -Value "D:\dev\compact_wsl.bat"

Get-ChildItem "$PROFILE\..\Completions\" | ForEach-Object {
    . $_.FullName
}
Get-ChildItem "$PROFILE\..\Completions\" | ForEach-Object {
    . $_.FullName
}
