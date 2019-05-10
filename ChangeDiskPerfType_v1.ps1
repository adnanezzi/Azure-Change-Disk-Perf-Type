#login Azure
Login-AzureRMAccount

# Name of the resource group that contains the VM
$rgName = 'rg-Labs-StorPools'

# Name of the your virtual machine
$vmName = 'VMStrPool01'

# Stop and deallocate the VM
Stop-AzureRmVM -ResourceGroupName $rgName -Name $vmName -Force

# Choose between Standard_LRS and Premium_LRS based on your scenario
$storageType = 'Standard_LRS'

$vm = Get-AzureRmVM -Name $vmName -resourceGroupName $rgName

# Get all disks in the resource group of the VM
$vmDisks = Get-AzureRmDisk -ResourceGroupName $rgName 

# For disks that belong to the selected VM, convert to premium storage
foreach ($disk in $vmDisks)
{
    if ($disk.ManagedBy -eq $vm.Id)
    {
        $diskUpdateConfig = New-AzureRmDiskUpdateConfig –AccountType $storageType
        Update-AzureRmDisk -DiskUpdate $diskUpdateConfig -ResourceGroupName $rgName `
        -DiskName $disk.Name
    }
}

# Start VM
Start-AzureRmVM -ResourceGroupName $rgName -Name $vmName