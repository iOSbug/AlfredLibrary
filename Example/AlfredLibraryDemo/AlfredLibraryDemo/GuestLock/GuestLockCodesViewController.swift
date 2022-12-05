//
//  GuestLockCodesViewController.swift
//  AlfredDemo
//
//  Created by Tianbao Wang on 2021/12/20.
//

import UIKit
import MJRefresh
import HandyJSON
import AlfredCore
import AlfredLockManager
import MBProgressHUD

class GuestLockCodesViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    let tableView = UITableView(frame: CGRect(), style: .plain)
    let noKeyview = DeviceEmptyView(UIImage(named: "device_empty_"),
                                    LockLocalizedString("home_lock_setting_pin_keys_nodata_info1"),
                                    LockLocalizedString("home_lock_setting_pin_keys_nodata_create"))
    var codeType = AlfredLockCodeType.LockCodeType_PIN
    
    var lockCodes = [AlfredLockCode]() {
        didSet {
            if lockCodes.count == 0 {
                setNoKeyData()
            } else {
                removeNoKeyData()
            }
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = LockLocalizedString("home_lock_setting_pin_keys_title", comment: "PIN keys")
        if codeType == .LockCodeType_RFID {
            self.navigationItem.title = LockLocalizedString("home_lock_setting_card_keys_title", comment: "Access Card")
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_add_dark_"), style: .done, target: self, action: #selector(addkey))

        initUIs()
        showCacheLockCodes()
        if self.lockCodes.count == 0 {
            self.tableView.mj_header?.beginRefreshing()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(showCacheLockCodes), name: NSNotification.Name("refreshmykeys"), object: nil)
    }
    
    //MARK: -- 从缓存中获取
    @objc func showCacheLockCodes() {
        var nkeys = [AlfredLockCode]()
        if let keys = GuestLockManager.shared().getGuestDevice(deviceId, paramStr: paramStr)?.extend?.keys {
            for key in keys {
                if key._type == codeType {
                    nkeys.append(key)
                }
            }
            self.lockCodes = nkeys
            self.sortKeys()
        }
    }
    
    //MARK: -- 通过蓝牙连接门锁读取数据
    @objc func showBLELockCodes() {
        GuestLockManager.shared().getLockCodes(deviceId, paramStr: paramStr, codeType: codeType) { (model, error) in
            self.tableView.mj_header?.endRefreshing()
            if error == .NONE_ERROR, let keys = model as? [AlfredLockCode] {
                self.lockCodes = keys
                self.sortKeys()
            }
        }
    }
    
    //下拉刷新
    @objc func downloadNew() {
        if let device = GuestLockManager.shared().getGuestDevice(deviceId, paramStr: paramStr) {
            //蓝牙已连接
            if device.connectState == .LockConnectState_Connected {
                self.showBLELockCodes()
            } else {
                //蓝牙未连接，需要先连接
                self.connectLock(device, action: #selector(showBLELockCodes), object: "")
            }
        }
    }
    
    //MARK: -- 通过蓝牙删除密钥
    @objc func delKey(_ data: AlfredLockCode) {
        if let index = data.index {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            GuestLockManager.shared().deleteLockCode(deviceId, paramStr: paramStr, codeType: codeType, codeIndex: Int32(index)!) { (model, error) in
                MBProgressHUD.hide(for: self.view, animated: true)
                if error == .NONE_ERROR {
                    self.showCacheLockCodes()
                } else {
                    
                }
            }
        }
    }
    
    //MARK: -- 通过蓝牙删除时间计划
    @objc func delSchedule(_ data: AlfredLockCode) {
        if let index = data.index {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            GuestLockManager.shared().deleteLockCodeSchedule(deviceId, paramStr: paramStr, codeType: codeType, codeIndex: Int32(index)!) { (model, error) in
                MBProgressHUD.hide(for: self.view, animated: true)
                if error == .NONE_ERROR {
                    self.showCacheLockCodes()
                } else {
                    
                }
            }
        }
    }
    
    //删除钥匙接口
    func delMykey(_ data: AlfredLockCode) {
        if let device = GuestLockManager.shared().getGuestDevice(deviceId, paramStr: paramStr) {
            //蓝牙已连接
            if device.connectState == .LockConnectState_Connected {
                self.delKey(data)
            } else {
                //蓝牙未连接，需要先连接
                self.connectLock(device, action: #selector(delKey), object: data)
            }
        }
    }
    
    //删除门锁时间计划
    func delLockSchedule(_ data: AlfredLockCode) {
        if let device = GuestLockManager.shared().getGuestDevice(deviceId, paramStr: paramStr) {
            //蓝牙已连接
            if device.connectState == .LockConnectState_Connected {
                self.delSchedule(data)
            } else {
                //蓝牙未连接，需要先连接
                self.connectLock(device, action: #selector(delSchedule), object: data)
            }
        }
    }
    
    //连接门锁蓝牙
    func connectLock(_ model: AlfredLock, action: Selector, object: Any) {
        GuestLockManager.shared().access(model.deviceid ?? "", paramStr: paramStr, timeout: 10) { (device, connectState, error) in
            if connectState == .LockConnectState_Connected {
                self.perform(action, with: object)
            }
        } notifyCallback: { (device, obj) in
            
        }
    }
        
    // 添加钥匙
    @objc func addkey() {
        if codeType == .LockCodeType_PIN {
            let control = GuestLockCodeAddViewController()
            control.codeType = codeType
            PushViewController(control)
        } else if codeType == .LockCodeType_RFID {
            let control = GuestLockAccessCodeAddViewController()
            control.codeType = codeType
            PushViewController(control)
        }
    }
    
    // 设置时间计划
    func timePlanSet(_ model: AlfredLockCode) {
        let control = GuestLockCodeScheduleViewController()
        control.lockCode = model
        PushViewController(control)
    }
    
    //排序
    func sortKeys() {
        lockCodes.sort(by: { (key1, key2) -> Bool in
            if let index1 = key1.index, let index2 = key2.index {
                return Int(index1)! < Int(index2)!
            }
            return true
        })
    }
            
    //卷尺操作
    func showActionSheet(_ model: AlfredLockCode) {
        if model._scheduletype != .LockCodeSchedule_Always {
            let sheet = UIPinKeyActionSheetView([LockLocalizedString("home_lock_setting_pin_keys_list_sheet_time_plan"),
                                                 LockLocalizedString("home_lock_setting_pin_keys_list_sheet_delete_key"),
                                                 LockLocalizedString("home_lock_setting_pin_keys_list_sheet_delete_time_plan"),
                                                 LockLocalizedString("cancel")]) { (tag) in
                                                    switch tag {
                                                    case 0:
                                                        //时间计划设置
                                                        self.timePlanSet(model)
                                                    case 1:
                                                        //删除key
                                                        self.delMykey(model)
                                                    case 2:
                                                        //删除时间计划
                                                        self.delLockSchedule(model)
                                                        break
                                                    default:
                                                        break
                                                    }
                                        }
            sheet.show()
        } else {
            let sheet = UIPinKeyActionSheetView([LockLocalizedString("home_lock_setting_pin_keys_list_sheet_time_plan"),
                                                 LockLocalizedString("home_lock_setting_pin_keys_list_sheet_delete_key"),
                                                 LockLocalizedString("cancel")]) { (tag) in
                                                    switch tag {
                                                    case 0:
                                                        //时间计划设置
                                                        self.timePlanSet(model)
                                                    case 1:
                                                        //删除key
                                                        self.delMykey(model)
                                                    case 2:
                                                        break
                                                    default:
                                                        break
                                                    }
                                        }
            sheet.show()
        }
    }
    
    //没有设备
    func setNoKeyData() {
        noKeyview.frame = self.view.frame
        noKeyview.buttonBlock = {
            self.addkey()
        }
        tableView.tableFooterView = noKeyview
    }
    
    func removeNoKeyData() {
        tableView.tableFooterView = nil
    }
    
    private func initUIs() {
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LockCodeCell.self, forCellReuseIdentifier: LockCodeCell.lockCodeCellIdentifier)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        setheaderView()
    }
    
    private func setheaderView() {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(downloadNew))
        tableView.mj_header = header
    }
    
    //MARK: -- UItableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return lockCodes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LockCodeCell.lockCodeCellIdentifier, for: indexPath as IndexPath) as! LockCodeCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.white
        
        let model = lockCodes[indexPath.section]
        cell.setData(model: model)
        cell.operateBlock = {
            self.showActionSheet(model)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
