//
//  NetManager.h
//  AlfredNetManager
//
//  Created by Tianbao Wang on 2020/11/13.
//

#import <Foundation/Foundation.h>
#import <AlfredCore/AlfredCore.h>
#import <AlfredCore/AlfredCore-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetManager : NSObject

/**
*    单例
*/
+ (instancetype)shared;


/**
 *    获取当前账户下所有设备的列表及详细信息数据
 *
 *    @param     success              成功回调 AlfredDevices
 *    @param     failure              失败回调

 */
- (void)queryDevices:(nullable void (^)(AlfredDevices *alfredDevices))success
             failure:(nullable void (^)(NetErrorModel *error))failure;



/**
 *    获取当前账户下指定门锁设备的详细信息数据
 *
 *    @param     deviceID          指定设备的SN
 *    @param     deviceType       指定设备的类型
 *    @param     success              成功回调 AlfredDeviceBindStatus
 *    @param     failure              失败回调

 */
- (void)fetchDevice:(NSString*)deviceID
         deviceType:(AlfredDeviceType)deviceType
            success:(nullable void (^)(AlfredLock *device))success
            failure:(nullable void (^)(NetErrorModel *error))failure;



/**
 *    获取当前账户下指定网关设备的详细信息数据
 *
 *    @param     deviceID          指定设备的SN
 *    @param     success              成功回调 AlfredDeviceBindStatus
 *    @param     failure              失败回调

 */
- (void)fetchBridge:(NSString*)deviceID
            success:(nullable void (^)(AlfredBridge *device))success
            failure:(nullable void (^)(NetErrorModel *error))failure;

/**
 *    更改当前账户下指定设备的别名
 *
 *    @param     deviceID          指定设备的SN
 *    @param     deviceType       指定设备的类型
 *    @param     alias                 别名
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)renameDevice:(NSString*)deviceID
           deviceDid:(NSString *)deviceDid
          deviceType:(AlfredDeviceType)deviceType
               alias:(NSString*)alias
             success:(nullable void (^)(void))success
             failure:(nullable void (^)(NetErrorModel *error))failure;


/**
 *    解除当前账户下指定设备的绑定状态
 *
 *    @param     deviceID          指定设备的SN
 *    @param     deviceType       指定设备的类型
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)unbindDevice:(NSString*)deviceID
          deviceType:(AlfredDeviceType)deviceType
             success:(nullable void (^)(void))success
             failure:(nullable void (^)(NetErrorModel *error))failure;


/**
 *    获取标准时间戳
 *    @param     success              成功回调NSString
 *    @param     failure              失败回调

 */
- (void)timestamp:(nullable void (^)(NSString *timestamp))success
          failure:(nullable void (^)(NetErrorModel *error))failure;

@end

NS_ASSUME_NONNULL_END

#pragma mark - LockBinder

@interface NetManager(AlfredLockBinder)

/**
 *    搜索设备的绑定状态
 *
 *    @param     deviceID          指定设备的SN
 *    @param     deviceType       指定设备的类型
 *    @param     success              成功回调 AlfredDeviceBindStatus
 *    @param     failure              失败回调

 */
- (void)checkDeviceBindStatus:(NSString*_Nullable)deviceID
                   deviceType:(AlfredDeviceType)deviceType
                      success:(nullable void (^)(AlfredDeviceBindStatus * _Nullable bindStatus))success
                      failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;


/**
 *    搜索设备的详细数据（蓝牙门锁）
 *
 *    @param     deviceID          指定设备的SN
 *    @param     success             成功回调 AlfredLock
 *    @param     failure             失败回调

 */
- (void)getDeviceBaseInfo:(NSString*_Nullable)deviceID
                  success:(nullable void (^)(AlfredLock * _Nullable device))success
                  failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;


/**
 *    门锁绑定
 *
 *    @param     deviceID          指定设备的SN
 *    @param     type                   设备类型
 *    @param     success              成功回调 AlfredLock
 *    @param     failure              失败回调

 */
- (void)lockBind:(NSString*_Nullable)deviceID
            type:(NSString*_Nullable)type
         success:(nullable void (^)(AlfredLock * _Nullable device))success
         failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;

