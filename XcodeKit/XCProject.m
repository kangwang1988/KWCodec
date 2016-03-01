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

#import "XCProject.h"
#import "XCTarget.h"

@implementation XCProject

+ (XCProject *)createProjectWithMainGroup:(XCGroup *)group inRegistry:(XCObjectRegistry *)registry {
    XCGroup *productsGroup = [XCGroup createLogicalGroupWithName:@"Products" inRegistry:registry];
    [group addChildGroup:productsGroup];
    return [self createProjectWithMainGroup:group productReferenceGroup:productsGroup inRegistry:registry];
}

+ (XCProject *)createProjectWithMainGroup:(XCGroup *)group productReferenceGroup:(XCGroup *)productsGroup inRegistry:(XCObjectRegistry *)registry {
    XCConfigurationList *list = [XCConfigurationList createConfigurationListInRegistry:registry];
    return [self createProjectWithMainGroup:group productReferenceGroup:productsGroup buildConfigurationList:list inRegistry:registry];
}

+ (XCProject *)createProjectWithMainGroup:(XCGroup *)group productReferenceGroup:(XCGroup *)productsGroup buildConfigurationList:(XCConfigurationList *)configurationList inRegistry:(XCObjectRegistry *)registry {
    static NSMutableDictionary *defaultProperties;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultProperties = [NSMutableDictionary dictionary];
        defaultProperties[@"isa"] = @"PBXProject";
        defaultProperties[@"compatibilityVersion"] = @"Xcode 3.2";
        defaultProperties[@"developmentRegion"] = @"English";
        defaultProperties[@"knownRegions"] = [NSMutableArray array];
        defaultProperties[@"hasScannedForEncodings"] = @"0";
        defaultProperties[@"projectDirPath"] = @"";
        defaultProperties[@"projectRoot"] = @"";
        defaultProperties[@"targets"] = [NSMutableArray array];
        
        NSMutableDictionary *defaultAttributes = [NSMutableDictionary dictionary];
        defaultAttributes[@"LastUpgradeCheck"] = @"0510";
        defaultProperties[@"attributes"] = defaultAttributes;
    });
    
    NSMutableDictionary *finalProperties = [defaultProperties copy];
    finalProperties[@"buildConfigurationList"] = configurationList.identifier;
    finalProperties[@"mainGroup"] = group.identifier;
    finalProperties[@"productRefGroup"] = productsGroup.identifier;
    
    [registry setResourceObject:group];
    [registry setResourceObject:productsGroup];
    [registry setResourceObject:configurationList];
    
    return [registry addResourceObjectOfClass:[self class] withProperties:finalProperties];
}

#pragma mark Properties

- (XCConfigurationList *)configurationList {
    return [self.registry objectOfClass:[XCConfigurationList class] withIdentifier:self.properties[@"buildConfigurationList"]];
}

- (void)setConfigurationList:(XCConfigurationList *)configurationList {
    [self.registry setResourceObject:configurationList];
    self.properties[@"buildConfigurationList"] = configurationList.identifier;
}

- (XCGroup *)mainGroup {
    return [self.registry objectOfClass:[XCGroup class] withIdentifier:self.properties[@"mainGroup"]];
}

- (void)setMainGroup:(XCGroup *)mainGroup {
    [self.registry setResourceObject:mainGroup];
    self.properties[@"mainGroup"] = mainGroup.identifier;
}

- (XCGroup *)productReferenceGroup {
    return [self.registry objectOfClass:[XCGroup class] withIdentifier:self.properties[@"productRefGroup"]];
}

- (void)setProductReferenceGroup:(XCGroup *)productReferenceGroup {
    [self.registry setResourceObject:productReferenceGroup];
    self.properties[@"productRefGroup"] = productReferenceGroup.identifier;
}

- (NSMutableArray *)targets {
    NSMutableArray *array = [NSMutableArray array];
    
    for (XCObjectIdentifier *ident in self.properties[@"targets"]) {
        [array addObject:[self.registry objectOfClass:[XCTarget class] withIdentifier:ident]];
    }
    
    return array;
}

- (void)setTargets:(NSMutableArray *)targets {
    NSMutableArray *identifiers = [NSMutableArray array];
    
    for (XCTarget *target in targets) {
        [self.registry setResourceObject:target];
        [identifiers addObject:target.identifier];
    }
    
    self.properties[@"targets"] = identifiers;
}

- (NSMutableDictionary *)attributes {
    return self.properties[@"attributes"];
}

- (void)setAttributes:(NSMutableDictionary *)attributes {
    self.properties[@"attributes"] = attributes;
}

@end
