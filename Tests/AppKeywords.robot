*** Settings ***
Library    AppiumLibrary
Library    OperatingSystem

*** Variables ***
${APPIUM_URL}      http://localhost:4723
${PLATFORM_NAME}   Android
${DEVICE_NAME}     emulator-5554
${APP_PACKAGE}     com.cummins.guidanz
${APP_ACTIVITY}    com.cummins.guidanz.ui.uihelper.splashscreen.view.SplashScreen
${AUTOMATION_NAME}    UiAutomator2
${NEW_COMMAND_TIMEOUT}    60
${AUTO_GRANT_PERMISSIONS}    true
${SCREENSHOT_DIR}    ${OUTPUT_DIR}/AppScreenshots
${Click_Confirm_Button}    xpath= //android.widget.RelativeLayout[@resource-id="com.cummins.guidanz:id/layoutA1Continue"]

*** Keywords ***
Open App
    Open Application    ${APPIUM_URL}
    ...    platformName=${PLATFORM_NAME}
    ...    deviceName=${DEVICE_NAME}
    ...    appPackage=${APP_PACKAGE}
    ...    appActivity=${APP_ACTIVITY}
    ...    automationName=${AUTOMATION_NAME}
    ...    newCommandTimeout=${NEW_COMMAND_TIMEOUT}
    ...    autoGrantPermissions=${AUTO_GRANT_PERMISSIONS}

Take App Screenshot
    [Arguments]    ${name}
    Create Directory    ${SCREENSHOT_DIR}
    Capture Page Screenshot    ${SCREENSHOT_DIR}/${name}.png

Click Confirm Button
    Wait Until Element Is Visible    ${Click_Confirm_Button}    10s
    Click Element    ${Click_Confirm_Button}
    Take App Screenshot    04_after_click_continue
    Sleep    3s

Close App
    Close Application

Assert Visual Match
    [Arguments]    ${baseline}    ${actual}    ${threshold}=0.98    ${region}=
    ${status}    ${message}=    Run Keyword And Ignore Error    Verify Slide Design    ${baseline}    ${actual}    threshold=${threshold}    region=${region}
    Run Keyword If    '${status}' == 'FAIL'    Log    Visual validation FAILED for '${actual}'. Details: ${message}    ERROR
    Run Keyword If    '${status}' == 'PASS'    Log    Visual validation PASSED for '${actual}'    INFO
    Should Be Equal    ${status}    PASS    msg=Visual validation failed for ${actual}: ${message}
