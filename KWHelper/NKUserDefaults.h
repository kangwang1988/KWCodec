//
//  NKUserDefaults.h
//  KWHelper
//
//  Created by KyleWong on 2/27/16.
//  Copyright © 2016 KyleWong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKUserDefaults : NSObject
+ (NKUserDefaults *)sharedInstance;
- (void)setAutoCommFrom:(NSString *)aAutoCommFrom;
- (NSString *)autoCommFrom;
- (void)setAutoCommTo:(NSString *)aAutoCommTo;
- (NSString *)autoCommTo;
@end
