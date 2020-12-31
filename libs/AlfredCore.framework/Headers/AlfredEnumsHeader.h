//
//  AlfredEnumsHeader.h
//  AlfredCore
//
//  Created by Tianbao Wang on 2020/11/16.
//

/**
 错误码定义
 */
typedef NS_ENUM(NSInteger,AlfredError) {
    LIBRARY_NOT_INIT = 0, //库未正常初始化
    LIBRARY_NOT_SIGNIN, //库未注册鉴权
    LIBRARY_INIT_ERROR, //sdk初始化失败
    LIBRARY_SDC_ERROR, //Sdc失败
    LIBRARY_SIGNIN_ERROR, //登录失败
    SYSTEM_BLE_PoweredOff, //手机系统蓝牙未打开
    PASSWORD1_MISSING, //鉴权码1丢失
    ACCESS_DATA_MISSING, //鉴权数据丢失
    MASTERPINCODE_ERROR, //管理员密码错误
    CONNECTION_NOT_FOUND, //未找到该设备
    CONNECTION_NOT_CREATED, //接入连接未建立
    CONNECTION_OCCUPIED, //连接的设备不是当前设备
    CONNECTION_CREATE_FAILED,//接入连接创建失败
    CONNECTION_ON_OAD, //接入连接处于OAD模式
    CONNECTION_BUSYING, //当前接入连接正忙
    CONNECTION_DISCONNECTED, //当前接入连接已断开
    REQUSET_NOT_SUPPORTED, //不支持的操作请求
    REQUEST_ILLEGAL_FORMAT, //非法格式的操作请求参数
    REQUEST_ILLEGAL_PARAMETER, //非法的操作请求参数
    REQUEST_TIMEOUT, //操作请求超时
    REQUEST_FAILED,//操作请求失败
    RESPONSE_ILLEGAL_FORMAT,//操作应答数据格式错误
    BLE_REQUEST_FAILURE,//蓝牙请求失败
    BLE_REQUEST_NOT_AUTHORIZED,//蓝牙请求未鉴权
    BLE_REQUEST_AUTHORIZED_FAIL,//蓝牙请求鉴权失败
    BLE_REQUEST_LOCKINFO_FAIL,//蓝牙获取门锁基本信息失败
    BLE_REQUEST_RESERVED_FIELD_NOT_ZERO,//保留区域没有置零
    BLE_REQUEST_MALFORMED_COMMAND,//蓝牙请求命令异常
    BLE_REQUEST_UNSUPPORT_COMMAND,//不支持的蓝牙请求
    BLE_REQUEST_INVALID_FIELD,//非法的蓝牙请求字段
    BLE_REQUEST_UNSUPPORTED_ATTRIBUTE,//不支持的蓝牙请求属性
    BLE_REQUEST_INVALID_VALUE,//蓝牙请求值超出范围，或设置为保留值，或当前序号已存在
    BLE_REQUEST_READ_ONLY,//蓝牙请求属性为只读
    BLE_REQUEST_INSUFFICIENT_SPACE,//蓝牙请求操作空间不足
    BLE_REQUEST_DUPLICATE_EXISTS,//蓝牙请求数据重复存在
    BLE_REQUEST_NOT_FOUND,//蓝牙请求数据不存在
    BLE_REQUEST_INVALID_DATA_TYPE,//错误的蓝牙请求数据类型
    BLE_REQUEST_WRITE_ONLY,//蓝牙请求属性为只写
    BLE_REQUEST_ACTION_DENIED,//蓝牙请求权限不足
    BLE_REQUEST_TIMEOUT,//蓝牙请求超时，一般为门锁固件未响应蓝牙模块的请求
    BLE_REQUEST_ABORT,//蓝牙升级请求过程中被异常退出
    BLE_REQUEST_INVALID_IMAGE,//非法的蓝牙升级请求文件
    BLE_REQUEST_WAIT_FOR_DATA,//蓝牙升级请求正等待服务端响应
    BLE_REQUEST_HARDWARE_FAILURE,//蓝牙内部硬件错误
    BLE_REQUEST_SOFTWARE_FAILURE,//蓝牙内部软件错误
    BLE_REQUEST_CALIBRATION_ERROR,//蓝牙请求校验过程出错
    BLE_REQUEST_NO_RESPONSE,//蓝牙请求已接收，但处理超时
    BLE_LOCKCODE_SCHEDULE_NUM_OVER,//门锁时间计划最多五组
    BLE_LOCKCODE_NO_EXIST,//门锁密钥不存在
    INTERNAL_ERROR,//未归类的其他内部错误
    
    BRIDGE_DEVICETOKEN_ERROR, //绑定获取token错误
    BRIDGE_CONNECT_FAILURE, //网关连接失败
    BRIDGE_CONNECT_MANUAL,  //网关需要获取手动连接
    BRIDGE_CONNECT_TIMEOUT,  //网关链接超时
    BRIDGE_CONNECT_WIFI_DIFFERENT,  //连接了错误Wi-Fi
    BRIDGE_CONNECT_TCP_FAILURE, //连接tcp错误
    BRIDGE_CHECK_MASTERCODE_ERROR, //管理员密码不正确
    BRIDGE_CHECK_MASTERCODE_CRCERROR,//crc校验错误
    BRIDGE_MODIFY_MASTERCODE_FAILURE, //修改管理员密码失败
    BRIDGE_REQUEST_WIFICONFIG_SSID_ERROR, //ssid为空
    BRIDGE_REQUEST_WIFILIST_FAILURE, //获取Wi-Fi列表失败
    BRIDGE_REQUEST_WIFICONFIGTIME_FAILURE, //配网时间同步失败
    BRIDGE_REQUEST_WIFICONFIG_FAILURE,  //配网失败
    BRIDGE_REQUEST_WIFICONFIG_WIFIPASSWORD_ERROR, //配网Wi-Fi密码错误
    BRIDGE_REQUEST_WIFICONFIG_DEVICETOKEN_ERROR, //配网token错误
    BRIDGE_REQUEST_WIFICONFIG_SCANSSID_FAILURE, //配网scan ssid 失败
    BRIDGE_REQUEST_WIFICONFIG_SDC_FAILURE, //配网sdc 请求失败
    BRIDGE_REQUEST_WIFICONFIG_BIND_FAILURE, //配网bind 失败
    BRIDGE_REQUEST_WIFICONFIG_CONNREADY_FAILURE, //配网conn ready 失败
    BRIDGE_REQUEST_WIFICONFIG_ANALYSIS_FAILURE, //配网请求解析失败
    BRIDGE_BIND_OTHER, //网关被其他人已绑定
    BRIDGE_REQUEST_WIFICONFIG_TIMEOUT, //配网超时
    BRIDGE_UPDATEVENDOR_ERROR, //更新vendor失败
    
    NET_REQUEST_ERROR, //网络请求错误

    NONE_ERROR,//无错，请求成功完成时返回
};


