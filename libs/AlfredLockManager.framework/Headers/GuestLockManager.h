//
//  GuestLockManager.h
//  AlfredLockManager
//
//  Created by buzhuangle on 2021/4/23.
//

#import <Foundation/Foundation.h>
#import <AlfredCore/AlfredCore.h>
#import <AlfredCore/AlfredCore-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@interface GuestLockManager : NSObject

/**
*    单例
*/
+ (instancetype)shared;


/**
 *    建立蓝牙通讯连接
 *    @param     deviceId 指定门锁对象SN
 *    @param     paramStr    URLSAFE_BASE64({password1}.{password2}.{systemId}.{expire_ts}) +"." +URLSAFE_BASE64({verify})
 *    @param     connectCallback 连接状态回调
 *    @param     notifyCallback 门锁状态变化通知
 */
- (void)access:(NSString *)deviceId
      paramStr:(NSString *)paramStr
       timeout:(int)timeout
connectCallbak:(nullable void (^)(AlfredLock *_Nullable device, AlfredLockConnectState state, AlfredError error))connectCallback
notifyCallback:(nullable void (^)(AlfredLock *_Nullable device, AlfredLockRecord *record))notifyCallback;


/**
 *    门锁操作控制
 *    @param     deviceId 指定门锁对象SN
 *    @param     paramStr URLSAFE_BASE64({password1}.{password2}.{systemId}.{expire_ts}) +"." +URLSAFE_BASE64({verify})
 *    @param     operation 开关门
 *    @param     callback 回调

 */
- (void)setOperation:(NSString *)deviceId
            paramStr:(NSString *)paramStr
           operation:(AlfredLockOperation)operation
            callback:(AlfredBLECallback)callback;


/**
 *   主动断开指定门锁的蓝牙通讯连接
 */
- (void)disconnect;


/**
 *    获取客人门锁数据
 *    @param     deviceId 指定门锁对象SN
 *    @param     paramStr URLSAFE_BASE64({password1}.{password2}.{systemId}.{expire_ts}) +"." +URLSAFE_BASE64({verify})

 */
- (nullable AlfredLock *)getGuestDevice:(NSString *)deviceId
                               paramStr:(NSString *)paramStr;
@end

NS_ASSUME_NONNULL_END
