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

#import "XCBuildPhase.h"

@implementation XCBuildPhase

- (XCBuildFile *)buildFileWithName:(NSString *)name {
    for (XCObjectIdentifier *ident in self.properties[@"files"]) {
        XCBuildFile *file = [self.registry objectOfClass:[XCBuildFile class] withIdentifier:ident];
        if ([file.fileReference.name isEqualToString:name]) return file;
    }
    
    return nil;
}

- (XCBuildFile *)buildFileWithPath:(NSString *)path {
    for (XCObjectIdentifier *ident in self.properties[@"files"]) {
        XCBuildFile *file = [self.registry objectOfClass:[XCBuildFile class] withIdentifier:ident];
        if ([file.fileReference.path isEqualToString:path]) return file;
    }
    
    return nil;
}

- (XCFileReference *)buildFileReferenceWithName:(NSString *)name {
    for (XCObjectIdentifier *ident in self.properties[@"files"]) {
        XCBuildFile *file = [self.registry objectOfClass:[XCBuildFile class] withIdentifier:ident];
        if ([file.fileReference.name isEqualToString:name]) return file.fileReference;
    }
    
    return nil;
}

- (XCFileReference *)buildFileReferenceWithPath:(NSString *)path {
    for (NSString *ident in self.properties[@"files"]) {
        XCBuildFile *file = [self.registry objectOfClass:[XCBuildFile class] withIdentifier:[[XCObjectIdentifier alloc] initWithKey:ident]];
        if ([file.fileReference.path isEqualToString:path]) return file.fileReference;
    }
    
    return nil;
}

- (NSArray *)allBuildFileReferences {
    NSMutableArray *references = [NSMutableArray array];
    
    for (NSString *key in self.properties[@"files"]) {
        XCObjectIdentifier *ident = [[XCObjectIdentifier alloc] initWithKey:key];
        XCBuildFile *buildFile = [self.registry objectOfClass:[XCBuildFile class] withIdentifier:ident];
        [references addObject:buildFile.fileReference];
    }
    
    return references;
}

- (void)addBuildFileWithReference:(XCFileReference *)reference buildSettings:(NSDictionary *)dictionary {
    if ([self buildFileWithPath:reference.path]) return;
    if ([self buildFileWithName:reference.name]) return;
    
    XCBuildFile *file = [XCBuildFile createBuildFileWithFileReference:reference buildSettings:dictionary inRegistry:self.registry];
    [self.registry setResourceObject:file];
    [self.properties[@"files"] addObject:file.identifier];
}

@end

#pragma mark -

@implementation XCLinkFrameworksBuildPhase

+ (XCLinkFrameworksBuildPhase *)createLinkFrameworksBuildPhaseInRegistry:(XCObjectRegistry *)registry {
    static NSMutableDictionary *defaultProperties;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultProperties = [[NSMutableDictionary alloc] init];
        defaultProperties[@"isa"] = @"PBXFrameworksBuildPhase";
        defaultProperties[@"buildActionMask"] = @(2147483647);
        defaultProperties[@"files"] = [NSMutableArray array];
        defaultProperties[@"runOnlyForDeploymentPostprocessing"] = @"0";
    });
    
    return [registry addResourceObjectOfClass:[self class] withProperties:[defaultProperties copy]];
}

@end

#pragma mark -

@implementation XCCompileSourcesBuildPhase

+ (XCCompileSourcesBuildPhase *)createCompileSourcesBuildPhaseInRegistry:(XCObjectRegistry *)registry {
    static NSMutableDictionary *defaultProperties;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultProperties = [[NSMutableDictionary alloc] init];
        defaultProperties[@"isa"] = @"PBXSourcesBuildPhase";
        defaultProperties[@"buildActionMask"] = @(2147483647);
        defaultProperties[@"files"] = [NSMutableArray array];
        defaultProperties[@"runOnlyForDeploymentPostprocessing"] = @"0";
    });
    
    return [registry addResourceObjectOfClass:[self class] withProperties:[defaultProperties copy]];
}

