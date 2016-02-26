//
//  NSObject+MethodSwizzler.h
//  KWCodec
//
//  Created by KyleWong on 2/26/16.
//  Copyright © 2016 KyleWong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MethodSwizzler)
+ (void)swizzleWithOriginalSelector:(SEL)originalSelector swizzledSelector:(SEL) swizzledSelector isClassMethod:(BOOL)isClassMethod;

@end
