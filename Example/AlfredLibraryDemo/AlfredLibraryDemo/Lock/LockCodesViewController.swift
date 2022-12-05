//
//  LockCodesViewController.swift
//  AlfredDemo
//
//  Created by Tianbao Wang on 2020/12/22.
//

import UIKit
import MJRefresh
import HandyJSON
import AlfredCore
import AlfredLockManager
import MBProgressHUD
import AlfredNetManager
import AlfredBridgeManager

class LockCodesViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    let tableView = UITableView(frame: CGRect(), style: .plain)
    let noKeyview = DeviceEmptyView(UIImage(named: "device_empty_"),
                                    LockLocalizedString("home_lock_setting_pin_keys_nodata_info1"),
                                    LockLocalizedString("home_lock_setting_pin_keys_nodata_create"))
    var device: AlfredLock?
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_add_dark_"), style: .done, target: self, action: #selector(addkey))

        initUIs()
        showNetLockCodes()
        NotificationCenter.default.addObserver(self, selector: #selector(showNetLockCodes), name: NSNotification.Name("refreshmykeys"), object: nil)
    }
    
    //MARK: -- 从云端获取密钥
    @objc func showNetLockCodes() {
        var nkeys = [AlfredLockCode]()
        if let keys = device?.extend?.keys {
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
        LockManager.shared().getLockCodes(device?.deviceid ?? "", codeType: codeType) { (model, error) in
            self.tableView.mj_header?.endRefreshing()
            if error == .NONE_ERROR, let keys = model as? [AlfredLockCode] {
                self.lockCodes = keys
                self.sortKeys()
            }
        }
    }
    
    //MARK: -- 通过网关读取数据门锁密钥
    func showBridgeLockCodes(_ device: AlfredLock) {
        if let bridge = CacheManager.shared.getLockBindGateway(device) {
            BridgeManager.shared().getLockCodes(bridge.did ?? "", subdeviceID: device.deviceid ?? "", mode: device.mode ?? "", codeType: codeType) { (keys) in
                self.tableView.mj_header?.endRefreshing()
                self.lockCodes = keys
                self.sortKeys()
            } failure: { (error) in
                self.tableView.mj_header?.endRefreshing()
                Toast.promptMessage(error?.eMessage)
            }
        }
    }
    
    //下拉刷新
    @objc func downloadNew() {
        if let device = device {
            if device.connectBridge {
                self.showBridgeLockCodes(device)
            } else {
                //蓝牙已连接
                if device.connectState == .LockConnectState_Connected {
                    self.showBLELockCodes()
                } else {
                    //蓝牙未连接，需要先连接
                    self.connectLock(device, action: #selector(showBLELockCodes), object: "")
                }
            }
        }
    }
    
    //MARK: -- 通过蓝牙删除密钥
    @objc func delKey(_ data: AlfredLockCode) {
        if let index = data.index {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            LockManager.shared().deleteLockCode(device?.deviceid ?? "", codeType: codeType, codeIndex: Int32(index)!) { (model, error) in
                MBProgressHUD.hide(for: self.view, animated: true)
                if error == .NONE_ERROR {
                    self.showNetLockCodes()
                } else {
                    
                }
            }
        }
    }
    
    //MARK: -- 通过网关删除密钥
    func delkeyByBridge(_ data: AlfredLockCode) {
        if let bridge = CacheManager.shared.getLockBindGateway(device),let index = data.index {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            BridgeManager.shared().deleteLockCode(bridge.did ?? "", subdeviceID: device?.deviceid ?? "", codeType: codeType, codeIndex: Int32(index)!) {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.showNetLockCodes()
            } failure: { (error) in
                MBProgressHUD.hide(for: self.view, animated: true)
                Toast.promptMessage(error?.eMessage)
            }
        }
    }
    
    //MARK: -- 通过蓝牙删除时间计划
    @objc func delSchedule(_ data: AlfredLockCode) {
        if let index = data.index {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            LockManager.shared().deleteLockCodeSchedule(device?.deviceid ?? "", codeType: codeType, codeIndex: Int32(index)!) { (model, error) in
                MBProgressHUD.hide(for: self.view, animated: true)
                if error == .NONE_ERROR {
                    self.showNetLockCodes()
                } else {
                    
                }
            }
        }
    }
    
    //MARK: -- 通过网关删除时间计划
    @objc func delScheduleByBridge(_ data: AlfredLockCode) {
        if let bridge = CacheManager.shared.getLockBindGateway(device),let index = data.index {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            BridgeManager.shared().deleteLockCodeSchedule(bridge.did ?? "", subdeviceID: device?.deviceid ?? "", codeType: codeType, codeIndex: Int32(index)!) {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.showNetLockCodes()
            } failure: { (error) in
                MBProgressHUD.hide(for: self.view, animated: true)
                Toast.promptMessage(error?.eMessage)
            }
        }
    }
    
    //删除钥匙接口
    func delMykey(_ data: AlfredLockCode) {
        if let device = device {
            //网关模式下
            if device.connectBridge {
                self.delkeyByBridge(data)
            } else {
                //蓝牙已连接
                if device.connectState == .LockConnectState_Connected {
                    self.delKey(data)
                } else {
                    //蓝牙未连接，需要先连接
                    self.connectLock(device, action: #selector(delKey), object: data)
                }
            }
        }
    }
    
    //删除门锁时间计划
    func delLockSchedule(_ data: AlfredLockCode) {
        if let device = device {
            //网关状态下
            if device.connectBridge {
                self.delScheduleByBridge(data)
            } else {
                //蓝牙已连接
                if device.connectState == .LockConnectState_Connected {
                    self.delSchedule(data)
                } else {
                    //蓝牙未连接，需要先连接
                    self.connectLock(device, action: #selector(delSchedule), object: data)
                }
            }
        }
    }
    
    //连接门锁蓝牙
    func connectLock(_ model: AlfredLock, action: Selector, object: Any) {
        LockManager.shared().access(model.deviceid ?? "", timeout: 10) { (device, connectState, error) in
           self.perform(action, with: object)
        } notifyCallback: { (device, obj) in
            
        }
    }
        
    // 添加钥匙
    @objc func addkey() {
        if codeType == .LockCodeType_PIN {
            let control = LockCodeAddViewController()
            control.device = device
            control.codeType = codeType
            PushViewController(control)
        } else if codeType == .LockCodeType_RFID {
            let control = LockAccessCodeAddViewController()
            control.device = device
            control.codeType = codeType
            PushViewController(control)
        }
    }
    
    // 设置时间计划
    func timePlanSet(_ model: AlfredLockCode) {
        let control = LockCodeScheduleViewController()
        control.device = device
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


class LockCodeCell: UITableViewCell {
    static let lockCodeCellIdentifier = "lockCodeCellIdentifier"
    let nameLabel = UILabel()
    let avatarImgView = UIImageView()
    let ownNameLabel = UILabel()
    let scheduleLabel = UILabel()

    let rightBtn = UIButton()
    var operateBlock: (()->(Void))?
    
    let weekStrs = [LockLocalizedString("share_bluetooth_key_sun", comment: "Sun"),
                    LockLocalizedString("share_bluetooth_key_mon", comment: "Mon"),
                    LockLocalizedString("share_bluetooth_key_tues", comment: "Tues"),
                    LockLocalizedString("share_bluetooth_key_wed", comment: "Wed"),
                    LockLocalizedString("share_bluetooth_key_thur", comment: "Thur"),
                    LockLocalizedString("share_bluetooth_key_fri", comment: "Fri"),
                    LockLocalizedString("share_bluetooth_key_sat", comment: "Sat")]

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initUIs()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUIs() {
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        nameLabel.textColor = WVColor.WVBlackTextColor()
        self.contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(16)
            make.left.equalTo(self.contentView).offset(25)
        }

        
        avatarImgView.clipsToBounds = true
        avatarImgView.layer.cornerRadius = 18
        self.contentView.addSubview(avatarImgView)
        avatarImgView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(24)
            make.bottom.equalTo(self.contentView).offset(-16)
            make.width.height.equalTo(36)
        }
        
        ownNameLabel.font = UIFont.systemFont(ofSize: 16)
        ownNameLabel.textColor = WVColor.WVBlackTextColor()
        ownNameLabel.textAlignment = .left
        self.contentView.addSubview(ownNameLabel)
        ownNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(avatarImgView.snp.centerY)
            make.left.equalTo(self.contentView).offset(68)
            make.right.equalTo(self.contentView).offset(-80)
        }
        
        scheduleLabel.font = UIFont.systemFont(ofSize: 14)
        scheduleLabel.textColor = WVColor.WVCommentTextColor()
        scheduleLabel.textAlignment = .left
        self.contentView.addSubview(scheduleLabel)
        
        rightBtn.setImage(UIImage(named: "icon_more_"), for: .normal)
        rightBtn.addTarget(self, action: #selector(operateAction), for: .touchUpInside)
        self.contentView.addSubview(rightBtn)
        rightBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.right.equalTo(self.contentView).offset(-24)
        }
        
        let line = UILabel()
        line.backgroundColor = WVColor.WVTableLineColor()
        self.contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(24)
            make.right.equalTo(self.contentView).offset(-24)
            make.height.equalTo(1)
        }
    }
    
    func setData(model: AlfredLockCode) {
        if model._type == .LockCodeType_PIN {
            //从锁里读出来的pinkey是1，但实际上pinkey开门是0
            nameLabel.text = LockLocalizedString("family_member_detail_pin_key_title", comment: "") + " " + (model.index ?? "")
            
        } else if model._type == .LockCodeType_Fingerprint {
            nameLabel.text = LockLocalizedString("family_member_detail_touch_key_title", comment: "") + " " + (model.index ?? "")
        } else if model._type == .LockCodeType_RFID {
            nameLabel.text = LockLocalizedString("family_member_detail_card_key_title") + " " + (model.index ?? "")
        }
        
        avatarImgView.image = UIImage(named: "device_key_bind_combined_")
        ownNameLabel.text = LockLocalizedString("home_lock_setting_pin_keys_create_password_bind_owner", comment: "")
        
        ownNameLabel.snp.remakeConstraints { (make) in
            make.centerY.equalTo(avatarImgView.snp.centerY)
            make.left.equalTo(self.contentView).offset(68)
            make.right.equalTo(self.contentView).offset(-80)
        }
        
        scheduleLabel.isHidden = true
        if model._scheduletype == AlfredLockCodeSchedule.LockCodeSchedule_Weekly || model._scheduletype == AlfredLockCodeSchedule.LockCodeSchedule_Period {
            scheduleLabel.isHidden = false
            
            ownNameLabel.snp.remakeConstraints { (make) in
                make.bottom.equalTo(avatarImgView.snp.centerY).offset(-2)
                make.left.equalTo(self.contentView).offset(68)
                make.right.equalTo(self.contentView).offset(-80)
            }
            
            scheduleLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(avatarImgView.snp.centerY).offset(2)
                make.left.equalTo(self.contentView).offset(68)
                make.right.equalTo(self.contentView).offset(-80)
            }
            
            if model._scheduletype == AlfredLockCodeSchedule.LockCodeSchedule_Weekly {
                if let weeks = model.week {
                    var weekstrs = [String]()
                    for (i,week) in weeks.enumerated() {
                        if week == 1 {
                            weekstrs.append(weekStrs[i])
                        }
                    }
                    var week = weekstrs.joined(separator: ",") + ","
                    if !weeks.contains(0) {
                        week = LockLocalizedString("share_bluetooth_key_every_day", comment: "everyday") + ","
                    } else {
                        if weeks[0] == 0 && weeks[1] == 1 &&
                            weeks[2] == 1 && weeks[3] == 1 &&
                            weeks[4] == 1 && weeks[5] == 1 &&
                            weeks[6] == 0 {
                            week = LockLocalizedString("share_bluetooth_key_workday", comment: "workday") + ","
                        } else if weeks[0] == 1 && weeks[1] == 0 &&
                            weeks[2] == 0 && weeks[3] == 0 &&
                            weeks[4] == 0 && weeks[5] == 0 &&
                            weeks[6] == 1 {
                            week = LockLocalizedString("share_bluetooth_key_weekday", comment: "weekend") + ","
                        }
                    }
                    let startend = (model.start ?? "") + "-" + (model.end ?? "")
                    week = week + startend
                    scheduleLabel.text = week
                }
            } else {
                var timeStr = ""
                if let start = model.start {
                    timeStr = ymdFormatter().string(from: Date(timeIntervalSince1970: TimeInterval(start)!))
                }
                if let end = model.end {
                    timeStr = timeStr + " - " + ymdFormatter().string(from: Date(timeIntervalSince1970: TimeInterval(end)!))
                }
                scheduleLabel.text = timeStr
            }
        }
    }
    
    @objc func operateAction() {
        operateBlock?()
    }
}

func ymdFormatter() -> DateFormatter{
    let format = DateFormatter()
    format.dateFormat = "M/dd/yy HH:mm"
    return format
}
