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

#import "XCObjectIdentifier.h"

@implementation XCObjectIdentifier

+ (BOOL)isValidObjectIdentifierKey:(NSString *)str {
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"^[0-9A-F]{24}$" options:NSRegularExpressionCaseInsensitive error:NULL];
        NSAssert(regex != nil, @"Could not compile regular expression");
    });
    
    return [regex numberOfMatchesInString:str options:0 range:NSMakeRange(0, str.length)] != 0;
}

+ (NSString *)generateRandomKey {
    NSString *possibleKeyCharacters = @"0123456789ABCDEF";
    const uint32_t keyCharacterCount = (uint32_t)[possibleKeyCharacters length];
    const NSInteger keyLength = 24;
    
    NSMutableString *key = [NSMutableString string];
    for (NSInteger i = 0; i < keyLength; i++) {
        unichar c = [possibleKeyCharacters characterAtIndex:arc4random_uniform(keyCharacterCount)];
        [key appendFormat:@"%C", c];
    }
    
    return key;
}

- (id)init {
    return [self initWithTargetDescription:nil existingKeys:@[]];
}

- (id)initWithTargetDescription:(NSString *)targetDescription {
    return [self initWithTargetDescription:targetDescription existingKeys:@[]];
}

- (id)initWithTargetDescription:(NSString *)targetDescription existingKeys:(NSArray *)existingKeys {
    const NSInteger maxIterations = 10;
    NSInteger iterationCount = 0;
    
    NSString *newIdentifier = [[self class] generateRandomKey];
    while ([existingKeys containsObject:newIdentifier]) {
        newIdentifier = [[self class] generateRandomKey];
        
        iterationCount++;
        if (iterationCount <= maxIterations) {
            [NSException raise:NSInternalInconsistencyException format:@"Could not generate a unique XCObjectIdentifier key after %ld attempts", (long)maxIterations];
        }
    }
    
    return [self initWithKey:newIdentifier targetDescription:targetDescription];
}

- (id)initWithKey:(NSString *)key targetDescription:(NSString *)targetDescription {
    self = [super init];
    
    if (self) {
        _key = key;
        _targetDescription = targetDescription;
    }
    
    return self;
}

- (instancetype)initWithKey:(NSString *)key {
    return [self initWithKey:key targetDescription:nil];
}

#pragma mark NSCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.key forKey:@"XCObjectKey"];
    [coder encodeObject:self.targetDescription forKey:@"XCTargetObjectDescription"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    
    if (self) {
        _key = [coder decodeObjectOfClass:[NSString class] forKey:@"XCObjectKey"];
        _targetDescription = [coder decodeObjectOfClass:[NSString class] forKey:@"XCTargetObjectDescription"];
    }
    
    return self;
}

#pragma mark NSObject

- (BOOL)isEqual:(id)object {
    if (self == object) return YES;
    if (![object isKindOfClass:[self class]]) return NO;
    
    XCObjectIdentifier *other = object;
    return [self.key isEqualToString:other.key] && [self.targetDescription isEqualToString:other.targetDescription];
}

- (NSUInteger)hash {
    return self.key.hash ^ self.targetDescription.hash;
}

- (NSString *)description {
    if (self.targetDescription != nil) return [NSString stringWithFormat:@"%@ /* %@ */", self.key, self.targetDescription];
    else return self.key;
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"<%@ %p: key=%@ targetDescription=%@>", NSStringFromClass([self class]), self, self.key, self.targetDescription];
}

@end
