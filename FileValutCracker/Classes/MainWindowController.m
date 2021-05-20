//
//  MainWindowController.m
//  FileValutCracker
//
//  Created by Elangovan Ayyasamy on 20/05/21.
//  Copyright © 2021 Krisna Pranav. All rights reserved.
//

#import "MainWindowController.h"
#import "FileVaultCracker.h"
#import "CoreStorageHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainWindowController()

@property( atomic, readwrite, assign           ) BOOL               running;
@property( atomic, readwrite, assign           ) BOOL               caseVariants;
@property( atomic, readwrite, assign           ) NSInteger          caseVariantsMax;
@property( atomic, readwrite, assign           ) BOOL               commonSubstitutions;
@property( atomic, readwrite, assign           ) NSInteger          commonSubstitutionsMax;
@property( atomic, readwrite, strong, nullable ) NSString         * coreStorageUUID;
@property( atomic, readwrite, strong, nullable ) NSString         * wordList;
@property( atomic, readwrite, strong, nullable ) NSImage          * wordListIcon;
@property( atomic, readwrite, strong, nullable ) NSString         * runningLabel;
@property( atomic, readwrite, strong, nullable ) FileVaultCracker * cracker;
@property( atomic, readwrite, strong, nullable ) NSTimer          * timer;
@property( atomic, readwrite, assign           ) NSInteger          numberOfThreads;
@property( atomic, readwrite, assign           ) double             progress;
@property( atomic, readwrite, assign           ) BOOL               indeterminate;
@property( atomic, readwrite, assign           ) BOOL               hasStopped;
@property( atomic, readwrite, assign           ) BOOL               hasTimeRemaining;
@property( atomic, readwrite, strong, nullable ) NSString         * timeRemainingLabel;

- ( void )windowWillClose: ( NSNotification * )notification;
- ( IBAction )crack: ( nullable id )sender;
- ( IBAction )stop: ( nullable id )sender;
- ( IBAction )chooseWordList: ( nullable id )sender;
- ( IBAction )chooseImplementation: ( nullable id )sender;
- ( void )displayAlertWithTitle: ( NSString * )title message: ( NSString * )message;
- ( void )updateUI;
- ( NSString * )timeRemainingWithSeconds: ( NSUInteger )seconds;
- ( BOOL )verifyVolumeUUID: ( NSString * )uuid;

@end

NS_ASSUME_NONNULL_END

@implementation MainWindowController

- (instancetype) init
{
    return [self initWithWindowNibName: NSStringFromClass(self.class)];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.timer invalidate];
}

@end
