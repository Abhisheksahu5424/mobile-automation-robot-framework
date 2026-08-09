# Mobile Automation Setup Guide

This document covers the full Ubuntu setup for Appium 2 + Robot Framework + Python.

## Overview

This repo runs Robot Framework tests against Android using Appium 2 and UiAutomator2. The following setup is required before running tests.

## Prerequisites

- Ubuntu 22.04+ or compatible Linux
- Java JDK 17
- Android Studio and Android SDK
- Node.js 22 LTS installed via `nvm`
- Appium 2 installed globally
- UiAutomator2 Appium driver installed
- Python 3.12 recommended (3.10+ supported)
- An Android emulator or device connected via ADB

## 1. Install Java JDK 17

```bash
sudo apt update
sudo apt install openjdk-17-jdk -y
java --version
```

Expected output contains `openjdk 17.x.x`.

## 2. Install Android Studio

```bash
sudo snap install android-studio --classic
```

Then launch Android Studio and install the SDK components.

## 3. Install Android SDK Components

Open Android Studio → More Actions → SDK Manager.

### SDK Platforms
- Android 15 (API 35)
- or Android 14 (API 34)

### SDK Tools
- Android SDK Platform-Tools
- Android SDK Build-Tools
- Android Emulator
- Android SDK Command-line Tools (latest)

Click Apply → OK.

## 4. Configure Android environment variables

Add the following to `~/.zshrc` or `~/.bashrc`:

```bash
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/build-tools"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
```

Reload the shell:

```bash
source ~/.zshrc
```

Verify:

```bash
echo $ANDROID_HOME
which adb
adb version
```

## 5. Configure JAVA_HOME

Find the Java install path:

```bash
readlink -f $(which java)
```

Then add to your shell config:

```bash
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH="$JAVA_HOME/bin:$PATH"
```

Reload and verify:

```bash
source ~/.zshrc
echo $JAVA_HOME
```

## 6. Create an Android emulator

Open Android Studio → Device Manager → Create Virtual Device.

Recommended:
- Device: Pixel 8 or Pixel 7
- System image: Android 15 API 35

Launch the emulator:

```bash
emulator -list-avds
emulator -avd <AVD_NAME>
```

Verify the device is connected:

```bash
adb devices
```

Expected output includes `emulator-5554 device`.

## 7. Install Node.js via nvm

Do not use `sudo apt install nodejs npm` for Appium.

Install `nvm`:

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
source ~/.zshrc
```

Install and pin Node 22 LTS:

```bash
nvm install 22
nvm use 22
nvm alias default 22
node -v
npm -v
which node
```

Expected `node` path is under `~/.nvm`.

## 8. Install Appium 2

Install Appium globally using `npm`:

```bash
npm install -g appium@2
appium -v
```

Install the UiAutomator2 driver:

```bash
appium driver install uiautomator2
appium driver list --installed
```

Expected installed drivers include `uiautomator2`.

## 9. Install Appium Doctor

```bash
npm install -g @appium/doctor
appium-doctor --version
appium-doctor --android
```

All Android checks should pass:
- Node.js
- ANDROID_HOME
- adb
- emulator
- JAVA_HOME

## 10. Install Python and create a virtual environment

Install Python 3.12 if needed:

```bash
sudo apt update
sudo apt install python3.12 python3.12-venv python3.12-dev -y
python3.12 --version
```

Create the project environment:

```bash
cd /path/to/mobile-automation-robot-framework
python3.12 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
```

## 11. Install Python libraries

Install the project dependencies:

```bash
pip install -r requirements.txt
```

If you need to pin dependencies later:

```bash
pip freeze > requirements.txt
```

## 12. Start Appium server

From the project root:

```bash
./start_appium.sh
```

Alternatively, run Appium directly:

```bash
appium
```

Default server URL is `http://127.0.0.1:4723`.

## 13. Verify Robot Framework

```bash
robot --version
```

## 14. Run the test

From the project root:

```bash
robot -d Output --loglevel INFO Tests/Open_Application.robot
```

Or run the wrapper:

```bash
chmod +x run_tests.sh
./run_tests.sh
```

## 15. Useful commands

| Purpose | Command |
| --- | --- |
| List devices | `adb devices` |
| Install APK | `adb install app.apk` |
| Uninstall app | `adb uninstall <package.name>` |
| Clear app data | `adb shell pm clear <package.name>` |
| Screenshot | `adb exec-out screencap -p > screenshot.png` |
| Current activity | `adb shell dumpsys window | grep mCurrentFocus` |

## 16. Troubleshooting

### npm permission error

If `npm install -g` fails with `EACCES`, uninstall apt-based Node and reinstall via `nvm`.

### Unsupported Node engine

If Appium warns about Node 18, upgrade to Node 22 with `nvm`.

### `appium` not found

Ensure `nvm` is loaded in the shell and the correct Node binary is active.

### Conda base is active

If your prompt shows `(base)`, use the project `.venv` instead of Conda for Python dependencies.

## 17. Final environment checklist

- Java 17 installed and `JAVA_HOME` configured
- Android SDK and emulator installed
- `ANDROID_HOME` / `ANDROID_SDK_ROOT` configured
- Node 22 installed via `nvm`
- Appium 2 installed without `sudo`
- UiAutomator2 driver installed
- Appium Doctor Android checks passed
- Python virtual environment created and activated
- Robot Framework dependencies installed
- Android emulator/device connected and visible in `adb devices`
