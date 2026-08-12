*** Settings ***
Library           AppiumLibrary
Test Teardown     Run Keyword If Test Failed    Run Keyword And Ignore Error    Capture Page Screenshot    ${OUTPUT_DIR}/failure.png

*** Variables ***
${APP_PACKAGE}    com.aratai.chat
${APP_ACTIVITY}   com.arattai.home.presentation.ui.ExternalEntryPointActivity   
${APP_URL}       http://localhost:4723
${Automation_Name}    UiAutomator2
${Device_Name}    emulator-5554
${New_Command_Timeout}    60
${Platform_Name}    Android
# ${Agree_Button}    xpath=//android.widget.Button[@text="Agree and continue"]
${Agree_Button}    xpath=//android.widget.TextView[@text="Agree and continue"]


*** Test Cases ***
Accept Terms and Conditions
    [Setup]    Open Application    ${APP_URL}    platformName=${Platform_Name}    deviceName=${Device_Name}    ${APP_PACKAGE}     ${APP_ACTIVITY}    automationName=${Automation_Name}    newCommandTimeout=${New_Command_Timeout}

    # Wait for the onboarding screen text to load safely
    # Wait Until Element Is Visible    xpath=//*[@text='Multi-device']    timeout=15

    # Action: Click the agreement button using the UIAutomator text strategy
    Click Element    ${Agree_Button}

    [Teardown]    Close Application