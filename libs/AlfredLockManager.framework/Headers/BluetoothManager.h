//
//  ILockAPI.h
//  AlfredLibrary
//
//  Created by tianbao on 2019/4/8.
//  Copyright © 2019 tianbao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlfredCore/AlfredCore.h>

typedef void(^BleOpendoorRecordBlock)(NSArray * _Nullable records, int totalCount); //所有开门消息

NS_ASSUME_NONNULL_BEGIN

@interface BluetoothManager : NSObject

@property (nonatomic, assign) int maxPinPwds; //pin的最大个数，默认是10个
@property (nonatomic, strong) NSMutableArray *existPinPwds;
@property (nonatomic, strong) NSMutableArray *unexistPinPwds;
@property (nonatomic, strong) NSMutableArray *existTouchPwds; //已存在的touchkeys
@property (nonatomic, strong) NSMutableArray *unexistTouchPwds;
@property (nonatomic, strong) NSMutableArray *existCardPwds; //已存在的card
@property (nonatomic, strong) NSMutableArray *unexistCardPwds;

@property (nonatomic, assign, readonly) BOOL systemBLEStatus; //手机系统蓝牙是否开启

/**
 SDK 实例化
 */
+ (instancetype)shared;


/**
 搜索蓝牙设备
 
 @param timeout 搜索超时时间
 @param name 通过蓝牙前缀名称过滤，不传值默认过滤出“ALF”，"Alfred"
 @param callback AlfredCallback<Array<SearchDevice>, AlfredError>
 
 */
- (void)searchDeviceList:(int)timeout
              blePreName:(NSString *)name
                callback:(AlfredBLECallback)callback;



/**
 门锁注册
 
 @param deviceId        门锁SN
 @param uuid                门锁蓝牙产生的uuid
 @param password1     门锁pwd1
 @param masterPincode 指定门锁的当前管理员密码
 @param mode                 门锁型号
 @param callback  AlfredBLECallback
 操作结果回调，门锁生成的唯一鉴权数据以AlfredLockAccessData返回，调用者需保存此结果，用于后续的接入鉴权

 */
- (void)registerDevice:(NSString *)deviceId
               bleUuid:(NSString *)uuid
             password1:(NSString *)password1
                  mode:(NSString *)mode
         masterPincode:(NSString *)masterPincode
              callback:(AlfredBLECallback)callback;


/**
 建立蓝牙通讯连接
 
 @param device 指定门锁对象，必须包含完整的设备产品数据(deviceID, password1, password2, systemid)，并且包含正确的鉴权数据内容，否则将无法正常接入
 @param connectCallbak 连接状态回调
 @param notifyCallback NotifyCallback<AlfredLock *device, AlfredLockInfoStatus status>
 
 */
- (void)access:(AlfredLock *)device
       timeout:(int)timeout
connectCallbak:(nullable void (^)(AlfredLock *device, AlfredLockConnectState state, AlfredError error))connectCallbak
notifyCallback:(nullable void (^)(AlfredLock *device, AlfredLockRecord *__nullable record))notifyCallback;


/**
 主动断开指定门锁的蓝牙通讯连接
 
 */
- (void)disconnect;



/**
 获得当前Library连接管理中的门锁对象；若无蓝牙连接，则会返回空对象
 
 */
- (AlfredLock *)getConnectedDevice;


/**
 读取门锁基本信息
 
 */
- (void)getLockInfo:(AlfredBLECallback)callback;


/**
 读取指定门锁的基本参数信息，需先接入鉴权成功
 
 @param device 指定门锁对象
 @param callback 连接状态回调 AlfredCallback<AlfredLockInfo, AlfredError>
 
 */
- (void)getConfig:(AlfredLock *)device
         callback:(AlfredBLECallback)callback;



/**
 设置门锁基本参数
 
 @param device 指定门锁对象
 @param configID 参数设置ID
 @param value 参数设置值，根据参数设置ID不同，需调用者传入不同的值
 
                'INSIDE_DEAD_LOCK'
                vaules: NSString   1为启用，0为关闭
 
                 'AUTO_LOCK'
                 vaules: NSString   1为启用，0为关闭
 
                 'AWAY_MODE'
                 vaules: NSString   1为启用自动上锁，0为关闭自动上锁

                 'POWER_SAVE'
                 vaules: NSString    1为启用自动上锁，0为关闭自动上锁
 
                 'MASTER_PIN_CODE'
                 vaules: NSString   新管理员密码
 
                 'VOICE'
                 vaules: NSString   0,1,2音量参数
 
                 'LANGUAGE'
                 vaules: NSString  语言类型参数
                                     zh, //汉语
                                     en, //英语
                                     fr, //法语
                                     pt, //葡萄牙语
                                     es, //西班牙语
 
                 'LOCK_TIME'
                 vaules: NSString unix时间戳
 
 @param callback 连接状态回调 AlfredCallback<Void, AlfredError>
 
 */
- (void)setConfig:(AlfredLock *)device
         configID:(AlfredLockRequestConfig)configID
            value:(id)value
         callback:(AlfredBLECallback)callback;


