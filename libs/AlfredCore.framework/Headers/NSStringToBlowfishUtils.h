//
//  NSString+Blowfish.h
//  Alfred
//
//  Created by tianbao on 2019/1/17.
//  Copyright © 2019 tianbao. All rights reserved.
//

#import <Foundation/Foundation.h>
#define BlowFishKey @"lhcwysghbc"

@interface NSStringToBlowfishUtils: NSObject

+ (NSString *)blowFishEncodingWithKey:(NSString *)pkey andStr:(NSString *)string;
+ (NSString *)blowFishDecodingWithKey:(NSString *)pkey andStr:(NSString *)string;

+ (NSData *)blowFishEncoding:(NSString *)pkey andStr:(NSString *)string;
+ (NSString *)blowFishDecoding:(NSString *)pkey decodeData:(NSData *)decodeData;
@end
