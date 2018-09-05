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

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [Parameter()]
        [ValidateSet('BestAvailability','GoodAvailability','Lossless')]
        [System.String]
        $AutoDatabaseMountDial,

        [Parameter()]
        [System.Int32]
        $CalendarRepairIntervalEndWindow,

        [Parameter()]
        [System.String]
        $CalendarRepairLogDirectorySizeLimit,

        [Parameter()]
        [System.Boolean]
        $CalendarRepairLogEnabled,

        [Parameter()]
        [System.String]
        $CalendarRepairLogFileAgeLimit,

        [Parameter()]
        [System.String]
        $CalendarRepairLogPath,

        [Parameter()]
        [System.Boolean]
        $CalendarRepairLogSubjectLoggingEnabled,

        [Parameter()]
        [System.Boolean]
        $CalendarRepairMissingItemFixDisabled,

        [Parameter()]
        [ValidateSet('ValidateOnly','RepairAndValidate')]
        [System.String]
        $CalendarRepairMode,

        [Parameter()]
        [System.String]
        $CalendarRepairWorkCycle,

        [Parameter()]
        [System.String]
        $CalendarRepairWorkCycleCheckpoint,

        [Parameter()]
        [System.Boolean]
        $DatabaseCopyActivationDisabledAndMoveNow,

        [Parameter()]
        [ValidateSet('Blocked','IntrasiteOnly','Unrestricted')]
        [System.String]
        $DatabaseCopyAutoActivationPolicy,

        [Parameter()]
        [System.String]
        $DomainController,

        [Parameter()]
        [System.Boolean]
        $FolderLogForManagedFoldersEnabled,

        [Parameter()]
        [System.Boolean]
        $ForceGroupMetricsGeneration,

        [Parameter()]
        [System.Boolean]
        $IsExcludedFromProvisioning,

        [Parameter()]
        [System.Boolean]
        $JournalingLogForManagedFoldersEnabled,

        [Parameter()]
        [System.String[]]
        $Locale,

        [Parameter()]
        [System.String]
        $LogDirectorySizeLimitForManagedFolders,

        [Parameter()]
        [System.String]
        $LogFileAgeLimitForManagedFolders,

        [Parameter()]
        [System.String]
        $LogFileSizeLimitForManagedFolders,

        [Parameter()]
        [System.String]
        $LogPathForManagedFolders,

        [Parameter()]
        [System.String]
        $MailboxProcessorWorkCycle,

        [Parameter()]
        [System.String[]]
        $ManagedFolderAssistantSchedule,

        [Parameter()]
        [System.String]
        $ManagedFolderWorkCycle,

        [Parameter()]
        [System.String]
        $ManagedFolderWorkCycleCheckpoint,

        [Parameter()]
        [System.Boolean]
        $MAPIEncryptionRequired,

        [Parameter()]
        [System.String]
        $MaximumActiveDatabases,

        [Parameter()]
        [System.String]
        $MaximumPreferredActiveDatabases,

        [Parameter()]
        [System.String]
        $OABGeneratorWorkCycle,

        [Parameter()]
        [System.String]
        $OABGeneratorWorkCycleCheckpoint,

        [Parameter()]
        [System.String]
        $PublicFolderWorkCycle,

        [Parameter()]
        [System.String]
        $PublicFolderWorkCycleCheckpoint,

        [Parameter()]
        [System.Boolean]
        $RetentionLogForManagedFoldersEnabled,

        [Parameter()]
        [System.String[]]
        $SharingPolicySchedule,

        [Parameter()]
        [System.String]
        $SharingPolicyWorkCycle,

        [Parameter()]
        [System.String]
        $SharingPolicyWorkCycleCheckpoint,

        [Parameter()]
        [System.String]
        $SharingSyncWorkCycle,

        [Parameter()]
        [System.String]
        $SharingSyncWorkCycleCheckpoint,

        [Parameter()]
        [System.String]
        $SiteMailboxWorkCycle,

        [Parameter()]
        [System.String]
        $SiteMailboxWorkCycleCheckpoint,

        [Parameter()]
        [System.Boolean]
        $SubjectLogForManagedFoldersEnabled,

        [Parameter()]
        [System.String]
        $TopNWorkCycle,

        [Parameter()]
        [System.String]
        $TopNWorkCycleCheckpoint,

        [Parameter()]
        [System.String]
        $UMReportingWorkCycle,

        [Parameter()]
        [System.String]
        $UMReportingWorkCycleCheckpoint,

        [Parameter()]
        [System.String]
        $WacDiscoveryEndpoint
    )

    LogFunctionEntry -Parameters @{"Identity" = $Identity} -Verbose:$VerbosePreference

    #Establish remote Powershell session
    GetRemoteExchangeSession -Credential $Credential -CommandsToLoad 'Get-MailboxServer' -Verbose:$VerbosePreference

    $server = GetMailboxServer @PSBoundParameters

    if ($null -ne $server)
    {
        $returnValue = @{
            Identity                                 = [System.String] $Identity
            AutoDatabaseMountDial                    = [System.String] $server.AutoDatabaseMountDial
            CalendarRepairIntervalEndWindow          = [System.Int32] $server.CalendarRepairIntervalEndWindow
            CalendarRepairLogDirectorySizeLimit      = [System.String] $server.CalendarRepairLogDirectorySizeLimit
            CalendarRepairLogEnabled                 = [System.Boolean] $server.CalendarRepairLogEnabled
            CalendarRepairLogFileAgeLimit            = [System.String] $server.CalendarRepairLogFileAgeLimit
            CalendarRepairLogPath                    = [System.String] $server.CalendarRepairLogPath
            CalendarRepairLogSubjectLoggingEnabled   = [System.Boolean] $server.CalendarRepairLogSubjectLoggingEnabled
            CalendarRepairMissingItemFixDisabled     = [System.Boolean] $server.CalendarRepairMissingItemFixDisabled
            CalendarRepairMode                       = [System.String] $server.CalendarRepairMode
            DatabaseCopyActivationDisabledAndMoveNow = [System.Boolean] $server.DatabaseCopyActivationDisabledAndMoveNow
            DatabaseCopyAutoActivationPolicy         = [System.String] $server.DatabaseCopyAutoActivationPolicy
            FolderLogForManagedFoldersEnabled        = [System.Boolean] $server.FolderLogForManagedFoldersEnabled
            ForceGroupMetricsGeneration              = [System.Boolean] $server.ForceGroupMetricsGeneration
            IsExcludedFromProvisioning               = [System.Boolean] $server.IsExcludedFromProvisioning
            JournalingLogForManagedFoldersEnabled    = [System.Boolean] $server.JournalingLogForManagedFoldersEnabled
            Locale                                   = [System.String[]] $Server.Locale
            LogDirectorySizeLimitForManagedFolders   = [System.String] $server.LogDirectorySizeLimitForManagedFolders
            LogFileAgeLimitForManagedFolders         = [System.String] $server.LogFileAgeLimitForManagedFolders
            LogFileSizeLimitForManagedFolders        = [System.String] $server.LogFileSizeLimitForManagedFolders
            LogPathForManagedFolders                 = [System.String] $server.LogPathForManagedFolders
            MAPIEncryptionRequired                   = [System.Boolean] $server.MAPIEncryptionRequired
            MaximumActiveDatabases                   = [System.String] $server.MaximumActiveDatabases
            MaximumPreferredActiveDatabases          = [System.String] $server.MaximumPreferredActiveDatabases
            RetentionLogForManagedFoldersEnabled     = [System.Boolean] $server.RetentionLogForManagedFoldersEnabled
            SharingPolicySchedule                    = [System.String[]] $server.SharingPolicySchedule
            SubjectLogForManagedFoldersEnabled       = [System.Boolean] $server.SubjectLogForManagedFoldersEnabled
        }

        $serverVersion = Get-ExchangeVersion

        if ($serverVersion -in '2016','2019')
        {
            $returnValue.Add('WacDiscoveryEndpoint', [System.String]$server.WacDiscoveryEndpoint)
        }
        elseif ($serverVersion -eq '2013')
        {
            if ($null -ne $server.ManagedFolderAssistantSchedule)
            {
                $mfaSchedule = [System.String[]]$server.ManagedFolderAssistantSchedule
            }
            else
            {
                $mfaSchedule = [System.String[]]@()
            }

            $returnValue.Add('CalendarRepairWorkCycle', [System.String]$server.CalendarRepairWorkCycle)
            $returnValue.Add('CalendarRepairWorkCycleCheckpoint', [System.String]$server.CalendarRepairWorkCycleCheckpoint)
            $returnValue.Add('MailboxProcessorWorkCycle', [System.String]$server.MailboxProcessorWorkCycle)
            $returnValue.Add('ManagedFolderAssistantSchedule', $mfaSchedule)
            $returnValue.Add('ManagedFolderWorkCycle', [System.String]$server.ManagedFolderWorkCycle)
            $returnValue.Add('ManagedFolderWorkCycleCheckpoint', [System.String]$server.ManagedFolderWorkCycleCheckpoint)
            $returnValue.Add('OABGeneratorWorkCycle', [System.String]$server.OABGeneratorWorkCycle)
            $returnValue.Add('OABGeneratorWorkCycleCheckpoint', [System.String]$server.OABGeneratorWorkCycleCheckpoint)
            $returnValue.Add('PublicFolderWorkCycle', [System.String]$server.PublicFolderWorkCycle)
            $returnValue.Add('PublicFolderWorkCycleCheckpoint', [System.String]$server.PublicFolderWorkCycleCheckpoint)
            $returnValue.Add('SharingPolicyWorkCycle', [System.String]$server.SharingPolicyWorkCycle)
            $returnValue.Add('SharingPolicyWorkCycleCheckpoint', [System.String]$server.SharingPolicyWorkCycleCheckpoint)
            $returnValue.Add('SharingSyncWorkCycle', [System.String]$server.SharingSyncWorkCycle)
            $returnValue.Add('SharingSyncWorkCycleCheckpoint', [System.String]$server.SharingSyncWorkCycleCheckpoint)
            $returnValue.Add('SiteMailboxWorkCycle', [System.String]$server.SiteMailboxWorkCycle)
            $returnValue.Add('SiteMailboxWorkCycleCheckpoint', [System.String]$server.SiteMailboxWorkCycleCheckpoint)
            $returnValue.Add('TopNWorkCycle', [System.String]$server.TopNWorkCycle)
            $returnValue.Add('TopNWorkCycleCheckpoint', [System.String]$server.TopNWorkCycleCheckpoint)
            $returnValue.Add('UMReportingWorkCycle', [System.String]$server.UMReportingWorkCycle)
            $returnValue.Add('UMReportingWorkCycleCheckpoint', [System.String]$server.UMReportingWorkCycleCheckpoint)
        }
        else
        {
            Write-Verbose -Message 'Could not detect Exchange version'
        }
    }

    $returnValue
}

