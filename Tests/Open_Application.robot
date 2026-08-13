*** Settings ***
Library    AppiumLibrary
Library    OperatingSystem

Suite Setup    Create Directory    ${OUTPUT_DIR}/AppScreenshots
Test Teardown    Run Keyword If Test Failed    Run Keyword And Ignore Error    Capture Page Screenshot    ${OUTPUT_DIR}/failure.png

*** Variables ***
${SCREENSHOT_DIR}    ${OUTPUT_DIR}/AppScreenshots
${Click_Confirm_Button}    xpath= //android.widget.RelativeLayout[@resource-id="com.cummins.guidanz:id/layoutA1Continue"]

*** Keywords ***
Take App Screenshot
    [Arguments]    ${name}
    Capture Page Screenshot    ${SCREENSHOT_DIR}/${name}.png

*** Test Cases ***
Open App and Capture Screens
    Open Application    http://localhost:4723
    ...    platformName=Android
    ...    deviceName=emulator-5554
    ...    appPackage=com.cummins.guidanz
    ...    appActivity=com.cummins.guidanz.ui.uihelper.splashscreen.view.SplashScreen
    ...    automationName=UiAutomator2
    ...    newCommandTimeout=60
    ...    autoGrantPermissions=true

    Take App Screenshot    00_app_opened
    Sleep    3s

    Take App Screenshot    01_after_each_page_load
    Sleep    3s


    Take App Screenshot    02_splash
    Sleep    3s


    Take App Screenshot    03_main_page
    sleep    3s

Click Confirm Button
    wait until element is visible    ${Click_Confirm_Button}    10s
    Click Element    ${Click_Confirm_Button}

    Take App Screenshot    04_after_click_continue
    Sleep    3s

    Take App Screenshot    05_Continue_to_next_page

    Close Application