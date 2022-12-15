//
//  NSData+String.h
//  Alfred
//
//  Created by tianbao on 2018/6/8.
//  Copyright © 2018年 tianbao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDataToStringUtils: NSObject

//data转16进制字符串
+ (NSString*)cDataToHexStr:(NSData *)data;

+ (NSString *)utf8String:(NSData *)data;
@end
