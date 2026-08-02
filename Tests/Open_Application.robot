*** Settings ***

Library    AppiumLibrary

*** Test Cases ***
Open Application
    Open Application    http://localhost:4723     platformName=Android    deviceName=emulator-5554    appPackage=com.aratai.chat    appActivity=com.arattai.home.presentation.ui.ExternalEntryPointActivity    automationName=UiAutomator2    newCommandTimeout=60