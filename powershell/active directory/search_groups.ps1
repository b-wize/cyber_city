$domains = @()#insert domains here as array

$groupsearch = Read-Host -prompt 'Input group name to look for'

$lookup = "*$groupsearch*"

Foreach ($domain in $domains)
{
    try {

        $findgroups = Get-ADGroup -filter {name -like $lookup} -server $domain -properties * | select name, groupcategory, mail, @{name="OU";expression={($_.canonicalname).split('/')[2]}}, @{name="domain";expression={($_.canonicalname).split('/')[0]}} | sort name | ft

    }

    catch {

        Write-Error "Group not found in $domain"

    }

    $findgroups
}