function Set-TargetResource
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSDSCUseVerboseMessageInDSCResource", "")]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [Parameter()]
        [ValidateSet('BestAvailability','GoodAvailability','Lossless')]
        [System.String]
        $AutoDatabaseMountDial,

        [Parameter()]
        [System.Int32]
        $CalendarRepairIntervalEndWindow,

        [Parameter()]
        [System.String]
        $CalendarRepairLogDirectorySizeLimit,

        [Parameter()]
        [System.Boolean]
        $CalendarRepairLogEnabled,

        [Parameter()]
        [System.String]
        $CalendarRepairLogFileAgeLimit,

        [Parameter()]
        [System.String]
        $CalendarRepairLogPath,

        [Parameter()]
        [System.Boolean]
        $CalendarRepairLogSubjectLoggingEnabled,

        [Parameter()]
        [System.Boolean]
        $CalendarRepairMissingItemFixDisabled,

        [Parameter()]
        [ValidateSet('ValidateOnly','RepairAndValidate')]
        [System.String]
        $CalendarRepairMode,

        [Parameter()]
        [System.String]
        $CalendarRepairWorkCycle,

        [Parameter()]
        [System.String]
        $CalendarRepairWorkCycleCheckpoint,

        [Parameter()]
        [System.Boolean]
        $DatabaseCopyActivationDisabledAndMoveNow,

        [Parameter()]
        [ValidateSet('Blocked','IntrasiteOnly','Unrestricted')]
        [System.String]
        $DatabaseCopyAutoActivationPolicy,

        [Parameter()]
        [System.String]
        $DomainController,

        [Parameter()]
        [System.Boolean]
        $FolderLogForManagedFoldersEnabled,

        [Parameter()]
        [System.Boolean]
        $ForceGroupMetricsGeneration,

        [Parameter()]
        [System.Boolean]
        $IsExcludedFromProvisioning,

        [Parameter()]
        [System.Boolean]
        $JournalingLogForManagedFoldersEnabled,

        [Parameter()]
        [System.String[]]
        $Locale,

        [Parameter()]
        [System.String]
        $LogDirectorySizeLimitForManagedFolders,

        [Parameter()]
        [System.String]
        $LogFileAgeLimitForManagedFolders,

        [Parameter()]
        [System.String]
        $LogFileSizeLimitForManagedFolders,

        [Parameter()]
        [System.String]
        $LogPathForManagedFolders,

        [Parameter()]
        [System.String]
        $MailboxProcessorWorkCycle,

        [Parameter()]
        [System.String[]]
        $ManagedFolderAssistantSchedule,

        [Parameter()]
        [System.String]
        $ManagedFolderWorkCycle,

        [Parameter()]
        [System.String]
        $ManagedFolderWorkCycleCheckpoint,

        [Parameter()]
        [System.Boolean]
        $MAPIEncryptionRequired,

        [Parameter()]
        [System.String]
        $MaximumActiveDatabases,

        [Parameter()]
        [System.String]
        $MaximumPreferredActiveDatabases,

        [Parameter()]
        [System.String]
        $OABGeneratorWorkCycle,

        [Parameter()]
        [System.String]
        $OABGeneratorWorkCycleCheckpoint,

        [Parameter()]
        [System.String]
        $PublicFolderWorkCycle,

        [Parameter()]
        [System.String]
        $PublicFolderWorkCycleCheckpoint,

        [Parameter()]
        [System.Boolean]
        $RetentionLogForManagedFoldersEnabled,

        [Parameter()]
        [System.String[]]
        $SharingPolicySchedule,

        [Parameter()]
        [System.String]
        $SharingPolicyWorkCycle,

        [Parameter()]
        [System.String]
        $SharingPolicyWorkCycleCheckpoint,

        [Parameter()]
        [System.String]
        $SharingSyncWorkCycle,

        [Parameter()]
        [System.String]
        $SharingSyncWorkCycleCheckpoint,

        [Parameter()]
        [System.String]
        $SiteMailboxWorkCycle,

        [Parameter()]
        [System.String]
        $SiteMailboxWorkCycleCheckpoint,

        [Parameter()]
        [System.Boolean]
        $SubjectLogForManagedFoldersEnabled,

        [Parameter()]
        [System.String]
        $TopNWorkCycle,

        [Parameter()]
        [System.String]
        $TopNWorkCycleCheckpoint,

        [Parameter()]
        [System.String]
        $UMReportingWorkCycle,

        [Parameter()]
        [System.String]
        $UMReportingWorkCycleCheckpoint,

        [Parameter()]
        [System.String]
        $WacDiscoveryEndpoint
    )

    LogFunctionEntry -Parameters @{'Identity' = $Identity} -Verbose:$VerbosePreference

    #Establish remote Powershell session
    GetRemoteExchangeSession -Credential $Credential -CommandsToLoad 'Set-MailboxServer' -Verbose:$VerbosePreference

    #Setup params for next command
    RemoveParameters -PSBoundParametersIn $PSBoundParameters -ParamsToRemove 'Credential'

    #create array of Exchange 2013 only parameters
    [array]$Exchange2013Only = 'CalendarRepairWorkCycle','CalendarRepairWorkCycleCheckpoint','MailboxProcessorWorkCycle','ManagedFolderAssistantSchedule','ManagedFolderWorkCycle',
    'ManagedFolderWorkCycleCheckpoint','OABGeneratorWorkCycle','OABGeneratorWorkCycleCheckpoint','PublicFolderWorkCycle','PublicFolderWorkCycleCheckpoint','SharingPolicyWorkCycle',
    'SharingPolicyWorkCycleCheckpoint','SharingSyncWorkCycle','SharingSyncWorkCycleCheckpoint','SiteMailboxWorkCycle','SiteMailboxWorkCycleCheckpoint','TopNWorkCycle','TopNWorkCycleCheckpoint',
    'UMReportingWorkCycle','UMReportingWorkCycleCheckpoint'

    $serverVersion = Get-ExchangeVersion
    if ($serverVersion -eq '2013')
    {
      #Check for non-existent parameters in Exchange 2013
      Remove-NotApplicableParamsForVersion -PSBoundParametersIn $PSBoundParameters -ParamName 'WacDiscoveryEndpoint' -ResourceName 'xExchMailboxServer' -ParamExistsInVersion '2016','2019'
    }
    elseif ($serverVersion -in '2016','2019')
    {
      foreach ($Exchange2013Parameter in $Exchange2013Only)
      {
        #Check for non-existent parameters in Exchange 2016
        Remove-NotApplicableParamsForVersion -PSBoundParametersIn $PSBoundParameters -ParamName "$Exchange2013Parameter" -ResourceName 'xExchMailboxServer' -ParamExistsInVersion '2013'
      }
    }
    else
    {
        Write-Verbose -Message 'Could not detect Exchange version'
    }

    #Ensure an empty string is $null and not a string
    SetEmptyStringParamsToNull -PSBoundParametersIn $PSBoundParameters

    Set-MailboxServer @PSBoundParameters

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

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [Parameter()]
        [ValidateSet('BestAvailability','GoodAvailability','Lossless')]
        [System.String]
        $AutoDatabaseMountDial,

        [Parameter()]
        [System.Int32]
        $CalendarRepairIntervalEndWindow,

        [Parameter()]
        [System.String]
        $CalendarRepairLogDirectorySizeLimit,

        [Parameter()]
        [System.Boolean]
        $CalendarRepairLogEnabled,

        [Parameter()]
        [System.String]
        $CalendarRepairLogFileAgeLimit,

        [Parameter()]
        [System.String]
        $CalendarRepairLogPath,

        [Parameter()]
        [System.Boolean]
        $CalendarRepairLogSubjectLoggingEnabled,

        [Parameter()]
        [System.Boolean]
        $CalendarRepairMissingItemFixDisabled,

        [Parameter()]
        [ValidateSet('ValidateOnly','RepairAndValidate')]
        [System.String]
        $CalendarRepairMode,

        [Parameter()]
        [System.String]
        $CalendarRepairWorkCycle,

        [Parameter()]
        [System.String]
        $CalendarRepairWorkCycleCheckpoint,

        [Parameter()]
        [System.Boolean]
        $DatabaseCopyActivationDisabledAndMoveNow,

        [Parameter()]
        [ValidateSet('Blocked','IntrasiteOnly','Unrestricted')]
        [System.String]
        $DatabaseCopyAutoActivationPolicy,

        [Parameter()]
        [System.String]
        $DomainController,

        [Parameter()]
        [System.Boolean]
        $FolderLogForManagedFoldersEnabled,

        [Parameter()]
        [System.Boolean]
        $ForceGroupMetricsGeneration,

        [Parameter()]
        [System.Boolean]
        $IsExcludedFromProvisioning,

        [Parameter()]
        [System.Boolean]
        $JournalingLogForManagedFoldersEnabled,

        [Parameter()]
        [System.String[]]
        $Locale,

        [Parameter()]
        [System.String]
        $LogDirectorySizeLimitForManagedFolders,

        [Parameter()]
        [System.String]
        $LogFileAgeLimitForManagedFolders,

        [Parameter()]
        [System.String]
        $LogFileSizeLimitForManagedFolders,

        [Parameter()]
        [System.String]
        $LogPathForManagedFolders,

        [Parameter()]
        [System.String]
        $MailboxProcessorWorkCycle,

        [Parameter()]
        [System.String[]]
        $ManagedFolderAssistantSchedule,

        [Parameter()]
        [System.String]
        $ManagedFolderWorkCycle,

        [Parameter()]
        [System.String]
        $ManagedFolderWorkCycleCheckpoint,

        [Parameter()]
        [System.Boolean]
        $MAPIEncryptionRequired,

        [Parameter()]
        [System.String]
        $MaximumActiveDatabases,

        [Parameter()]
        [System.String]
        $MaximumPreferredActiveDatabases,

        [Parameter()]
        [System.String]
        $OABGeneratorWorkCycle,

        [Parameter()]
        [System.String]
        $OABGeneratorWorkCycleCheckpoint,

        [Parameter()]
        [System.String]
        $PublicFolderWorkCycle,

        [Parameter()]
        [System.String]
        $PublicFolderWorkCycleCheckpoint,

        [Parameter()]
        [System.Boolean]
        $RetentionLogForManagedFoldersEnabled,

        [Parameter()]
        [System.String[]]
        $SharingPolicySchedule,

        [Parameter()]
        [System.String]
        $SharingPolicyWorkCycle,

        [Parameter()]
        [System.String]
        $SharingPolicyWorkCycleCheckpoint,

        [Parameter()]
        [System.String]
        $SharingSyncWorkCycle,

        [Parameter()]
        [System.String]
        $SharingSyncWorkCycleCheckpoint,

        [Parameter()]
        [System.String]
        $SiteMailboxWorkCycle,

        [Parameter()]
        [System.String]
        $SiteMailboxWorkCycleCheckpoint,

        [Parameter()]
        [System.Boolean]
        $SubjectLogForManagedFoldersEnabled,

        [Parameter()]
        [System.String]
        $TopNWorkCycle,

        [Parameter()]
        [System.String]
        $TopNWorkCycleCheckpoint,

        [Parameter()]
        [System.String]
        $UMReportingWorkCycle,

        [Parameter()]
        [System.String]
        $UMReportingWorkCycleCheckpoint,

        [Parameter()]
        [System.String]
        $WacDiscoveryEndpoint
    )

    LogFunctionEntry -Parameters @{"Identity" = $Identity} -Verbose:$VerbosePreference

    #Establish remote Powershell session
    GetRemoteExchangeSession -Credential $Credential -CommandsToLoad 'Get-MailboxServer','Set-MailboxServer' -Verbose:$VerbosePreference

    #create array of Exchange 2013 only parameters
    [array]$Exchange2013Only = 'CalendarRepairWorkCycle','CalendarRepairWorkCycleCheckpoint','MailboxProcessorWorkCycle','ManagedFolderAssistantSchedule','ManagedFolderWorkCycle',
    'ManagedFolderWorkCycleCheckpoint','OABGeneratorWorkCycle','OABGeneratorWorkCycleCheckpoint','PublicFolderWorkCycle','PublicFolderWorkCycleCheckpoint','SharingPolicyWorkCycle',
    'SharingPolicyWorkCycleCheckpoint','SharingSyncWorkCycle','SharingSyncWorkCycleCheckpoint','SiteMailboxWorkCycle','SiteMailboxWorkCycleCheckpoint','TopNWorkCycle','TopNWorkCycleCheckpoint',
    'UMReportingWorkCycle','UMReportingWorkCycleCheckpoint'

    $serverVersion = Get-ExchangeVersion
    if ($serverVersion -eq '2013')
    {
      #Check for non-existent parameters in Exchange 2013
      Remove-NotApplicableParamsForVersion -PSBoundParametersIn $PSBoundParameters -ParamName 'WacDiscoveryEndpoint' -ResourceName 'xExchMailboxServer' -ParamExistsInVersion '2016','2019'
    }
    elseif ($serverVersion -in '2016','2019')
    {
      foreach ($Exchange2013Parameter in $Exchange2013Only)
      {
        #Check for non-existent parameters in Exchange 2016
        Remove-NotApplicableParamsForVersion -PSBoundParametersIn $PSBoundParameters -ParamName "$Exchange2013Parameter" -ResourceName 'xExchMailboxServer' -ParamExistsInVersion '2013'
      }
    }
    else
    {
        Write-Verbose -Message 'Could not detect Exchange version'
    }

    $server = GetMailboxServer @PSBoundParameters

    $testResults = $true

    if ($null -eq $server) #Couldn't find the server, which is bad
    {
        Write-Error -Message 'Unable to retrieve Mailbox Server settings for server'

        $testResults = $false
    }
    else #Validate server params
    {
        if (!(VerifySetting -Name 'AutoDatabaseMountDial' -Type 'String' -ExpectedValue $AutoDatabaseMountDial -ActualValue $server.AutoDatabaseMountDial -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'CalendarRepairIntervalEndWindow' -Type 'Int' -ExpectedValue $CalendarRepairIntervalEndWindow -ActualValue $server.CalendarRepairIntervalEndWindow -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'CalendarRepairLogDirectorySizeLimit' -Type 'Unlimited' -ExpectedValue $CalendarRepairLogDirectorySizeLimit -ActualValue $server.CalendarRepairLogDirectorySizeLimit -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'CalendarRepairLogEnabled' -Type 'Boolean' -ExpectedValue $CalendarRepairLogEnabled -ActualValue $server.CalendarRepairLogEnabled -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'CalendarRepairLogFileAgeLimit' -Type 'TimeSpan' -ExpectedValue $CalendarRepairLogFileAgeLimit -ActualValue $server.CalendarRepairLogFileAgeLimit -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'CalendarRepairLogPath' -Type 'String' -ExpectedValue $CalendarRepairLogPath -ActualValue $server.CalendarRepairLogPath -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'CalendarRepairLogSubjectLoggingEnabled' -Type 'Boolean' -ExpectedValue $CalendarRepairLogSubjectLoggingEnabled -ActualValue $server.CalendarRepairLogSubjectLoggingEnabled -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'CalendarRepairMissingItemFixDisabled' -Type 'Boolean' -ExpectedValue $CalendarRepairMissingItemFixDisabled -ActualValue $server.CalendarRepairMissingItemFixDisabled -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'CalendarRepairMode' -Type 'String' -ExpectedValue $CalendarRepairMode -ActualValue $server.CalendarRepairMode -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'CalendarRepairWorkCycle' -Type 'TimeSpan' -ExpectedValue $CalendarRepairWorkCycle -ActualValue $server.CalendarRepairWorkCycle -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'CalendarRepairWorkCycleCheckpoint' -Type 'TimeSpan' -ExpectedValue $CalendarRepairWorkCycleCheckpoint -ActualValue $server.CalendarRepairWorkCycleCheckpoint -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'DatabaseCopyActivationDisabledAndMoveNow' -Type 'Boolean' -ExpectedValue $DatabaseCopyActivationDisabledAndMoveNow -ActualValue $server.DatabaseCopyActivationDisabledAndMoveNow -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'DatabaseCopyAutoActivationPolicy' -Type 'String' -ExpectedValue $DatabaseCopyAutoActivationPolicy -ActualValue $server.DatabaseCopyAutoActivationPolicy -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'FolderLogForManagedFoldersEnabled' -Type 'Boolean' -ExpectedValue $FolderLogForManagedFoldersEnabled -ActualValue $server.FolderLogForManagedFoldersEnabled -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'ForceGroupMetricsGeneration' -Type 'Boolean' -ExpectedValue $ForceGroupMetricsGeneration -ActualValue $server.ForceGroupMetricsGeneration -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'IsExcludedFromProvisioning' -Type 'Boolean' -ExpectedValue $IsExcludedFromProvisioning -ActualValue $server.IsExcludedFromProvisioning -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'JournalingLogForManagedFoldersEnabled' -Type 'Boolean' -ExpectedValue $JournalingLogForManagedFoldersEnabled -ActualValue $server.JournalingLogForManagedFoldersEnabled -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'Locale' -Type 'Array' -ExpectedValue $Locale -ActualValue $server.Locale -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'LogDirectorySizeLimitForManagedFolders' -Type 'Unlimited' -ExpectedValue $LogDirectorySizeLimitForManagedFolders -ActualValue $server.LogDirectorySizeLimitForManagedFolders -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'LogFileAgeLimitForManagedFolders' -Type 'TimeSpan' -ExpectedValue $LogFileAgeLimitForManagedFolders -ActualValue $server.LogFileAgeLimitForManagedFolders -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'LogFileSizeLimitForManagedFolders' -Type 'Unlimited' -ExpectedValue $LogFileSizeLimitForManagedFolders -ActualValue $server.LogFileSizeLimitForManagedFolders -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'LogPathForManagedFolders' -Type 'String' -ExpectedValue $LogPathForManagedFolders -ActualValue $server.LogPathForManagedFolders -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'MailboxProcessorWorkCycle' -Type 'TimeSpan' -ExpectedValue $MailboxProcessorWorkCycle -ActualValue $server.MailboxProcessorWorkCycle -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'ManagedFolderAssistantSchedule' -Type 'Array' -ExpectedValue $ManagedFolderAssistantSchedule -ActualValue $server.ManagedFolderAssistantSchedule -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'ManagedFolderWorkCycle' -Type 'TimeSpan' -ExpectedValue $ManagedFolderWorkCycle -ActualValue $server.ManagedFolderWorkCycle -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'ManagedFolderWorkCycleCheckpoint' -Type 'TimeSpan' -ExpectedValue $ManagedFolderWorkCycleCheckpoint -ActualValue $server.ManagedFolderWorkCycleCheckpoint -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'MAPIEncryptionRequired' -Type 'Boolean' -ExpectedValue $MAPIEncryptionRequired -ActualValue $server.MAPIEncryptionRequired -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'MaximumActiveDatabases' -Type 'String' -ExpectedValue $MaximumActiveDatabases -ActualValue $server.MaximumActiveDatabases -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'MaximumPreferredActiveDatabases' -Type 'String' -ExpectedValue $MaximumPreferredActiveDatabases -ActualValue $server.MaximumPreferredActiveDatabases -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'OABGeneratorWorkCycle' -Type 'TimeSpan' -ExpectedValue $OABGeneratorWorkCycle -ActualValue $server.OABGeneratorWorkCycle -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'OABGeneratorWorkCycleCheckpoint' -Type 'TimeSpan' -ExpectedValue $OABGeneratorWorkCycleCheckpoint -ActualValue $server.OABGeneratorWorkCycleCheckpoint -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'PublicFolderWorkCycle' -Type 'TimeSpan' -ExpectedValue $PublicFolderWorkCycle -ActualValue $server.PublicFolderWorkCycle -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'PublicFolderWorkCycleCheckpoint' -Type 'TimeSpan' -ExpectedValue $PublicFolderWorkCycleCheckpoint -ActualValue $server.PublicFolderWorkCycleCheckpoint -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'RetentionLogForManagedFoldersEnabled' -Type 'Boolean' -ExpectedValue $RetentionLogForManagedFoldersEnabled -ActualValue $server.RetentionLogForManagedFoldersEnabled -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'SharingPolicySchedule' -Type 'Array' -ExpectedValue $SharingPolicySchedule -ActualValue $server.SharingPolicySchedule -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'SharingPolicyWorkCycle' -Type 'TimeSpan' -ExpectedValue $SharingPolicyWorkCycle -ActualValue $server.SharingPolicyWorkCycle -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'SharingPolicyWorkCycleCheckpoint' -Type 'TimeSpan' -ExpectedValue $SharingPolicyWorkCycleCheckpoint -ActualValue $server.SharingPolicyWorkCycleCheckpoint -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'SharingSyncWorkCycle' -Type 'TimeSpan' -ExpectedValue $SharingSyncWorkCycle -ActualValue $server.SharingSyncWorkCycle -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'SharingSyncWorkCycleCheckpoint' -Type 'TimeSpan' -ExpectedValue $SharingSyncWorkCycleCheckpoint -ActualValue $server.SharingSyncWorkCycleCheckpoint -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'SiteMailboxWorkCycle' -Type 'TimeSpan' -ExpectedValue $SiteMailboxWorkCycle -ActualValue $server.SiteMailboxWorkCycle -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'SiteMailboxWorkCycleCheckpoint' -Type 'TimeSpan' -ExpectedValue $SiteMailboxWorkCycleCheckpoint -ActualValue $server.SiteMailboxWorkCycleCheckpoint -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'SubjectLogForManagedFoldersEnabled' -Type 'Boolean' -ExpectedValue $SubjectLogForManagedFoldersEnabled -ActualValue $server.SubjectLogForManagedFoldersEnabled -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'TopNWorkCycle' -Type 'TimeSpan' -ExpectedValue $TopNWorkCycle -ActualValue $server.TopNWorkCycle -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'TopNWorkCycleCheckpoint' -Type 'TimeSpan' -ExpectedValue $TopNWorkCycleCheckpoint -ActualValue $server.TopNWorkCycleCheckpoint -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'UMReportingWorkCycle' -Type 'TimeSpan' -ExpectedValue $UMReportingWorkCycle -ActualValue $server.UMReportingWorkCycle -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'UMReportingWorkCycleCheckpoint' -Type 'TimeSpan' -ExpectedValue $UMReportingWorkCycleCheckpoint -ActualValue $server.UMReportingWorkCycleCheckpoint -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }

        if (!(VerifySetting -Name 'WacDiscoveryEndpoint' -Type 'String' -ExpectedValue $WacDiscoveryEndpoint -ActualValue $server.WacDiscoveryEndpoint -PSBoundParametersIn $PSBoundParameters -Verbose:$VerbosePreference))
        {
            $testResults = $false
        }
    }

    return $testResults
}

