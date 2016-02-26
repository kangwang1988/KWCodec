//
//  NKHelper.h
//  KWCodec
//
//  Created by KyleWong on 2/25/16.
//  Copyright © 2016 KyleWong. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NKHelper : NSObject
+ (NSStringEncoding)stringEncodingFromDesc:(NSString *)aTypeDesc;
+ (NSString *)convertString:(NSString *)aFromStr fromEncoding:(NSStringEncoding)aFromEncoding toEncoding:(NSStringEncoding)aToEncoding;
@end
