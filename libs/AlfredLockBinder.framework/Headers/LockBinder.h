//
//  LockBinder.h
//  AlfredLockBinder
//
//  Created by Tianbao Wang on 2020/11/13.
//

#import <Foundation/Foundation.h>
#import <AlfredCore/AlfredCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface LockBinder : NSObject

/**
*    单例
*/
+ (instancetype)shared;


/**
 *    搜索蓝牙设备
 *    @param     timeout              搜索超时时间
 *    @param     name                     通过蓝牙前缀名称过滤，不传值默认过滤出“ALF”，"Alfred"
 *    @param     success              成功回调 AlfredDevices
 *    @param     failure              失败回调

 */
- (void)searchDeviceList:(int)timeout
              blePreName:(NSString *)name
                 success:(nullable void (^)(NSArray<AlfredDeviceBindStatus *>*))success
                 failure:(AlfredErrorCallback)failure;


/**
 *    设备绑定
 *    @param     device                    蓝牙设备
 *    @param     masterPincode     门锁的当前管理员密码
 *    @param     success                  成功回调 AlfredDevices
 *    @param     failure                  失败回调
 */

- (void)registerDevice:(AlfredDeviceBindStatus *)device
         masterPincode:(NSString *)masterPincode
               success:(nullable void (^)(AlfredLock *))success
               failure:(AlfredErrorCallback)failure;
@end

NS_ASSUME_NONNULL_END
