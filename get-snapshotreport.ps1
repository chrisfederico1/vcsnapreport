 
 
 
 Begin {
     #Create an empty array for report
    $report = @()

 }
 

 Process{

 foreach ($snap in Get-VM | Get-Snapshot)
 {$snapevent = Get-VIEvent -Entity $snap.VM -Types Info -Finish $snap.Created -MaxSamples 1 | Where-Object {$_.FullFormattedMessage -imatch 'Task: Create virtual machine snapshot'}
 
 if ($snapevent -ne $null){

    $myobject = New-Object psobject -Property @{

        VM = $snap.VM
        SNAPSHOT = $snap.Name
        CREATED = $snap.Created.DateTime
        SNAPOWNER = $snapevent.UserName
    }

$report += $myobject


 }
 
 else {

$myobject = New-Object psobject -Property @{

        VM = $snap.VM
        SNAPSHOT = $snap.Name
        CREATED = $snap.Created.DateTime
        SNAPOWNER = "This event is not in vCente4revents Database"
    }

  $report += $myobject


}


}
 

 }


 End{
$report | sort-object Created | select-object VM,SNAPSHOT,CREATED,SNAPOWNER

 }