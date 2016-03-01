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

#import <Foundation/Foundation.h>

@interface XCObjectIdentifier : NSObject <NSSecureCoding>

/// Creates a new, unique XCObjectIdentifier.
- (id)init;

/// Creates a new, unique XCObjectIdentifier with the given \c targetDescription .
- (id)initWithTargetDescription:(NSString *)targetDescription;

/// Creates a new, unique XCObjectIdentifier with the given \c targetDescription .
/// The \c key is guaranteed to not be equal to any of the keys in the \c existingKeys array.
- (instancetype)initWithTargetDescription:(NSString *)targetDescription existingKeys:(NSArray *)existingKeys;

/// Creates an instance of \c XCObjectIdentifier with the given \c key and \c targetDescription .
/// This is the designated initializer.
- (instancetype)initWithKey:(NSString *)key targetDescription:(NSString *)targetDescription;

/// Creates an instance of \c XCObjectIdentifier with the given \c key .
- (instancetype)initWithKey:(NSString *)key;

/// Gets whether or not the given string is a valid XCObjectIdentifier key.
+ (BOOL)isValidObjectIdentifierKey:(NSString *)str;

#pragma mark Properties

/// The randomly generated key string. This is composed of 24 uppercase hexadecimal characters.
@property (readonly, strong) NSString *key;

/// A string that describes what the \c key points to. This will be
/// written in a comment when the Xcode project is formatted for output.
@property (strong) NSString *targetDescription;

@end
