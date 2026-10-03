#!/usr/bin/env ruby
# Forces ENABLE_MODULE_VERIFIER = NO on every Pod target/config of
# ios/Pods/Pods.xcodeproj.
#
# Xcode 16 added a strict module-verifier build step that fails on every
# Flutter plugin whose umbrella header references Flutter/Flutter.h with
# quoted #imports (sqflite_darwin, permission_handler_apple,
# flutter_local_notifications, etc.). Our Podfile post_install sets this in
# the in-memory project, but CocoaPods (or Flutter's podhelper) reverts it
# for many targets before the project is saved.
#
# This script runs AFTER `pod install` and writes the setting directly to
# the saved project on disk, where it sticks.
#
# Usage: ruby ios/disable_module_verifier.rb  (auto-invoked from Podfile
# post_install)
require "xcodeproj"

path = File.expand_path(File.join(__dir__, "Pods", "Pods.xcodeproj"))
exit 0 unless File.exist?(path)

project = Xcodeproj::Project.open(path)

count = 0
project.build_configurations.each do |c|
  c.build_settings["ENABLE_MODULE_VERIFIER"] = "NO"
  c.build_settings["CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER"] = "NO"
  count += 1
end
project.targets.each do |t|
  t.build_configurations.each do |c|
    c.build_settings["ENABLE_MODULE_VERIFIER"] = "NO"
    c.build_settings["CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER"] = "NO"
    count += 1
  end
end

project.save
puts "[disable_module_verifier] patched #{count} build configurations"
