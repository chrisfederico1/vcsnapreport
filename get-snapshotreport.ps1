 
 # This script creates a snapshot report. Uses the Get-VIEvent cmdlet. Creates objects ans then exports the object to a CSV file.
 
 Begin {
     #Create an empty array for report
    $report = @()

 }
 

 Process{

 foreach ($snap in Get-VM | Get-Snapshot)
 {$snapevent = Get-VIEvent -Entity $snap.VM -Types Info -Finish $snap.Created -MaxSamples 1 | Where-Object {$_.FullFormattedMessage -imatch 'Task: Create virtual machine snapshot'}
 
 if ($null -ne $snapevent){

    $myobject = New-Object psobject -Property @{

        VM = $snap.VM
        SNAPSHOT = $snap.Name
        CREATED = $snap.Created.DateTime
        SNAPOWNER = $snapevent.UserName
        SIZE = $snap.SIZE
    }

$report += $myobject


 }
 
 else {

$myobject = New-Object psobject -Property @{

        VM = $snap.VM
        SNAPSHOT = $snap.Name
        CREATED = $snap.Created.DateTime
        SNAPOWNER = "This event is not in vCenter events Database"
        SIZE = $snap.SIZE
    }

  $report += $myobject


}


}
 

 }


 End{
$report | sort-object Created | select-object VM,SNAPSHOT,CREATED,SNAPOWNER,SIZE

 }