//
//  HomeViewController.swift
//  AlfredDemo
//
//  Created by Tianbao Wang on 2020/12/18.
//

import UIKit
import SnapKit
import AlfredNetManager
import AlfredLibrary
import AlfredLockManager

let paramStr = ""
let deviceId = ""

class GuestHomeViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    let tableView = UITableView(frame: CGRect(), style: .plain)
    var isoperate: Bool = false //防止多次点击
    var myLockList = [AlfredLock]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Guest devices"
        self.navigationItem.leftBarButtonItem = nil
        GuestLockManager.shared().disconnect()
        guestSdkInit()
        initUIs()
        //后台
        NotificationCenter.default.addObserver(self, selector: #selector(becomeDeath), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    //后台
    @objc func becomeDeath() {
        GuestLockManager.shared().disconnect()
    }
    
    //MARK: -- 访客鉴权
    func guestSdkInit() {
        AlfredLib.asyncInit(accessKeyID, securityKey: secretAccessKey) {
            self.getTestData()
        } failure: { (err, msg) in
            Toast.promptMessage(msg)
        }
    }

    func getTestData() {
        //对每个访客门锁，先设置门锁型号
        if let lock = GuestLockManager.shared().getGuestDevice(deviceId, paramStr: paramStr) {
            GuestLockManager.shared().setDeviceMode(deviceId, mode:ML2)
            lock.extend?.name = "Test guest lock"
            myLockList.append(lock)
        }
        
        //多把访客门锁
//        if let lock2 = GuestLockManager.shared().getGuestDevice(deviceId2, paramStr: paramStr2) {
//            GuestLockManager.shared().setDeviceMode(deviceId2, mode:ML2)
//            lock2.extend?.name = "Test guest lock"
//            myLockList.append(lock2)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTestData()
    }
    
    //MARK: -- 开关门操作(蓝牙)
    func operateLockByBLE(_ model: AlfredLock) {
        GuestLockManager.shared().setVerifyLevel(LOW)
        //关门
        var lockOperate = AlfredLockOperation.LockOperation_Lock
        if model.lockState == .LockState_Locked {
            //开门
            lockOperate = .LockOperation_UnLock
        }
        GuestLockManager.shared().setOperation(model.deviceid ?? "", paramStr: paramStr, operation: lockOperate) { (device, error) in
            self.isoperate = false
            if error == .ACCESS_DATA_EXPIRED {
                
            } else if error == .ACCESS_DATA_MISSING {
                
            } else if error == .NONE_ERROR {
                if let dev = device as? AlfredLock {
                    model.lockState = dev.lockState
                }
            }
            self.tableView.reloadData()
        }
    }
    
    //连接门锁蓝牙
    func connectLock(_ model: AlfredLock) {
        GuestLockManager.shared().setVerifyLevel(HIGH)
        GuestLockManager.shared().access(model.deviceid ?? "", paramStr: paramStr, timeout: 10) { (device, connectState, error) in
            self.isoperate = false
            if connectState == .LockConnectState_Disconnect {
                Toast.promptMessage("Disconnect")
            } else if connectState == .LockConnectState_Connected {
                Toast.promptMessage("Connected")
            } else if connectState == .LockConnectState_ConnectFailed {
                Toast.promptMessage("Connect Failed")
            }
            if error == .ACCESS_DATA_EXPIRED {
                
            } else if error == .ACCESS_DATA_MISSING {
                
            }
            if device != nil {
                model.connectState = device!.connectState
                model.lockState = device!.lockState
            }
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
        isoperate = true
        //蓝牙已连接
        if model.connectState == .LockConnectState_Connected {
            self.operateLockByBLE(model)
        } else {
            //蓝牙未连接，需要先连接
            self.connectLock(model)
        }
    }
    
    //开门记录
    func messageAction(_ model: AlfredLock) {
        let control = GuestLockRecordViewController()
        PushViewController(control)
    }
    
    //设置
    func settings(_ model: AlfredLock) {
        let control = GuestLockSetViewController()
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
    }

    
    //MARK: -- UItableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return myLockList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LockCell.lockCellIdentifier, for: indexPath as IndexPath) as! LockCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.white
        //我的门锁
        let device = myLockList[indexPath.section]
        cell.setData(model: device)
        cell.openDoorBlock = {
            //开门
            self.openDoorAction(device)
        }
        cell.messageBlock = {
            //消息
            self.messageAction(device)
        }
        cell.settingBlock = {
            //设置
            self.settings(device)
        }
        return cell
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
