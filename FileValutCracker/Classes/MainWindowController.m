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

- ( instancetype )init
{
    return [ self initWithWindowNibName: NSStringFromClass( self.class ) ];
}

- ( void )dealloc
{
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self ];
    [ self.timer invalidate ];
}

- ( void )windowWillClose: ( NSNotification * )notification
{
    ( void )notification;
    
    [ [ NSUserDefaults standardUserDefaults ] setObject:  self.coreStorageUUID        forKey: @"CoreStorageUUID" ];
    [ [ NSUserDefaults standardUserDefaults ] setBool:    self.caseVariants           forKey: @"CaseVariants" ];
    [ [ NSUserDefaults standardUserDefaults ] setInteger: self.caseVariantsMax        forKey: @"CaseVariantsMax" ];
    [ [ NSUserDefaults standardUserDefaults ] setBool:    self.commonSubstitutions    forKey: @"CommonSubstitutions" ];
    [ [ NSUserDefaults standardUserDefaults ] setInteger: self.commonSubstitutionsMax forKey: @"CommonSubstitutionsMax" ];
    [ [ NSUserDefaults standardUserDefaults ] setInteger: self.numberOfThreads        forKey: @"NumberOfThreads" ];
    [ [ NSUserDefaults standardUserDefaults ] synchronize ];
}

- ( void )windowDidLoad
{
    NSString * wordList;
    
    [ super windowDidLoad ];
    
    [ [ NSNotificationCenter defaultCenter ] addObserver: self selector: @selector( windowWillClose: ) name: NSWindowWillCloseNotification object: self.window ];
    
    self.window.titlebarAppearsTransparent = YES;
    self.window.titleVisibility            = NSWindowTitleHidden;
    self.window.title                      = [ [ NSBundle mainBundle ] objectForInfoDictionaryKey: @"CFBundleName" ];
    
    self.coreStorageUUID = [ [ NSUserDefaults standardUserDefaults ] objectForKey: @"CoreStorageUUID" ];
    wordList             = [ [ NSUserDefaults standardUserDefaults ] objectForKey: @"WordList" ];
    
    self.caseVariants           = [ [ NSUserDefaults standardUserDefaults ] boolForKey:    @"CaseVariants" ];
    self.caseVariantsMax        = [ [ NSUserDefaults standardUserDefaults ] integerForKey: @"CaseVariantsMax" ];
    self.commonSubstitutions    = [ [ NSUserDefaults standardUserDefaults ] boolForKey:    @"CommonSubstitutions" ];
    self.commonSubstitutionsMax = [ [ NSUserDefaults standardUserDefaults ] integerForKey: @"CommonSubstitutionsMax" ];
    self.numberOfThreads        = [ [ NSUserDefaults standardUserDefaults ] integerForKey: @"NumberOfThreads" ];
    
    if( self.numberOfThreads <= 0 || self.numberOfThreads > 30 )
    {
        self.numberOfThreads = 20;
    }
    
    if( self.caseVariantsMax < 2 || self.caseVariantsMax > 20 )
    {
        self.caseVariantsMax = 20;
    }
    
    if( self.commonSubstitutionsMax < 2 || self.commonSubstitutionsMax > 20 )
    {
        self.commonSubstitutionsMax = 5;
    }
    
    if( wordList.length && [ [ NSFileManager defaultManager ] fileExistsAtPath: wordList ] )
    {
        self.wordList     = wordList;
        self.wordListIcon = [ [ NSWorkspace sharedWorkspace ] iconForFile: self.wordList ];
    }
    else if
        (
         [ [ NSBundle mainBundle ] pathForResource: @"words" ofType: @"txt" ].length
         && [ [ NSFileManager defaultManager ] fileExistsAtPath: [ [ NSBundle mainBundle ] pathForResource: @"words" ofType: @"txt" ] ]
         )
    {
        self.wordList     = [ [ NSBundle mainBundle ] pathForResource: @"words" ofType: @"txt" ];
        self.wordListIcon = [ [ NSWorkspace sharedWorkspace ] iconForFile: self.wordList ];
    }
    
    self.timer = [ NSTimer scheduledTimerWithTimeInterval: 0.1 target: self selector: @selector( updateUI ) userInfo: nil repeats: YES ];
}

- ( IBAction )crack: ( nullable id )sender
{
    NSArray< NSString * > * passwords;
    NSData                * data;
    
    ( void )sender;
    
    if( self.cracker != nil )
    {
        return;
    }
    
    if( [ self verifyVolumeUUID: self.coreStorageUUID ] == NO )
    {
        return;
    }
    
    data      = [ [ NSFileManager defaultManager ] contentsAtPath: self.wordList ];
    passwords = [ [ [ NSString alloc ] initWithData: data encoding: NSUTF8StringEncoding ] componentsSeparatedByString: @"\n" ];
    
    if( passwords.count == 0 || ( passwords.count == 1 && passwords.firstObject.length == 0 ) )
    {
        [ self displayAlertWithTitle: @"Error" message: @"Error reading from the word list file." ];
        
        return;
    }
    
    self.cracker            = [ [ FileVaultCracker alloc ] initWithCoreStorageUUID: self.coreStorageUUID passwords: passwords ];
    self.cracker.maxThreads = ( self.numberOfThreads ) ? ( NSUInteger )( self.numberOfThreads ) : 1;
    
    if( self.caseVariants && self.caseVariantsMax > 0 )
    {
        self.cracker.maxCharsForCaseVariants = ( NSUInteger )( self.caseVariantsMax );
    }
    
    if( self.commonSubstitutions && self.commonSubstitutionsMax > 0 )
    {
        self.cracker.maxCharsForCommonSubstitutions = ( NSUInteger )( self.commonSubstitutionsMax );
    }
    
    if( self.cracker == nil )
    {
        [ self displayAlertWithTitle: @"Error" message: @"Error initializing the FileVault cracker." ];
        
        return;
    }
    
    self.running = YES;
    
    [ self.cracker crack: ^( BOOL volumeMounted, NSString * _Nullable password )
     {
         dispatch_async
         (
          dispatch_get_main_queue(),
          ^( void )
          {
              if( self.hasStopped == NO )
              {
                  if( volumeMounted )
                  {
                      [ self displayAlertWithTitle: @"Password found" message: [ NSString stringWithFormat: @"The FileVault volume has been successfully mounted. Password is: %@", password ] ];
                  }
                  else
                  {
                      [ self displayAlertWithTitle: @"Password not found" message: @"A correct FileVault password wasn't found in the supplied word list." ];
                  }
              }
              
              self.hasStopped = NO;
              self.running    = NO;
              self.cracker    = nil;
          }
          );
     }
     ];
}

