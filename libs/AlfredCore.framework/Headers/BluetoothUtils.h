//
//  BluetoothUtils.h
//  Alfred
//
//  Created by tianbao on 2018/6/8.
//  Copyright © 2018年 tianbao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BluetoothUtils : NSObject

//10进制转16进制
+ (NSString *)intTypeToHexStr:(long long int)tmpid;
+ (NSString *)getBinaryByHex:(NSString *)hex;
+ (NSString *)hexStringTransWithSmallAndBig:(NSString *)string;
+ (NSString *)hexStringTransWithSmallAndBig1:(NSString *)string;
//通过名称获取蓝牙mac
+ (NSString *)changeToMacAddress:(NSString *)nameStr;
+ (UInt64)coverFromHexStrToInt:(NSString *)hexStr;
+ (NSInteger)getDecimalByBinary:(NSString *)binary;
// 十进制转二进制
+ (NSString *)convertBinarySystemFromDecimalSystem:(NSString *)decimal;
+ (NSString *)getHexByBinary:(NSString *)binary;

+ (NSString *)getRandomNumber:(int)from to:(int)to;
+ (BOOL)isInvalidString:(NSString *)string;
+ (BOOL)pinkeyLegal:(NSString *)text;

+ (NSString *)base64UrlEncoder:(NSString *)str;
+ (NSString *)base64UrlDecoder:(NSString *)str;
@end
