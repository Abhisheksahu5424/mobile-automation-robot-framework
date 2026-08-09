# Mobile Automation with Robot Framework

This project automates an Android app using Robot Framework and Appium.

## Prerequisites

- Ubuntu 22.04+ or compatible Linux
- Java JDK 17
- Android Studio and Android SDK
- Node.js 22+ installed with `nvm`
- Appium 2 installed globally
- UiAutomator2 Appium driver installed
- Android emulator or device connected via ADB
- Python 3.12 recommended (3.10+ supported)
- `ANDROID_HOME` and `ANDROID_SDK_ROOT` configured

For the full setup guide, see `SETUP.md`.

## Installation

Create and activate a Python environment, then install the dependencies:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

## Services to run before tests

1. Start or connect an Android device/emulator:

```bash
emulator -list-avds
emulator -avd <AVD_NAME>
adb devices
```

2. Start Appium 2 and confirm the UiAutomator2 driver is available:

```bash
./start_appium.sh
appium driver list --installed
```

3. Optionally verify Android environment setup with Appium Doctor:

```bash
appium-doctor --android
```

## Run the test

From the project root:

```bash
robot -d Output --loglevel INFO Tests/Open_Application.robot
```

## Run Appium + test wrapper

Use the helper script from the project root:

```bash
chmod +x run_tests.sh
./run_tests.sh
```

## Project layout

- `Tests/` - Robot test files
- `Resources/` - reusable Robot resources
- `Data/` - test data
- `Output/` - generated reports and logs
- `start_appium.sh` - helper script to start Appium with the correct environment
