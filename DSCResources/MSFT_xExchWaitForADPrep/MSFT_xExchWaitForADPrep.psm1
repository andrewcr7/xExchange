function Get-TargetResource
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSDSCUseVerboseMessageInDSCResource", "")]
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [Parameter()]
        [System.Int32]
        $SchemaVersion,

        [Parameter()]
        [System.Int32]
        $OrganizationVersion,

        [Parameter()]
        [System.Int32]
        $DomainVersion,

        [Parameter()]
        [System.String[]]
        $ExchangeDomains,

        [Parameter()]
        [System.UInt32]
        $RetryIntervalSec = 60,

        [Parameter()]
        [System.UInt32]
        $RetryCount = 30
    )

    LogFunctionEntry -Verbose:$VerbosePreference

    $dse = GetADRootDSE -Credential $Credential

    if ($PSBoundParameters.ContainsKey('SchemaVersion'))
    {
        #Check for existence of schema object
        $schemaObj = GetADObject -Credential $credential -DistinguishedName "CN=ms-Exch-Schema-Version-Pt,$($dse.schemaNamingContext)" -Properties 'rangeUpper'

        if ($null -ne $schemaObj)
        {
            $currentSchemaVersion = $schemaObj.rangeUpper
        }
        else
        {
            Write-Warning "Unable to find schema object 'CN=ms-Exch-Schema-Version-Pt,$($dse.schemaNamingContext)'. This is either because Exchange /PrepareSchema has not been run, or because the configured account does not have permissions to access this object."
        }
    }

    if ($PSBoundParameters.ContainsKey('OrganizationVersion'))
    {
        $exchangeContainer = GetADObject -Credential $credential -DistinguishedName "CN=Microsoft Exchange,CN=Services,$($dse.configurationNamingContext)" -Properties 'rangeUpper'

        if ($null -ne $exchangeContainer)
        {
            $orgContainer = GetADObject -Credential $Credential -Searching $true -DistinguishedName "CN=Microsoft Exchange,CN=Services,$($dse.configurationNamingContext)" -Properties 'objectVersion' -Filter "objectClass -like 'msExchOrganizationContainer'" -SearchScope 'OneLevel'

            if ($null -ne $orgContainer)
            {
                $currentOrganizationVersion = $orgContainer.objectVersion
            }
            else
            {
                Write-Warning "Unable to find any objects of class msExchOrganizationContainer under 'CN=Microsoft Exchange,CN=Services,$($dse.configurationNamingContext)'. This is either because Exchange /PrepareAD has not been run, or because the configured account does not have permissions to access this object."
            }
        }
        else
        {
            Write-Warning "Unable to find Exchange Configuration Container at 'CN=Microsoft Exchange,CN=Services,$($dse.configurationNamingContext)'. This is either because Exchange /PrepareAD has not been run, or because the configured account does not have permissions to access this object."
        }
    }

    if ($PSBoundParameters.ContainsKey('DomainVersion'))
    {
        #Get this server's domain
        [System.String]$machineDomain = (Get-CimInstance -ClassName Win32_ComputerSystem).Domain.ToLower()

        #Figure out all domains we need to inspect
        [System.String[]]$targetDomains = @()
        $targetDomains += $machineDomain

        if ($null -ne $ExchangeDomains)
        {
            foreach ($domain in $ExchangeDomains)
            {
                $domainLower = $domain.ToLower()

                if ($targetDomains.Contains($domainLower) -eq $false)
                {
                    $targetDomains += $domainLower
                }
            }
        }

        #Populate the return value in a hashtable of domains and versions
        [Hashtable]$currentDomainVersions = @{}

        foreach ($domain in $targetDomains)
        {
            $domainDn = DomainDNFromFQDN -Fqdn $domain

            $mesoContainer = GetADObject -Credential $Credential -DistinguishedName "CN=Microsoft Exchange System Objects,$($domainDn)" -Properties 'objectVersion'

            $mesoVersion = $null

            if ($null -ne $mesoContainer)
            {
                $mesoVersion = $mesoContainer.objectVersion
            }
            else
            {
                Write-Warning "Unable to find object with DN 'CN=Microsoft Exchange System Objects,$($domainDn)'. This is either because Exchange /PrepareDomain has not been run for this domain, or because the configured account does not have permissions to access this object."
            }

            if ($null -eq $currentDomainVersions)
            {
                $currentDomainVersions = @{$domain = $mesoVersion}
            }
            else
            {
                $currentDomainVersions.Add($domain, $mesoVersion)
            }
        }
    }

    $returnValue = @{
        SchemaVersion       = [System.String] $currentSchemaVersion
        OrganizationVersion = [System.String] $currentOrganizationVersion
        DomainVersion       = [System.String] $currentDomainVersions
    }

    $returnValue
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [Parameter()]
        [System.Int32]
        $SchemaVersion,

        [Parameter()]
        [System.Int32]
        $OrganizationVersion,

        [Parameter()]
        [System.Int32]
        $DomainVersion,

        [Parameter()]
        [System.String[]]
        $ExchangeDomains,

        [Parameter()]
        [System.UInt32]
        $RetryIntervalSec = 60,

        [Parameter()]
        [System.UInt32]
        $RetryCount = 30
    )

    LogFunctionEntry -Verbose:$VerbosePreference

    $testResults = Test-TargetResource @PSBoundParameters

    for ($i = 0; $i -lt $RetryCount; $i++)
    {
        if ($testResults -eq $false)
        {
            Write-Verbose "AD has still not been fully prepped as of $([DateTime]::Now). Sleeping for $($RetryIntervalSec) seconds."
            Start-Sleep -Seconds $RetryIntervalSec

            $testResults = Test-TargetResource @PSBoundParameters
        }
        else
        {
            break
        }
    }

    if ($testResults -eq $false)
    {
        throw 'AD has still not been prepped after the maximum amount of retries.'
    }
}

