//
//  BridgeBinder.h
//  AlfredBridgeBinder
//
//  Created by Tianbao Wang on 2020/11/13.
//

#import <Foundation/Foundation.h>
#import <AlfredCore/AlfredCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface BridgeBinder : NSObject

/**
*    单例
*/
+ (instancetype)shared;


/**
 *    获取定位权限用来连接网关
 *

 */
- (void)accessLocation;


/**
 *    连接小AP设备无线
 *
 *    @param     deviceId           设备的sn，可以通过扫描二维码获取
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)connect:(NSString *)deviceId
        success:(nullable void (^)(void))success
        failure:(AlfredErrorCallback)failure;

/**
*    手动连接小AP设备无线后，校验是否已连接
*
*    @param     deviceId           设备的sn，可以通过扫描二维码获取
*    @param     success           成功回调
*    @param     failure              失败回调
*/
- (void)connectManual:(NSString *)deviceId
              success:(nullable void (^)(void))success
              failure:(AlfredErrorCallback)failure;


/**
*    获取无线热点扫描数据
*
*    @param     success           成功回调
*    @param     failure              失败回调
*/
- (void)requestWifiList:(nullable void (^)(NSArray<AlfredBridgeHotspot *> * hotspots))success
                failure:(AlfredErrorCallback)failure;


/**
*    配置无线热点网络参数
*
*    @param     hotspot          无线热点扫描数据
*    @param     password       无线热点密码
*    @param     success           成功回调
*    @param     failure              失败回调
*/
- (void)requestWifiConfig:(AlfredBridgeHotspot *)hotspot
                 password:(NSString *)password
                  success:(nullable void (^)(void))success
                  failure:(AlfredErrorCallback)failure;



/**
 *    解除当前账户下指定设备
 *
 *    @param     deviceID          指定设备的SN
 *    @param     success              成功回调
 *    @param     failure              失败回调

 */
- (void)unbindDevice:(NSString*)deviceID
             success:(nullable void (^)(void))success
             failure:(AlfredErrorCallback)failure;


/**
*    取消配置无线热点网络
*
*/
- (void)cancelWifiConfig;

@end

NS_ASSUME_NONNULL_END
