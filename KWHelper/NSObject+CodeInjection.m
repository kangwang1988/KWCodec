//
//  NSObject+CodeInjection.m
//  KWHelper
//
//  Created by KyleWong on 2/26/16.
//  Copyright © 2016 KyleWong. All rights reserved.
//

#import "NSObject+CodeInjection.h"
#import "NSObject+MethodSwizzler.h"
#import <AppKit/AppKit.h>
#import "NKHelper.h"

@implementation NSObject (CodeInjection)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSClassFromString(@"DVTBezelAlertPanel") swizzleWithOriginalSelector:@selector(initWithIcon:message:parentWindow:duration:) swizzledSelector:@selector(NK_initWithIcon:message:parentWindow:duration:) isClassMethod:NO];
        [NSClassFromString(@"NSDictionary") swizzleWithOriginalSelector:@selector(description) swizzledSelector:@selector(NK_description) isClassMethod:NO];
    });
}

- (id)NK_initWithIcon:(id)icon message:(id)message parentWindow:(id)window duration:(double)duration
{
    // 10
    NSBundle *bundle = [NSBundle bundleWithIdentifier:@"com.virtualvilliage.KWHelper"];
    NSImage *newImage = [bundle imageForResource:@"leftarrow"];
    return [self NK_initWithIcon:newImage message:@"KyleWong's Message!" parentWindow:window duration:duration];
}

- (NSString *)NK_description{
    NSString *desc = [self NK_description];
    return [NKHelper convertString:desc fromEncoding:NSUnicodeStringEncoding toEncoding:NSUTF8StringEncoding];
}
@end
