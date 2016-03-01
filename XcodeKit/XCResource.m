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

#import "XCResource.h"

@implementation XCResource

- (instancetype)initWithIdentifier:(XCObjectIdentifier *)identifier registry:(XCObjectRegistry *)registry {
    self = [super init];
    
    if (self) {
        _identifier = identifier;
        _registry = registry;
        _properties = [NSMutableDictionary dictionary];
        self.resourceDescription = nil;
    }
    
    return self;
}

- (void)saveToObjectRegistry {
    [self.registry setResourceObject:self];
}

#pragma mark NSObject

- (BOOL)isEqual:(id)object {
    if (self == object) return YES;
    if (![object isKindOfClass:[self class]]) return NO;
    
    XCResource *other = object;
    return [self.registry isEqual:other.registry] && [self.identifier isEqual:other.identifier] && [self.properties isEqual:other.properties];
}

- (NSUInteger)hash {
    return self.registry.hash ^ self.identifier.hash ^ self.properties.hash;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ = %@", self.identifier, self.properties];
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"<%@ %p: identifier=%@ registry=%@ properties=%@>", NSStringFromClass([self class]), self, self.identifier, self.registry, self.properties];
}

@end
