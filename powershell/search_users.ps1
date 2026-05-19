$domains = @()#insert domains here as array

$username = Read-host -prompt 'Enter the user to look for'

$searchuser = "*$username*"

Foreach ($domain in $domais)
{
    try {

        $checkuser = Get-ADUser -filter {samaccountname -like $searchuser} -server $domain -properties * | select name, samaccountname, enabled, lockedout, @{name="domain";expression={($_.canonicalname).split('/')[0]}} | sort name | ft

    }

    catch {

        Write-Error "User not found in $domain"
    
    }

    $checkuser
}