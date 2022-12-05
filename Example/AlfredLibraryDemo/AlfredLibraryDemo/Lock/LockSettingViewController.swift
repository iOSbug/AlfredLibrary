//
//  LockSettingViewController.swift
//  AlfredDemo
//
//  Created by Tianbao Wang on 2020/12/21.
//

import UIKit
import AlfredCore
import AlfredLockBinder

class LockSettingViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    let tableView = UITableView(frame: CGRect(), style: .plain)
    private let pinKeysItem = WVTableItem()
    private let touchKeysItem = WVTableItem()
    private let cardKeysItem = WVTableItem()
    
    private let leavemodeItem = WVSwitchTableItem()
    private let antilockItem = WVSwitchTableItem()
    private let autolockItem = WVSwitchTableItem()
    private let powersaveItem = WVSwitchTableItem()
    
    private let languageAndvoiceItem = WVTableItem()
    private let renameItem = WVTableItem()
    private let adminPwdItem = WVTableItem()
    private let updateItem = WVTableItem()
    private let deviceinfoItem = WVTableItem()
    
    private var itemGroups: [WVTableGroup] = []
    private let thinTableCellId = "thinTableCellId"

    var device: AlfredLock?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        initUIs()
        initData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
        tableView.reloadData()
    }
    
    //MARK: -- 删除门锁
    @objc func deleteDevice() {
        LockBinder.shared().unbindDevice(device?.deviceid ?? "") {
            NotificationCenter.default.post(name: NSNotification.Name("refreshDeviceList"), object: nil)
            self.navigationController?.popViewController(animated: true)
        } failure: { (error, msg) in
            Toast.promptMessage(msg)
        }
    }
    
    //离家模式，反锁，自动模式设置
    func lockParamSet(_ type: AlfredLockRequestConfig) {
        let control = LockConfigSetViewController()
        control.viewType = type
        control.device = device
        PushViewController(control)
    }
    
    //语言和语音
    func showVocieAndLanguage() {
        let control = LockLanguageAndVoiceViewController()
        control.device = device
        PushViewController(control)
    }
    
    //管理员密码修改
    func showAdminPwd() {
        let control = LockAdminPwdViewController()
        control.device = device
        PushViewController(control)
    }
    
    //显示门锁信息
    func showDeviceInfo() {
        let control = LockInformationViewController()
        control.device = device
        PushViewController(control)
    }
    
    //修改名称
    func showRename() {
        let control = LockRenameViewController()
        control.device = device
        PushViewController(control)
    }
    
    //密钥
    func showLockCode(_ type: AlfredLockCodeType) {
        let control = LockCodesViewController()
        control.device = device
        control.codeType = type
        PushViewController(control)
    }
    
    func initData() {
        var keyitems = [WVTableItem]()
        pinKeysItem.icon = UIImage(named: "icon_PIN_dark_")
        pinKeysItem.accessoryCustomImage = UIImage(named: "arrow_right")
        pinKeysItem.title = LockLocalizedString("home_lock_setting_pin_keys_title", comment: "Pin Keys")
        pinKeysItem.showAccessory = true
        pinKeysItem.execute = { [weak self] in
            self?.showLockCode(.LockCodeType_PIN)
        }
        keyitems.append(pinKeysItem)
        
        cardKeysItem.icon = UIImage(named: "icon_card_dark_")
        cardKeysItem.accessoryCustomImage = UIImage(named: "arrow_right")
        cardKeysItem.title = LockLocalizedString("home_lock_setting_card_keys_title")
        cardKeysItem.showAccessory = true
        cardKeysItem.execute = { [weak self] in
            self?.showLockCode(.LockCodeType_RFID)
        }
        if device?.mode == "ML2" {
            keyitems.append(cardKeysItem)
        }
        
        var lockSetitems = [WVTableItem]()
        leavemodeItem.icon = UIImage(named: "icon_Leave-Mode_")
        leavemodeItem.accessoryCustomImage = UIImage(named: "arrow_right")
        leavemodeItem.title = LockLocalizedString("home_lock_setting_leave_mode_title", comment: "Away Mode")
        leavemodeItem.showAccessory = true
        leavemodeItem.execute = { [weak self] in
            self?.lockParamSet(.LockRequestConfig_AwayMode)
        }
        if let leavemode = device?.ability?.leavemode {
            if leavemode.enable == "1" {
               lockSetitems.append(leavemodeItem)
            }
        }
        
        autolockItem.icon = UIImage(named: "icon_Auto-lock_")
        autolockItem.accessoryCustomImage = UIImage(named: "arrow_right")
        autolockItem.title = LockLocalizedString("home_lock_setting_auto_lock_title", comment: "Auto-lock")
        autolockItem.showAccessory = true
        autolockItem.execute = { [weak self] in
            self?.lockParamSet(.LockRequestConfig_Auto)
        }
        if let autolock = device?.ability?.autolock {
            if autolock.enable == "1" {
                lockSetitems.append(autolockItem)
            }
        }
        

        antilockItem.icon = UIImage(named: "icon_lock-yourself_")
        antilockItem.accessoryCustomImage = UIImage(named: "arrow_right")
        antilockItem.title = LockLocalizedString("home_lock_setting_anti_lock_title", comment: "Anti-lock")
        antilockItem.showAccessory = true
        antilockItem.execute = { [weak self] in
            self?.lockParamSet(.LockRequestConfig_InsideDeadLock)
        }
        if let insidelock = device?.ability?.insidelock {
            if insidelock.enable == "1" {
                lockSetitems.append(antilockItem)
            }
        }
        
        //节电
        powersaveItem.icon = UIImage(named: "icon_Power-saving_")
        powersaveItem.accessoryCustomImage = UIImage(named: "arrow_right")
        powersaveItem.title = LockLocalizedString("home_lock_setting_power_save_title")
        powersaveItem.showAccessory = true
        powersaveItem.execute = { [weak self] in
            self?.lockParamSet(.LockRequestConfig_PowerSafe)
        }
        lockSetitems.append(powersaveItem)

        
        var lockInfotems = [WVTableItem]()
        renameItem.icon = UIImage(named: "icon_edit_")
        renameItem.accessoryCustomImage = UIImage(named: "arrow_right")
        renameItem.title = LockLocalizedString("home_lock_setting_name_title", comment: "Name")
        renameItem.showAccessory = true
        renameItem.execute = { [weak self] in
            self?.showRename()
        }
        lockInfotems.append(renameItem)

        
        languageAndvoiceItem.icon = UIImage(named: "icon_voice_")
        languageAndvoiceItem.title = LockLocalizedString("home_lock_setting_lock_language_voice_title", comment: "Language")
        if let mode = device?.mode {
            if mode == "DB1" {
                languageAndvoiceItem.title = LockLocalizedString("home_lock_setting_lock_voice_title", comment: "voice")
            }
        }
        languageAndvoiceItem.showAccessory = true
        languageAndvoiceItem.accessoryCustomImage = UIImage(named: "arrow_right")
        languageAndvoiceItem.execute = { [weak self] in
            self?.showVocieAndLanguage()
        }
        lockInfotems.append(languageAndvoiceItem)
        
        adminPwdItem.icon = UIImage(named: "icon_change-admin_")
        adminPwdItem.title = LockLocalizedString("home_lock_setting_change_admin_password", comment: "admin password")
        adminPwdItem.showAccessory = true
        adminPwdItem.accessoryCustomImage = UIImage(named: "arrow_right")
        adminPwdItem.execute = { [weak self] in
            self?.showAdminPwd()
        }
        lockInfotems.append(adminPwdItem)
        
        updateItem.icon = UIImage(named: "icon_update_")
        updateItem.accessoryCustomImage = UIImage(named: "icon_refresh_light_")
        updateItem.showAccessory = true
        updateItem.title = LockLocalizedString("home_lock_setting_update_firmware_title", comment: "Update firmware")
        updateItem.execute = { [weak self] in
//            self?.showUpdate()
        }
//        lockInfotems.append(updateItem)

        deviceinfoItem.icon = UIImage(named: "icon_about_")
        deviceinfoItem.title = LockLocalizedString("lock_device_infomation_title", comment: "Device information")
        deviceinfoItem.showAccessory = true
        deviceinfoItem.accessoryCustomImage = UIImage(named: "arrow_right")
        deviceinfoItem.execute = {  [weak self] in
            self?.showDeviceInfo()
        }
        lockInfotems.append(deviceinfoItem)
        
        let group0 = WVTableGroup()
        group0.items = keyitems
        
        let group1 = WVTableGroup()
        group1.items = lockSetitems
        
        let group2 = WVTableGroup()
        group2.items = lockInfotems
                
        itemGroups = [group0, group1, group2]
        refreshData()
        tableView.reloadData()
    }
    
    
    func refreshData() {
        if let keys = device?.extend?.keys {
            var pinkeys = [AlfredLockCode]()
            var touchkeys = [AlfredLockCode]()
            var cardkeys = [AlfredLockCode]()
            for key in keys {
                if key._type == .LockCodeType_PIN {
                    pinkeys.append(key)
                }
                if key._type == .LockCodeType_Fingerprint {
                    touchkeys.append(key)
                }
                if key._type == .LockCodeType_RFID {
                    cardkeys.append(key)
                }
            }
            pinKeysItem.comment = "\(pinkeys.count)"
            touchKeysItem.comment = "\(touchkeys.count)"
            cardKeysItem.comment = "\(cardkeys.count)"
        }

        //布防
        if let armingState = device?.extend?.leavemode {
            leavemodeItem.comment = (armingState == "1") ? "On" : "Off"
        }
        
        //反锁
        if let antilockState = device?.extend?.insidelock {
            antilockItem.comment = (antilockState == "0") ? "On" : "Off"
        }
        
        //自动
        if let autoState = device?.extend?.autolock {
            autolockItem.comment = (autoState == "1") ? "On" : "Off"
        }
        
        //节电(1表示蓝牙常开（非节电），0表示蓝牙关闭（节电）)
        if let powersave = device?.extend?.powersave {
            powersaveItem.comment = (powersave == "1") ? "On" : "Off"
        }
        
        if device?.mode == "ML2" {
            leavemodeItem.switchEnable = false
            leavemodeItem.accessoryCustomImage = UIImage(named: "arrow_right_white")
            leavemodeItem.execute = nil
            antilockItem.switchEnable = false
            antilockItem.accessoryCustomImage = UIImage(named: "arrow_right_white")
            antilockItem.execute = nil
        }
    }
    
    func setFootView() {
        let foot = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 96))
        tableView.tableFooterView = foot
        
        let deletBtn = UIButton()
        deletBtn.setTitle(LockLocalizedString("home_lock_setting_delete_title", comment: "Delete the device"), for: .normal)
        deletBtn.setTitleColor(WVColor.WVRedTextColor(), for: .normal)
        deletBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        deletBtn.addTarget(self, action: #selector(deleteDevice), for: .touchUpInside)
        foot.addSubview(deletBtn)
        deletBtn.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(foot)
            make.height.equalTo(64)
        }
        
        let topline = UIView()
        topline.backgroundColor = WVColor.WVTableLineColor()
        foot.addSubview(topline)
        topline.snp.makeConstraints { (make) in
            make.left.equalTo(foot).offset(24)
            make.right.equalTo(foot).offset(-24)
            make.height.equalTo(0.8)
            make.top.equalTo(foot).offset(32)
        }
        
        let bottomline = UIView()
        bottomline.backgroundColor = WVColor.WVTableLineColor()
        foot.addSubview(bottomline)
        bottomline.snp.makeConstraints { (make) in
            make.left.equalTo(foot).offset(24)
            make.right.equalTo(foot).offset(-24)
            make.height.equalTo(0.8)
            make.bottom.equalTo(foot)
        }
    }
    
    private func initUIs() {
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 64
        tableView.backgroundColor = WVColor.WVViewBackColor()
        tableView.register(CommSwitchCell.self, forCellReuseIdentifier: thinTableCellId)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        setFootView()
    }
    
    //MARK: -- UItableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemGroups.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let group = itemGroups[section]
        return group.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: thinTableCellId, for: indexPath) as! CommSwitchCell
        
        let items = itemGroups[indexPath.section].items
        let item = items[indexPath.row]
        cell.item = item
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = itemGroups[indexPath.section].items[indexPath.row]
        item.execute?()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
    }

}
