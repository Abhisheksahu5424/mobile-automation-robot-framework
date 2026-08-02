# Mobile Automation with Robot Framework

This project automates an Android app using Robot Framework and Appium.

## Prerequisites

- Python 3.10+
- Android emulator or device connected via ADB
- Appium installed globally or in the active environment
- Android SDK configured with `ANDROID_HOME` and `ANDROID_SDK_ROOT`

## Installation

Create and activate a Python environment, then install the dependencies:

```bash
pip install -r requirements.txt
```

## Start Appium

Run the helper script from the project root:

```bash
./start_appium.sh
```

## Run the test

```bash
robot -d Output --loglevel INFO Tests/Open_Application.robot
```

## Project layout

- `Tests/` - Robot test files
- `Resources/` - reusable Robot resources
- `Data/` - test data
- `Output/` - generated reports and logs
- `start_appium.sh` - helper script to start Appium with the correct environment
