//
//  AboutWindowController.m
//  FileValutCracker
//
//  Created by Elangovan Ayyasamy on 20/05/21.
//  Copyright © 2021 Krisna Pranav. All rights reserved.
//


#import "AboutWindowController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AboutWindowController()

@property( atomic, readwrite, strong ) NSString * name;
@property( atomic, readwrite, strong ) NSString * version;
@property( atomic, readwrite, strong ) NSString * copyright;

@end

NS_ASSUME_NONNULL_END

@implementation AboutWindowController

- ( instancetype )init
{
    return [ self initWithWindowNibName: NSStringFromClass( self.class ) ];
}

- ( void )windowDidLoad
{
    [ super windowDidLoad ];
    
    self.window.titlebarAppearsTransparent = YES;
    self.window.titleVisibility            = NSWindowTitleHidden;
    
    self.name      = [ [ NSBundle mainBundle ] objectForInfoDictionaryKey: @"CFBundleName" ];
    self.version   = [ [ NSBundle mainBundle ] objectForInfoDictionaryKey: @"CFBundleShortVersionString" ];
    self.copyright = [ [ NSBundle mainBundle ] objectForInfoDictionaryKey: @"NSHumanReadableCopyright" ];
}

@end
