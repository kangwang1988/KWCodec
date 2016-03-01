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

/*
 * The contents of the XCCopyFilesDestination enum were borrowed from the CocoaPods Xcodeproj library.
 * Copyright (c) 2012 Eloy Durán <eloy.de.enige@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "XCResource.h"
#import "XCBuildFile.h"

@interface XCBuildPhase : XCResource

- (NSArray *)allBuildFileReferences;
- (XCBuildFile *)buildFileWithName:(NSString *)name;
- (XCBuildFile *)buildFileWithPath:(NSString *)path;
- (XCFileReference *)buildFileReferenceWithName:(NSString *)name;
- (XCFileReference *)buildFileReferenceWithPath:(NSString *)path;

// This method adds a build file only if it there is no build file
// with the same path or name already present in the build phase.
- (void)addBuildFileWithReference:(XCFileReference *)reference buildSettings:(NSDictionary *)dictionary;

@end

#pragma mark -

@interface XCLinkFrameworksBuildPhase : XCBuildPhase

+ (XCLinkFrameworksBuildPhase *)createLinkFrameworksBuildPhaseInRegistry:(XCObjectRegistry *)registry;

@end

#pragma mark -

@interface XCCompileSourcesBuildPhase : XCBuildPhase

+ (XCCompileSourcesBuildPhase *)createCompileSourcesBuildPhaseInRegistry:(XCObjectRegistry *)registry;

- (void)addBuildFileWithReference:(XCFileReference *)reference useAutomaticReferenceCounting:(BOOL)useARC buildSettings:(NSDictionary *)dictionary;

@end

#pragma mark -

@interface XCCopyResourcesBuildPhase : XCBuildPhase

+ (XCCopyResourcesBuildPhase *)createCopyResourcesBuildPhaseInRegistry:(XCObjectRegistry *)registry;

@end

#pragma mark -

@interface XCRunScriptBuildPhase : XCBuildPhase

+ (XCRunScriptBuildPhase *)createRunScriptBuildPhaseWithScript:(NSString *)source inRegistry:(XCObjectRegistry *)registry; // interpreter defaults to /bin/sh
+ (XCRunScriptBuildPhase *)createRunScriptBuildPhaseWithScript:(NSString *)source interpreterPath:(NSString *)interpreter inRegistry:(XCObjectRegistry *)registry;

@property (assign) BOOL runOnlyWhenInstalling;
@property (strong) NSString *scriptSource;
@property (strong) NSString *interpreterPath;
@property (strong) NSString *name;

// These two arrays contain NSStrings: the paths to the files to be used, possibly containing Xcode $(variables).
@property (strong) NSArray *inputFiles;
@property (strong) NSArray *outputFiles;

@end

#pragma mark -

@interface XCCopyHeadersBuildPhase : XCBuildPhase

+ (XCCopyHeadersBuildPhase *)createCopyHeadersBuildPhaseInRegistry:(XCObjectRegistry *)registry;

- (void)addPublicHeaderFileWithReference:(XCFileReference *)reference buildSettings:(NSDictionary *)dictionary;
- (void)addPrivateHeaderFileWithReference:(XCFileReference *)reference buildSettings:(NSDictionary *)dictionary;

@end

#pragma mark -

typedef NS_ENUM(NSInteger, XCCopyFilesDestination) {
    XCCopyFilesDestinationAbsolutePath = 0,
    XCCopyFilesDestinationProductsDirectory = 16,
    XCCopyFilesDestinationWrapper = 1,
    XCCopyFilesDestinationResourcesDirectory = 7, // this is the default
    XCCopyFilesDestinationExecutables = 6,
    XCCopyFilesDestinationJavaResources = 15,
    XCCopyFilesDestinationFrameworks = 10,
    XCCopyFilesDestinationSharedFrameworks = 11,
    XCCopyFilesDestinationSharedSupport = 12,
    XCCopyFilesDestinationPlugIns = 13
};

@interface XCCopyFilesBuildPhase : XCBuildPhase

+ (XCCopyFilesBuildPhase *)createCopyFilesBuildPhaseWithName:(NSString *)name destination:(XCCopyFilesDestination)destination destinationSubdirectory:(NSString *)subdir inRegistry:(XCObjectRegistry *)registry;

+ (XCCopyFilesBuildPhase *)createCopyFilesBuildPhaseWithDestination:(XCCopyFilesDestination)destination destinationSubdirectory:(NSString *)subdir inRegistry:(XCObjectRegistry *)registry;

@property (assign) BOOL copyOnlyWhenInstalling;
@property (assign) XCCopyFilesDestination destination;
@property (strong) NSString *destinationSubdirectory;
@property (strong) NSString *name;

@end