/**
 *    门锁绑定（uac）
 *
 *    @param     deviceID          指定设备的SN
 *    @param     mac                     mac 地址
 *    @param     type                   设备类型
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)lockBindUac:(NSString*_Nullable)deviceID
                mac:(NSString*_Nullable)mac
               type:(NSString*_Nullable)type
            success:(nullable void (^)(void))success
            failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;

/**
 *    门锁详情更新
 *
 *    @param     params               字典
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)lockPostinfo:(NSDictionary*_Nullable)params
             success:(nullable void (^)(void))success
             failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;


/**
 *    更新蓝牙uuid
 *
 *    @param     deviceDid           指定设备的SN
 *    @param     bluuid                 门锁蓝牙产生的uuid
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)updateBluetoothUuid:(NSString*_Nullable)deviceDid
                     bluuid:(NSString*_Nullable)bluuid
                    success:(nullable void (^)(void))success
                    failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;


/**
 *    门锁keys更新
 *
 *    @param     params               字典
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)lockPostkeys:(NSDictionary*_Nullable)params
             success:(nullable void (^)(void))success
             failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;

/**
 *    门锁时间计划更新
 *
 *    @param     params                字典
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)lockkeyschedule:(NSDictionary*_Nullable)params
                success:(nullable void (^)(void))success
                failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;


@end


@interface NetManager(AlfredLockManager)

/**
 *    门锁记录
 *
 *    @param     deviceID          指定设备的SN
 *    @param     limit                   每页个数
 *    @param     page                     页数
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)fetchLockRecords:(NSString*_Nullable)deviceID
                   limit:(NSString*_Nullable)limit
                    page:(NSString *_Nullable)page
                 success:(nullable void (^)(AlfredLockRecords * _Nullable records))success
                 failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;


/**
 *    APP蓝牙手机开锁日志上报
 *
 *    @param     params                字典
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)updateLockRecords:(NSDictionary*_Nullable)params
                  success:(nullable void (^)(void))success
                  failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;
@end

#pragma mark - Gateway

@interface NetManager(AlfredBridge)

/**
 *    获取设备入网的token
 *
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)getDevicePairToken:(nullable void (^)(DeviceToken * _Nullable deviceToken))success
                   failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;



/**
 *    获取设备入网的url
 *

 */
- (NSString *_Nullable)getAlfredBridgePairUrl;


/**
 *    查询网关是否绑定成功
 *
 *    @param     params          字典
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)gatewayCheckBind:(NSDictionary*_Nullable)params
                 success:(nullable void (^)(AlfredBridgeBindStatus * _Nullable bindResult))success
                 failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;


/**
 *    查询网关已经下挂设备的在线状态
 *
 *    @param     params          字典
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)gatewayStatus:(NSDictionary*_Nullable)params
              success:(nullable void (^)(AlfredBridgeLockStatusListModel * _Nullable statusList))success
              failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;

/**
 *    通过主机下发门锁指令(开关门等)
 *
 *    @param     params          字典
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)gatewayTransparent:(NSDictionary*_Nullable)params
                   success:(nullable void (^)(AlfredBridgeOperate * _Nullable bridgeOperateResult))success
                   failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;


/**
 *    通过主机下发门锁指令（查询结果）
 *
 *    @param     params          字典
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)gatewayTransparentResult:(NSDictionary*_Nullable)params
                         success:(nullable void (^)(AlfredBridgeOperate * _Nullable bridgeOperateResult))success
                         failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;



/**
 *    查询门锁是否可以绑定
 *
 *    @param     params              字典
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)gatewayQueryBindReq:(NSDictionary*_Nullable)params
                    success:(nullable void (^)(AlfredBridgePair * _Nullable bridgePairResult))success
                    failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;

/**
 *    获取门锁是否绑定结果
 *
 *    @param     params              字典
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)gatewayQueryBindRes:(NSDictionary*_Nullable)params
                    success:(nullable void (^)(AlfredBridgePair * _Nullable bridgePairResult))success
                    failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;


/**
 *    uac网关绑定子设备
 *
 *    @param     params              字典
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)gatewayBindUacLock:(NSDictionary*_Nullable)params
                   success:(nullable void (^)(void))success
                   failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;


/**
 *    网关绑定门锁
 *
 *    @param     params              字典
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)gatewayBindLock:(NSDictionary*_Nullable)params
                success:(nullable void (^)(AlfredBridgePair * _Nullable bridgePairResult))success
                failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;



/**
 *    Uac网关解绑子设备
 *
 *    @param     params              字典
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)gatewayUnbindUacLock:(NSDictionary*_Nullable)params
                     success:(nullable void (^)(void))success
                     failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;


/**
 *    网关解绑子设备
 *
 *    @param     params              字典
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)gatewayUnbindLock:(NSDictionary*_Nullable)params
                  success:(nullable void (^)(void))success
                  failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;


/**
 *    网关时区
 *
 *    @param     params              字典
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)gatewayTimezones:(NSDictionary*_Nullable)params
                 success:(nullable void (^)(AlfredTimeZone *_Nullable))success
                 failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;


/**
 *    设置网关时区
 *
 *    @param     params              字典
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)setGatewayTimezone:(NSDictionary*_Nullable)params
                   success:(nullable void (^)(void))success
                   failure:(nullable void (^)(NetErrorModel * _Nullable error))failure;
@end
