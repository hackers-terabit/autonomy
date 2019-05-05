<#
.SYNOPSIS
Use RIPE Stat API to blackhole prefixes from specific ASNs
.DESCRIPTION
Use RIPE Stat API to blackhole prefixes from specific ASNs

.EXAMPLE
ASNBlackhole.ps1 -ASN 15169 -V4 -V6 -Type=Originating
.LINK
https://github.com/hackers-terabit/autonomy
#>
Param(
	[Parameter(Mandatory=$true)]
    [Int]
    $ASN
    ,
    [Parameter(Mandatory=$false)]
    [switch]
    $V4
    ,
    [Parameter(Mandatory=$false)]
    [switch]
    $Unblock
    ,
    [Parameter(Mandatory=$false)]
    [switch]
    $V6,
    [Parameter(Mandatory=$false)]
    [string]
    $Type
    )

$types=""
$af="v4,v6"

if($Type -like "Originating"){
	$types="o"
}elseif($Type -like "Transitting"){
	$types="t"
}else{
	$types="o,t"
	$Type="Both"
}

if(-not $V4 -and $V6){
	$af="v6"
}elseif($V4 -and -not $V6){
	$af="v4"
}elseif(-not $V4 -and -not $V6){
	$af="v4,v6"
	$V4=$true
	$V6=$true
}
try{
	$interfaces = Get-WmiObject Win32_NetworkAdapter
	$interfacelist = new-object System.Collections.ArrayList]
	$interfaces | foreach {
    	$friendlyname = $_ | Select-Object -ExpandProperty NetConnectionID
   		$name = $_.GetRelated("Win32_PnPEntity") | Select-Object -ExpandProperty Name
   		$interfacelist.Add($name)
	}
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
	$RIPEURI = "https://stat.ripe.net/data/ris-prefixes/data.json?resource=$ASN&af=$af&types=$types&noise=keep&list_prefixes=true"
	Write-Host "Getting Prefixes using URI: $RIPEURI"
	$response = Invoke-RestMethod  -Uri "$RIPEURI"
	#write-host $response

	if(-not ($response.status_code -eq 200)){
		throw "HTTP Error when calling the RIPE Stat API"
	}

	if($V4){
		if(($Type -eq "Both") -or ($Type -eq "Originating")){
			Write-Host "Applying change for orignating V4 prefixes"
			foreach($prefix in $response.data.prefixes.v4.originating){
				write-host "Processing $prefix"
				if($Unblock){
					netsh advfirewall firewall delete rule name="Block for $ASN/$prefix" dir=out   remoteip=$prefix
				}
				else{
					netsh advfirewall firewall add rule name="Block for $ASN/$prefix" dir=out action=block  remoteip=$prefix
				}
			}
		}
		if(($Type -eq "Both") -or ($Type -eq "Transitting")){
			Write-Host "Applying change for transitting V4 prefixes"
			foreach($prefix in $response.data.prefixes.v4.transitting){
				write-host "Processing $prefix"
				if($Unblock){
					netsh advfirewall firewall delete rule name="Block for $ASN/$prefix" dir=out   remoteip=$prefix
				}
				else{
					netsh advfirewall firewall add rule name="Block for $ASN/$prefix" dir=out action=block  remoteip=$prefix
				}
			}
		}
	}
	if($V6){
		if(($Type -eq "Both") -or ($Type -eq "Originating")){
			Write-Host "Applying change for orignating V6 prefixes"
			foreach($prefix in $response.data.prefixes.v6.transitting){
				write-host "Processing $prefix"
				if($Unblock){
					netsh advfirewall firewall delete rule name="Block for $ASN/$prefix" dir=out   remoteip=$prefix
				}
				else{
					netsh advfirewall firewall add rule name="Block for $ASN/$prefix" dir=out action=block  remoteip=$prefix
				}
			}
		}
		if(($Type -eq "Both") -or ($Type -eq "Transitting")){
			Write-Host "Applying change for transitting V6 prefixes"
			foreach($prefix in $response.data.prefixes.v6.originating){
				write-host "Processing $prefix"
				if($Unblock){
					netsh advfirewall firewall delete rule name="Block for $ASN/$prefix" dir=out   remoteip=$prefix
				}
				else{
					netsh advfirewall firewall add rule name="Block for $ASN/$prefix" dir=out action=block  remoteip=$prefix
				}
			}
		}
	}
}
catch{
	Write-Error -Message "Runtime error,fireall rule addition/deletion may not have taken place. $PSItem.Exception.Message" -ErrorAction Stop
}