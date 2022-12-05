//
//  NSString+Data.h
//  Alfred
//
//  Created by tianbao on 2018/6/8.
//  Copyright © 2018年 tianbao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSStringToDataUtils: NSObject

+ (NSData *)convertHexStrToData:(NSString *)string;
@end
