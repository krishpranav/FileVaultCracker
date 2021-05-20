//
//  FileVaultCracker.m
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

@property(atomic, readwrite, strong) DMManager * manager;
@property(atomic, readwrite, strong) DMCoreStorage * cs;

@end

NS_ASSUME_NONNULL_END


@implementation CoreStorageHelper

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id             instance;
    
    dispatch_once
    {
        &once
        ^(void)
        {
            instance = [self new]
        }
    };
    
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



@end
