#Pipeline objects and it will create an XML document
#e.g. gps a* | New-XML -RootTag PROCESSES -ItemTag PROCESS -Attribute=id,ProcessName -ChildItems WS,Handles | out-file C:\test.xml

function New-Xml
{
param($RootTag="ROOT",$ItemTag="ITEM", $ChildItems="*", $Attributes=$Null)

Begin {
    $xml = "<$RootTag>`n"
}


Process {
    $xml += "    <$ItemTag"
    if ($Attributes)
    {
        foreach ($attr in $_ | Get-Member -type *Property $attributes)
        {    $name = $attr.Name
             $xml += " $Name=`"$($_.$Name)`""
        }
    }
    $xml += ">`n"
    foreach ($child in $_ | Get-Member -Type *Property $childItems)
    {
        $Name = $child.Name
        $xml += "        <$Name>$($_.$Name)</$Name>`n"
    }
    $xml += "    </$ItemTag>`n"
}

End {
    $xml += "</$RootTag>`n"
    $xml
}
}