/**
 设备类型定义
 */
typedef NS_ENUM(NSInteger,AlfredDeviceType) {
    DeviceType_DoorLock = 2,//蓝牙门锁设备
    DeviceType_Gateway= 8,//网关设备
};

#pragma mark -  锁连接状态
typedef NS_ENUM(NSUInteger,AlfredLockConnectState) {
    LockConnectState_Unconnect,        //未连接
    LockConnectState_Connected,        //已连接
    LockConnectState_ConnectFailed,    //连接失败
    LockConnectState_Disconnect,       //连接断开
    LockConnectState_OAD,              //已连接，但处于OAD升级模式
};

#pragma mark -  锁状态
typedef NS_ENUM(NSUInteger,AlfredLockStatus) {
    LockState_Locked,        //已上锁
    LockState_Unlocked,      //已解锁
    LockState_Updating,      //正在升级
};


#pragma mark -  锁控制
//Action
typedef NS_ENUM(NSUInteger,AlfredLockOperation) {
    LockOperation_UnLock = 0x00,
    LockOperation_Lock = 0x01,
    LockOperation_Toggle = 0x02,
};

//type
typedef NS_ENUM(NSUInteger,LockControlType) {
    LockControlType_PIN = 0x01,    //PIN 密码
    LockControlType_RFID = 0x02,   //RFID 卡片
    LockControlType_APP = 0x04,    //APP 开锁(锁不鉴权)
};

