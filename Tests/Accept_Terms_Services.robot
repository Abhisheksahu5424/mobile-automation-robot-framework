*** Settings ***
Library           AppiumLibrary
Test Teardown     Run Keyword If Test Failed    Run Keyword And Ignore Error    Capture Page Screenshot    ${OUTPUT_DIR}/failure.png

*** Variables ***
${APP_PACKAGE}    com.aratai.chat
${APP_ACTIVITY}   com.arattai.home.presentation.ui.ExternalEntryPointActivity   
# ${Agree_Button}    xpath=//android.widget.Button[@text="Agree and continue"]
${Agree_Button}    xpath=//android.widget.TextView[@text="Agree and continue"]


*** Test Cases ***
Accept Terms and Conditions
    [Setup]    Open Application    http://localhost:4723    platformName=Android    deviceName=emulator-5554    appPackage=com.aratai.chat    appActivity=com.arattai.home.presentation.ui.ExternalEntryPointActivity    automationName=UiAutomator2    newCommandTimeout=60

    # Wait for the onboarding screen text to load safely
    # Wait Until Element Is Visible    xpath=//*[@text='Multi-device']    timeout=15

    # Action: Click the agreement button using the UIAutomator text strategy
    Click Element    ${Agree_Button}

    [Teardown]    Close Application