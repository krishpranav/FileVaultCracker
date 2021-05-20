//
//  FileVaultCracker.h
//  FileValutCracker
//
//  Created by Elangovan Ayyasamy on 20/05/21.
//  Copyright © 2021 Krisna Pranav. All rights reserved.
//


@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface FileVaultCracker: NSObject

@property( atomic, readonly, nullable ) NSString * message;
@property( atomic, readonly           ) double     progress;
@property( atomic, readonly           ) BOOL       progressIsIndeterminate;
@property( atomic, readonly           ) NSUInteger secondsRemaining;
@property( atomic, readwrite, assign  ) NSUInteger maxThreads;
@property( atomic, readwrite, assign  ) NSUInteger maxCharsForCaseVariants;
@property( atomic, readwrite, assign  ) NSUInteger maxCharsForCommonSubstitutions;

- ( nullable instancetype )initWithCoreStorageUUID: ( NSString * )coreStorageUUID passwords: ( NSArray< NSString * > * )passwords NS_DESIGNATED_INITIALIZER;
- ( void )crack: ( void ( ^ )( BOOL volumeMounted, NSString * _Nullable password ) )completion;
- ( void )stop;

@end

NS_ASSUME_NONNULL_END
