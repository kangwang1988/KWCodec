//
//  KWCodecer.h
//  KWCodecer
//
//  Created by KyleWong on 2/24/16.
//  Copyright © 2016 KyleWong. All rights reserved.
//

#import <AppKit/AppKit.h>

@class KWCodecer;

static KWCodecer *sharedPlugin;

@interface KWCodecer : NSObject

+ (instancetype)sharedPlugin;
- (id)initWithBundle:(NSBundle *)plugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end