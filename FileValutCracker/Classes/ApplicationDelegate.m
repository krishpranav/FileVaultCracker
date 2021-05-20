//
//  ApplicationDelegate.m
//  FileValutCracker
//
//  Created by Elangovan Ayyasamy on 20/05/21.
//  Copyright © 2021 Krisna Pranav. All rights reserved.
//

#import "ApplicationDelegate.h"
#import "AboutWindowController.h"
#import "MainWindowController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ApplicationDelegate()

@property( atomic, readwrite, strong, nullable ) AboutWindowController * aboutWindowController;
@property( atomic, readwrite, strong, nullable ) MainWindowController  * mainWindowController;

@end

NS_ASSUME_NONNULL_END

@implementation ApplicationDelegate

- ( void )applicationDidFinishLaunching: ( NSNotification * )notification
{
    ( void )notification;
    
    self.mainWindowController = [ MainWindowController new ];
    
    [ self.mainWindowController.window center ];
    [ self.mainWindowController.window makeKeyAndOrderFront: nil ];
}

- ( BOOL )applicationShouldTerminateAfterLastWindowClosed: ( NSApplication * )sender
{
    ( void )sender;
    
    return YES;
}

- ( IBAction )showAboutWindow: ( nullable id )sender
{
    @synchronized( self )
    {
        if( self.aboutWindowController == nil )
        {
            self.aboutWindowController = [ AboutWindowController new ];
            
            [ self.aboutWindowController.window center ];
        }
        
        [ self.aboutWindowController.window makeKeyAndOrderFront: sender ];
    }
}

@end
