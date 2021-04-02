Set-Location C:\
Clear-Host

#If needed
Import-Module ActiveDirectory

#A new user
New-ADUser 'Bob Johnson'

#Now let’s check whether the user was added successfully by listing all Active Directory users
Get-ADUser -Filter * -Properties samAccountName | select samAccountName

#Create a New Active Directory User Account with Password
New-ADUser -Name "Jack Robinson" -GivenName "Jack" -Surname "Robinson" -SamAccountName "jack.robinson"`
-UserPrincipalName "jack.robinson@tomrocks.local" -Path "OU=Managers,DC=tomrocks,DC=local"`
-AccountPassword(Read-Host -AsSecureString "Input Password") -Enabled $true

#Now let’s take a look at the results
Get-ADUser 'jack.robinson' -Properties CanonicalName, Enabled, GivenName, Surname, Name, UserPrincipalName, samAccountName, whenCreated, PasswordLastSet | Select CanonicalName, Enabled, GivenName, Surname, Name, UserPrincipalName, samAccountName, whenCreated, PasswordLastSet

#Create AD Users in Bulk with a PowerShell Script
$path="OU=IT,DC=tomrocks,DC=local"
$username="ITclassuser"
$count=1..10

foreach ($i in $count)
{ New-AdUser -Name $username$i -Path $path -Enabled $True -ChangePasswordAtLogon $true -AccountPassword (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -force) -passThru }

#Now let’s make our script more flexible by adding the Read-Host parameter
$path="OU=IT,DC=tomrocks,DC=local"
$username=Read-Host "Enter name"
$n=Read-Host "Enter Number"
$count=1..$n

foreach ($i in $count)
{ New-AdUser -Name $username$i -Path $path -Enabled $True -ChangePasswordAtLogon $true -AccountPassword (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -force) -passThru }

#We create an OU
New-ADOrganizationalUnit NewUsers


#Let's look at the CSV list from HR
Import-CSV "C:\scripts\newusers.csv" | Out-GridView

#The list does not match the Powershell criteria

#Let's look at the parameters of New-ADUser
Get-Help New-ADuser

Update-Help * -Force

#We help ourselves with additional tricks
Import-CSV "C:\scripts\newusers.csv" | Select-Object Title, Department, City, State, Office, EmployeeID, `
    @{name='name';expression={$_.'First Name'+'.'+$_.'Last Name'}}, `
    @{name='samAccountName';expression={$_.'First Name'+'.'+$_.'Last Name'}}, `
    @{name='displayName';expression={$_.'First Name'+' '+$_.'Last Name'}}, `
    @{name='givenName';expression={$_.'First Name'}}, `
    @{name='surName';expression={$_.'Last Name'}}, `
    @{name='path';expression={'OU=NewUsers,DC=tomrocks,DC=local'}} |
    Out-GridView

#Now we create the accounts
Import-CSV "C:\scripts\newusers.csv" | Select-Object Title, Department, City, State, Office, EmployeeID, `
    @{name='name';expression={$_.'First Name'+'.'+$_.'Last Name'}}, `
    @{name='samAccountName';expression={$_.'First Name'+'.'+$_.'Last Name'}}, `
    @{name='displayName';expression={$_.'First Name'+' '+$_.'Last Name'}}, `
    @{name='givenName';expression={$_.'First Name'}}, `
    @{name='surName';expression={$_.'Last Name'}} |
    New-ADUser -ChangePasswordAtLogon $true -Enabled $True -AccountPassword $(ConvertTo-SecureString "P@55word" -AsPlainText -Force) -Path 'OU=NewUsers,DC=tomrocks,DC=local' -PassThru

#How do I control now?
Get-ADObject -SearchBase "OU=NewUsers,DC=tomrocks,DC=local" -Filter *
Get-ADUser -Filter 'Office -eq "OWA"' | Out-GridView