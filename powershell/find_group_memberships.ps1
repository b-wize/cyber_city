$membersearch = Read-Host -prompt 'Enter group to check'

$findmember = Get-ADGroup -LDAPFilter "(name=$membersearch)" | Get-ADGroupMember | select name | sort name

Write-Host "
All members listed below"
$findmember