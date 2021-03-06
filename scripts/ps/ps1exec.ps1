param
( 
    [Parameter(Position=0, Mandatory=$true)]
    [string] $scriptPath
)
function PsRuntime-ExecuteScript($path)
{
	trap { "Fatal Error: execution terminated!"; break }
	$raw = Get-Content $path  
	$secure = ConvertTo-SecureString $raw
	$helper = New-Object system.Management.Automation.PSCredential("test", $secure)
	$plain = $helper.GetNetworkCredential().Password
	Invoke-Expression $plain
}
PsRuntime-ExecuteScript $scriptPath