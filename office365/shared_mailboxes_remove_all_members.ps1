$admin_email = "admin@domain.com"


# Connect to Office 365 PowerShell
Install-Module -Name ExchangeOnlineManagement
Import-Module ExchangeOnlineManagement

Set-ExecutionPolicy Unrestricted

Connect-ExchangeOnline -UserPrincipalName $admin_email -ShowProgress $true

# Get all shared mailboxes
$mailboxes = Get-Mailbox -RecipientTypeDetails SharedMailbox

# Iterate through each shared mailbox and remove all members
foreach ($mailbox in $mailboxes) {
    $mailboxName = $mailbox.DisplayName
    Write-Host "Removing members from shared mailbox: $mailboxName"
    
    # Get all members of the shared mailbox
    $members = Get-MailboxPermission -Identity $mailbox.Identity -User "NT AUTHORITY\SELF" -ErrorAction SilentlyContinue
    
    # Remove each member
    foreach ($member in $members) {
        if ($member.User -ne $null) {
            Write-Host "Removing member $($member.User.DisplayName) from shared mailbox: $mailboxName"
            Remove-MailboxPermission -Identity $mailbox.Identity -User $member.User -AccessRights FullAccess -Confirm:$false
        }
    }
}

# Disconnect from Office 365 PowerShell
Disconnect-ExchangeOnline -Confirm:$false
