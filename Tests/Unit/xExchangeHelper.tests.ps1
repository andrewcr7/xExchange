#region HEADER
$script:DSCModuleName = 'xExchange'
$script:DSCHelperName = "xExchangeHelper"

# Unit Test Template Version: 1.2.2
$script:moduleRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

Import-Module -Name (Join-Path -Path $script:moduleRoot -ChildPath (Join-Path -Path 'Modules' -ChildPath 'xExchangeHelper.psm1')) -Force

#endregion HEADER

function Invoke-TestSetup
{

}

function Invoke-TestCleanup
{

}

# Begin Testing
try
{
    Invoke-TestSetup

    InModuleScope $script:DSCHelperName {
        # Used for calls to Get-InstallStatus
        $getInstallStatusParams = @{
            Arguments = '/mode:Install /role:Mailbox /Iacceptexchangeserverlicenseterms'
        }

        # Get a unique Guid that doesn't resolve to a local path
        # Use System.Guid, as New-Guid isn't available in PS4 and below
        do
        {
            $guid1 = [System.Guid]::NewGuid().ToString()
        } while (Test-Path -Path $guid1)

        # Get a unique Guid that doesn't resolve to a local path
        do
        {
            $guid2 = [System.Guid]::NewGuid().ToString()
        } while ((Test-Path -Path $guid2) -or $guid1 -like $guid2)

        Describe 'xExchangeHelper\Get-InstallStatus' -Tag 'Helper' {
            AfterEach {
                Assert-MockCalled -CommandName Get-ShouldInstallLanguagePack -Exactly -Times 1 -Scope It
                Assert-MockCalled -CommandName Get-IsSetupRunning -Exactly -Times 1 -Scope It
                Assert-MockCalled -CommandName Get-IsSetupComplete -Exactly -Times 1 -Scope It
                Assert-MockCalled -CommandName Get-IsExchangePresent -Exactly -Times 1 -Scope It
            }

            Context 'When Exchange is not present on the system' {
                It 'Should only recommend starting the install' {
                    Mock -CommandName Get-ShouldInstallLanguagePack -MockWith { return $false }
                    Mock -CommandName Get-IsSetupRunning -MockWith { return $false }
                    Mock -CommandName Get-IsSetupComplete -MockWith { return $false }
                    Mock -CommandName Get-IsExchangePresent -MockWith { return $false }

                    $installStatus = Get-InstallStatus @getInstallStatusParams

                    $installStatus.ShouldInstallLanguagePack | Should -Be $false
                    $installStatus.SetupRunning | Should -Be $false
                    $installStatus.SetupComplete | Should -Be $false
                    $installStatus.ExchangePresent | Should -Be $false
                    $installStatus.ShouldStartInstall | Should -Be $true
                }
            }

            Context 'When Exchange Setup has fully completed' {
                It 'Should indicate setup is complete and Exchange is present' {
                    Mock -CommandName Get-ShouldInstallLanguagePack -MockWith { return $false }
                    Mock -CommandName Get-IsSetupRunning -MockWith { return $false }
                    Mock -CommandName Get-IsSetupComplete -MockWith { return $true }
                    Mock -CommandName Get-IsExchangePresent -MockWith { return $true }

                    $installStatus = Get-InstallStatus @getInstallStatusParams

                    $installStatus.ShouldInstallLanguagePack | Should -Be $false
                    $installStatus.SetupRunning | Should -Be $false
                    $installStatus.SetupComplete | Should -Be $true
                    $installStatus.ExchangePresent | Should -Be $true
                    $installStatus.ShouldStartInstall | Should -Be $false
                }
            }

            Context 'When Exchange Setup has partially completed' {
                It 'Should indicate that Exchange is present, but setup is not complete, and recommend starting an install' {
                    Mock -CommandName Get-ShouldInstallLanguagePack -MockWith { return $false }
                    Mock -CommandName Get-IsSetupRunning -MockWith { return $false }
                    Mock -CommandName Get-IsSetupComplete -MockWith { return $false }
                    Mock -CommandName Get-IsExchangePresent -MockWith { return $true }

                    $installStatus = Get-InstallStatus @getInstallStatusParams

                    $installStatus.ShouldInstallLanguagePack | Should -Be $false
                    $installStatus.SetupRunning | Should -Be $false
                    $installStatus.SetupComplete | Should -Be $false
                    $installStatus.ExchangePresent | Should -Be $true
                    $installStatus.ShouldStartInstall | Should -Be $true
                }
            }

            Context 'When Exchange Setup is currently running' {
                It 'Should indicate that Exchange is present and that setup is running' {
                    Mock -CommandName Get-ShouldInstallLanguagePack -MockWith { return $false }
                    Mock -CommandName Get-IsSetupRunning -MockWith { return $true }
                    Mock -CommandName Get-IsSetupComplete -MockWith { return $false }
                    Mock -CommandName Get-IsExchangePresent -MockWith { return $true }

                    $installStatus = Get-InstallStatus @getInstallStatusParams

                    $installStatus.ShouldInstallLanguagePack | Should -Be $false
                    $installStatus.SetupRunning | Should -Be $true
                    $installStatus.SetupComplete | Should -Be $false
                    $installStatus.ExchangePresent | Should -Be $true
                    $installStatus.ShouldStartInstall | Should -Be $false
                }
            }

            Context 'When a Language Pack install is requested, and the Language Pack has not been installed' {
                It 'Should indicate that setup has completed and a language pack Should -Be installed' {
                    Mock -CommandName Get-ShouldInstallLanguagePack -MockWith { return $true }
                    Mock -CommandName Get-IsSetupRunning -MockWith { return $false }
                    Mock -CommandName Get-IsSetupComplete -MockWith { return $true }
                    Mock -CommandName Get-IsExchangePresent -MockWith { return $true }

                    $installStatus = Get-InstallStatus @getInstallStatusParams

                    $installStatus.ShouldInstallLanguagePack | Should -Be $true
                    $installStatus.SetupRunning | Should -Be $false
                    $installStatus.SetupComplete | Should -Be $true
                    $installStatus.ExchangePresent | Should -Be $true
                    $installStatus.ShouldStartInstall | Should -Be $true
                }
            }
        }

        Describe 'xExchangeHelper\Get-PreviousError' -Tag 'Helper' {
            Context 'After an error occurs' {
                It 'Should retrieve the most recent error' {
                    # First get whatever error is currently on top of the stack
                    $initialError = Get-PreviousError

                    # Cause an error by trying to get a non-existent item
                    Get-ChildItem -Path $guid1 -ErrorAction SilentlyContinue

                    $firstError = Get-PreviousError

                    # Cause another error by trying to get a non-existent item
                    Get-ChildItem -Path $guid2 -ErrorAction SilentlyContinue

                    $secondError = Get-PreviousError

                    $initialError -ne $firstError | Should -Be $true
                    $secondError -ne $firstError | Should -Be $true
                    $firstError -eq $null | Should -Be $false
                    $secondError -eq $null | Should -Be $false
                }
            }

            Context 'When an error has not occurred' {
                It 'Should return the same previous error with each call' {
                    # Run Get-PreviousError twice in a row so we can later ensure results are the same
                    $error1 = Get-PreviousError
                    $error2 = Get-PreviousError

                    # Run a command that should always succeed
                    Get-ChildItem  | Out-Null

                    # Get the previous error one more time
                    $error3 = Get-PreviousError

                    $error1 -eq $error2 | Should -Be $true
                    $error1 -eq $error3 | Should -Be $true
                }
            }
        }

        Describe 'xExchangeHelper\Assert-NoNewError' -Tag 'Helper' {
            Context 'After a new, unique error occurs' {
                It 'Should throw an exception' {
                    # First get whatever error is currently on top of the stack
                    $initialError = Get-PreviousError

                    # Cause an error by trying to get a non-existent item
                    Get-ChildItem $guid1 -ErrorAction SilentlyContinue

                    $caughtException = $false

                    try
                    {
                        Assert-NoNewError -CmdletBeingRun "Get-ChildItem" -PreviousError $initialError
                    }
                    catch
                    {
                        $caughtException = $true
                    }

                    $caughtException | Should -Be $true
                }
            }

            Context 'When an error has not occurred' {
                It 'Should not throw an exception' {
                    # First get whatever error is currently on top of the stack
                    $initialError = Get-PreviousError

                    # Run a command that should always succeed
                    Get-ChildItem | Out-Null

                    $caughtException = $false

                    try
                    {
                        Assert-NoNewError -CmdletBeingRun "Get-ChildItem" -PreviousError $initialError
                    }
                    catch
                    {
                        $caughtException = $true
                    }

                    $caughtException | Should -Be $false
                }
            }
        }

        Describe 'xExchangeHelper\Assert-IsSupportedWithExchangeVersion' -Tag 'Helper' {
            $supportedVersionTestCases = @(
                @{Name='2013 Operation Supported on 2013';      ExchangeVersion='2013'; SupportedVersions='2013'}
                @{Name='2013 Operation Supported on 2013,2019'; ExchangeVersion='2013'; SupportedVersions='2013','2019'}
            )

            $notSupportedVersionTestCases = @(
                @{Name='2013 Operation Not Supported on 2016';      ExchangeVersion='2013'; SupportedVersions='2016'}
                @{Name='2013 Operation Not Supported on 2016,2019'; ExchangeVersion='2013'; SupportedVersions='2016','2019'}
            )

            Context 'When a supported version is passed' {
                It 'Should not throw an exception' -TestCases $supportedVersionTestCases {
                    param($Name, $ExchangeVersion, $SupportedVersions)

                    Mock -CommandName Get-ExchangeVersion -MockWith { return $ExchangeVersion }

                    $caughtException = $false

                    try
                    {
                        Assert-IsSupportedWithExchangeVersion -ObjectOrOperationName $Name -SupportedVersions $SupportedVersions
                    }
                    catch
                    {
                        $caughtException = $true
                    }

                    $caughtException | Should -Be $false
                }
            }

            Context 'When an unsupported version is passed' {
                It 'Should throw an exception' -TestCases $notSupportedVersionTestCases {
                    param($Name, $ExchangeVersion, $SupportedVersions)

                    Mock -CommandName Get-ExchangeVersion -MockWith { return $ExchangeVersion }

                    $caughtException = $false

                    try
                    {
                        Assert-IsSupportedWithExchangeVersion -ObjectOrOperationName $Name -SupportedVersions $SupportedVersions
                    }
                    catch
                    {
                        $caughtException = $true
                    }

                    $caughtException | Should -Be $true
                }
            }
        }
    }
}
finally
{
    Invoke-TestCleanup
}
