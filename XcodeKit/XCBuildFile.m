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

#import "XCBuildFile.h"

@implementation XCBuildFile

+ (XCBuildFile *)createBuildFileWithFileReference:(XCFileReference *)fileReference inRegistry:(XCObjectRegistry *)registry {
    return [self createBuildFileWithFileReference:fileReference buildSettings:nil inRegistry:registry];
}

+ (XCBuildFile *)createBuildFileWithFileReference:(XCFileReference *)fileReference buildSettings:(NSDictionary *)buildSettings inRegistry:(XCObjectRegistry *)registry {
    return [self createBuildFileWithFileReference:fileReference buildSettings:buildSettings inRegistry:registry additionalProperties:nil];
}

+ (XCBuildFile *)createBuildFileWithFileReference:(XCFileReference *)fileReference buildSettings:(NSDictionary *)buildSettings inRegistry:(XCObjectRegistry *)registry additionalProperties:(NSDictionary *)properties {
    static NSMutableDictionary *defaultProperties;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultProperties = [[NSMutableDictionary alloc] init];
        defaultProperties[@"isa"] = @"PBXBuildFile";
    });
    
    NSMutableDictionary *finalProperties = [defaultProperties copy];
    [finalProperties addEntriesFromDictionary:properties];
    finalProperties[@"fileRef"] = fileReference.identifier.key;
    if (buildSettings.count > 0) finalProperties[@"settings"] = buildSettings;
    
    return [registry addResourceObjectOfClass:[self class] withProperties:finalProperties];
}

#pragma mark Properties

- (XCFileReference *)fileReference {
    XCResource *resource = [self.registry objectWithIdentifier:self.properties[@"fileRef"]];
    NSAssert([resource isKindOfClass:[XCFileReference class]], @"File reference %@ doesn't point to a file reference", self.properties[@"fileRef"]);
    return (XCFileReference *)resource;
}

- (void)setFileReference:(XCFileReference *)fileReference {
    XCObjectIdentifier *identifier = [[XCObjectIdentifier alloc] initWithKey:fileReference.identifier.key targetDescription:fileReference.name];
    
    [self.registry setResourceObject:fileReference];
    self.properties[@"fileRef"] = identifier;
}

- (NSDictionary *)buildSettings {
    return self.properties[@"settings"];
}

- (void)setBuildSettings:(NSDictionary *)buildSettings {
    self.properties[@"settings"] = buildSettings;
}

@end