- (void)addBuildFileWithReference:(XCFileReference *)reference useAutomaticReferenceCounting:(BOOL)useARC buildSettings:(NSDictionary *)dictionary {
    NSMutableDictionary *settings = [dictionary mutableCopy];
    if (!useARC) {
        NSMutableArray *flags = settings[@"COMPILE_FLAGS"];
        if (flags == nil) {
            flags = [NSMutableArray array];
            settings[@"COMPILE_FLAGS"] = flags;
        }
        
        [flags addObject:@"-fno-objc-arc"];
    }
    
    [self addBuildFileWithReference:reference buildSettings:settings];
}

@end

#pragma mark -

@implementation XCCopyResourcesBuildPhase

+ (XCCopyResourcesBuildPhase *)createCopyResourcesBuildPhaseInRegistry:(XCObjectRegistry *)registry {
    static NSMutableDictionary *defaultProperties;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultProperties = [[NSMutableDictionary alloc] init];
        defaultProperties[@"isa"] = @"PBXResourcesBuildPhase";
        defaultProperties[@"buildActionMask"] = @(2147483647);
        defaultProperties[@"files"] = [NSMutableArray array];
        defaultProperties[@"runOnlyForDeploymentPostprocessing"] = @"0";
    });
    
    return [registry addResourceObjectOfClass:[self class] withProperties:[defaultProperties copy]];
}

@end

#pragma mark -

@implementation XCRunScriptBuildPhase

+ (XCRunScriptBuildPhase *)createRunScriptBuildPhaseWithScript:(NSString *)source inRegistry:(XCObjectRegistry *)registry {
    return [self createRunScriptBuildPhaseWithScript:source interpreterPath:@"/bin/sh" inRegistry:registry];
}

+ (XCRunScriptBuildPhase *)createRunScriptBuildPhaseWithScript:(NSString *)source interpreterPath:(NSString *)interpreter inRegistry:(XCObjectRegistry *)registry {
    static NSMutableDictionary *defaultProperties;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultProperties = [[NSMutableDictionary alloc] init];
        defaultProperties[@"isa"] = @"PBXShellScriptBuildPhase";
        defaultProperties[@"buildActionMask"] = @(2147483647);
        defaultProperties[@"files"] = [NSMutableArray array];
        defaultProperties[@"inputPaths"] = [NSMutableArray array];
        defaultProperties[@"outputPaths"] = [NSMutableArray array];
        defaultProperties[@"runOnlyForDeploymentPostprocessing"] = @"0";
    });
    
    NSMutableDictionary *finalProperties = [defaultProperties copy];
    finalProperties[@"shellPath"] = interpreter;
    finalProperties[@"shellScript"] = source;
    
    return [registry addResourceObjectOfClass:[self class] withProperties:finalProperties];
}

- (NSString *)name {
    return self.properties[@"name"];
}

- (void)setName:(NSString *)name {
    self.properties[@"name"] = name;
}

- (BOOL)runOnlyWhenInstalling {
    NSString *val = self.properties[@"runOnlyForDeploymentPreprocessing"];
    
    // Default to NO.
    if (val == nil) {
        return NO;
    } else if ([val isEqualToString:@"1"]) {
        return YES;
    } else if ([val isEqualToString:@"0"]) {
        return NO;
    } else {
        [NSException raise:NSInternalInconsistencyException format:@"Unrecognized 'runOnlyForDeploymentPreprocessing': %@", val];
        return NO;
    }
}

- (void)setRunOnlyWhenInstalling:(BOOL)runOnlyWhenInstalling {
    self.properties[@"runOnlyForDeploymentPreprocessing"] = runOnlyWhenInstalling ? @"1" : @"0";
}

- (NSString *)scriptSource {
    return self.properties[@"shellScript"];
}

- (void)setScriptSource:(NSString *)scriptSource {
    self.properties[@"shellScript"] = scriptSource;
}

- (NSArray *)inputFiles {
    return self.properties[@"inputFiles"];
}

- (void)setInputFiles:(NSArray *)inputFiles {
    self.properties[@"inputFiles"] = inputFiles;
}

- (NSArray *)outputFiles {
    return self.properties[@"outputFiles"];
}

- (void)setOutputFiles:(NSArray *)inputFiles {
    self.properties[@"outputFiles"] = inputFiles;
}

@end

#pragma mark -

@implementation XCCopyHeadersBuildPhase

