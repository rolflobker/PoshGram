#-------------------------------------------------------------------------
Set-Location -Path $PSScriptRoot
#-------------------------------------------------------------------------
$ModuleName = 'PoshGram'
$PathToManifest = [System.IO.Path]::Combine('..', '..', $ModuleName, "$ModuleName.psd1")
#-------------------------------------------------------------------------
if (Get-Module -Name $ModuleName -ErrorAction 'SilentlyContinue') {
    #if the module is already in memory, remove it
    Remove-Module -Name $ModuleName -Force
}
Import-Module $PathToManifest -Force
#-------------------------------------------------------------------------
$WarningPreference = "SilentlyContinue"
#-------------------------------------------------------------------------
#Import-Module $moduleNamePath -Force

InModuleScope PoshGram {
    #-------------------------------------------------------------------------
    $WarningPreference = "SilentlyContinue"
    function Write-Error {}
    $token = "#########:xxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxx"
    $chat = "-nnnnnnnnn"
    #-------------------------------------------------------------------------
    Describe 'Send-TelegramMediaGroup' -Tag Unit {
        $justRight = @(
            'photo1.jpg',
            'photo2.jpg'
        )
        BeforeEach {
            mock Test-Path { $true }
            mock Test-FileExtension { $true }
            mock Test-FileSize { $true }
            mock Get-Item {
                [PSCustomObject]@{
                    Mode          = "True"
                    LastWriteTime = "06/17/16     00:19"
                    Length        = "1902"
                    Name          = "diagvresults.jpg"
                }
            }#endMock
            mock Invoke-RestMethod -MockWith {
                [PSCustomObject]@{
                    ok     = "True"
                    result = @{
                        message_id       = 2222
                        from             = "@{id=#########; is_bot=True; first_name=botname; username=bot_name}"
                        chat             = "@{id=-#########; title=ChatName; type=group; all_members_are_administrators=True}"
                        date             = "1530157540"
                        photo            = "{@{file_id=AgADAQAD-qcxG3V1oUWan8rsJbPxtH6vCjAABG9Ju7DQr02GYgMBAAEC; file_size=1084;file_path=photos/file_427.jpg; width=90; height=85},@{file_id=AgADAQAD-qcxG3V1oUWan8rsJbPxtH6vCj################; file_size=2305; width=123;height=116}}"
                        caption          = "Please work, please"
                        caption_entities = "{@{offset=13; length=6; type=bold}}"
                    }
                }
            }#endMock
        }#before_each
        Context 'Error' {
            It 'should return false if the files provided are fewer than 2' {
                $tooFew = @(
                    'photo1.jpg'
                )
                Send-TelegramMediaGroup `
                    -BotToken $token `
                    -ChatID $chat `
                    -MediaType Photo `
                    -FilePaths $tooFew `
                    | Should -Be $false
            }#it
            It 'should return false if the files provided are great than 10' {
                $tooMany = @(
                    'photo1.jpg',
                    'photo2.jpg',
                    'photo3.jpg',
                    'photo4.jpg',
                    'photo5.jpg',
                    'photo6.jpg',
                    'photo7.jpg',
                    'photo8.jpg',
                    'photo9.jpg',
                    'photo10.jpg',
                    'photo11.jpg'
                )
                Send-TelegramMediaGroup `
                    -BotToken $token `
                    -ChatID $chat `
                    -MediaType Photo `
                    -FilePaths $tooMany `
                    | Should -Be $false
            }#it
            It 'should return false if the media can not be found' {
                mock Test-Path { $false }
                Send-TelegramMediaGroup `
                    -BotToken $token `
                    -ChatID $chat `
                    -MediaType Photo `
                    -FilePaths $justRight `
                    | Should -Be $false
            }#it
            It 'should return false if the media extension is not supported' {
                mock Test-FileExtension { $false }
                Send-TelegramMediaGroup `
                    -BotToken $token `
                    -ChatID $chat `
                    -MediaType Photo `
                    -FilePaths $justRight `
                    | Should -Be $false
            }#it
            It 'should return false if the media is too large' {
                mock Test-FileSize { $false }
                Send-TelegramMediaGroup `
                    -BotToken $token `
                    -ChatID $chat `
                    -MediaType Video `
                    -FilePaths $justRight `
                    | Should -Be $false
            }#it
            It 'should return false if it cannot successfuly get the file' {
                mock Get-Item {
                    Throw 'Bullshit Error'
                }#endMock
                Send-TelegramMediaGroup `
                    -BotToken $token `
                    -ChatID $chat `
                    -MediaType Photo `
                    -FilePaths $justRight `
                    | Should -Be $false
            }#it
            It 'should return false if an error is encountered sending the message' {
                mock Invoke-RestMethod {
                    Throw 'Bullshit Error'
                }#endMock
                Send-TelegramMediaGroup `
                    -BotToken $token `
                    -ChatID $chat `
                    -MediaType Photo `
                    -FilePaths $justRight `
                    | Should -Be $false
            }#it
        }#context_error
        Context 'Success' {
            It 'should return a custom PSCustomObject if successful' {
                Send-TelegramMediaGroup `
                    -BotToken $token `
                    -ChatID $chat `
                    -MediaType Photo `
                    -FilePaths $justRight `
                    -DisableNotification `
                    | Should -BeOfType System.Management.Automation.PSCustomObject
            }#it
        }#context_success
    }#describe_Send-TelegramMediaGroup
}#inModule