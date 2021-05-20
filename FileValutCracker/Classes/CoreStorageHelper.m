//
//  CoreStorageHelper.m
//  FileValutCracker
//
//  Created by Elangovan Ayyasamy on 20/05/21.
//  Copyright © 2021 Krisna Pranav. All rights reserved.
//

@import DiskArbitration;

#import "CoreStorageHelper.h"
#import "DiskManagement.h"
#import <stdatomic.h>

NS_ASSUME_NONNULL_BEGIN

@interface CoreStorageHelper() < DMManagerDelegate, DMManagerClientDelegate >
{
    atomic_bool _unlocked;
}

@property( atomic, readwrite, strong ) DMManager     * manager;
@property( atomic, readwrite, strong ) DMCoreStorage * cs;

@end

NS_ASSUME_NONNULL_END

@implementation CoreStorageHelper

+ ( instancetype )sharedInstance
{
    static dispatch_once_t once;
    static id              instance = nil;
    
    dispatch_once
    (
     &once,
     ^( void )
     {
         instance = [ self new ];
     }
     );
    
    return instance;
}

- ( instancetype )init
{
    if( ( self = [ super init ] ) )
    {
        self.manager                = [ DMManager new ];
        self.manager.language       = @"English";
        self.manager.delegate       = self;
        self.manager.clientDelegate = self;
        self.cs                     = [ [ DMCoreStorage alloc ] initWithManager: self.manager ];
    }
    
    return self;
}

- ( BOOL )isValidLogicalVolumeUUID: ( NSString * )uuid
{
    return [ self.cs logicalVolumeGroupForLogicalVolume: uuid logicalVolumeGroup: NULL ] == 0;
}

- ( BOOL )isEncryptedLogicalVolumeUUID: ( NSString * )uuid
{
    BOOL encrypted;
    
    if( [ self.cs isEncryptedDiskForLogicalVolume: uuid encrypted: &encrypted locked: NULL type: NULL ] != 0 )
    {
        return NO;
    }
    
    return encrypted;
}

- ( BOOL )isLockedLogicalVolumeUUID: ( NSString * )uuid
{
    BOOL locked;
    
    if( [ self.cs isEncryptedDiskForLogicalVolume: uuid encrypted: NULL locked: &locked type: NULL ] != 0 )
    {
        return NO;
    }
    
    return locked;
}


- ( BOOL )unlockLogicalVolumeUUID: ( NSString * )volumeUUID withAKSUUID: ( NSString * )aksUUID
{
    NSMutableDictionary * options;
    
    atomic_store( &_unlocked, false );
    
    if( volumeUUID.length == 0 || aksUUID.length == 0 )
    {
        return NO;
    }
    
    options =
    @{
      @"lvuuid"  : volumeUUID,
      @"options" :
          @{
              @"AKSPassphraseUUID" : aksUUID
              }
      }
    .mutableCopy;
    
    [ self.cs unlockLogicalVolume: volumeUUID options: options[ @"options" ] ];
    
    CFRunLoopRun();
    
    return atomic_load( &_unlocked );
}

#pragma mark - DMManagerDelegate

- ( void )dmInterruptibilityChanged: ( BOOL )value
{
    ( void )value;
}