/**
 读取门锁操作日志
 
 @param callback AlfredCallback<AlfredLockRecords, AlfredError>
 Alfred门锁内最多可记录200条操作日志；
 日志总是将最新的记录插入到序列最前面，而不是顺序记录到旧记录后面；并且在200条日志容量达到上限后，丢弃最久的旧日志数据；
 读取时将以分页方式提供数据，每页包含20条日志数据；
 目前仅记录AlfredLockRecord.OPERATION类型的日志；
 目前仅记录AlfredLockRecord.OPERATION_UNLOCK的操作
 
 */
- (void)getDBHistoryRecoryOrder:(int)start endIndex:(int)end callback:(BleOpendoorRecordBlock)callback;
- (void)getML2AllLockRecord:(int)type startIndex:(int)start endIndex:(int)end callback:(BleOpendoorRecordBlock)callback;


/**
 门锁操作控制，目前仅支持开锁和关锁的操作
 
 @param device 指定门锁对象
 @param operation 门锁操作
 @param callback AlfredCallback<Void, AlfredError> 操作结果回调
 
 */
- (void)setOperation:(AlfredLock *)device
           operation:(AlfredLockOperation)operation
            callback:(AlfredBLECallback)callback;


/**
 门锁操作控制，使用按键开锁和关锁的操作
 
 @param device 指定门锁对象
 @param operation 门锁操作
 @param callback AlfredCallback<Void, AlfredError> 操作结果回调
 
 */
- (void)setPinOperation:(AlfredLock *)device
              operation:(AlfredLockOperation)operation
            controlType:(LockControlType)controlType
                   code:(NSString *)code
               callback:(AlfredBLECallback)callback;



/**
 读取门锁已存在的密钥列表
 
 @param device 指定门锁对象
 @param callback AlfredCallback<Array<Int>, AlfredError> 操作结果回调
 因PIN密钥存储的安全机制限制，仅能提取到已存在的密钥序号，不包含密钥内容。
 
 */
- (void)getLockCodes:(AlfredLock *)device
            codeType:(AlfredLockCodeType)codeType
            callback:(AlfredBLECallback)callback;



/**
 添加PIN密钥
 
 @param device 指定门锁对象
 @param codeType  钥匙类型
 @param codeIndex 钥匙编号
 @param value PIN密钥内容，长度4~10位的纯数字，不能包含有4位及以上的连续或重复数字
 @param callback AlfredCallback<Void, AlfredError> 操作结果回调
 
 */
- (void)addLockCode:(AlfredLock *)device
           codeType:(AlfredLockCodeType)codeType
          codeIndex:(int)codeIndex
              value:(NSString *)value
           callback:(AlfredBLECallback)callback;



/**
 删除PIN密钥
 
 @param device 指定门锁对象
 @param codeType  钥匙类型
 @param codeIndex 钥匙编号
 @param callback AlfredCallback<Void, AlfredError> 操作结果回调
 
 */
- (void)deleteLockCode:(AlfredLock *)device
              codeType:(AlfredLockCodeType)codeType
             codeIndex:(int)codeIndex
              callback:(AlfredBLECallback)callback;


/**
 *    修改密钥时间段时间计划
 *
 *    @param     device 指定门锁对象
 *    @param     codeType 密钥类型
 *    @param     codeIndex 密钥编号
 *    @param     startTime 时间计划起始时间，Unix时间戳（自1970年1月1日0时起的秒数）
 *    @param     endTime  时间计划结束时间，Unix时间戳（自1970年1月1日0时起的秒数）
 *    @param     callback 回调

 */
- (void)setLockCodeSchedule:(AlfredLock *)device
                 scheduleId:(int)scheduleId
                   codeType:(AlfredLockCodeType)codeType
                  codeIndex:(int)codeIndex
                  startTime:(NSString *)startTime
                    endTime:(NSString *)endTime
                   callback:(AlfredBLECallback)callback;

/**
 *    修改密钥周时间计划
 *
 *    @param     device 指定门锁对象
 *    @param     codeType 密钥类型
 *    @param     codeIndex 密钥编号
 *    @param     startTime 时间计划起始时间，HH:mm
 *    @param     endTime  时间计划结束时间，HH:mm
 *    @param     weekdays  一周内时间计划生效的天数组合，“Sunday，Monday，Tuesday...” 即"1,1,1,0,0,0,0"
 *    @param     callback 回调

 */
- (void)setLockCodeSchedule:(AlfredLock *)device
                 scheduleId:(int)scheduleId
                   codeType:(AlfredLockCodeType)codeType
                  codeIndex:(int)codeIndex
                  startTime:(NSString *)startTime
                    endTime:(NSString *)endTime
                   weekdays:(NSString *)weekdays
                   callback:(AlfredBLECallback)callback;


/**
 *    删除密钥的时间计划
 *
 *    @param     device 指定门锁对象
 *    @param     lockCode 密钥
 *    @param     callback 回调

 */
- (void)deleteLockCodeSchedule:(AlfredLock *)device
                      lockCode:(AlfredLockCode *)lockCode
                      callback:(AlfredBLECallback)callback;
@end

NS_ASSUME_NONNULL_END
