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

#import <Foundation/Foundation.h>
#import "XCObjectIdentifier.h"

extern NSString * const XCInvalidProjectFileException;

@class XCResource, XCProject, XCGroup;
@interface XCObjectRegistry : NSObject

// This method returns an XCObjectRegistry instance equipped with an
// XCProject instance, a root XCGroup, and an XCConfigurationList instance.
+ (XCObjectRegistry *)objectRegistryForEmptyProjectWithName:(NSString *)projectName;
+ (XCObjectRegistry *)objectRegistryWithXcodePBXProjectText:(NSString *)pbxproj;
- (id)initWithProjectPropertyList:(NSDictionary *)propertyList;

@property (assign) NSInteger objectVersion;
@property (readonly, strong) NSMutableDictionary *projectPropertyList;
@property (strong) XCProject *project;

- (NSString *)xcodePBXProjectText;
- (NSMutableDictionary *)objectDictionary;
- (void)removeUnreferencedResources;

// If the XCResource instance returned from this method has its resourceDescription
// property set to a non-nil value, its value will be propagated to the targetDescription
// property on the passed-in XCObjectIdentifier.
- (XCResource *)objectWithIdentifier:(XCObjectIdentifier *)identifier;
- (id)objectOfClass:(Class)cls withIdentifier:(XCObjectIdentifier *)identifier;
- (NSDictionary *)propertiesForObjectWithIdentifier:(XCObjectIdentifier *)identifier;

- (id)addResourceObjectOfClass:(Class)cls withProperties:(NSDictionary *)properties;
- (void)setResourceObject:(XCResource *)resource;
- (void)removeResourceObjectWithIdentifier:(XCObjectIdentifier *)identifier;

@end
