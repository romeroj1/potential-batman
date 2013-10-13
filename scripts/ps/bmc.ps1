$svrs = Get-Content e:\temp\svrlist.txt
$uid = "xxxx"
$pwd = "xxxx"
$basepath = "E:\BMCSoftware\BMCPortalKit\appserver\util\BPM_CLI\"
[string]$cmd = "bpmcli"
$bmcserver = "svrname.domain.com"

function getBMCData
{
	foreach ($p in $lstmonitors)
	{		
		cd $basepath	
		[array]$args = "-portal", $bmcserver, "-login", $uid, "-pass", $pwd, "-c getElemets";
		& $cmd $args;
	}
}

