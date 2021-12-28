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

typedef enum {
    LOW,
    HIGH
}VerifyLevel;


typedef enum {
    DB1,
    DB2,
    ML2
}DeviceMode;

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
 *    读取门锁设备密钥数据，因密钥存储的安全机制限制，仅能提取到已存在的密钥序号和时间计划，不包含密钥内容。
 *
 *    @param     deviceId 指定门锁对象SN
 *    @param     paramStr    URLSAFE_BASE64({password1}.{password2}.{systemId}.{expire_ts}) +"." +URLSAFE_BASE64({verify})
 *    @param     codeType 密钥类型
 *    @param     callback 回调

 */
- (void)getLockCodes:(NSString *)deviceId
            paramStr:(NSString *)paramStr
            codeType:(AlfredLockCodeType)codeType
            callback:(AlfredBLECallback)callback;


/**
 *    添加密钥
 *
 *    @param     deviceId 指定门锁对象SN
 *    @param     paramStr    URLSAFE_BASE64({password1}.{password2}.{systemId}.{expire_ts}) +"." +URLSAFE_BASE64({verify})
 *    @param     codeType 密钥类型
 *    @param     codeIndex 密钥编号
 *    @param     value 密钥内容
 *    @param     callback 回调

 */
- (void)addLockCode:(NSString *)deviceId
           paramStr:(NSString *)paramStr
           codeType:(AlfredLockCodeType)codeType
          codeIndex:(int)codeIndex
              value:(NSString *)value
           callback:(AlfredBLECallback)callback;


/**
 *    删除密钥
 *
 *    @param     deviceId 指定门锁对象SN
 *    @param     paramStr    URLSAFE_BASE64({password1}.{password2}.{systemId}.{expire_ts}) +"." +URLSAFE_BASE64({verify})
 *    @param     codeType 密钥类型
 *    @param     codeIndex 密钥编号
 *    @param     callback 回调

 */
- (void)deleteLockCode:(NSString *)deviceId
              paramStr:(NSString *)paramStr
              codeType:(AlfredLockCodeType)codeType
             codeIndex:(int)codeIndex
              callback:(AlfredBLECallback)callback;


/**
 *    修改密钥时间段时间计划
 *
 *    @param     deviceId 指定门锁对象SN
 *    @param     paramStr    URLSAFE_BASE64({password1}.{password2}.{systemId}.{expire_ts}) +"." +URLSAFE_BASE64({verify})
 *    @param     codeType 密钥类型
 *    @param     codeIndex 密钥编号
 *    @param     startTime 时间计划起始时间，Unix时间戳（自1970年1月1日0时起的秒数）
 *    @param     endTime  时间计划结束时间，Unix时间戳（自1970年1月1日0时起的秒数）
 *    @param     timezone  主人绑定门锁的时区(device.extend.timezone)
 *    @param     callback 回调

 */
- (void)setLockCodeSchedule:(NSString *)deviceId
                   paramStr:(NSString *)paramStr
                   codeType:(AlfredLockCodeType)codeType
                  codeIndex:(int)codeIndex
                  startTime:(NSString *)startTime
                    endTime:(NSString *)endTime
                   timezone:(NSString *)timezone
                   callback:(AlfredBLECallback)callback;


/**
 *    修改密钥周时间计划
 *
 *    @param     deviceId 指定门锁对象SN
 *    @param     paramStr    URLSAFE_BASE64({password1}.{password2}.{systemId}.{expire_ts}) +"." +URLSAFE_BASE64({verify})
 *    @param     codeType 密钥类型
 *    @param     codeIndex 密钥编号
 *    @param     startTime 时间计划起始时间，HH:mm
 *    @param     endTime  时间计划结束时间，HH:mm
 *    @param     weekdays  一周内时间计划生效的天数组合，“Sunday，Monday，Tuesday...” 即"1,1,1,0,0,0,0"
 *    @param     callback 回调

 */
- (void)setLockCodeSchedule:(NSString *)deviceId
                   paramStr:(NSString *)paramStr
                   codeType:(AlfredLockCodeType)codeType
                  codeIndex:(int)codeIndex
                  startTime:(NSString *)startTime
                    endTime:(NSString *)endTime
                   weekdays:(NSArray *)weekdays
                   callback:(AlfredBLECallback)callback;


/**
 *    删除密钥的时间计划
 *
 *    @param     deviceId 指定门锁对象SN
 *    @param     paramStr    URLSAFE_BASE64({password1}.{password2}.{systemId}.{expire_ts}) +"." +URLSAFE_BASE64({verify})
 *    @param     codeType 密钥类型
 *    @param     codeIndex 密钥编号
 *    @param     callback 回调

 */
- (void)deleteLockCodeSchedule:(NSString *)deviceId
                      paramStr:(NSString *)paramStr
                      codeType:(AlfredLockCodeType)codeType
                     codeIndex:(int)codeIndex
                      callback:(AlfredBLECallback)callback;



/**
 *    同步门锁操作日志数据
 从门锁设备中同步本地的操作日志数据；
 日志总是将最新的记录插入到序列最前面，而不是顺序记录到旧记录后面；
 在日志容量达到上限后，丢弃生成时间最久的旧日志数据。
 *
 *    @param     deviceId 指定门锁对象SN
 *    @param     paramStr    URLSAFE_BASE64({password1}.{password2}.{systemId}.{expire_ts}) +"." +URLSAFE_BASE64({verify})
 *    @param     callback 回调

 */
- (void)syncRecords:(NSString *)deviceId
           paramStr:(NSString *)paramStr
               page:(int)page
              limit:(int)limit
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


/**
 *   设置门锁型号（类初始化时必须传入)
 */
- (void)setDeviceMode:(DeviceMode)mode;


/**
 *   校验等级开关设置
 */
- (void)setVerifyLevel:(VerifyLevel)level;

/**
 *   校验等级开关获取
 */
- (VerifyLevel)getVerifyLevel;
@end

NS_ASSUME_NONNULL_END
