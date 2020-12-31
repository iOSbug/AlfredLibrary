//
//  BridgeManager.h
//  AlfredBridgeManager
//
//  Created by Tianbao Wang on 2020/11/13.
//

#import <Foundation/Foundation.h>
#import <AlfredCore/AlfredCore.h>
NS_ASSUME_NONNULL_BEGIN

@interface BridgeManager : NSObject

/**
*    单例
*/
+ (instancetype)shared;



/**
 *    远程读取门锁设备密钥数据
 *
 *    @param     gatewayID          指定设备的SN
 *    @param     subdeviceID      网关下挂子设备的SN
 *    @param     mode                     子设备型号
 *    @param     codeType            key类别
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)getLockCodes:(NSString*)gatewayID
         subdeviceID:(NSString*)subdeviceID
                mode:(NSString*)mode
            codeType:(AlfredLockCodeType)codeType
             success:(nullable void (^)(NSArray<AlfredLockCode *>*))success
             failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;


/**
 *    远程添加门锁设备密钥
 *
 *    @param     gatewayID          指定设备的SN
 *    @param     subdeviceID      网关下挂子设备的SN
 *    @param     codeType            key类别
 *    @param     codeIndex          key编号
 *    @param     value                  输入值
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)addLockCode:(NSString*)gatewayID
        subdeviceID:(NSString*)subdeviceID
           codeType:(AlfredLockCodeType)codeType
          codeIndex:(int)codeIndex
              value:(NSString*)value
            success:(nullable void (^)(AlfredLockCode *))success
            failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;


/**
 *    远程删除门锁设备密钥
 *
 *    @param     gatewayID          指定设备的SN
 *    @param     subdeviceID      网关下挂子设备的SN
 *    @param     codeType            key类别
 *    @param     codeIndex          key编号
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)deleteLockCode:(NSString*)gatewayID
           subdeviceID:(NSString*)subdeviceID
              codeType:(AlfredLockCodeType)codeType
             codeIndex:(int)codeIndex
               success:(nullable void (^)(void))success
               failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;


/**
 *    远程读取门锁设备日志数据
 *
 *    @param     gatewayID          指定设备的SN
 *    @param     subdeviceID      网关下挂子设备的SN
 *    @param     mode                     子设备型号
 *    @param     page                   日志起始页序号，从1开始计数
 *    @param     limit                  每页的个数
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)getLockRecords:(NSString*)gatewayID
           subdeviceID:(NSString*)subdeviceID
                  mode:(NSString*)mode
                  page:(int)page
                 limit:(int)limit
               success:(nullable void (^)(NSArray<AlfredLockRecord *> *))success
               failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;



/**
 *    远程设置门锁设备基本参数
 *
 *    @param     gatewayID          指定设备的SN
 *    @param     subdeviceID      网关下挂子设备的SN
 *    @param     configID             参数设置ID
 *    @param     values                 参数设置值，根据参数设置ID不同，需调用者传入不同的值
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)setLockConfig:(NSString*)gatewayID
          subdeviceID:(NSString*)subdeviceID
             configID:(AlfredLockRequestConfig)configID
               values:(id)values
              success:(nullable void (^)(void))success
              failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;



/**
 *    远程修改门锁设备密钥时间段计划
 *
 *    @param     gatewayID          指定设备的SN
 *    @param     subdeviceID      网关下挂子设备的SN
 *    @param     codeType            key类别
 *    @param     codeIndex          key编号
 *    @param     startTime          开始时间
 *    @param     endTime              结束时间
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)setLockCodePeriodSchedule:(NSString*)gatewayID
                      subdeviceID:(NSString*)subdeviceID
                         codeType:(AlfredLockCodeType)codeType
                        codeIndex:(int)codeIndex
                        startTime:(NSString*)startTime
                          endTime:(NSString*)endTime
                          success:(nullable void (^)(void))success
                          failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;



/**
 *    远程修改门锁设备密钥周时间计划
 *
 *    @param     gatewayID          指定设备的SN
 *    @param     subdeviceID      网关下挂子设备的SN
 *    @param     codeType            key类别
 *    @param     codeIndex          key编号
 *    @param     weekdays              一周里的天数
 *    @param     startTime          开始时间
 *    @param     endTime              结束时间
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)setLockCodeWeeklySchedule:(NSString*)gatewayID
                      subdeviceID:(NSString*)subdeviceID
                         codeType:(AlfredLockCodeType)codeType
                        codeIndex:(int)codeIndex
                         weekdays:(NSArray *)weekdays
                        startTime:(NSString*)startTime
                          endTime:(NSString*)endTime
                          success:(nullable void (^)(void))success
                          failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;


/**
 *    远程删除门锁设备密钥时间计划
 *
 *    @param     gatewayID          指定设备的SN
 *    @param     subdeviceID      网关下挂子设备的SN
 *    @param     codeType            key类别
 *    @param     codeIndex          key编号
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)deleteLockCodeSchedule:(NSString*)gatewayID
                   subdeviceID:(NSString*)subdeviceID
                      codeType:(AlfredLockCodeType)codeType
                     codeIndex:(int)codeIndex
                       success:(nullable void (^)(void))success
                       failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;


/**
 *    远程门锁操作控制
 *
 *    @param     gatewayID          指定设备的SN
 *    @param     subdeviceID      网关下挂子设备的SN
 *    @param     operation         1是开门 0是关门
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)setLockOperation:(NSString*)gatewayID
             subdeviceID:(NSString*)subdeviceID
               operation:(AlfredLockOperation)operation
                 success:(nullable void (^)(void))success
                 failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;


/**
 *    关联子设备
 *
 *    @param     gatewayID          指定设备的SN
 *    @param     subdeviceID      网关下挂子设备的SN
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)pairSubdevice:(NSString*)gatewayID
          subdeviceID:(NSString*)subdeviceID
              success:(nullable void (^)(void))success
              failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;



/**
 *    解除关联子设备
 *
 *    @param     gatewayID          指定设备的SN
 *    @param     subdeviceID      网关下挂子设备的SN
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)unpairSubdevice:(NSString*)gatewayID
            subdeviceID:(NSString*)subdeviceID
                success:(nullable void (^)(void))success
                failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;



/**
 *    网关以及下挂子设备的状态
 *
 *    @param     bridges               网关数组
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)bridgeLockStatus:(NSArray*)bridges
                 success:(nullable void (^)(void))success
                 failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;



/**
 *    重启网关设备
 *
 *    @param     gatewayID          指定设备的SN
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)restart:(NSString*)gatewayID
        success:(nullable void (^)(void))success
        failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;

/**
 *    恢复网关设备出厂设置
 *
 *    @param     gatewayID          指定设备的SN
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)restore:(NSString*)gatewayID
        success:(nullable void (^)(void))success
        failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;


/**
 *    获取网关设备时区列表
 *
 *    @param     gatewayID          指定设备的SN
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)getTimezones:(NSString*)gatewayID
             success:(nullable void (^)(AlfredTimeZone *))success
             failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;


/**
 *    设置网关设备时区
 *
 *    @param     gatewayID          指定设备的SN
 *    @param     tzName                时区名称
 *    @param     tzValue              时区内部值
 *    @param     tzDistrict       时区内部别名
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)restart:(NSString*)gatewayID
         tzName:(NSString *)tzName
        tzValue:(NSString *)tzValue
     tzDistrict:(NSString *)tzDistrict
        success:(nullable void (^)(void))success
        failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;

@end

NS_ASSUME_NONNULL_END
