//
//  NKHelperWindowController.m
//  KWHelper
//
//  Created by KyleWong on 2/25/16.
//  Copyright © 2016 KyleWong. All rights reserved.
//

#import "NKHelperWindowController.h"
#import "NKHelper.h"
#import "NKUserDefaults.h"
#import "XCObjectRegistry.h"
#import "XMLDictionary.h"

typedef NS_ENUM(NSInteger,NKResCheckResultType){
    NKResCheckResultTypeRedudant,
    NKResCheckResultTypeRepeat,
    NKResCheckResultTypeOK
};

NSString *kKeyResCheckResultType = @"type";
NSString *kKeyResCheckResultName = @"name";
NSString *kKeyResCheckResultPath = @"path";
NSString *kKeyResCheckResultInfo = @"info";

@interface NKHelperWindowController ()<NSTableViewDataSource,NSTableViewDelegate>
@property (weak) IBOutlet NSComboBox *combbCharsetFrom;
@property (weak) IBOutlet NSTextField *textFldFrom;
@property (weak) IBOutlet NSComboBox *combbCharsetTo;
@property (weak) IBOutlet NSTextField *textFldTo;
@property (weak) IBOutlet NSTextField *textFldTimeDesc;
@property (weak) IBOutlet NSTextField *textFldTimestamp;
@property (weak) IBOutlet NSTextField *textFldAutoCommFrom;
@property (weak) IBOutlet NSTextField *textFldAutoCommTo;
@property (weak) IBOutlet NSTableView *resCheckResTable;
@property (strong) NSMutableArray *resCheckResArray;
@property (weak) IBOutlet NSButton *resCheckBtn;
@end

@implementation NKHelperWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    [self.combbCharsetFrom selectItemAtIndex:0];
    [self.combbCharsetTo selectItemAtIndex:1];
    [self setResCheckResArray:[NSMutableArray array]];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

#pragma mark - Action
- (IBAction)onCharsetRightConvertAction:(id)sender {
    NSStringEncoding leftEncoding = [NKHelper stringEncodingFromDesc:[self.combbCharsetFrom objectValueOfSelectedItem]];
    NSStringEncoding rightEncoding = [NKHelper stringEncodingFromDesc:[self.combbCharsetTo objectValueOfSelectedItem]];
    NSString *text = [NKHelper convertString:self.textFldFrom.stringValue fromEncoding:leftEncoding toEncoding:rightEncoding];
    if(text.length)
        [self.textFldTo setStringValue:text];
}


- (IBAction)onCharsetLeftConvertAction:(id)sender {
    NSStringEncoding leftEncoding = [NKHelper stringEncodingFromDesc:[self.combbCharsetFrom objectValueOfSelectedItem]];
    NSStringEncoding rightEncoding = [NKHelper stringEncodingFromDesc:[self.combbCharsetTo objectValueOfSelectedItem]];
    NSString *text = [NKHelper convertString:self.textFldTo.stringValue fromEncoding:rightEncoding toEncoding:leftEncoding];
    if(text.length)
        [self.textFldFrom setStringValue:text];
}

- (IBAction)onTimeRightConvertAction:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:self.textFldTimeDesc.stringValue];
    [self.textFldTimestamp setStringValue:[NSString stringWithFormat:@"%.f",[date timeIntervalSince1970]]];
}

- (IBAction)onTimeLeftConvertAction:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.textFldTimestamp.stringValue.doubleValue];
    [self.textFldTimeDesc setStringValue:[dateFormatter stringFromDate:date ]];
}

- (IBAction)onAutoCommSaveAction:(id)sender {
    NKUserDefaults *defaults = [NKUserDefaults sharedInstance];
    [defaults setAutoCommFrom:self.textFldAutoCommFrom.stringValue];
    [defaults setAutoCommTo:self.textFldAutoCommTo.stringValue];
    [self.window performClose:nil];
}

- (IBAction)onCheckResAction:(id)sender {
    static NSInteger logIndex = 0;
    NSDocument *ideDocument = [[[NSClassFromString(@"IDEDocumentController") sharedDocumentController] documents] firstObject];
    [self.resCheckBtn setTitle:@"搜索中"];
    [self.resCheckBtn setEnabled:NO];
    dispatch_async(dispatch_get_global_queue(NULL, 0), ^{
        NSArray *array = [self checkResOfWspORPrj:ideDocument.fileURL.path];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resCheckResArray = [array mutableCopy];
            [self.resCheckResTable reloadData];
            [self.resCheckBtn setTitle:nil];
            [self.resCheckBtn setEnabled:YES];
        });
    });
}

