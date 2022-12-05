//
//  TestViewController.m
//  AlfredLibraryDemo
//
//  Created by Tianbao Wang on 2020/12/31.
//

#import "TestViewController.h"
#import <AlfredLibrary/AlfredLibrary.h>
#import <AlfredLockBinder/AlfredLockBinder.h>
#import <AlfredLockManager/AlfredLockManager.h>
#import <AlfredNetManager/AlfredNetManager.h>
#import <AlfredBridgeManager/AlfredBridgeManager.h>
#import <AlfredBridgeBinder/AlfredBridgeBinder.h>
#import <AlfredCore/AlfredCore.h>


@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)test {
    [AlfredLib asyncInit:@"ibcnet" securityKey:@"ibcnet-test-eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIwMDAwMDAwMSIsIm5hbWUiOiJBbmRyb2lkIFRlc3QwMSIsImFkbWluIjp0cnVlLCJqdGkiOiIwMDAwMDAwMS04ZmE5LTRhNjctOThjMi0wZjVjNTQ5MGI2OTUiLCJpYXQiOjE2MDQyNTk2NDUsImV4cCI6MTYxMDY2MzI0NX0.ITrClLO6CMzR3soRbtnYiX04BHRcXXRCRZvJKLQCPG8" success:^{
        
    } failure:^(AlfredError error, NSString *message) {
        
    }];
}

- (void)test1 {
    [[NetManager shared] queryDevices:^(AlfredDevices * _Nonnull alfredDevices) {
        
    } failure:^(NetErrorModel * _Nonnull error) {
        
    }];
}


- (void)test2 {
    [[BridgeManager shared] bridgeLockStatus:@[@"bridegeId"] success:^{
        
    } failure:^(NetErrorModel * _Nullable error) {
        
    }];
}

- (void)test3 {
    [[BridgeBinder shared] connect:@"bridgeid" success:^{
        
    } failure:^(AlfredError error, NSString *message) {
        
    }];
}

- (void)test4 {
    [[LockBinder shared] searchDeviceList:5 blePreName:@"ALF" success:^(NSArray<AlfredDeviceBindStatus *> * devs) {
        
    } failure:^(AlfredError error, NSString *message) {
        
    }];
}

- (void)test5 {
    [[LockManager shared] addLockCode:@"3" codeType:LockCodeType_PIN codeIndex:3 value:@"4782787" callback:^(id T, AlfredError E) {
        
    }];
}

@end
