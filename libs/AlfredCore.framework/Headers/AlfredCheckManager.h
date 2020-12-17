//
//  AlfredCheckManager.h
//  AlfredCore
//
//  Created by Tianbao Wang on 2020/11/17.
//

#import <Foundation/Foundation.h>
#import "AlfredGerneralDefinition.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlfredCheckManager : NSObject

@property(nonatomic) BOOL sdkInitState;
@property(nonatomic) BOOL sdkSignInState;
@property(nonatomic) AlfredError sdkinitErr;

+ (instancetype)shared;

///判定sdk有没有初始化和注册鉴权
- (BOOL)checkSDKAuthSuccess:(nullable void (^)(void))success
                    failure:(nullable AlfredErrorCallback)failure;
@end

NS_ASSUME_NONNULL_END