+ (XCCopyHeadersBuildPhase *)createCopyHeadersBuildPhaseInRegistry:(XCObjectRegistry *)registry {
    static NSMutableDictionary *defaultProperties;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultProperties = [[NSMutableDictionary alloc] init];
        defaultProperties[@"isa"] = @"PBXHeadersBuildPhase";
        defaultProperties[@"buildActionMask"] = @(2147483647);
        defaultProperties[@"files"] = [NSMutableArray array];
        defaultProperties[@"runOnlyForDeploymentPostprocessing"] = @"0";
    });
    
    return [registry addResourceObjectOfClass:[self class] withProperties:[defaultProperties copy]];
}

- (void)addPublicHeaderFileWithReference:(XCFileReference *)reference buildSettings:(NSDictionary *)dictionary {
    [self addBuildFileWithReference:reference buildSettings:@{ @"ATTRIBUTES": @[ @"Public" ] }];
}

- (void)addPrivateHeaderFileWithReference:(XCFileReference *)reference buildSettings:(NSDictionary *)dictionary {
    [self addBuildFileWithReference:reference buildSettings:@{ @"ATTRIBUTES": @[ @"Private" ] }];
}

@end

#pragma mark -

@implementation XCCopyFilesBuildPhase

+ (XCCopyFilesBuildPhase *)createCopyFilesBuildPhaseWithName:(NSString *)name destination:(XCCopyFilesDestination)destination destinationSubdirectory:(NSString *)subdir inRegistry:(XCObjectRegistry *)registry {
    XCCopyFilesBuildPhase *phase = [self createCopyFilesBuildPhaseWithDestination:destination destinationSubdirectory:subdir inRegistry:registry];
    phase.properties[@"name"] = name;
    return phase;
}

+ (XCCopyFilesBuildPhase *)createCopyFilesBuildPhaseWithDestination:(XCCopyFilesDestination)destination destinationSubdirectory:(NSString *)subdir inRegistry:(XCObjectRegistry *)registry {
    static NSMutableDictionary *defaultProperties;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultProperties = [[NSMutableDictionary alloc] init];
        defaultProperties[@"isa"] = @"PBXCopyFilesBuildPhase";
        defaultProperties[@"buildActionMask"] = @(8);
        defaultProperties[@"files"] = [NSMutableArray array];
        defaultProperties[@"runOnlyForDeploymentPostprocessing"] = @"0";
    });
    
    NSMutableDictionary *finalProperties = [defaultProperties copy];
    finalProperties[@"dstSubfolderSpec"] = @(destination);
    finalProperties[@"dstPath"] = subdir;
    
    return [registry addResourceObjectOfClass:[self class] withProperties:finalProperties];
}

- (BOOL)copyOnlyWhenInstalling {
    NSString *val = self.properties[@"runOnlyForDeploymentPostprocessing"];
    
    // Default to NO.
    if (val == nil) {
        return NO;
    } else if ([val isEqualToString:@"1"]) {
        return YES;
    } else if ([val isEqualToString:@"0"]) {
        return NO;
    } else {
        [NSException raise:NSInternalInconsistencyException format:@"Unexpected 'runOnlyForDeploymentPostprocessing' value: %@", val];
        return NO;
    }
}

- (void)setCopyOnlyWhenInstalling:(BOOL)copyOnlyWhenInstalling {
    self.properties[@"runOnlyForDeploymentPostprocessing"] = copyOnlyWhenInstalling ? @"1" : @"0";
}

- (XCCopyFilesDestination)destination {
    return (XCCopyFilesDestination) [self.properties[@"dstSubfolderSpec"] integerValue];
}

- (void)setDestination:(XCCopyFilesDestination)destination {
    self.properties[@"dstSubfolderSpec"] = @((NSInteger) destination);
}

- (NSString *)destinationSubdirectory {
    return self.properties[@"dstPath"];
}

- (void)setDestinationSubdirectory:(NSString *)destinationSubdirectory {
    self.properties[@"dstPath"] = destinationSubdirectory;
}

- (NSString *)name {
    return self.properties[@"name"];
}

- (void)setName:(NSString *)name {
    self.properties[@"name"] = name;
}

@end
