/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

module nuvk.core.platform;
import std.format;

/**
    Whether the target platform is an Apple platform
    running the Darwin kernel.
*/
version(OSX) enum NuvkIsAppleOS = true;
else version(iOS) enum NuvkIsAppleOS = true;
else version(TVOS) enum NuvkIsAppleOS = true;
else version(WatchOS) enum NuvkIsAppleOS = true;
else version(VisionOS) enum NuvkIsAppleOS = true;
else enum NuvkIsAppleOS = false;

/**
    Whether the target platform is a mobile
    Apple platform with their own specialized API.
*/
version(iOS) enum NuvkIsAppleMobileOS = true;
else version(TVOS) enum NuvkIsAppleMobileOS = true;
else version(WatchOS) enum NuvkIsAppleMobileOS = true;
else version(VisionOS) enum NuvkIsAppleMobileOS = true;
else enum NuvkIsAppleMobileOS = false;

/**
    Whether the target platform is an ARM platform.
*/
version(ARM) enum NuvkIsARM = true;
else version(AArch64) enum NuvkIsARM = true;
else enum NuvkIsARM = false;

/**
    Whether the target platform is WebAssembly.
*/
version(WebAssembly) enum NuvkIsWeb = true;
else enum NuvkIsWeb = false;

/**
    Whether the target platform is POSIX compliant.
*/
version(Posix) enum NuvkIsPOSIX = true;
else enum NuvkIsPOSIX = false;

/**
    Whether the target platform is Windows.
*/
version(Windows) enum NuvkIsWindows = true;
else enum NuvkIsWindows = false;

/**
    The D compiler in use.
*/
__gshared const(string) nuvkCompiler = "%s %s".format(__VENDOR__, __VERSION__);