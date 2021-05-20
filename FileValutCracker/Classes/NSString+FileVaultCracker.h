//
//  NSString+FileVaultCracker.h
//  FileValutCracker
//
//  Created by Elangovan Ayyasamy on 20/05/21.
//  Copyright © 2021 Krisna Pranav. All rights reserved.
//


@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface NSString( FileVaultCracker )

- ( NSArray< NSString * > * )caseVariants;
- ( NSArray< NSString * > * )commonSubstitutions;

@end

NS_ASSUME_NONNULL_END