#Runs Get-MailboxServer, only specifying Identity, and optionally DomainController
function GetMailboxServer
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,

        [Parameter()]
        [ValidateSet('BestAvailability','GoodAvailability','Lossless')]
        [System.String]
        $AutoDatabaseMountDial,

        [Parameter()]
        [System.Int32]
        $CalendarRepairIntervalEndWindow,

        [Parameter()]
        [System.String]
        $CalendarRepairLogDirectorySizeLimit,

        [Parameter()]
        [System.Boolean]
        $CalendarRepairLogEnabled,

        [Parameter()]
        [System.String]
        $CalendarRepairLogFileAgeLimit,

        [Parameter()]
        [System.String]
        $CalendarRepairLogPath,

        [Parameter()]
        [System.Boolean]
        $CalendarRepairLogSubjectLoggingEnabled,

        [Parameter()]
        [System.Boolean]
        $CalendarRepairMissingItemFixDisabled,

        [Parameter()]
        [ValidateSet('ValidateOnly','RepairAndValidate')]
        [System.String]
        $CalendarRepairMode,

        [Parameter()]
        [System.String]
        $CalendarRepairWorkCycle,

        [Parameter()]
        [System.String]
        $CalendarRepairWorkCycleCheckpoint,

        [Parameter()]
        [System.Boolean]
        $DatabaseCopyActivationDisabledAndMoveNow,

        [Parameter()]
        [ValidateSet('Blocked','IntrasiteOnly','Unrestricted')]
        [System.String]
        $DatabaseCopyAutoActivationPolicy,

        [Parameter()]
        [System.String]
        $DomainController,

        [Parameter()]
        [System.Boolean]
        $FolderLogForManagedFoldersEnabled,

        [Parameter()]
        [System.Boolean]
        $ForceGroupMetricsGeneration,

        [Parameter()]
        [System.Boolean]
        $IsExcludedFromProvisioning,

        [Parameter()]
        [System.Boolean]
        $JournalingLogForManagedFoldersEnabled,

        [Parameter()]
        [System.String[]]
        $Locale,

        [Parameter()]
        [System.String]
        $LogDirectorySizeLimitForManagedFolders,

        [Parameter()]
        [System.String]
        $LogFileAgeLimitForManagedFolders,

        [Parameter()]
        [System.String]
        $LogFileSizeLimitForManagedFolders,

        [Parameter()]
        [System.String]
        $LogPathForManagedFolders,

        [Parameter()]
        [System.String]
        $MailboxProcessorWorkCycle,

        [Parameter()]
        [System.String[]]
        $ManagedFolderAssistantSchedule,

        [Parameter()]
        [System.String]
        $ManagedFolderWorkCycle,

        [Parameter()]
        [System.String]
        $ManagedFolderWorkCycleCheckpoint,

        [Parameter()]
        [System.Boolean]
        $MAPIEncryptionRequired,

        [Parameter()]
        [System.String]
        $MaximumActiveDatabases,

        [Parameter()]
        [System.String]
        $MaximumPreferredActiveDatabases,

        [Parameter()]
        [System.String]
        $OABGeneratorWorkCycle,

        [Parameter()]
        [System.String]
        $OABGeneratorWorkCycleCheckpoint,

        [Parameter()]
        [System.String]
        $PublicFolderWorkCycle,

        [Parameter()]
        [System.String]
        $PublicFolderWorkCycleCheckpoint,

        [Parameter()]
        [System.Boolean]
        $RetentionLogForManagedFoldersEnabled,

        [Parameter()]
        [System.String[]]
        $SharingPolicySchedule,

        [Parameter()]
        [System.String]
        $SharingPolicyWorkCycle,

        [Parameter()]
        [System.String]
        $SharingPolicyWorkCycleCheckpoint,

        [Parameter()]
        [System.String]
        $SharingSyncWorkCycle,

        [Parameter()]
        [System.String]
        $SharingSyncWorkCycleCheckpoint,

        [Parameter()]
        [System.String]
        $SiteMailboxWorkCycle,

        [Parameter()]
        [System.String]
        $SiteMailboxWorkCycleCheckpoint,

        [Parameter()]
        [System.Boolean]
        $SubjectLogForManagedFoldersEnabled,

        [Parameter()]
        [System.String]
        $TopNWorkCycle,

        [Parameter()]
        [System.String]
        $TopNWorkCycleCheckpoint,

        [Parameter()]
        [System.String]
        $UMReportingWorkCycle,

        [Parameter()]
        [System.String]
        $UMReportingWorkCycleCheckpoint,

        [Parameter()]
        [System.String]
        $WacDiscoveryEndpoint
    )

    RemoveParameters -PSBoundParametersIn $PSBoundParameters -ParamsToKeep 'Identity','DomainController'

    return (Get-MailboxServer @PSBoundParameters)
}

Export-ModuleMember -Function *-TargetResource
