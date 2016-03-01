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

#import "XCGroup.h"

static NSArray *XCArrayWhere(NSArray *source, BOOL (^block)(id object)) {
    NSMutableArray *retval = [NSMutableArray array];
    NSUInteger count = source.count;
    
    for (NSUInteger i = 0; i < count; i++) {
        id object = source[i];
        if (block(object)) [retval addObject:object];
    }
    
    return retval;
}

static NSArray *XCArrayReject(NSArray *source, BOOL (^block)(id object)) {
    NSMutableArray *retval = [NSMutableArray array];
    NSUInteger count = source.count;
    
    for (NSUInteger i = 0; i < count; i++) {
        id object = source[i];
        if (!block(object)) [retval addObject:object];
    }
    
    return retval;
}

static NSArray *XCArrayMap(NSArray *source, id (^block)(id oldValue)) {
    NSMutableArray *retval = [NSMutableArray array];
    NSUInteger count = source.count;
    
    for (NSUInteger i = 0; i < count; i++) {
        [retval addObject:block(source[i])];
    }
    
    return retval;
}

#pragma mark -

@implementation XCGroup

+ (NSString *)propertiesClassTypeName {
    // This method exists to allow XCVariantGroup to supply its own isa for
    // the properties of instances of that subclass, without having to reimplement
    // the rest of +createLogicalGroupWithName:inRegistry:. DRY, anyone?
    return @"PBXGroup";
}

+ (XCGroup *)createLogicalGroupWithName:(NSString *)name inRegistry:(XCObjectRegistry *)registry {
    static NSMutableDictionary *defaultProperties;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultProperties = [NSMutableDictionary dictionary];
        defaultProperties[@"isa"] = [[self class] propertiesClassTypeName];
        defaultProperties[@"sourceTree"] = @"<group>";
        defaultProperties[@"children"] = [NSMutableArray array];
    });
    
    NSMutableDictionary *finalProperties = [defaultProperties copy];
    finalProperties[@"name"] = name;
    
    XCGroup *retval = [registry addResourceObjectOfClass:[self class] withProperties:finalProperties];
    retval.resourceDescription = name;
    return retval;
}

- (NSArray *)children {
    NSMutableArray *retval = [NSMutableArray array];
    
    for (XCObjectIdentifier *ident in self.properties[@"children"]) {
        [retval addObject:[self.registry objectWithIdentifier:ident]];
    }
    
    return retval;
}

- (NSArray *)childGroups {
    NSArray *array = XCArrayWhere(self.children, ^BOOL(id object) {
        return [object isKindOfClass:[XCGroup class]];
    });
    
    return XCArrayMap(array, ^id(id oldValue) {
        XCGroup *group = oldValue;
        group.parentGroup = self;
        return group;
    });
}

- (NSArray *)childFiles {
    return XCArrayReject(self.children, ^BOOL(id object) {
        return [object isKindOfClass:[XCGroup class]];
    });
}

- (void)addChildGroup:(XCGroup *)group {
    [self.properties[@"children"] addObject:group.identifier];
    [self.registry setResourceObject:group];
}

- (void)addChildFileReference:(XCFileReference *)reference {
    [self.properties[@"children"] addObject:reference.identifier];
    [self.registry setResourceObject:reference];
}

- (void)removeChild:(XCResource *)resource {
    [self.properties[@"children"] removeObject:resource];
}

- (void)removeFromParentGroup {
    for (XCGroup *group in self.childGroups) {
        [group removeFromParentGroup];
    }
    
    for (XCFileReference *ref in self.childFiles) {
        [ref removeFromParentGroup];
    }
    
    [self.parentGroup removeChild:self];
}

@end

#pragma mark -

@implementation XCVariantGroup

+ (NSString *)propertiesClassTypeName {
    return @"PBXVariantGroup";
}

@end
