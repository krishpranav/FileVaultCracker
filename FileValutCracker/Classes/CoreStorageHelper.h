//
//  CoreStorageHelper.h
//  FileValutCracker
//
//  Created by Elangovan Ayyasamy on 20/05/21.
//  Copyright © 2021 Krisna Pranav. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface CoreStorageHelper: NSObject

+ ( instancetype )sharedInstance;

- ( BOOL )isValidLogicalVolumeUUID: ( NSString * )uuid;
- ( BOOL )isEncryptedLogicalVolumeUUID: ( NSString * )uuid;
- ( BOOL )isLockedLogicalVolumeUUID: ( NSString * )uuid;
- ( BOOL )unlockLogicalVolumeUUID: ( NSString * )volumeUUID withAKSUUID: ( NSString * )aksUUID;

@end

NS_ASSUME_NONNULL_END
