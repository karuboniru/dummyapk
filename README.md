# Dummy URI Handler Android App

This Android app registers itself to handle custom URI schemes starting with `weixin://`. It doesn't perform any complex functions but demonstrates how to register and handle custom URI intents.

## Features

- Registers intent filters for `weixin://` scheme
- Handles various weixin URI patterns:
  - `weixin://` (basic scheme)
  - `weixin://*` (any host)
  - `weixin://example/` (specific host with paths)
- Displays received URIs in the app interface
- Logs URI details for debugging

## Usage

### Testing the URI Handling

You can test the app by triggering dummy URIs using ADB commands:

```bash
# Basic dummy scheme
adb shell am start -d "weixin://" -a android.intent.action.VIEW

# Dummy scheme with host
adb shell am start -d "weixin://example.com" -a android.intent.action.VIEW

# Dummy scheme with path and query parameters
adb shell am start -d "weixin://example.com/path?param=value" -a android.intent.action.VIEW
```

### From Other Apps

You can also launch the app from other Android applications using intents:

```java
// Java example
Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse("weixin://example.com/test"));
startActivity(intent);
```

```kotlin
// Kotlin example
val intent = Intent(Intent.ACTION_VIEW, Uri.parse("weixin://example.com/test"))
startActivity(intent)
```

### From Web Pages

The app can also be triggered from web pages using links:

```html
<a href="weixin://example.com/open">Open Dummy App</a>
```

## Project Structure

```
dummy_app/
├── app/
│   ├── src/main/
│   │   ├── AndroidManifest.xml  # Intent filter declarations
│   │   ├── java/com/example/dummyapp/
│   │   │   └── MainActivity.java  # URI handling logic
│   │   └── res/
│   │       ├── layout/activity_main.xml  # UI layout
│   │       └── values/strings.xml  # String resources
│   └── build.gradle  # App dependencies
├── build.gradle  # Project configuration
└── settings.gradle  # Project settings
```

## Building the App

1. Open the project in Android Studio
2. Build and run the app on an Android device or emulator
3. Test the URI handling using the ADB commands above

## Customization

To modify the URI scheme, update the `AndroidManifest.xml` file:

```xml
<data android:scheme="your-custom-scheme" android:host="your-host" />
```

The app will automatically handle any URIs that match the registered patterns and display them in the interface.

## Continuous Integration with GitHub Actions

This project includes a GitHub Actions workflow that automatically builds the APK on every push to the main branch and creates a downloadable artifact.

### GitHub Actions Workflow

The workflow file (`.github/workflows/build-apk.yml`) performs the following:

1. **Triggers**: Runs on pushes to main/master branches, pull requests, and manual triggers
2. **Environment**: Uses Ubuntu latest with JDK 17 and Android SDK
3. **Build Process**: 
   - Checks out the code
   - Sets up Java and Android environment
   - Makes gradlew executable
   - Builds the debug APK using `./gradlew assembleDebug`
4. **Artifacts**: 
   - Uploads the built APK as a downloadable artifact
   - Creates a GitHub release with the APK on main branch pushes

### Accessing Built APKs

After a successful workflow run:
1. Go to the **Actions** tab in your GitHub repository
2. Click on the latest workflow run
3. Download the `app-debug` artifact from the **Artifacts** section
4. The APK will be available at `app/build/outputs/apk/debug/app-debug.apk`

### Manual Testing

You can install and test the built APK using ADB:

```bash
# Install the APK
adb install app-debug.apk

# Test URI handling
adb shell am start -d "weixin://example.com/test" -a android.intent.action.VIEW
```

## Notes

- The app requires no special permissions
- It works on Android 5.0 (API 21) and above
- The URI handling is logged to Logcat with tag "DummyApp"
- GitHub Actions builds debug APKs (unsigned) suitable for testing
