//
//  HomeViewController.swift
//  AlfredDemo
//
//  Created by Tianbao Wang on 2020/12/18.
//

import UIKit
import SnapKit
import MJRefresh
import AlfredNetManager
import AlfredLibrary
import AlfredLockManager
import AlfredBridgeManager

let accessKeyID = "bddc6a33b97059f10f492b579b2e0932"
let secretAccessKey = "K/jwNK1vxvYwxdbBakzBwguHh8iUutAfydYGioHt82c="
let allyName = "alfcom"
let allyToken = ""

class HomeViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    let tableView = UITableView(frame: CGRect(), style: .plain)
    let nodeviceview = HomeNoDeviceView(icon: UIImage(named: "device_empty_")!, info: LockLocalizedString("home_nodevice_info", comment: ""), action: LockLocalizedString("home_nodevice_add_btn", comment: ""))

    var myLockList = [AlfredLock]()
    var myBridgeList = [AlfredBridge]()
    var isoperate: Bool = false //防止多次点击


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My devices"
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_add_dark_"), style: .done, target: self, action: #selector(addDevice))
        sdkInit()
        initUIs()
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("refreshDeviceList"), object: nil)
        //后台
        NotificationCenter.default.addObserver(self, selector: #selector(becomeDeath), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    //后台
    @objc func becomeDeath() {
        LockManager.shared().disconnect()
    }
    
    //MARK: -- 鉴权
    func sdkInit() {
        AlfredLib.asyncInit(accessKeyID, securityKey: secretAccessKey) {
            self.sdkSignin()
        } failure: { (err, msg) in
            Toast.promptMessage(msg)
        }
    }
    
    //MARK: -- 登录
    func sdkSignin() {
        AlfredLib.sign(in: allyName, allyToken: allyToken) {
            self.tableView.mj_header?.beginRefreshing()
            self.getData()
        } failure: { (error, msg) in
            Toast.promptMessage(msg)
        }
    }
    
    //MARK: -- 开关门操作(蓝牙)
    func operateLockByBLE(_ model: AlfredLock) {
        //关门
        var lockOperate = AlfredLockOperation.LockOperation_Lock
        if model.lockState == .LockState_Locked {
            //开门
            lockOperate = .LockOperation_UnLock
        }
        LockManager.shared().setOperation(model.deviceid ?? "" , operation: lockOperate) { (device, error) in
            if error == .NONE_ERROR {
                if let dev = device as? AlfredLock {
                    model.lockState = dev.lockState
                }
            } else {
                if error == .CONNECTION_NOT_CREATED {
                    Toast.promptMessage("Disconnect")
                }
            }

            self.isoperate = false
            self.tableView.reloadData()
        }
    }
    
    //MARK: -- 开关门操作(网关)
    func operateLockByBridge(_ model: AlfredLock) {
        if let bridge = CacheManager.shared.getLockBindGateway(model) {
            //关门
            var lockOperate = AlfredLockOperation.LockOperation_Lock
            if model.lockState == .LockState_Locked {
                //开门
                lockOperate = .LockOperation_UnLock
            }
            BridgeManager.shared().setLockOperation(bridge.did ?? "",
                                                    subdeviceID: model.deviceid ?? "",
                                                    operation: lockOperate) {
                self.isoperate = false
                self.tableView.reloadData()
            } failure: { (error) in
                self.isoperate = false
                Toast.promptMessage(error?.eMessage)
            }
        }
    }
    
    //MARK: -- 获取设备列表
    @objc func getData() {
        LockManager.shared().disconnect()
        NetManager.shared().queryDevices { (alfredDevices) in
            self.tableView.mj_header?.endRefreshing()
            if let locks = alfredDevices.locks {
                self.myLockList = locks
            }
            if let bridges = alfredDevices.bridges {
                self.myBridgeList = bridges
            }
            if self.myLockList.count + self.myBridgeList.count == 0 {
                self.setNodevice()
            } else {
                self.removeNodevice()
            }
            self.bridgeStatus()
            self.tableView.reloadData()
        } failure: { (error) in
            self.tableView.mj_header?.endRefreshing()
            Toast.promptMessage(error.eMessage)
        }
    }
    
    //MARK: -- 网关状态
    func bridgeStatus() {
        if self.myBridgeList.count > 0 {
            BridgeManager.shared().bridgeLockStatus(self.myBridgeList) {
                self.tableView.reloadData()
            } failure: { (error) in
                
            }
        }
    }
    
    //连接门锁蓝牙
    func connectLock(_ model: AlfredLock) {
        LockManager.shared().access(model.deviceid ?? "", timeout: 10) { (device, connectState, error) in
            if connectState == .LockConnectState_Disconnect {
                Toast.promptMessage("Disconnect")
            } else if connectState == .LockConnectState_Connected {
                Toast.promptMessage("Connected")
                //默认管理密码 =0:出厂密码 =1:已修改
                if device.lockInfo?.adminPwdState == "0" {
                    
                }
                
            } else if connectState == .LockConnectState_ConnectFailed {
                Toast.promptMessage("Connect Failed")
            }
            model.connectState = device.connectState
            model.lockState = device.lockState
            self.isoperate = false
            self.tableView.reloadData()
        } notifyCallback: { (device, obj) in
            self.tableView.reloadData()
        }
    }
    
    //开门
    @objc func openDoorAction(_ model: AlfredLock) {
        if isoperate {
            return
        }
        self.isoperate = true
        //连接网关
        if model.connectBridge {
            self.operateLockByBridge(model)
        } else {
            //蓝牙已连接
            if model.connectState == .LockConnectState_Connected {
                self.operateLockByBLE(model)
            } else {
                //蓝牙未连接，需要先连接
                self.connectLock(model)
            }
        }
    }
    
    
    //添加设备
    @objc func addDevice() {
        PushViewController(AddDeviceViewController())
    }
    
    //设置
    func settings(_ model: AlfredLock) {
        let control = LockSettingViewController()
        control.device = model
        PushViewController(control)
    }
    
    //开门记录
    func messageAction(_ model: AlfredLock) {
        let control = LockRecordViewController()
        control.device = model
        PushViewController(control)
    }

    private func initUIs() {
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LockCell.self, forCellReuseIdentifier: LockCell.lockCellIdentifier)
        tableView.register(BridgeCell.self, forCellReuseIdentifier: BridgeCell.bridgeCellIdentifier)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        setheaderView()
    }
    
    private func setheaderView() {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(getData))
        tableView.mj_header = header
    }
    
    //没有设备
    func setNodevice() {
        nodeviceview.frame = self.view.frame
        nodeviceview.addDeviceAction = {
            self.addDevice()
        }
        tableView.tableFooterView = nodeviceview
    }
    
    func removeNodevice() {
        tableView.tableFooterView = nil
    }
    
    //MARK: -- UItableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return myLockList.count + myBridgeList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section < myLockList.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: LockCell.lockCellIdentifier, for: indexPath as IndexPath) as! LockCell
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.white
            //我的门锁
            let device = myLockList[indexPath.section]
            cell.setData(model: device)
            cell.messageBlock = {
                //消息
                self.messageAction(device)
            }
    
            cell.settingBlock = {
                //设置
                self.settings(device)
            }

            cell.openDoorBlock = {
                //开门
                self.openDoorAction(device)
            }
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: BridgeCell.bridgeCellIdentifier, for: indexPath as IndexPath) as! BridgeCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.white
        //我的网关
        let device = myBridgeList[indexPath.section - myLockList.count]
        cell.setData(device)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section >= myLockList.count {
            let device = myBridgeList[indexPath.section - myLockList.count]
            let control = BridgeSettingViewController()
            control.bridge = device
            PushViewController(control)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 144
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headview = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 24))
        return headview
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 216
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
}