/**
 时间计划类型
 */
typedef NS_ENUM(NSUInteger,AlfredLockCodeSchedule) {
    LockCodeSchedule_Always = 0x01,//永久生效
    LockCodeSchedule_Weekly = 0x02, //周计划生效
    LockCodeSchedule_Period = 0x03,//时间段内生效
};

//code
typedef NS_ENUM(NSUInteger,AlfredLockCodeType) {
    LockCodeType_PIN = 0x01,  //PIN 密码
    LockCodeType_Fingerprint = 0x02, //指纹
    LockCodeType_RFID = 0x03, //RFID 卡片
    LockCodeType_Admin = 0x04, //管理员密码(只支持 Set/Check)
};

//voice
typedef NS_ENUM(NSInteger,AlfredLockVoice) {
    LockVoice_Mute = 0,  //静音模式
    LockVoice_Sofly = 1, //低音量模式
    LockVoice_Loud = 2, //高音量模式
};

//Language
typedef NS_ENUM(NSUInteger,AlfredLockLanguage) {
    LockLanguage_EN = 0x01,  //英语
    LockLanguage_ES, //西班牙语
    LockLanguage_FR, //法语
    LockLanguage_PT, //葡萄牙语
    LockLanguage_ZH, //汉语
};

#pragma mark -  密钥管理,同步密钥状态
//Action
typedef NS_ENUM(NSUInteger,LockPwdAction) {
    LockPwdAction_setPwd = 0x01, //Set Code 设置密钥
    LockPwdAction_getPwd = 0x02, //Get Code 查询密钥
    LockPwdAction_delPwd = 0x03, //Clear Code 删除密钥
    LockPwdAction_checkPwd = 0x04, //Check Code 验证密钥
};

#pragma mark -  锁参数修改

//index
typedef NS_ENUM(NSUInteger,AlfredLockRequestConfig) {
    LockRequestConfig_Language = 0x01,  //门锁播报语音语言类型设置
    LockRequestConfig_Voice = 0x02, //门锁播报语音音量设置
    LockRequestConfig_Time = 0x03, //门锁时间设置
    LockRequestConfig_Auto = 0x04, //自动上锁设置
    LockRequestConfig_InsideDeadLock = 0x05, //内反锁设置
    LockRequestConfig_AwayMode = 0x06, //门锁离家模式设置/ 布防
    LockRequestConfig_PowerSafe = 0x07, //节电模式设置
    LockRequestConfig_MasterPinCode = 0x08, //修改门锁当前管理员密码
};


#pragma mark -  门锁日志类型定义

