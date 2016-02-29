//
//  NSObject_Extension.m
//  KWHelper
//
//  Created by KyleWong on 2/24/16.
//  Copyright © 2016 KyleWong. All rights reserved.
//


#import "NSObject_Extension.h"
#import "KWHelper.h"

@implementation NSObject (Xcode_Plugin_Template_Extension)

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[KWHelper alloc] initWithBundle:plugin];
        });
    }
}
@end
