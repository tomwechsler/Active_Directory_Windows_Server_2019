Set-Location
Clear-Host

#New OU for the leaders
New-ADOrganizationalUnit CFO

#And one new group
New-ADGroup -Name "Fuehrungskraefte" `
-GroupScope Universal `
-Description "Fuehrungskraefte von tomrocks.local" `
-GroupCategory "Security" `
-Path "OU=CFO,DC=tomrocks,DC=local" `
-SAMAccountName "Fuehrungskraefte" `
-PassThru

#New CFO needs an account
New-ADUser -Name "Erika Meister" `
-GivenName "Erika" `
-SurName "Meister" `
-Department "Finance" `
-Description "Chief Financial Officer" `
-ChangePasswordAtLogon $True `
-EmailAddress "Meister@tomrocks.local" `
-Enabled $True `
-PasswordNeverExpires $False `
-SAMAccountName "Meister" `
-AccountPassword (ConvertTo-SecureString "Starting P@ssw0rd!" `
-AsPlainText `
-Force) `
-Title "Chief Financial Officer" `
-Path 'OU=CFO,DC=tomrocks,DC=local'`
-PassThru

#This account is a member of the new group
Add-ADPrincipalGroupMembership -Identity Meister `
-MemberOf "Fuehrungskraefte" `
-PassThru

#Now we create a PSO
New-ADFineGrainedPasswordPolicy `
-description:"Minimum 12 Zeichen fuer alle Fuehrungskraefte." `
-LockoutDuration 00:10:00 `
-LockoutObservationWindow 00:10:00 `
-LockoutThreshold 5 `
-MaxPasswordAge 65.00:00:00 `
-MinPasswordLength 12 `
-Name:"Fuehrungskraefte Pwd Policy" `
-Precedence 10 `
-PassThru

#This new PSO we put on the new group
Get-ADGroup -Identity "Fuehrungskraefte" `
| Add-ADFineGrainedPasswordPolicySubject `
-Identity "Fuehrungskraefte Pwd Policy"

#And see if it worked => control can also be done in AD administration center
Get-ADFineGrainedPasswordPolicySubject -Identity "Fuehrungskraefte Pwd Policy"