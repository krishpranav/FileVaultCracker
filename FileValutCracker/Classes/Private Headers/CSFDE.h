//
//  CSFDE.h
//  FileValutCracker
//
//  Created by Elangovan Ayyasamy on 20/05/21.
//  Copyright © 2021 Krisna Pranav. All rights reserved.
//


@import CoreFoundation;

NS_ASSUME_NONNULL_BEGIN

CFStringRef CSFDEStorePassphrase( const char * passphrase );
void        CSFDERemovePassphrase( CFStringRef uuid );

NS_ASSUME_NONNULL_END
