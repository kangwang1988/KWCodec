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

#import "XCConfiguration.h"

NSString * const XCConfigurationNameDebug = @"Debug";
NSString * const XCConfigurationNameRelease = @"Release";

@implementation XCConfiguration

+ (XCConfiguration *)createConfigurationWithName:(NSString *)name inRegistry:(XCObjectRegistry *)registry {
    NSMutableDictionary *finalProperties = [[NSMutableDictionary alloc] init];
    finalProperties[@"isa"] = @"XCBuildConfiguration";
    finalProperties[@"name"] = name;
    finalProperties[@"buildSettings"] = [NSMutableDictionary dictionary];
    
    return [registry addResourceObjectOfClass:[XCConfiguration class] withProperties:finalProperties];
}

#pragma mark Properties

- (NSString *)name {
    return self.properties[@"name"];
}

- (void)setName:(NSString *)name {
    self.properties[@"name"] = name;
}

- (NSMutableDictionary *)buildSettings {
    return self.properties[@"buildSettings"];
}

- (NSString *)expandedBuildSettingValueForName:(NSString *)name {
    NSError *error;
    NSRegularExpression * const settingPattern = [NSRegularExpression regularExpressionWithPattern:@"\\$\\(([^)]+)\\)" options:0 error:&error];
    NSAssert(settingPattern != nil, @"Could not compile setting pattern: %@", error);
    
    NSString *setting = self.buildSettings[name];
    NSMutableString *retval = [name mutableCopy];
    [settingPattern enumerateMatchesInString:setting options:0 range:NSMakeRange(0, setting.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSString *name = [setting substringWithRange:[result rangeAtIndex:1]];
        [retval replaceCharactersInRange:result.range withString:[self expandedBuildSettingValueForName:name]];
    }];
    
    return retval;
}

@end
