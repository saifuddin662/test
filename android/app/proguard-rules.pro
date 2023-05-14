# Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 19,March,2023.

#Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class io.flutter.plugin.editing.** { *; }
-keep class androidx.lifecycle.** { *; }

#Firebase
-keep class com.google.firebase.** { *; }
-keep class com.firebase.** { *; }
-keep class org.apache.** { *; }
-keepnames class com.fasterxml.jackson.** { *; }
-keepnames class javax.servlet.** { *; }
-keepnames class org.ietf.jgss.** { *; }
-dontwarn org.w3c.dom.**
-dontwarn org.joda.time.**
-dontwarn org.shaded.apache.**
-dontwarn org.ietf.jgss.**
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses

#Crashlytics
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception

#SSl Commerz
-keep public class **.BuildConfig { *; }
-keepclassmembers class **.R$* {public static <fields>;}

-keepclassmembernames class * {
    public protected <methods>;
}
-keep class com.sslwireless.** { *; }