function Test-TargetResource
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSDSCUseVerboseMessageInDSCResource", "")]
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [Parameter()]
        [System.Int32]
        $SchemaVersion,

        [Parameter()]
        [System.Int32]
        $OrganizationVersion,

        [Parameter()]
        [System.Int32]
        $DomainVersion,

        [Parameter()]
        [System.String[]]
        $ExchangeDomains,

        [Parameter()]
        [System.UInt32]
        $RetryIntervalSec = 60,

        [Parameter()]
        [System.UInt32]
        $RetryCount = 30
    )

    LogFunctionEntry -Verbose:$VerbosePreference

    $adStatus = Get-TargetResource @PSBoundParameters

    $testResults = $true

    if ($null -eq $adStatus)
    {
        $testResults = $false
    }
    else
    {
        if (!(VerifySetting -Name 'SchemaVersion' -Type 'Int' -ExpectedValue $SchemaVersion -ActualValue $adStatus.SchemaVersion -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'OrganizationVersion' -Type 'Int' -ExpectedValue $OrganizationVersion -ActualValue $adStatus.OrganizationVersion -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if ($PSBoundParameters.ContainsKey('DomainVersion'))
        {
            #Get this server's domain
            [System.String]$machineDomain = (Get-CimInstance -ClassName Win32_ComputerSystem).Domain.ToLower()

            #Figure out all domains we need to inspect
            [System.String[]]$targetDomains = @()
            $targetDomains += $machineDomain

            if ($null -ne $ExchangeDomains)
            {
                foreach ($domain in $ExchangeDomains)
                {
                    $domainLower = $domain.ToLower()

                    if ($targetDomains.Contains($domainLower) -eq $false)
                    {
                        $targetDomains += $domainLower
                    }
                }
            }

            #Compare the desired DomainVersion with the actual version of each domain
            foreach ($domain in $targetDomains)
            {
                if (!(VerifySetting -Name 'DomainVersion' -Type 'Int' -ExpectedValue $DomainVersion -ActualValue $adStatus.DomainVersion[$domain] -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
                {
                    $testResults = $false
                }
            }
        }
    }

    return $testResults
}

function GetADRootDSE
{
    param
    (
        [Parameter()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential
    )

    if ($null -eq $Credential)
    {
        $dse = Get-ADRootDSE -ErrorAction SilentlyContinue -ErrorVariable errVar
    }
    else
    {
        $dse = Get-ADRootDSE -Credential $Credential -ErrorAction SilentlyContinue -ErrorVariable errVar
    }

    return $dse
}

function GetADObject
{
    param
    (
        [Parameter()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [Parameter()]
        [System.Boolean]
        $Searching = $false,

        [Parameter()]
        [System.String]
        $DistinguishedName,

        [Parameter()]
        [System.String[]]
        $Properties,

        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.String]
        $SearchScope
    )

    if ($Searching -eq $false)
    {
        $getAdObjParams = @{'Identity' = $DistinguishedName}
    }
    else
    {
        $getAdObjParams = @{'SearchBase' = $DistinguishedName}

        if ([System.String]::IsNullOrEmpty($Filter) -eq $false)
        {
            $getAdObjParams.Add('Filter', $Filter)
        }

        if ([System.String]::IsNullOrEmpty($SearchScope) -eq $false)
        {
            $getAdObjParams.Add('SearchScope', $SearchScope)
        }
    }

    if ($null -ne $Credential)
    {
        $getAdObjParams.Add('Credential', $Credential)
    }

    if ([System.String]::IsNullOrEmpty($Properties) -eq $false)
    {
        $getAdObjParams.Add('Properties', $Properties)
    }

    #ErrorAction SilentlyContinue doesn't seem to work with Get-ADObject. Doing in Try/Catch instead
    try
    {
        $object = Get-ADObject @getAdObjParams
    }
    catch
    {
        Write-Warning "Failed to find object at '$DistinguishedName' using Get-ADObject."
    }

    return $object
}

function DomainDNFromFQDN
{
    param
    (
        [Parameter()]
        [System.String]
        $Fqdn
    )

    if ($Fqdn.Contains('.'))
    {
        $domainParts = $Fqdn.Split('.')

        $domainDn = "DC=$($domainParts[0])"

        for ($i = 1; $i -lt $domainParts.Count; $i++)
        {
            $domainDn = "$($domainDn),DC=$($domainParts[$i])"
        }
    }
    elseif ($Fqdn.Length -gt 0)
    {
        $domainDn = "DC=$($Fqdn)"
    }
    else
    {
        throw 'Empty value specified for domain name'
    }

    return $domainDn
}

Export-ModuleMember -Function *-TargetResource
