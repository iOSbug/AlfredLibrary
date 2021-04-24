//
//  LockManager.h
//  AlfredLockManager
//
//  Created by Tianbao Wang on 2020/11/13.
//

#import <Foundation/Foundation.h>
#import <AlfredCore/AlfredCore.h>
#import <AlfredCore/AlfredCore-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@interface LockManager : NSObject


/**
*    单例
*/
+ (instancetype)shared;


/**
 *    建立蓝牙通讯连接
 *
 *    @param     deviceId 指定门锁对象SN
 *    @param     connectCallback 连接状态回调
 *    @param     notifyCallback 门锁状态变化通知
 */
- (void)access:(NSString *)deviceId
connectCallbak:(nullable void (^)(AlfredLock *device, AlfredLockConnectState state, AlfredError error))connectCallback
notifyCallback:(nullable void (^)(AlfredLock *device, AlfredLockRecord *record))notifyCallback;

/**
 *    获取当前请求接入设备的详细数据

 */
- (AlfredLock *)getAccessDevice;

/**
 *    读取门锁设备基本参数信息，需先接入鉴权成功
 *
 *    @param     deviceId 指定门锁对象SN
 *    @param     callback 回调

 */
- (void)getConfig:(NSString *)deviceId
         callback:(AlfredBLECallback)callback;


/**
 *    读取门锁设备密钥数据，因密钥存储的安全机制限制，仅能提取到已存在的密钥序号和时间计划，不包含密钥内容。
 *
 *    @param     deviceId 指定门锁对象SN
 *    @param     codeType 密钥类型
 *    @param     callback 回调

 */
- (void)getLockCodes:(NSString *)deviceId
            codeType:(AlfredLockCodeType)codeType
            callback:(AlfredBLECallback)callback;

/**
 *    添加密钥
 *
 *    @param     deviceId 指定门锁对象SN
 *    @param     codeType 密钥类型
 *    @param     codeIndex 密钥编号
 *    @param     value 密钥内容
 *    @param     callback 回调

 */
- (void)addLockCode:(NSString *)deviceId
           codeType:(AlfredLockCodeType)codeType
          codeIndex:(int)codeIndex
              value:(NSString *)value
         callback:(AlfredBLECallback)callback;

/**
 *    删除密钥
 *
 *    @param     deviceId 指定门锁对象SN
 *    @param     codeType 密钥类型
 *    @param     codeIndex 密钥编号
 *    @param     callback 回调

 */
- (void)deleteLockCode:(NSString *)deviceId
              codeType:(AlfredLockCodeType)codeType
             codeIndex:(int)codeIndex
              callback:(AlfredBLECallback)callback;


/**
 *    修改密钥时间段时间计划
 *
 *    @param     deviceId 指定门锁对象SN
 *    @param     codeType 密钥类型
 *    @param     codeIndex 密钥编号
 *    @param     startTime 时间计划起始时间，Unix时间戳（自1970年1月1日0时起的秒数）
 *    @param     endTime  时间计划结束时间，Unix时间戳（自1970年1月1日0时起的秒数）
 *    @param     callback 回调

 */
- (void)setLockCodeSchedule:(NSString *)deviceId
                   codeType:(AlfredLockCodeType)codeType
                  codeIndex:(int)codeIndex
                  startTime:(NSString *)startTime
                    endTime:(NSString *)endTime
                   callback:(AlfredBLECallback)callback;

/**
 *    修改密钥周时间计划
 *
 *    @param     deviceId 指定门锁对象SN
 *    @param     codeType 密钥类型
 *    @param     codeIndex 密钥编号
 *    @param     startTime 时间计划起始时间，HH:mm
 *    @param     endTime  时间计划结束时间，HH:mm
 *    @param     weekdays  一周内时间计划生效的天数组合，“Sunday，Monday，Tuesday...” 即"1,1,1,0,0,0,0"
 *    @param     callback 回调

 */
- (void)setLockCodeSchedule:(NSString *)deviceId
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
 *    @param     codeType 密钥类型
 *    @param     codeIndex 密钥编号
 *    @param     callback 回调

 */
- (void)deleteLockCodeSchedule:(NSString *)deviceId
                      codeType:(AlfredLockCodeType)codeType
                     codeIndex:(int)codeIndex
                      callback:(AlfredBLECallback)callback;


/**
 *    门锁操作控制
 *
 *    @param     deviceId 指定门锁对象SN
 *    @param     operation 开关门
 *    @param     callback 回调

 */
- (void)setOperation:(NSString *)deviceId
           operation:(AlfredLockOperation)operation
            callback:(AlfredBLECallback)callback;


/**
 *    按键操作控制
 *
 *    @param     deviceId 指定门锁对象SN
 *    @param     operation 开关门
 *    @param     callback 回调

 */
- (void)setPinOperation:(NSString *)deviceId
              operation:(AlfredLockOperation)operation
            controlType:(LockControlType)controlType
                   code:(NSString *)code
               callback:(AlfredBLECallback)callback;


/**
 *    蓝牙开关门
 *
 *    @param     deviceId 指定门锁对象SN
 *    @param     operation 开关门
 *    @param     callback 回调

 */
- (void)openDoor:(NSString *)deviceId
       password1:(NSString *)password1
       password2:(NSString *)password2
        systemId:(NSString *)systemId
       operation:(AlfredLockOperation)operation
        callback:(AlfredBLECallback)callback;

/**
 设置门锁基本参数
 
 @param deviceId 指定门锁对象SN
 @param configID 参数设置ID
 @param values 参数设置值，根据参数设置ID不同，需调用者传入不同的值
 
             'LockRequestConfig_Language'
             vaules: AlfredLockLanguage  语言类型参数
                                 zh, //汉语
                                 en, //英语
                                 fr, //法语
                                 pt, //葡萄牙语
                                 es, //西班牙语
 
             'LockRequestConfig_Voice'
             vaules: AlfredLockVoice   0,1,2音量参数
 
             'LockRequestConfig_Time'
             vaules: NSString unix时间戳
 
             'LockRequestConfig_Auto'
             vaules: NSString   1为启用，0为关闭
 
             'LockRequestConfig_InsideDeadLock'
             vaules: NSString   1为启用，0为关闭
  
             'LockRequestConfig_AwayMode'
             vaules: NSString   1为启用，0为关闭

             'LockRequestConfig_PowerSafe'
             vaules: NSString    1为启用，0为关闭
 
             'LockRequestConfig_MasterPinCode'
             vaules: NSString   新管理员密码
 
 @param callback 连接状态回调 AlfredBLECallback<id, AlfredError>
 
 */
- (void)setConfig:(NSString *)deviceId
         configID:(AlfredLockRequestConfig)configID
           values:(id)values
         callback:(AlfredBLECallback)callback;


/**
 *    同步门锁操作日志数据，回调返回本次操作同步了多少条日志到云端，完整的日志数据可通过NetManager接口中的fetchLockRecords方法，从云端查询；
 根据云端最新的日志数据记录时间，作为起始时间标识，从门锁设备中同步本地的操作日志数据，并同步上传到云端；
 日志总是将最新的记录插入到序列最前面，而不是顺序记录到旧记录后面；
 在日志容量达到上限后，丢弃生成时间最久的旧日志数据。
 *
 *    @param     deviceId 指定门锁对象SN
 *    @param     callback 回调

 */
- (void)syncRecords:(NSString *)deviceId
               page:(int)page
              limit:(int)limit
           callback:(AlfredBLECallback)callback;

/**
 *   主动断开指定门锁的蓝牙通讯连接
 */
- (void)disconnect;
@end

NS_ASSUME_NONNULL_END
