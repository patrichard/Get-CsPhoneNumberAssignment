function Get-CsPhoneNumberAssignment{
  #Requires -Modules 'SkypeForBusiness'
  
  [CmdletBinding(SupportsShouldProcess, SupportsPaging, HelpUri = 'https://github.com/patrichard/Get-CsPhoneNumberAssignment/blob/master/README.md')]
  param(
    # Defines the LineUri, or a partial LineUri, to search for.
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [ValidateNotNullOrEmpty()]
    [string] $LineUri
  )
  BEGIN{
    $AllMatches = @()
  }

  PROCESS{
    # Matching users - LineUri
    try{
      Get-CsUser | Where-Object {$_.LineURI -imatch $LineUri} | Select-Object -Property DisplayName,SipAddress,LineURI | ForEach-Object {$AllMatches += New-Object -TypeName PSObject -Property @{Name = $_.DisplayName; SipAddress = $_.SipAddress; Number = $_.LineURI; Type = 'User'}}
    }
    catch{
      Write-Verbose -Message $_.exception.message
    }

    # Matching users - PrivateLine
    try{
      Get-CsUser | Where-Object {$_.PrivateLine -imatch $LineUri} | Select-Object -Property DisplayName,SipAddress,PrivateLine | ForEach-Object {$AllMatches += New-Object -TypeName PSObject -Property @{Name = $_.DisplayName; SipAddress = $_.SipAddress; Number = $_.PrivateLine; Type = 'UserPrivateLine'}}
    }
    catch{
      Write-Verbose -Message $_.exception.message
    }

    # Matching analog devices
    try{
      Get-CsAnalogDevice | Where-Object {$_.LineURI -imatch $LineUri} | Select-Object -Property DisplayName,SipAddress,LineURI | ForEach-Object {$AllMatches += New-Object -TypeName PSObject -Property @{Name = $_.DisplayName; SipAddress = $_.SipAddress; Number = $_.LineURI; Type = 'AnalogDevice'}}
    }
    catch{
      Write-Verbose -Message $_.exception.message
    }

    # Matching common area phones
    try{
      Get-CsCommonAreaPhone | Where-Object {$_.LineURI -imatch $LineUri} | Select-Object -Property DisplayName,SipAddress,LineURI | ForEach-Object {$AllMatches += New-Object -TypeName PSObject -Property @{Name = $_.DisplayName; SipAddress = $_.SipAddress; Number = $_.LineURI; Type = 'CommonArea'}}
    }
    catch{
      Write-Verbose -Message $_.exception.message
    }

    # Matching UM contacts
    try{
      Get-CsExUmContact | Where-Object {$_.LineURI -imatch $LineUri} | Select-Object -Property DisplayName,SipAddress,LineURI | ForEach-Object {$AllMatches += New-Object -TypeName PSObject -Property @{Name = $_.DisplayName; SipAddress = $_.SipAddress; Number = $_.LineURI; Type = 'ExUmContact'}}
    }
    catch{
      Write-Verbose -Message $_.exception.message
    }

    # Matching dial-in conferencing numbers
    try{
      Get-CsDialInConferencingAccessNumber | Where-Object {$_.LineURI -imatch $LineUri} | Select-Object -Property DisplayName,PrimaryUri,LineURI | ForEach-Object {$AllMatches += New-Object -TypeName PSObject -Property @{Name = $_.DisplayName; SipAddress = $_.PrimaryUri; Number = $_.LineURI; Type = 'DialInAccess'}}
    }
    catch{
      Write-Verbose -Message $_.exception.message
    }

    # Matching trusted application numbers
    try{
      Get-CsTrustedApplicationEndpoint | Where-Object {$_.LineURI -imatch $LineUri} | Select-Object -Property DisplayName,SipAddress,LineURI | ForEach-Object {$AllMatches += New-Object -TypeName PSObject -Property @{Name = $_.DisplayName; SipAddress = $_.SipAddress; Number = $_.LineURI; Type = 'ApplicationEndpoint'}}
    }
    catch{
      Write-Verbose -Message $_.exception.message
    }

    # Matching response group numbers
    try{
      Get-CsRgsWorkflow | Select-Object -Property Name,PrimaryUri,LineURI | ForEach-Object {$AllMatches += New-Object -TypeName PSObject -Property @{Name = $_.Name; SipAddress = $_.PrimaryUri; Number = $_.LineURI; Type = 'Workflow'}}
    }
    catch{
      Write-Verbose -Message $_.exception.message
    }
  
    # Matching meeting rooms
    try{
      Get-CsMeetingRoom | Select-Object -Property Identity,SipAddress,LineURI | ForEach-Object {$AllMatches += New-Object -TypeName PSObject -Property @{Name = $_.Identity; SipAddress = $_.SipAddress; Number = $_.LineURI; Type = 'MeetingRoom'}}
    }
    catch{
      Write-Verbose -Message $_.exception.message
    }
  
    # Matching meeting rooms - PrivateLine
    try{
      Get-CsMeetingRoom | Select-Object -Property Identity,SipAddress,LineURI | ForEach-Object {$AllMatches += New-Object -TypeName PSObject -Property @{Name = $_.Identity; SipAddress = $_.SipAddress; Number = $_.PrivateLine; Type = 'MeetingRoomPrivateLine'}}
    }
    catch{
      Write-Verbose -Message $_.exception.message
    }
  }

  END{
    $AllMatches
  }
}