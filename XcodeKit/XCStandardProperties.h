/*
 * The sources in the "XcodeKit" directory are based on the Ruby project Xcoder.
 *
 * Copyright (c) 2012 cisimple
 *
 * MIT License
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <Cocoa/Cocoa.h>
#import "XCConfiguration.h"

// You can use -[NSString(ShellSplit) componentsSplitUsingShellQuotingRules] to split
// space-delimited string array values into their component parts. Boolean properties
// have two valid string values: YES and NO

/// \c PRODUCT_NAME (simple string)
extern NSString * const XCConfigurationPropertyProductName;
/// \c SUPPORTED_PLATFORMS (space-delimited string array)
extern NSString * const XCConfigurationPropertySupportedPlatforms;
/// \c GCC_PRECOMPILE_PREFIX_HEADER (boolean)
extern NSString * const XCConfigurationPropertyPrecompilePrefixHeader;
/// \c GCC_PREFIX_HEADER (simple string)
extern NSString * const XCConfigurationPropertyPrefixHeaderPath;
/// \c INFOPLIST_FILE (simple string)
extern NSString * const XCConfigurationPropertyBundleInfoPropertyListPath;
/// \c WRAPPER_EXTENSION (simple string)
extern NSString * const XCConfigurationPropertyWrapperExtension;
/// \c TARGETED_DEVICE_FAMILY (complex)
/// \par The value is a comma-delimited string of numeric values
/// (1 for iPhone and 2 for iPad).
extern NSString * const XCConfigurationPropertyTargetedDeviceFamily;
/// \c SDKROOT (simple string)
extern NSString * const XCConfigurationPropertySDKRoot;
/// \c OTHER_CFLAGS (space-delimited string array)
extern NSString * const XCConfigurationPropertyOtherCFlags;
/// \c GCC_C_LANGUAGE_STANDARD (simple string). Usually set to \c gnu99
extern NSString * const XCConfigurationPropertyCLanguageStandard;
/// \c ALWAYS_SEARCH_USER_PATHS (boolean)
extern NSString * const XCConfigurationPropertyAlwaysSearchUserPaths; // ...for header files in #include statements
/// \c GCC_VERSION (simple string)
extern NSString * const XCConfigurationPropertyGCCVersion;
/// \c ARCHS (space-delimited string array)
extern NSString * const XCConfigurationPropertyArchitectures;
/// \c GCC_WARN_ABOUT_MISSING_PROTOTYPES (boolean)
extern NSString * const XCConfigurationPropertyWarnAboutMissingPrototypes;
/// \c GCC_WARN_ABOUT_RETURN_TYPE (boolean)
extern NSString * const XCConfigurationPropertyWarnAboutReturnTypes;
/// \c CODE_SIGN_IDENTITY (simple string)
extern NSString * const XCConfigurationPropertyCodeSignIdentity;
/// \c VALIDATE_PRODUCT (boolean)
extern NSString * const XCConfigurationPropertyValidateProduct;
/// \c IPHONEOS_DEPLOYMENT_TARGET (boolean)
extern NSString * const XCConfigurationPropertyiPhoneOSDeploymentTarget;
/// \c COPY_PHASE_STRIP (boolean)
extern NSString * const XCConfigurationPropertyCopyPhaseStrip;
/// \c OTHER_LDFLAGS (space-delimited string array)
extern NSString * const XCConfigurationPropertyOtherLDFlags;
/// \c DEAD_CODE_STRIPPING (boolean)
extern NSString * const XCConfigurationPropertyEnableDeadCodeStripping;
/// \c DEBUG_INFORMATION_FORMAT (enumerated); one of \c stabs , \c dwarf , \c dwarf-with-dsym
extern NSString * const XCConfigurationPropertyDebugInformationFormat;
/// \c GCC_ENABLE_OBJC_EXCEPTIONS (boolean)
extern NSString * const XCConfigurationPropertyEnableObjCExceptions;
/// \c GCC_GENERATE_DEBUGGING_SYMBOLS (boolean)
extern NSString * const XCConfigurationPropertyGenerateDebuggingSymbols;
/// \c GCC_WARN_64_TO_32_BIT_CONVERSION (boolean)
extern NSString * const XCConfigurationPropertyWarn64To32BitConversion;
/// \c LINK_WITH_STANDARD_LIBRARIES (boolean)
extern NSString * const XCConfigurationPropertyLinkWithStandardLibraries;
/// \c INSTALL_PATH (simple string)
extern NSString * const XCConfigurationPropertyInstallPath;
/// \c MACH_O_TYPE (enumerated); one of \c mh_executable , \c mh_bundle , \c mh_dylib , \c staticlib
extern NSString * const XCConfigurationPropertyMachOType;
/// \c MACOSX_DEPLOYMENT_TARGET (enumerated); one of \c 10.6 , \c 10.7 , \c 10.8 , \c 10.9
extern NSString * const XCConfigurationPropertyMacOSXDeploymentTarget;
/// \c VALID_ARCHS (space-delimited string array)
extern NSString * const XCConfigurationPropertyValidArchitectures;
/// \c USER_HEADER_SEARCH_PATHS (space-delimited string array)
extern NSString * const XCConfigurationPropertyUserHeaderSearchPaths;
