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



