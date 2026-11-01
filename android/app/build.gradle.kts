plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val releaseSigningValues = listOf(
    "ANDROID_KEYSTORE_PATH",
    "ANDROID_KEY_ALIAS",
    "ANDROID_STORE_PASSWORD",
    "ANDROID_KEY_PASSWORD",
).associateWith { System.getenv(it) }
val missingReleaseSigningValues =
    releaseSigningValues.filterValues { it.isNullOrBlank() }.keys

gradle.taskGraph.whenReady {
    if (
        allTasks.any { it.name.contains("release", ignoreCase = true) } &&
        missingReleaseSigningValues.isNotEmpty()
    ) {
        throw org.gradle.api.GradleException(
            "Release builds require these environment variables: " +
                missingReleaseSigningValues.joinToString(", "),
        )
    }
}

android {
    namespace = "com.example.GMDex"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.GMDex"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            if (missingReleaseSigningValues.isEmpty()) {
                signingConfig = signingConfigs.create("release") {
                    storeFile = file(checkNotNull(releaseSigningValues["ANDROID_KEYSTORE_PATH"]))
                    storePassword = checkNotNull(releaseSigningValues["ANDROID_STORE_PASSWORD"])
                    keyAlias = checkNotNull(releaseSigningValues["ANDROID_KEY_ALIAS"])
                    keyPassword = checkNotNull(releaseSigningValues["ANDROID_KEY_PASSWORD"])
                }
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
