plugins {
    id("com.android.application")

    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration

    // The Flutter Gradle Plugin must be applied after
    // the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.quick_bite"

    compileSdk = flutter.compileSdkVersion

    ndkVersion = flutter.ndkVersion

    //==========================================================
    // JAVA / CORE LIBRARY DESUGARING
    //==========================================================

    compileOptions {
        isCoreLibraryDesugaringEnabled = true

        sourceCompatibility =
            JavaVersion.VERSION_17

        targetCompatibility =
            JavaVersion.VERSION_17
    }

    //==========================================================
    // DEFAULT CONFIGURATION
    //==========================================================

    defaultConfig {
        applicationId =
            "com.example.quick_bite"

        minSdk =
            flutter.minSdkVersion

        targetSdk =
            flutter.targetSdkVersion

        versionCode =
            flutter.versionCode

        versionName =
            flutter.versionName
    }

    //==========================================================
    // BUILD TYPES
    //==========================================================

    buildTypes {
        release {
            // TODO: Add your own signing config
            // for the release build.

            // Signing with debug keys for now,
            // so flutter run --release works.
            signingConfig =
                signingConfigs
                    .getByName("debug")
        }
    }
}

//==============================================================
// CORE LIBRARY DESUGARING DEPENDENCY
//==============================================================

dependencies {
    coreLibraryDesugaring(
        "com.android.tools:desugar_jdk_libs:2.1.5"
    )
}

//==============================================================
// KOTLIN
//==============================================================

kotlin {
    compilerOptions {
        jvmTarget =
            org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

//==============================================================
// FLUTTER
//==============================================================

flutter {
    source = "../.."
}