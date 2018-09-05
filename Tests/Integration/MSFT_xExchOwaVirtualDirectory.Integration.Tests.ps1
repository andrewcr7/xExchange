<#
    .SYNOPSIS
        Automated integration test for MSFT_xExchOwaVirtualDirectory DSC Resource.
        This test module requires use of credentials.
        The first run through of the tests will prompt for credentials from the logged on user.
#>

#region HEADER
[System.String]$script:moduleRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
[System.String]$script:DSCModuleName = 'xExchange'
[System.String]$script:DSCResourceFriendlyName = 'xExchOwaVirtualDirectory'
[System.String]$script:DSCResourceName = "MSFT_$($script:DSCResourceFriendlyName)"

Import-Module -Name (Join-Path -Path $script:moduleRoot -ChildPath (Join-Path -Path 'Tests' -ChildPath (Join-Path -Path 'TestHelpers' -ChildPath 'xExchangeTestHelper.psm1'))) -Force
Import-Module -Name (Join-Path -Path $script:moduleRoot -ChildPath (Join-Path -Path 'Modules' -ChildPath 'xExchangeHelper.psm1')) -Force
Import-Module -Name (Join-Path -Path $script:moduleRoot -ChildPath (Join-Path -Path 'DSCResources' -ChildPath (Join-Path -Path "$($script:DSCResourceName)" -ChildPath "$($script:DSCResourceName).psm1")))

#Check if Exchange is installed on this machine. If not, we can't run tests
[System.Boolean]$exchangeInstalled = Get-IsSetupComplete

#endregion HEADER

if ($exchangeInstalled)
{
    #Get required credentials to use for the test
    $shellCredentials = Get-TestCredential

    #Get the Server FQDN for using in URL's
    if ($null -eq $serverFqdn)
    {
        $serverFqdn = [System.Net.Dns]::GetHostByName($env:COMPUTERNAME).HostName
    }

    GetRemoteExchangeSession -Credential $shellCredentials -CommandsToLoad 'Get-ExchangeCertificate'

    #Get the thumbprint to use for Lync integration
    [System.Object[]]$exCerts = Get-ExchangeCertificate

    if ($exCerts.Count -gt 0)
    {
        $imCertThumbprint = $exCerts[0].Thumbprint
    }
    else
    {
        Write-Error 'At least one Exchange certificate must be installed to perform tests in this file'
        return
    }

    Describe 'Test Setting Properties with xExchOwaVirtualDirectory' {
        $testParams = @{
            Identity =  "$($env:COMPUTERNAME)\owa (Default Web Site)"
            Credential = $shellCredentials
            #AdfsAuthentication = $false #Don't test AdfsAuthentication changes in dedicated OWA tests, as they have to be done to ECP at the same time
            BasicAuthentication = $true
            ChangePasswordEnabled = $true
            DigestAuthentication = $false
            ExternalUrl = "https://$($serverFqdn)/owa"
            FormsAuthentication = $true
            InstantMessagingEnabled = $false
            InstantMessagingCertificateThumbprint = ''
            InstantMessagingServerName = ''
            InstantMessagingType = 'None'
            InternalUrl = "https://$($serverFqdn)/owa"
            LogonPagePublicPrivateSelectionEnabled = $true
            LogonPageLightSelectionEnabled = $true
            WindowsAuthentication = $false
            LogonFormat = 'PrincipalName'
            DefaultDomain = 'contoso.local'
        }

        $expectedGetResults = @{
            Identity =  "$($env:COMPUTERNAME)\owa (Default Web Site)"
            BasicAuthentication = $true
            ChangePasswordEnabled = $true
            DigestAuthentication = $false
            ExternalUrl = "https://$($serverFqdn)/owa"
            FormsAuthentication = $true
            InstantMessagingEnabled = $false
            InstantMessagingCertificateThumbprint = ''
            InstantMessagingServerName = ''
            InstantMessagingType = 'None'
            InternalUrl = "https://$($serverFqdn)/owa"
            LogonPagePublicPrivateSelectionEnabled = $true
            LogonPageLightSelectionEnabled = $true
            WindowsAuthentication = $false
            LogonFormat = 'PrincipalName'
            DefaultDomain = 'contoso.local'
        }

        Test-TargetResourceFunctionality -Params $testParams -ContextLabel 'Set standard parameters' -ExpectedGetResults $expectedGetResults


        $testParams = @{
            Identity =  "$($env:COMPUTERNAME)\owa (Default Web Site)"
            Credential = $shellCredentials
            BasicAuthentication = $false
            ChangePasswordEnabled = $false
            DigestAuthentication = $true
            ExternalUrl = ''
            FormsAuthentication = $false
            InstantMessagingEnabled = $true
            InstantMessagingCertificateThumbprint = $imCertThumbprint
            InstantMessagingServerName = $env:COMPUTERNAME
            InstantMessagingType = 'Ocs'
            InternalUrl = ''
            LogonPagePublicPrivateSelectionEnabled = $false
            LogonPageLightSelectionEnabled = $false
            WindowsAuthentication = $true
            LogonFormat = 'FullDomain'
            DefaultDomain = ''
        }

        $expectedGetResults = @{
            Identity =  "$($env:COMPUTERNAME)\owa (Default Web Site)"
            BasicAuthentication = $false
            ChangePasswordEnabled = $false
            DigestAuthentication = $true
            ExternalUrl = ''
            FormsAuthentication = $false
            InstantMessagingEnabled = $true
            InstantMessagingCertificateThumbprint = $imCertThumbprint
            InstantMessagingServerName = $env:COMPUTERNAME
            InstantMessagingType = 'Ocs'
            InternalUrl = ''
            LogonPagePublicPrivateSelectionEnabled = $false
            LogonPageLightSelectionEnabled = $false
            WindowsAuthentication = $true
            LogonFormat = 'FullDomain'
            DefaultDomain = ''
        }

        Test-TargetResourceFunctionality -Params $testParams -ContextLabel 'Try with the opposite of each property value' -ExpectedGetResults $expectedGetResults


        #Set Authentication values back to default
        $testParams = @{
            Identity =  "$($env:COMPUTERNAME)\owa (Default Web Site)"
            Credential = $shellCredentials
            BasicAuthentication = $true
            DigestAuthentication = $false
            FormsAuthentication = $true
            WindowsAuthentication = $false
        }

        $expectedGetResults = @{
            Identity =  "$($env:COMPUTERNAME)\owa (Default Web Site)"
            BasicAuthentication = $true
            DigestAuthentication = $false
            FormsAuthentication = $true
            WindowsAuthentication = $false
        }

        Test-TargetResourceFunctionality -Params $testParams -ContextLabel 'Reset authentication to default' -ExpectedGetResults $expectedGetResults
    }
}
else
{
    Write-Verbose -Message 'Tests in this file require that Exchange is installed to be run.'
}
