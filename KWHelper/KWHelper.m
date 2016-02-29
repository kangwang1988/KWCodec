//
//  KWHelper.m
//  KWHelper
//
//  Created by KyleWong on 2/24/16.
//  Copyright © 2016 KyleWong. All rights reserved.
//

#import "KWHelper.h"
#import "NKHelperWindowController.h"
#import "NKUserDefaults.h"

@interface KWHelper()

@property (nonatomic, strong, readwrite) NSBundle *bundle;
@property (nonatomic, strong, readwrite) NKHelperWindowController *helperVC;
@property (nonatomic, strong, readwrite) NSMutableSet *notifs;
@property (nonatomic, assign, readwrite) BOOL isEnabled;
@property (nonatomic, strong, readwrite) NSMenuItem *closeAllDocsMenuItem;
@end

@implementation KWHelper

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didApplicationFinishLaunchingNotification:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationLog:) name:nil object:nil];
        [self setNotifs:[NSMutableSet set]];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications
- (void)didApplicationFinishLaunchingNotification:(NSNotification*)noti
{
    //removeObserver
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    
    // Create menu items, initialize UI, etc.
    // Sample Menu Item:
    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Window"];
    if (menuItem) {
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
        NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"KWHelper" action:@selector(doShowMainWindow:) keyEquivalent:@""];
        [actionMenuItem setTarget:self];
        [[menuItem submenu] addItem:actionMenuItem];
        NSMenuItem *actionMenuItem2 = [[NSMenuItem alloc] initWithTitle:@"Close All Docs" action:@selector(doCloseAllDocs:) keyEquivalent:@"1"];
        [actionMenuItem2 setTarget:self];
        [self setCloseAllDocsMenuItem:actionMenuItem2];
        [[menuItem submenu] addItem:actionMenuItem2];
    }
    [self updateUIComponents];
}

- (BOOL)validateMenuItem:(NSMenuItem*)menuItem{
    if([menuItem isEqual:self.closeAllDocsMenuItem]){
        return self.isEnabled;
    }
    return YES;
}


- (void)notificationLog:(NSNotification *)notify
{
    if([notify.name isEqualToString:@"NSWindowWillOrderOffScreenNotification"]){
    }
    if([notify.name isEqualToString:@"NSMenuDidCompleteInteractionNotification"]){
    }
    if([notify.name isEqualToString:NSTextDidChangeNotification]){
        NSTextView *textView = notify.object;
        if([textView.window isEqual:self.helperVC.window])
            return;
        NKUserDefaults *defaults = [NKUserDefaults sharedInstance];
        NSString *fromPattern = defaults.autoCommFrom, *toPattern = defaults.autoCommTo;
        NSString *fromContent = textView.textStorage.string;
        NSString *toContent = nil;
        NSInteger insertionPoint = [[[textView selectedRanges] objectAtIndex:0] rangeValue].location;
        NSString *subContent1 = [fromContent substringToIndex:insertionPoint];
        NSString *subContent2 = [fromContent substringFromIndex:insertionPoint];
        if(fromPattern.length && toPattern.length && [subContent1 hasSuffix:fromPattern]){
            toContent = [[[subContent1 substringToIndex:subContent1.length-fromPattern.length] stringByAppendingString:toPattern] stringByAppendingString:subContent2];
            [textView setString:toContent];
        }
    }
    if([notify.name isEqualToString:@"IDEEditorDocumentDidChangeNotification"] || [notify.name isEqualToString:@"IDEEditorDocumentShouldCommitEditingNotification"]){
        [self updateUIComponents];
    }
    if([self.notifs containsObject:notify.name])
        return;
    [self.notifs addObject:notify.name];
}

#pragma mark - Action
// Sample Action, for menu item:
- (void)doShowMainWindow:(id)sender
{
    self.helperVC = [[NKHelperWindowController alloc] initWithWindowNibName:@"NKHelperWindowController"];
    [self.helperVC showWindow:self.helperVC];
}

- (void)doCloseAllDocs:(id)sender{
    [self updateUIComponents];
    if(!self.isEnabled){
        return;
    }
    [self sendCombinedKeysForCloseCurDoc];
    [self performSelector:@selector(doCloseAllDocs:) withObject:nil afterDelay:.35f];
}

#pragma mark - Update UIComponents
- (void)updateUIComponents{
    NSDocumentController* curIDEDC = [NSClassFromString(@"IDEDocumentController") sharedDocumentController];
    NSArray *openedDocs = curIDEDC.documents;
    BOOL isEnabled = YES;
    if(openedDocs.count<=0 || (openedDocs.count == 1 && [[[openedDocs.firstObject fileURL] absoluteString] hasSuffix:@".xcworkspace/"])){
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        isEnabled = NO;
    }
    [self setIsEnabled:isEnabled];
    [self.closeAllDocsMenuItem setEnabled:isEnabled];
}

#pragma mark - Close Document Related
- (void)sendCombinedKeysForCloseCurDoc{
    CGEventSourceRef source = CGEventSourceCreate(kCGEventSourceStateCombinedSessionState);
    // kVK_ANSI_W                    = 0x0D,
    CGEventRef wCommandCtrlDown = CGEventCreateKeyboardEvent(source, (CGKeyCode)0x0D, YES);
    CGEventSetFlags(wCommandCtrlDown, kCGEventFlagMaskCommand | kCGEventFlagMaskControl);
    CGEventRef wCommandCtrlUp = CGEventCreateKeyboardEvent(source, (CGKeyCode)0x0D, NO);
    
    CGEventPost(kCGAnnotatedSessionEventTap, wCommandCtrlDown);
    CGEventPost(kCGAnnotatedSessionEventTap, wCommandCtrlUp);
    
    CFRelease(wCommandCtrlUp);
    CFRelease(wCommandCtrlDown);
    CFRelease(source);
}
@end