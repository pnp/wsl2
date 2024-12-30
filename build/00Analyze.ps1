Invoke-ScriptAnalyzer -Path $PSScriptRoot\..\public\*.ps1 -ExcludeRule PSAvoidUsingInvokeExpression,PSShouldProcess,PSUseShouldProcessForStateChangingFunctions -Recurse >$PSScriptRoot\report.txt
