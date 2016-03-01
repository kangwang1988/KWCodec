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

#import "XCResource.h"

extern NSString * const XCFileReferencePathInGroup;
extern NSString * const XCFileReferencePathInSDK;
extern NSString * const XCFileReferencePathInBuiltProductsDirectory;

@class XCGroup;
@interface XCFileReference : XCResource

+ (XCFileReference *)createFileReferenceForRegularFileInRegistry:(XCObjectRegistry *)registry additionalProperties:(NSDictionary *)properties;
+ (XCFileReference *)createFileReferenceForFrameworkWithName:(NSString *)name path:(NSString *)path inRegistry:(XCObjectRegistry *)registry additionalProperties:(NSDictionary *)properties;
+ (XCFileReference *)createFileReferenceForSDKFrameworkWithName:(NSString *)name inRegistry:(XCObjectRegistry *)registry additionalProperties:(NSDictionary *)properties;
+ (XCFileReference *)createFileReferenceForSDKLibraryWithName:(NSString *)name inRegistry:(XCObjectRegistry *)registry additionalProperties:(NSDictionary *)properties;
+ (XCFileReference *)createFileReferenceForApplicationProductWithName:(NSString *)name inRegistry:(XCObjectRegistry *)registry additionalProperties:(NSDictionary *)properties;

- (void)removeFromParentGroup;

#pragma mark Properties

@property (strong) XCGroup *parentGroup;

@property (strong) NSString *name;
@property (strong) NSString *path;
// This property's value can be one of XCFileReferencePathInGroup, XCFileReferencePathInSDK, or XCFileReferencePathInBuiltProductsDirectory
@property (strong) NSString *pathResolveBase;
@property (strong) NSString *explicitFileType;
@property (strong) NSString *lastKnownFileType;
@property (assign) BOOL includeInIndex;

@end