- ( IBAction )stop: ( nullable id )sender
{
    ( void )sender;
    
    self.hasStopped = YES;
    
    [ self.cracker stop ];
}

- ( IBAction )chooseWordList: ( nullable id )sender
{
    NSOpenPanel * panel;
    
    ( void )sender;
    
    panel                         = [ NSOpenPanel openPanel ];
    panel.canCreateDirectories    = NO;
    panel.canChooseDirectories    = NO;
    panel.canChooseFiles          = YES;
    panel.allowsMultipleSelection = NO;
    panel.allowedFileTypes        = @[ @"txt" ];
    
    [ panel beginSheetModalForWindow: self.window completionHandler: ^( NSInteger result )
     {
         if( result != NSModalResponseOK )
         {
             return;
         }
         
         if( [ [ NSFileManager defaultManager ] fileExistsAtPath: panel.URLs.firstObject.path ] == NO )
         {
             return;
         }
         
         self.wordList     = panel.URLs.firstObject.path;
         self.wordListIcon = [ [ NSWorkspace sharedWorkspace ] iconForFile: self.wordList ];
         
         [ [ NSUserDefaults standardUserDefaults ] setObject: self.wordList forKey: @"WordList" ];
         [ [ NSUserDefaults standardUserDefaults ] synchronize ];
     }
     ];
}

- ( IBAction )chooseImplementation: ( nullable id )sender
{
    ( void )sender;
}

- ( void )displayAlertWithTitle: ( NSString * )title message: ( NSString * )message
{
    dispatch_async
    (
     dispatch_get_main_queue(),
     ^( void )
     {
         NSAlert * alert;
         
         alert                 = [ NSAlert new ];
         alert.messageText     = title;
         alert.informativeText = message;
         
         [ alert addButtonWithTitle: NSLocalizedString( @"OK", @"" ) ];
         [ alert beginSheetModalForWindow: self.window completionHandler: NULL ];
     }
     );
}

- ( void )updateUI
{
    if( self.running == NO )
    {
        self.runningLabel       = @"";
        self.progress           = 0.0;
        self.indeterminate      = YES;
        self.hasTimeRemaining   = NO;
        self.timeRemainingLabel = @"";
    }
    else
    {
        self.runningLabel       = self.cracker.message;
        self.progress           = self.cracker.progress;
        self.indeterminate      = self.cracker.progressIsIndeterminate;
        self.hasTimeRemaining   = ( self.cracker.secondsRemaining > 0 );
        self.timeRemainingLabel = [ self timeRemainingWithSeconds: self.cracker.secondsRemaining ];
    }
}

- ( NSString * )timeRemainingWithSeconds: ( NSUInteger )seconds
{
    NSString * unit;
    double     value;
    
    if( seconds == 0 )
    {
        return @"";
    }
    
    if( seconds < 60 )
    {
        value = seconds;
        unit  = ( value > 1 ) ? @"seconds" : @"second";
    }
    else if( seconds < 3600 )
    {
        value = seconds / 60;
        unit  = ( value > 1 ) ? @"minutes" : @"minute";
    }
    else
    {
        value = seconds / 3600;
        unit  = ( value > 1 ) ? @"hours" : @"hour";
    }
    
    return [ NSString stringWithFormat: @"Estimated time remaining: about %.02f %@", value, unit ];
}

- ( BOOL )verifyVolumeUUID: ( NSString * )uuid
{
    CoreStorageHelper * cs;
    NSAlert           * alert;
    
    cs    = [ CoreStorageHelper sharedInstance ];
    alert = [ NSAlert new ];
    
    [ alert setMessageText: NSLocalizedString( @"Error", nil ) ];
    [ alert addButtonWithTitle: NSLocalizedString( @"OK", nil ) ];
    
    if( [ cs isValidLogicalVolumeUUID: uuid ] == NO )
    {
        alert.informativeText = NSLocalizedString( @"UUID is not a valid CoreStorage volume UUID.", nil );
        
        [ alert beginSheetModalForWindow: self.window completionHandler: NULL ];
        
        return NO;
    }
    
    if( [ cs isEncryptedLogicalVolumeUUID: uuid ] == NO )
    {
        alert.informativeText = NSLocalizedString( @"Volume is not encrypted.", nil );
        
        [ alert beginSheetModalForWindow: self.window completionHandler: NULL ];
        
        return NO;
    }
    
    if( [ cs isLockedLogicalVolumeUUID: uuid ] == NO )
    {
        alert.informativeText = NSLocalizedString( @"Volume is already unlocked.", nil );
        
        [ alert beginSheetModalForWindow: self.window completionHandler: NULL ];
        
        return NO;
    }
    
    return YES;
}

@end