#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.resCheckResArray.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    NSMutableDictionary *dict = [[self.resCheckResArray objectAtIndex:row] mutableCopy];
    switch ([dict[kKeyResCheckResultType] integerValue]) {
        case NKResCheckResultTypeRedudant:
            dict[kKeyResCheckResultType]=@"冗余";
            break;
        case NKResCheckResultTypeRepeat:
            dict[kKeyResCheckResultType]=@"重复";
            break;
        case NKResCheckResultTypeOK:
            dict[kKeyResCheckResultType]=@"正常";
            break;
        default:
            break;
    }
    NSString *oriContent = [dict description];
    return [[oriContent stringByReplacingOccurrencesOfString:@"\r" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
}
#pragma mark - NSTableViewDelegate
- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row{
    return NO;
}

#pragma mark - Resource check.
- (NSArray *)checkResOfWspORPrj:(NSString *)aWspORPrjName{
    NSMutableArray *resResult = [NSMutableArray array];
    if([aWspORPrjName hasSuffix:@".xcworkspace"]){
        NSDictionary *dict = [[XMLDictionaryParser sharedInstance] dictionaryWithFile:[aWspORPrjName stringByAppendingString:@"/contents.xcworkspacedata"]];
        NSArray *fileRefs = dict[@"FileRef"];
        for(NSDictionary *dict in fileRefs){
            NSString *refLocation = dict[@"_location"];
            if(![refLocation hasPrefix:@"group"] || ![refLocation hasSuffix:@".xcodeproj"])
                continue;
            refLocation = [refLocation substringFromIndex:@"group:".length];
            [resResult addObjectsFromArray:[self checkResOfPrj:[[[aWspORPrjName stringByDeletingLastPathComponent] stringByAppendingPathComponent:refLocation] stringByAppendingPathComponent:@"project.pbxproj"]]];
        }
    }
    else if([aWspORPrjName hasSuffix:@".xcodeproj"]){
        [resResult addObjectsFromArray:[self checkResOfPrj:[aWspORPrjName stringByAppendingPathComponent:@"project.pbxproj"]]];
    }
    return resResult;
}
                                                         
- (NSArray *)checkResOfPrj:(NSString *)aPrjName{
    NSError *error = nil;
    NSString *text = [[NSString alloc] initWithContentsOfFile:aPrjName encoding:NSUTF8StringEncoding error:&error];
    if(error)
        return @[];
    NSMutableArray *checkResult = [NSMutableArray array];
    if([aPrjName hasSuffix:@"Pods/Pods.xcodeproj/project.pbxproj"]){
        NSDictionary *dict = [[XMLDictionaryParser sharedInstance] dictionaryWithFile:aPrjName];
        NSDictionary *objects = dict[@"dict"][@"dict"][@"dict"];
        for(NSDictionary *dict in objects){
            NSArray *allKeys = [dict allKeys];
            if(allKeys.count!=2
               || ![allKeys containsObject:@"key"]
               || ![allKeys containsObject:@"string"]
               || [dict[@"key"] count]!=[dict[@"string"] count])
                continue;
            NSInteger nameIndex = [dict[@"key"] indexOfObject:@"name"];
            if(nameIndex != NSNotFound){
                NSString *path = [dict[@"string"] objectAtIndex:nameIndex];
                if([path hasSuffix:@".png"] || [path hasSuffix:@".jpg"]){
                }
            }
        }
    }
    else{
        @try {
            XCObjectRegistry *registry = [XCObjectRegistry objectRegistryWithXcodePBXProjectText:text];
            NSDictionary *dict = [registry projectPropertyList];
            NSDictionary *objects = dict[@"objects"];
            NSArray *allKeys = [objects allKeys];
            for(NSString *key in allKeys){
                NSDictionary *value = [objects objectForKey:key];
                NSString *path = value[@"path"];
                if([path hasSuffix:@".png"] || [path hasSuffix:@".jpg"]){
                    NSPipe *pipe = [NSPipe pipe];
                    NSFileHandle *file = pipe.fileHandleForReading;
                    
                    NSTask *task = [[NSTask alloc] init];
                    NSString *fileName = [[[path componentsSeparatedByString:@"@"] firstObject] stringByDeletingPathExtension];
                    task.launchPath = @"/bin/bash";
                    task.arguments = @[@"-c",[NSString stringWithFormat:@"/usr/bin/grep -r --include \\*.m --include \\*.xib -w '%@' %@",fileName,[[aPrjName stringByDeletingLastPathComponent] stringByDeletingLastPathComponent]]];
                    task.standardOutput = pipe;
                    task.standardError = pipe;
                    [task waitUntilExit];
                    [task launch];
                    NSData *data = [file readDataToEndOfFile];
                    [file closeFile];
                    NSString *grepOutput = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
                    NSMutableDictionary *itemInfo = [NSMutableDictionary dictionary];
                    NSString *format = [NSString stringWithFormat:@"SELF.%@ == '%@'",kKeyResCheckResultPath,path];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:format];
                    if(grepOutput.length<=0){
                        itemInfo = [@{kKeyResCheckResultPath:path,kKeyResCheckResultType:@(NKResCheckResultTypeRedudant)} mutableCopy];
                    }
                    else if([[checkResult filteredArrayUsingPredicate:predicate] count]>0){
                        itemInfo = [@{kKeyResCheckResultPath:path,kKeyResCheckResultType:@(NKResCheckResultTypeRepeat)} mutableCopy];
                    }
                    else{
                        itemInfo = [@{kKeyResCheckResultPath:path,kKeyResCheckResultType:@(NKResCheckResultTypeOK)} mutableCopy];
                    }
                    [checkResult addObject:itemInfo];
                }
            }
        } @catch (NSException *exception) {
            fprintf(stderr, "Could not parse pbxproj: %s\n", exception.description.UTF8String);
            fprintf(stderr, "%s\n", exception.callStackSymbols.description.UTF8String);
        }
    }
    return checkResult;
}
@end