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

#import "XCConfigurationList.h"

@implementation XCConfigurationList

+ (XCConfigurationList *)createConfigurationListInRegistry:(XCObjectRegistry *)registry {
    static NSMutableDictionary *defaultProperties;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultProperties = [NSMutableDictionary dictionary];
        defaultProperties[@"isa"] = @"XCConfigurationList";
        defaultProperties[@"buildConfigurations"] = [NSMutableArray array];
        defaultProperties[@"defaultConfigurationIsVisible"] = @"0";
        defaultProperties[@"defaultConfigurationName"] = @"";
    });
    
    return [registry addResourceObjectOfClass:[self class] withProperties:[defaultProperties copy]];
}


- (NSArray *)configurations {
    NSMutableArray *retval = [NSMutableArray array];
    for (XCObjectIdentifier *ident in self.properties[@"buildConfigurations"]) {
        [retval addObject:[self.registry objectOfClass:[XCConfiguration class] withIdentifier:ident]];
    }
    
    return retval;
}

- (void)addConfigurationWithName:(NSString *)configName {
    [self addConfigurationWithName:configName block:NULL];
}

- (void)addConfigurationWithName:(NSString *)configName block:(void (^)(XCConfiguration *configuration))block {
    XCConfiguration *configuration = [XCConfiguration createConfigurationWithName:configName inRegistry:self.registry];
    [self.properties[@"buildConfigurations"] addObject:configuration.identifier];
    
    if (block != NULL) block(configuration);
    [configuration saveToObjectRegistry];
}

- (void)removeConfigurationWithName:(NSString *)configName {
    XCConfiguration *configurationToRemove = nil;
    for (XCConfiguration *config in self.configurations) {
        if ([config.name isEqualToString:configName]) {
            configurationToRemove = config;
            break;
        }
    }
    
    [self.properties[@"buildConfigurations"] removeObject:configurationToRemove.identifier];
}

- (NSString *)defaultConfigurationName {
    return self.properties[@"defaultConfigurationName"];
}

- (void)setDefaultConfigurationName:(NSString *)name {
    self.properties[@"defaultConfigurationName"] = name;
}

@end
