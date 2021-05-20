//
//  DiskManagement.h
//  FileValutCracker
//
//  Created by Elangovan Ayyasamy on 20/05/21.
//  Copyright © 2021 Krisna Pranav. All rights reserved.
//

@import Foundation;
@import DiskArbitration;

NS_ASSUME_NONNULL_BEGIN

@protocol DMManagerDelegate< NSObject >

@optional

- ( void )dmInterruptibilityChanged: ( BOOL )value;
- ( void )dmAsyncFinishedForDisk: ( DADiskRef )disk mainError: ( int )mainError detailError: ( int )detailError dictionary: ( NSDictionary * )dictionary;
- ( void )dmAsyncMessageForDisk: ( DADiskRef )disk string: ( NSString * )str dictionary: ( NSDictionary * )dict;
- ( void )dmAsyncProgressForDisk: ( DADiskRef )disk barberPole: ( BOOL )barberPole percent: ( float )percent;
- ( void )dmAsyncStartedForDisk: ( DADiskRef )disk;

@end

@protocol DMManagerClientDelegate< NSObject >

@end

@interface DMManager: NSObject

@property( atomic, readwrite, weak, nullable   ) id< DMManagerDelegate       > delegate;
@property( atomic, readwrite, weak, nullable   ) id< DMManagerClientDelegate > clientDelegate;
@property( atomic, readonly                    ) BOOL                          checkClientDelegate;
@property( atomic, readonly, nullable          ) NSArray                     * topLevelDisks;
@property( atomic, readonly, nullable          ) NSArray                     * disks;
@property( atomic, readwrite, assign, nullable ) DASessionRef                  defaultDASession;
@property( atomic, readwrite, strong, nullable ) NSString                    * language;

+ ( instancetype )sharedManager;
+ ( instancetype )sharedManagerForThread;

- ( BOOL )isCoreStoragePhysicalVolumeDisk: ( DADiskRef )disk error: ( NSError * __autoreleasing * )error;
- ( BOOL )isCoreStorageLogicalVolumeDisk: ( DADiskRef )disk error: ( NSError * __autoreleasing * )error;
- ( NSString * )diskUUIDForDisk: ( DADiskRef )disk error: ( NSError * __autoreleasing * )error;

@end

@interface DMCoreStorage: NSObject

- ( instancetype )initWithManager: ( DMManager * )manager;

- ( int )unlockLogicalVolume: ( NSString * )volumeUID options: ( NSDictionary * )options;
- ( int )doCallDaemonForCoreStorage: ( NSString * )selector inputDict: ( NSMutableDictionary * )inputDict outputDict: ( NSDictionary  * _Nullable * _Nullable )outputDict checkDelegate: ( BOOL )checkDelegate sync: ( BOOL )sync;

- ( int )logicalVolumeGroups: ( NSArray< NSString * > * _Nullable * _Nullable )groups;
- ( int )logicalVolumeForDisk: ( DADiskRef )disk logicalVolume: ( NSString * _Nullable * _Nullable )logicalVolume;
- ( int )physicalVolumeAndLogicalVolumeGroupForDisk:( DADiskRef )disk physicalVolume: ( NSString * _Nullable * _Nullable )physicalVolume logicalVolumeGroup: ( NSString * _Nullable * _Nullable )logicalVolumeGroup;
- ( int )logicalVolumeGroupForLogicalVolume: ( NSString * )uuid logicalVolumeGroup:( NSString * _Nullable * _Nullable )group;
- ( int )copyDiskForLogicalVolume: ( NSString * )uuid disk: ( DADiskRef _Nullable * _Nullable )disk;
- ( int )isEncryptedDiskForLogicalVolume: ( NSString * )uuid encrypted:( BOOL * _Nullable )encrypted locked: ( BOOL * _Nullable )locked type: ( id _Nullable * _Nullable )type;

@end

NS_ASSUME_NONNULL_END
