//
//  NKHelper.m
//  KWHelper
//
//  Created by KyleWong on 2/25/16.
//  Copyright © 2016 KyleWong. All rights reserved.
//

#import "NKHelper.h"

@implementation NKHelper
+ (NSStringEncoding)stringEncodingFromDesc:(NSString *)aTypeDesc{
    NSStringEncoding encoding = NSUTF8StringEncoding;
    if([aTypeDesc isEqualToString:@"Unicode"]){
        encoding = NSUnicodeStringEncoding;;
    }
    else if([aTypeDesc isEqualToString:@"UTF8"]){
        encoding = NSUTF8StringEncoding;
    }
    return encoding;
}

+ (NSString *)convertString:(NSString *)aFromStr fromEncoding:(NSStringEncoding)aFromEncoding toEncoding:(NSStringEncoding)aToEncoding{
    NSString *convertedStr = aFromStr;
    switch (aFromEncoding) {
        case NSUnicodeStringEncoding:
        {
            switch (aToEncoding) {
                case NSUTF8StringEncoding:
                    convertedStr = [self _convertUnicodeToUTF8:aFromStr];
                    break;
                default:
                    break;
            }
        }
            break;
        case NSUTF8StringEncoding:
        {
            switch (aToEncoding) {
                case NSUnicodeStringEncoding:
                    convertedStr = [self _convertUTF8ToUnicode:aFromStr];
                    break;
                    
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    return convertedStr;
}

+ (NSString*)_convertUnicodeToUTF8:(NSString*)aUnicodeString
{
    NSString *tempStr1 = [aUnicodeString stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData mutabilityOption:NSPropertyListImmutable
        format:NULL
        errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

+ (NSString*)_convertUTF8ToUnicode:(NSString*)aUTF8String
{
    NSUInteger length = [aUTF8String length];
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    for (int i = 0;i < length; i++)
    {
        unichar _char = [aUTF8String characterAtIndex:i];
        //判断是否为英文和数字
        if (_char <= '9' && _char >= '0')
        {
            [s appendFormat:@"%@",[aUTF8String substringWithRange:NSMakeRange(i, 1)]];
        }
        else if(_char >= 'a' && _char <= 'z')
        {
            [s appendFormat:@"%@",[aUTF8String substringWithRange:NSMakeRange(i, 1)]];
        }
        else if(_char >= 'A' && _char <= 'Z')
        {
            [s appendFormat:@"%@",[aUTF8String substringWithRange:NSMakeRange(i, 1)]];
        }
        else
        {
            [s appendFormat:@"\\u%x",[aUTF8String characterAtIndex:i]];
        }
    }
    return s;
}
@end