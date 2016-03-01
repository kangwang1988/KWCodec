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

#import "XCFileReference.h"
#import "XCGroup.h"

NSString * const XCFileReferencePathInGroup = @"<group>";
NSString * const XCFileReferencePathInSDK = @"SDKROOT";
NSString * const XCFileReferencePathInBuiltProductsDirectory = @"BUILT_PRODUCTS_DIR";

@implementation XCFileReference

+ (XCFileReference *)createFileReferenceForRegularFileInRegistry:(XCObjectRegistry *)registry additionalProperties:(NSDictionary *)properties {
    static NSMutableDictionary *defaultProperties;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultProperties = [NSMutableDictionary dictionary];
        defaultProperties[@"isa"] = @"PBXFileReference";
        defaultProperties[@"sourceTree"] = XCFileReferencePathInGroup;
    });
    
    NSMutableDictionary *retval = [defaultProperties copy];
    [retval addEntriesFromDictionary:properties];
    return [registry addResourceObjectOfClass:[self class] withProperties:retval];
}

+ (XCFileReference *)createFileReferenceForFrameworkWithName:(NSString *)name path:(NSString *)path inRegistry:(XCObjectRegistry *)registry additionalProperties:(NSDictionary *)properties {
    static NSMutableDictionary *defaultProperties;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultProperties = [NSMutableDictionary dictionary];
        defaultProperties[@"isa"] = @"PBXFileReference";
        defaultProperties[@"lastKnownFileType"] = @"wrapper.framework";
        defaultProperties[@"sourceTree"] = XCFileReferencePathInGroup;
    });
    
    NSMutableDictionary *retval = [defaultProperties copy];
    [retval addEntriesFromDictionary:properties];
    retval[@"name"] = [name.pathExtension isEqualToString:@"framework"] ? [name stringByDeletingPathExtension] : name;
    retval[@"path"] = path;
    
    return [registry addResourceObjectOfClass:[self class] withProperties:retval];
}

+ (XCFileReference *)createFileReferenceForSDKFrameworkWithName:(NSString *)name inRegistry:(XCObjectRegistry *)registry additionalProperties:(NSDictionary *)properties {
    static NSMutableDictionary *defaultProperties;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultProperties = [NSMutableDictionary dictionary];
        defaultProperties[@"isa"] = @"PBXFileReference";
        defaultProperties[@"lastKnownFileType"] = @"wrapper.framework";
        defaultProperties[@"sourceTree"] = XCFileReferencePathInSDK;
    });
    
    NSMutableDictionary *retval = [defaultProperties copy];
    [retval addEntriesFromDictionary:properties];
    retval[@"name"] = [name.pathExtension isEqualToString:@"framework"] ? [name stringByDeletingPathExtension] : name;
    retval[@"path"] = [NSString stringWithFormat:@"System/Library/Frameworks/%@.framework", retval[@"name"]];
    
    return [registry addResourceObjectOfClass:[self class] withProperties:retval];
}

+ (XCFileReference *)createFileReferenceForSDKLibraryWithName:(NSString *)name inRegistry:(XCObjectRegistry *)registry additionalProperties:(NSDictionary *)properties {
    static NSMutableDictionary *defaultProperties;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultProperties = [NSMutableDictionary dictionary];
        defaultProperties[@"isa"] = @"PBXFileReference";
        defaultProperties[@"lastKnownFileType"] = @"compiled.mach-o.dylib";
        defaultProperties[@"sourceTree"] = XCFileReferencePathInSDK;
    });
    
    NSMutableDictionary *retval = [defaultProperties copy];
    [retval addEntriesFromDictionary:properties];
    retval[@"name"] = name;
    retval[@"path"] = [NSString stringWithFormat:@"usr/lib/%@", name];
    
    return [registry addResourceObjectOfClass:[self class] withProperties:retval];
}

+ (XCFileReference *)createFileReferenceForApplicationProductWithName:(NSString *)name inRegistry:(XCObjectRegistry *)registry additionalProperties:(NSDictionary *)properties {
    static NSMutableDictionary *defaultProperties;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultProperties = [NSMutableDictionary dictionary];
        defaultProperties[@"isa"] = @"PBXFileReference";
        defaultProperties[@"explicitFileType"] = @"wrapper.application";
        defaultProperties[@"sourceTree"] = XCFileReferencePathInBuiltProductsDirectory;
        defaultProperties[@"includeInIndex"] = @"0";
    });
    
    NSMutableDictionary *retval = [defaultProperties copy];
    [retval addEntriesFromDictionary:properties];
    retval[@"name"] = name;
    retval[@"path"] = [NSString stringWithFormat:@"%@.app", name];
    
    return [registry addResourceObjectOfClass:[self class] withProperties:retval];
}

- (void)removeFromParentGroup {
    [self.parentGroup removeChild:self];
}

#pragma mark Properties

- (NSString *)name {
    return self.properties[@"name"];
}

- (void)setName:(NSString *)name {
    self.properties[@"name"] = name;
    [self saveToObjectRegistry];
}

- (NSString *)path {
    return self.properties[@"path"];
}

- (void)setPath:(NSString *)path {
    self.properties[@"path"] = path;
    [self saveToObjectRegistry];
}

- (NSString *)pathResolveBase {
    return self.properties[@"sourceTree"];
}

- (void)setPathResolveBase:(NSString *)pathResolveBase {
    self.properties[@"sourceTree"] = pathResolveBase;
    [self saveToObjectRegistry];
}

- (NSString *)explicitFileType {
    return self.properties[@"explicitFileType"];
}

- (void)setExplicitFileType:(NSString *)explicitFileType {
    self.properties[@"explicitFileType"] = explicitFileType;
    [self saveToObjectRegistry];
}

- (BOOL)includeInIndex {
    NSString *val = self.properties[@"includeInIndex"];
    
    // Default to YES.
    if (val == nil) {
        return YES;
    } else if ([val isEqualToString:@"1"]) {
        return YES;
    } else if ([val isEqualToString:@"0"]) {
        return NO;
    } else {
        [NSException raise:NSInternalInconsistencyException format:@"Unrecognized 'includeInIndex' value: %@", val];
        return YES;
    }
}

- (void)setIncludeInIndex:(BOOL)includeInIndex {
    self.properties[@"includeInIndex"] = includeInIndex ? @"1" : @"0";
    [self saveToObjectRegistry];
}

@end
