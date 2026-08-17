*** Settings ***
Resource    AppKeywords.robot
Library     ../library/VisualValidator.py

Suite Setup    Create Directory    ${OUTPUT_DIR}/AppScreenshots
Suite Teardown    Run Keyword And Ignore Error    Close App

*** Variables ***
${BASELINE_DIR}    ${CURDIR}/baseline_images
${SCREENSHOT_DIR}  ${OUTPUT_DIR}/AppScreenshots

*** Test Cases ***
Capture And Validate App Screens
    [Documentation]    Captures the app screens and validates each against the baseline images.

    # Capture initial app opened screen
    Open App
    Take App Screenshot    00_app_opened
    sleep    3s
    Assert Visual Match    ${BASELINE_DIR}/00_app_opened.png    ${SCREENSHOT_DIR}/00_app_opened.png    0.99
    Sleep    3s

    # Additional page snapshots
    Take App Screenshot    01_after_each_page_load
    sleep    3s
    Assert Visual Match    ${BASELINE_DIR}/01_after_each_page_load.png    ${SCREENSHOT_DIR}/01_after_each_page_load.png    0.70
    Sleep    3s

    Take App Screenshot    02_splash
    sleep    3s
    Assert Visual Match    ${BASELINE_DIR}/02_splash.png    ${SCREENSHOT_DIR}/02_splash.png    0.99
    Sleep    3s

    Take App Screenshot    03_main_page
    sleep    3s
    Assert Visual Match    ${BASELINE_DIR}/03_main_page.png    ${SCREENSHOT_DIR}/03_main_page.png    0.99
    Sleep    3s

    # Navigate forward and validate subsequent screens
    Click Confirm Button
    Take App Screenshot    04_after_click_continue
    sleep    3s
    Assert Visual Match    ${BASELINE_DIR}/04_after_click_continue.png    ${SCREENSHOT_DIR}/04_after_click_continue.png    0.99
    Sleep    3s

    Take App Screenshot    05_Continue_to_next_page
    sleep    3s
    Assert Visual Match    ${BASELINE_DIR}/05_Continue_to_next_page.png    ${SCREENSHOT_DIR}/05_Continue_to_next_page.png    0.99
    Sleep    3s

    Close App
