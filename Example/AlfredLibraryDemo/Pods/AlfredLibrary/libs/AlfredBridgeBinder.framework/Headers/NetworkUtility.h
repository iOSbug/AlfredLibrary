//
//  NetworkUtility.h
//  HomeCare
//
//  Created by Lawrence on 13-10-17.
//  Copyright (c) 2013年 ztesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkUtility : NSObject

+ (NSString *)getIPAddress;
+ (NSString *)getGatewayIP;
+ (NSString *)getGatewayMAC;
+ (NSDictionary *)fetchSSIDInfo;

@end
