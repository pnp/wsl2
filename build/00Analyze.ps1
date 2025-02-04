Write-Host " Start Analyzing Scripts"
Write-Host "  Psm1"
Invoke-ScriptAnalyzer -Path $PSScriptRoot\..\*.psm1 -ExcludeRule PSAvoidUsingInvokeExpression,PSShouldProcess,PSUseShouldProcessForStateChangingFunctions >$PSScriptRoot\reportPSM.txt
Write-Host "  Ps1"
Invoke-ScriptAnalyzer -Path $PSScriptRoot\..\public\*.ps1 -ExcludeRule PSAvoidUsingInvokeExpression,PSShouldProcess,PSUseShouldProcessForStateChangingFunctions -Recurse >$PSScriptRoot\report.txt
Write-Host " End Analyzing Scripts"
