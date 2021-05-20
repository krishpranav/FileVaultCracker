//
//  NSString+FileVaultCracker.m
//  FileValutCracker
//
//  Created by Elangovan Ayyasamy on 20/05/21.
//  Copyright © 2021 Krisna Pranav. All rights reserved.
//

#import "NSString+FileVaultCracker.h"

static NSMutableDictionary< NSString *, NSArray< NSString * > * > * variants = nil;

@implementation NSString( FileVaultCracker )

- ( NSArray< NSString * > * )caseVariants
{
    char                         * permutation;
    const char                   * cp;
    NSUInteger                     length;
    NSUInteger                     i;
    NSUInteger                     j;
    NSUInteger                     n;
    NSMutableArray< NSString * > * v;
    
    if( self.length == 0 )
    {
        return @[];
    }
    
    cp     = self.UTF8String;
    length = self.length;
    
    permutation = calloc( length + 1, 1 );
    
    if( permutation == NULL )
    {
        return @[ self ];
    }
    
    v = [ NSMutableArray new ];
    
    for( i = 0, n = ( NSUInteger )pow( 2, length ); i < n; i++ )
    {
        for( j = 0; j < length; j++ )
        {
            permutation[ j ] = ( ( i >> j & 1 ) != 0 ) ? ( char )toupper( cp[ j ] ) : cp[ j ];
        }
        
        [ v addObject: [ NSString stringWithUTF8String: permutation ] ];
    }
    
    free( permutation );
    
    return v;
}

- ( NSArray< NSString * > * )commonSubstitutions
{
    {
        static dispatch_once_t once;
        
        dispatch_once
        (
         &once,
         ^( void )
         {
             NSString * k;
             
             variants =
             @{
               @"A": @[ @"4", @"@", @"^", @"Д" ],
               @"B": @[ @"8", @"ß", @"6" ],
               @"C": @[ @"[", @"¢", @"[", @"<", @"(", @"©" ],
               @"D": @[ @")", @"?", @">" ],
               @"E": @[ @"3", @"&", @"£", @"€", @"ë" ],
               @"F": @[ @"ƒ", @"v" ],
               @"G": @[ @"&", @"6", @"9", @"[" ],
               @"H": @[ @"#" ],
               @"I": @[ @"1", @"|", @"!" ],
               @"J": @[ @";", @"1" ],
               @"K": @[],
               @"L": @[ @"1", @"£", @"7", @"|" ],
               @"M": @[],
               @"N": @[ @"И", @"^", @"ท" ],
               @"O": @[ @"0", @"Q", @"p", @"Ø" ],
               @"P": @[ @"9" ],
               @"Q": @[ @"9", @"2", @"&" ],
               @"R": @[ @"®", @"Я" ],
               @"S": @[ @"5", @"$", @"z", @"§", @"2" ],
               @"T": @[ @"7", @"+", @"†" ],
               @"U": @[ @"v", @"µ", @"บ" ],
               @"V": @[],
               @"W": @[ @"Ш", @"Щ", @"พ" ],
               @"X": @[ @"Ж", @"×" ],
               @"Y": @[ @"j", @"Ч", @"7", @"¥" ],
               @"Z": @[ @"2", @"%", @"s" ]
               }
             .mutableCopy;
             
             for( k in variants.allKeys )
             {
                 [ variants setObject: variants[ k ] forKey: k.lowercaseString ];
             }
         }
         );
    }
    
    if( self.length == 0 )
    {
        return @[ @"" ];
    }
    
    {
        NSString                     * c;
        NSString                     * tv;
        NSString                     * v;
        NSMutableArray< NSString * > * l;
        
        c = [ self substringToIndex: 1 ];
        l = [ NSMutableArray new ];
        
        for( tv in [ self substringFromIndex: 1 ].commonSubstitutions )
        {
            [ l addObject: [ c stringByAppendingString: tv ] ];
            
            if( variants[ c ].count == 0 )
            {
                continue;
            }
            
            for( v in variants[ c ] )
            {
                [ l addObject: [ v stringByAppendingString: tv ] ];
            }
        }
        
        return l;
    }
}

@end