//index
typedef NS_ENUM(NSUInteger,AlfredLockRecordID) {
    Unknown = 0,//未知
    LockRecordID_Lock = 3,  //斜锁舌上锁
    LockRecordID_Unlock = 4, //斜锁舌解锁
    LockRecordID_Magetic_Detection_Off = 5, //门磁感应关门
    LockRecordID_Magetic_Detection_On = 6, //门磁感应开门
    LockRecordID_Inside_Lock_On = 7, //门内反锁
    LockRecordID_Inside_Lock_Off = 8, //解除反锁
    LockRecordID_Away_Mode_On = 9, //打开布防模式
    LockRecordID_Away_Mode_Off = 10, //关闭布防模式
    LockRecordID_Safe_Mode_Off = 11, //关闭安全模式
    LockRecordID_Safe_Mode_On = 12, //打开关闭模式
    LockRecordID_Delete_Codes = 13, //删除密钥
    LockRecordID_Add_Codes = 14, //添加密钥
    LockRecordID_Manual_Lock = 15, //门锁手动上锁模式
    LockRecordID_Auto_Lock = 16, //门锁自动上锁模式
    LockRecordID_Rest = 17, //门锁恢复出厂模式
    LockRecordID_Master_Codes_Changed = 18, //门锁管理员密码改变
    LockRecordID_Power_Safe_Off = 19, //关闭蓝牙节能模式
    LockRecordID_Power_Safe_On = 20, //打开蓝牙节能模式
    LockRecordID_Set_Voice = 21,//门锁音量设置
    LockRecordID_Set_Language = 22,//门锁语音设置
    LockRecordID_Trigger_Doorbell_Button = 23,//触发门铃按键
    LockRecordID_Key_Changed = 24,//修改密钥
    LockRecordID_Infrared_Off = 25,//关闭红外开关
    LockRecordID_Infrared_On = 26,//打开红外开关
    LockRecordID_Exit_Master_Mode = 27,//退出门锁管理员模式
    LockRecordID_Enter_Master_Mode = 28,//进入门锁管理员模式
    LockRecordID_Corridor_Mode_On = 29,//打开过道模式
    LockRecordID_Corridor_Mode_Off = 30,//关闭过道模式
    LockRecordID_Vibration_Mode_Off = 32,//关闭震动模式
    LockRecordID_Vibration_Mode_On = 33,//打开震动模式
    LockRecordID_Alarm_Low_Power = 129,//门锁低电量告警
    LockRecordID_Alarm_LockDown = 130,//门锁锁定告警
    LockRecordID_Alarm_Violent = 131,//门锁防撬告警
    LockRecordID_Alarm_Away_Mode = 132,//门锁布防告警
    LockRecordID_Alarm_Duress = 133,//门锁胁迫告警
    LockRecordID_Alarm_Mechanical_Key = 134,//门锁机械钥匙开门告警
    LockRecordID_Alarm_Mechanical_Failure = 135,//门锁锁舌故障告警
    LockRecordID_Alarm_Input_Failure = 136,//门锁密钥输入错误告警
    LockRecordID_Alarm_Vibration = 137,//震动告警
};


//len
typedef NS_ENUM(NSUInteger,LockParamLen) {
    LockParamLen_language = 2,  //语言
    LockParamLen_voice = 1, //音量
    LockParamLen_time = 4, //时间
    LockParamLen_auto = 1, //Anti-lock
    LockParamLen_Antilock = 1, //反锁
    LockParamLen_leave = 1, //离家模式/ 布防
    LockParamLen_bleopen = 1, //蓝牙开关
};


#pragma mark -  锁Cmd
typedef NS_ENUM(NSInteger,LockCmd) {
    LockCmd_Auth = 0x01,    //鉴权帧
    LockCmd_Control = 0x02, //锁控制
    LockCmd_PwdManager = 0x03, //密钥管理
    LockCmd_Record = 0x04, //锁记录查询
    LockCmd_Operate = 0x05, //锁操作上报确认帧（开门后，自动上报开门记录）
    LockCmd_ParamsChange = 0x06, //锁参数修改
    LockCmd_PwdUpdate = 0x11, //同步密钥状态
    LockCmd_InfoQuery = 0x12, //查询门锁基本信息
    LockCmd_BindCheck = 0x13, //绑定请求帧（管理员密码校验）
    LockCmd_NewRecord = 0x14, //锁记录查询
    LockCmd_ML2NewRecord = 0x19, //锁记录查询

    LockCmd_WeekScheduleSet = 0x0B, //周计划设置
    LockCmd_WeekScheduleQuery = 0x0C, //周计划查询
    LockCmd_WeekScheduleDel = 0x0D, //周计划删除
    LockCmd_YMDScheduleSet = 0x0E, //年月日计划设置
    LockCmd_YMDScheduleQuery = 0x0F, //年月日计划查询
    LockCmd_YMDScheduleDel = 0x10, //年月日计划删除
    LockCmd_UserTypeSet = 0x09, //用户类型设置
    LockCmd_PwdInfoQUery = 0x1C, //密钥信息查询
};
