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
-UserPrincipalName "jack.robinson@tomrocks.local" -Path "OU=Managers,DC=enterprise,DC=com"`
-AccountPassword(Read-Host -AsSecureString "Input Password") -Enabled $true

#Now let’s take a look at the results
Get-ADUser 'jack.robinson' -Properties CanonicalName, Enabled, GivenName, Surname, Name, UserPrincipalName, samAccountName, whenCreated, PasswordLastSet | Select CanonicalName, Enabled, GivenName, Surname, Name, UserPrincipalName, samAccountName, whenCreated, PasswordLastSet

#Create AD Users in Bulk with a PowerShell Script
$path="OU=IT,DC=enterprise,DC=com"
$username="ITclassuser"
$count=1..10

foreach ($i in $count)
{ New-AdUser -Name $username$i -Path $path -Enabled $True -ChangePasswordAtLogon $true  `

-AccountPassword (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -force) -passThru }

#Now let’s make our script more flexible by adding the Read-Host parameter
$path="OU=IT,DC=enterprise,DC=com"
$username=Read-Host "Enter name"
$n=Read-Host "Enter Number"
$count=1..$n

foreach ($i in $count)
{ New-AdUser -Name $username$i -Path $path -Enabled $True -ChangePasswordAtLogon $true  `

-AccountPassword (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -force) -passThru }

#Import AD Users from a CSV File
#Enter a path to your import CSV file
$ADUsers = Import-csv C:\scripts\newusers.csv

foreach ($User in $ADUsers)
{

       $Username    = $User.username
       $Password    = $User.password
       $Firstname   = $User.firstname
       $Lastname    = $User.lastname
       $Department  = $User.department
       $OU          = $User.ou

       #Check if the user account already exists in AD
       if (Get-ADUser -F {SamAccountName -eq $Username})
       {
               #If user does exist, output a warning message
               Write-Warning "A user account $Username has already exist in Active Directory."
       }
       else
       {
              
 #If a user does not exist then create a new user account
       
 #Account will be created in the OU listed in the $OU variable in the CSV file; don’t forget to change the domain name in the"-UserPrincipalName" variable
              New-ADUser `
            -SamAccountName $Username `
            -UserPrincipalName "$Username@yourdomain.com" `
            -Name "$Firstname $Lastname" `
            -GivenName $Firstname `
            -Surname $Lastname `
            -Enabled $True `
            -ChangePasswordAtLogon $True `
            -DisplayName "$Lastname, $Firstname" `
            -Department $Department `
            -Path $OU `
            -AccountPassword (convertto-securestring $Password -AsPlainText -Force)

       }
}

#Lets check
Get-ADUser edward.franklin -Properties CanonicalName, Enabled, GivenName, Surname, Name, UserPrincipalName, samAccountName, whenCreated, PasswordLastSet  | Select CanonicalName, Enabled, GivenName, Surname, Name, UserPrincipalName, samAccountName, whenCreated, PasswordLastSet