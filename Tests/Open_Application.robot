*** Settings ***

Library    AppiumLibrary
Test Teardown    Run Keyword If Test Failed    Capture Page Screenshot    ${OUTPUT_DIR}/failure.png

*** Test Cases ***
Open Application
    Open Application    http://localhost:4723     platformName=Android    deviceName=emulator-5554    appPackage=com.aratai.chat    appActivity=com.arattai.home.presentation.ui.ExternalEntryPointActivity    automationName=UiAutomator2    newCommandTimeout=60
    # Fail    This test is intentionally failed to verify screenshot on failure