//
//  NKUserDefaults.m
//  KWHelper
//
//  Created by KyleWong on 2/27/16.
//  Copyright © 2016 KyleWong. All rights reserved.
//

#import "NKUserDefaults.h"

static NKUserDefaults *sUserDefaults = nil;
@interface NKUserDefaults()
@property (nonatomic,strong) NSUserDefaults *defaults;
@end

@implementation NKUserDefaults
+ (NKUserDefaults *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sUserDefaults = [NKUserDefaults new];
    });
    return sUserDefaults;
}

- (instancetype)init{
    if(self = [super init]){
        _defaults = [NSUserDefaults new];
    }
    return self;
}

- (void)setAutoCommFrom:(NSString *)aAutoCommFrom{
    [self.defaults setObject:aAutoCommFrom forKey:@"autoCommFrom"];
    [self.defaults synchronize];
}

- (NSString *)autoCommFrom{
    return [self.defaults objectForKey:@"autoCommFrom"];
}

- (void)setAutoCommTo:(NSString *)aAutoCommTo{
    [self.defaults setObject:aAutoCommTo forKey:@"autoCommTo"];
    [self.defaults synchronize];
}

- (NSString *)autoCommTo{
    return [self.defaults objectForKey:@"autoCommTo"];
}
@end
