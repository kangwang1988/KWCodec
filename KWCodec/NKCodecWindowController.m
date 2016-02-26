//
//  NKCodecWindowController.m
//  KWCodec
//
//  Created by KyleWong on 2/25/16.
//  Copyright © 2016 KyleWong. All rights reserved.
//

#import "NKCodecWindowController.h"
#import "NKHelper.h"
#import "NKUserDefaults.h"

@interface NKCodecWindowController ()
@property (weak) IBOutlet NSComboBox *combbCharsetFrom;
@property (weak) IBOutlet NSTextField *textFldFrom;
@property (weak) IBOutlet NSComboBox *combbCharsetTo;
@property (weak) IBOutlet NSTextField *textFldTo;
@property (weak) IBOutlet NSTextField *textFldTimeDesc;
@property (weak) IBOutlet NSTextField *textFldTimestamp;
@property (weak) IBOutlet NSTextField *textFldAutoCommFrom;
@property (weak) IBOutlet NSTextField *textFldAutoCommTo;
@end

@implementation NKCodecWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    [self.combbCharsetFrom selectItemAtIndex:0];
    [self.combbCharsetTo selectItemAtIndex:1];
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
}
@end