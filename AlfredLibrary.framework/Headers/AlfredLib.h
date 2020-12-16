//
//  AlfredLib.h
//  AlfredLibrary
//
//  Created by Tianbao Wang on 2020/11/12.
//

#import <Foundation/Foundation.h>
#import <AlfredCore/AlfredCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlfredLib : NSObject

/**
 *    核心库必须调用的方法，通过SDK发布方提供的鉴权数据正常完成初始化
 *
 *    @param     securityID          SDK库鉴权ID
 *    @param     securityKey       SDK库鉴权码
 *    @param     success                成功 回调
 *    @param     failure                失败回调
 */
+ (void)asyncInit:(NSString *)securityID
      securityKey:(NSString *)securityKey
          success:(nullable void (^)(void))success
          failure:(nullable AlfredErrorCallback)failure;


/**
 *    核心库必须调用的方法，用户必须用与SDK发布方协商生成的合法allyToken进行注册鉴权，才能正常使用库的其他功能。
 *
 *    @param     allyName       用户名
 *    @param     allyToken     用户鉴权令牌
 *    @param     success          成功 回调
 *    @param     failure          失败回调
 */
+ (void)signIn:(NSString *)allyName
     allyToken:(NSString *)allyToken
       success:(nullable void (^)(void))success
       failure:(nullable AlfredErrorCallback)failure;


/**
 *    日志显示
 */
+ (void)setDeubugLog:(BOOL)open;

@end

NS_ASSUME_NONNULL_END
