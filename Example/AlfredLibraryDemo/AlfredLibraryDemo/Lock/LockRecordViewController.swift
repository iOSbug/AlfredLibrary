//
//  LockRecordViewController.swift
//  AlfredDemo
//
//  Created by Tianbao Wang on 2020/12/30.
//

import UIKit
import MJRefresh
import AlfredLockManager
import AlfredBridgeManager
import AlfredNetManager
import MBProgressHUD

class LockRecordViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    private let tableView = UITableView(frame: CGRect(), style: .plain)
    private var logAlllist = [AlfredLockRecord]() //门锁所有数据，不过滤数据

    private var timeLogs = [[String: [AlfredLockRecord]]](){
        didSet {
            tableView.reloadData()
        }
    }
    private var currentpage = 1
    private let limit = 20
    var device: AlfredLock?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LockLocalizedString("home_lock_record_title", comment: "")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_refresh_dark_"), style: .done, target: self, action: #selector(updateLockMsg))
        initUIs()
        downloadData()
    }
    
    //MARK: -- 通过蓝牙同步开门记录
    func updateLockMsgByBLE() {
        currentpage = 1
        MBProgressHUD.showAdded(to: self.view, animated: true)
        LockManager.shared().syncRecords(device?.deviceid ?? "", page: Int32(currentpage), limit: Int32(limit)) { (model, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let data = model as? [AlfredLockRecord], error == .NONE_ERROR {
                self.parseData(data)
            }
        }
    }
    
    //MARK: -- 通过网关同步开门记录
    func updateLockMsgByBridge() {
        currentpage = 1
        if let bridge = CacheManager.shared.getLockBindGateway(device) {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            BridgeManager.shared().getLockRecords(bridge.did ?? "", subdeviceID: device?.deviceid ?? "", mode: device?.mode ?? "", page: Int32(currentpage), limit: Int32(limit)) { (model) in
                MBProgressHUD.hide(for: self.view, animated: true)
                self.parseData(model)
            } failure: { (error) in
                MBProgressHUD.hide(for: self.view, animated: true)
                Toast.promptMessage(error?.eMessage)
            }
        }
    }
    
    //MARK: -- 从云端获取
    @objc func getLogs() {
        NetManager.shared().fetchLockRecords(device?._id ?? "", limit: "\(limit)", page: "\(currentpage)") {[weak self] (model) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.tableView.mj_header?.endRefreshing()
            
            if strongSelf.tableView.mj_footer != nil {
                strongSelf.tableView.mj_footer?.endRefreshing()
            }
            if let logs = model?.logs {
                strongSelf.parseData(logs)
            }
        } failure: { (error) in
            Toast.promptMessage(error?.eMessage)
        }
    }

    //从门锁里获取开门记录来更新
    @objc func updateLockMsg() {
        if let device = device {
            //网关模式下
            if device.connectBridge {
                self.updateLockMsgByBridge()
            } else {
                //蓝牙已连接
                if device.connectState == .LockConnectState_Connected {
                    self.updateLockMsgByBLE()
                } else {
                    //蓝牙未连接，需要先连接
                    self.connectLock(device)
                }
            }
        }
    }
        
    //连接门锁蓝牙
    func connectLock(_ model: AlfredLock) {
        LockManager.shared().access(model.deviceid ?? "", timeout: 10) { (device, connectState, error) in
            self.updateLockMsgByBLE()
        } notifyCallback: { (device, obj) in
            
        }
    }
    
    //下拉刷新
    @objc func downloadData() {
        currentpage = 1
        getLogs()
    }
    
    //上拉刷新
    @objc func uploadData() {
        currentpage += 1
        getLogs()
    }
    
    func parseData(_ model: [AlfredLockRecord]) {
        self.setFooterView()
        self.timeLogs.removeAll()
        //下拉
        if self.currentpage == 1 {
            self.logAlllist.removeAll()
            //不足10个没有下拉
            if model.count != 20 {
                self.removeFooterView()
            }
        } else {
            //不足10个没有下拉
            if model.count != 20 {
                self.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }
        }
        for data in model {
            self.logAlllist.append(data)
        }
        
        if self.logAlllist.count%20 != 0 || self.logAlllist.count == 0 {
            self.removeFooterView()
        }
        
        for data in self.logAlllist {
            self.sortLogs(data)
        }
        self.tableView.reloadData()
    }
    
    func sortLogs(_ model: AlfredLockRecord) {
        if let time = model.time {
            let headtime = getMDYTime(time)
            if timeLogs.count == 0 {
                var logs = [AlfredLockRecord]()
                var timeDic = [String: [AlfredLockRecord]]()
                logs.append(model)
                timeDic[headtime] = logs
                timeLogs.append(timeDic)
            } else {
                var isexist = false
                //日期存在的话，找出数组，并排序
                for (i,timedic) in timeLogs.enumerated() {
                    if var elogs = timedic[headtime] {
                        elogs.append(model)
                        elogs.sort { (log1, log2) -> Bool in
                            //按照时间生序排列
                            return log1.time! > log2.time!
                        }
                        var addtimeDic = [String: [AlfredLockRecord]]()
                        addtimeDic[headtime] = elogs
                        isexist = true
                        timeLogs.remove(at: i)
                        timeLogs.insert(addtimeDic, at: i)
                        break
                    }
                }
                if !isexist {
                    //新增的日期不存在，则先创建日期dic，然后比较总数组日期排序
                    var nlogs = [AlfredLockRecord]()
                    var ntimeDic = [String: [AlfredLockRecord]]()
                    nlogs.append(model)
                    ntimeDic[headtime] = nlogs
                    timeLogs.insert(ntimeDic, at: 0)
                    timeLogs.sort { (dic1, dic2) -> Bool in
                        var log1: AlfredLockRecord?
                        var log2: AlfredLockRecord?
                        for (_,values) in dic1 {
                            log1 = values[0]
                            break
                        }
                        
                        for (_,values) in dic2 {
                            log2 = values[0]
                            break
                        }
                        
                        //按照时间生序排列
                        return log1!.time! > log2!.time!
                    }
                }
            }
        }
    }
    
    private func initUIs() {
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
            tableView.estimatedRowHeight = 0
            tableView.estimatedSectionFooterHeight = 0
            tableView.estimatedSectionHeaderHeight = 0
        }
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LockRecordCell.self, forCellReuseIdentifier: LockRecordCell.lockRecordCellIdentifier)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        setheaderView()
    }
    
    private func setheaderView() {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(downloadData))
        tableView.mj_header = header
    }
    
    private func setFooterView() {
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(uploadData))
        tableView.mj_footer = footer
    }
    
    private func removeFooterView() {
        tableView.mj_footer = nil
    }
    
    //MARK: -- UItableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return timeLogs.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let timedic = timeLogs[section]
        for (_,value) in timedic {
            return value.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LockRecordCell.lockRecordCellIdentifier, for: indexPath as IndexPath) as! LockRecordCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.white
        let timedic = timeLogs[indexPath.section]
        for (_,value) in timedic {
            let log = value[indexPath.row]
            cell.setData(model: log)
            if indexPath.row == 0 {
                cell.topLabel.isHidden = true
            }
            if indexPath.row == value.count - 1 {
                cell.bottomLabel.isHidden = true
            }
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headview = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 25))
        headview.backgroundColor = WVColor.WVViewBackColor()

        let timeLabel = UILabel()
        timeLabel.textColor = WVColor.WVBlackTextColor()
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        headview.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(headview)
            make.left.equalTo(headview).offset(25)
        }
        
        let timedic = timeLogs[section]
        for (key,_) in timedic {
            timeLabel.text = key
            break
        }
        return headview
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footview = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 15))
        return footview
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class LockRecordCell: UITableViewCell {
    static let lockRecordCellIdentifier = "lockRecordCellIdentifier"
    let avatarImgView = UIImageView()
    let nameLabel = UILabel()
    let timeLabel = UILabel()
    let topLabel = UILabel()
    let bottomLabel = UILabel()

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
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 3
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.textColor = WVColor.WVBlackTextColor()
        self.contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(105)
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.right.equalTo(self.contentView).offset(-30)
        }
        
        self.contentView.addSubview(avatarImgView)
        avatarImgView.snp.makeConstraints { (make) in
            make.right.equalTo(nameLabel.snp.left).offset(-8)
            make.centerY.equalTo(nameLabel.snp.centerY)
        }
        
        timeLabel.textAlignment = .left
        timeLabel.font = UIFont.systemFont(ofSize:12)
        timeLabel.textColor = WVColor.WVCommentTextColor()
        self.contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(25)
            make.centerY.equalTo(nameLabel.snp.centerY)
        }
        
        topLabel.backgroundColor = WVColor.WVdeepGrayTextColor()
        self.contentView.addSubview(topLabel)
        topLabel.snp.makeConstraints { (make) in
            make.height.equalTo(16)
            make.width.equalTo(1)
            make.top.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(40)
        }

        bottomLabel.backgroundColor = WVColor.WVdeepGrayTextColor()
        self.contentView.addSubview(bottomLabel)
        bottomLabel.snp.makeConstraints { (make) in
            make.height.equalTo(16)
            make.width.equalTo(1)
            make.bottom.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(40)
        }
    }
    
    func setData(model: AlfredLockRecord) {
        if let time = model.time {
            timeLabel.text = getHMTime(time)
        }
        topLabel.isHidden = false
        bottomLabel.isHidden = false
        
        switch model.recordID {
        case .LockRecordID_Lock:
            nameLabel.text = LockLocalizedString("lock_record_hub_door_close")
            avatarImgView.image = UIImage(named: "icon_inbox_lock_")
            break

        case .LockRecordID_Magetic_Detection_Off:
            nameLabel.text = LockLocalizedString("lock_record_hub_door_senor_close")
            avatarImgView.image = UIImage(named: "icon_inbox_door bell_")
            break

        case .LockRecordID_Magetic_Detection_On:
            nameLabel.text = LockLocalizedString("lock_record_hub_door_senor_open")
            avatarImgView.image = UIImage(named: "icon_inbox_door bell_")
            break

        case .LockRecordID_Inside_Lock_On:
            nameLabel.text = LockLocalizedString("lock_record_hub_insideDeadlock_open")
            avatarImgView.image = UIImage(named: "icon_inbox_dead inside_")
            break

        case .LockRecordID_Inside_Lock_Off:
            nameLabel.text = LockLocalizedString("lock_record_hub_insideDeadlock_close")
            avatarImgView.image = UIImage(named: "icon_inbox_dead inside_")
            break

        case .LockRecordID_Away_Mode_On:
            nameLabel.text = LockLocalizedString("lock_record_hub_awayMode_open")
            avatarImgView.image = UIImage(named: "icon_inbox_defence_")
            break

        case .LockRecordID_Away_Mode_Off:
            nameLabel.text = LockLocalizedString("lock_record_hub_awayMode_close")
            avatarImgView.image = UIImage(named: "icon_inbox_defence_")
            break

        case .LockRecordID_Safe_Mode_On:
            nameLabel.text = LockLocalizedString("lock_record_hub_safeMode_open")
            avatarImgView.image = UIImage(named: "icon_security mode_")
            break

        case .LockRecordID_Safe_Mode_Off:
            nameLabel.text = LockLocalizedString("lock_record_hub_safeMode_close")
            avatarImgView.image = UIImage(named: "icon_security mode_")
            break

        case .LockRecordID_Delete_Codes:
            if let index = model.index, let type = model.type {
                //删除所有
                if index == "255" {
                    if type == "0" {
                        //0x00: PIN Key (密码)
                        nameLabel.text = LockLocalizedString("lock_record_hub_del_all_pinKey")
                    } else if type == "3" {
                        //0x03: RFID 卡片
                        nameLabel.text = LockLocalizedString("lock_record_hub_del_all_card")
                    } else if type == "4" {
                        //0x04: Fingerprint 指纹
                        nameLabel.text = LockLocalizedString("lock_record_hub_del_all_touchKey")
                    }
                } else {
                    if type == "0" {
                        //0x00: PIN Key (密码)
                        nameLabel.text = String(format: LockLocalizedString("lock_record_hub_del_pinKey"), String(format: "%d", Int(index)!))
                    } else if type == "3" {
                        //0x03: RFID 卡片
                        nameLabel.text = String(format: LockLocalizedString("lock_record_hub_del_card"), String(format: "%d", Int(index)!))
                    } else if type == "4" {
                        //0x04: Fingerprint 指纹
                        nameLabel.text = String(format: LockLocalizedString("lock_record_hub_del_touchKey"), String(format: "%d", Int(index)!))
                    }
                }
            }
            avatarImgView.image = UIImage(named: "icon_inbox_PIN_delete_")

            break

        case .LockRecordID_Add_Codes:
            if let index = model.index, let type = model.type  {
                if type == "0" {
                    //0x00: PIN Key (密码)
                    nameLabel.text = String(format: LockLocalizedString("lock_record_hub_add_pinKey"), String(format: "%d", Int(index)!))
                } else if type == "3" {
                    //0x03: RFID 卡片
                    nameLabel.text = String(format: LockLocalizedString("lock_record_hub_add_card"), String(format: "%d", Int(index)!))
                } else if type == "4" {
                    //0x04: Fingerprint 指纹
                    nameLabel.text = String(format: LockLocalizedString("lock_record_hub_add_touchKey"), String(format: "%d", Int(index)!))
                }
            }
            avatarImgView.image = UIImage(named: "icon_inbox_PIN_")

            break

        case .LockRecordID_Manual_Lock:
            nameLabel.text = LockLocalizedString("lock_record_hub_autoLock_close")
            avatarImgView.image = UIImage(named: "icon_inbox_auto lock_")
            break

        case .LockRecordID_Auto_Lock:
            nameLabel.text = LockLocalizedString("lock_record_hub_autoLock_open")
            avatarImgView.image = UIImage(named: "icon_inbox_auto lock_")
            break

        case .LockRecordID_Rest:
            nameLabel.text = LockLocalizedString("lock_record_hub_restore")
            avatarImgView.image = UIImage(named: "icon_inbox_factory_")
            break

        case .LockRecordID_Master_Codes_Changed:
            nameLabel.text = LockLocalizedString("lock_record_hub_adminPwdChanged")
            avatarImgView.image = UIImage(named: "icon_inbox_admin change_")
            break

        case .LockRecordID_Power_Safe_Off:
            nameLabel.text = LockLocalizedString("lock_record_hub_powersave_close")
            avatarImgView.image = UIImage(named: "icon_inbox_power saving_")
            break

        case .LockRecordID_Power_Safe_On:
            nameLabel.text = LockLocalizedString("lock_record_hub_powersave_open")
            avatarImgView.image = UIImage(named: "icon_inbox_power saving_")
            break

        case .LockRecordID_Set_Voice:
            nameLabel.text = LockLocalizedString("lock_record_hub_voice_Changed")
            avatarImgView.image = UIImage(named: "icon_inbox_speaker_")
            break

        case .LockRecordID_Set_Language:
            nameLabel.text = LockLocalizedString("lock_record_hub_language_Changed")
            avatarImgView.image = UIImage(named: "icon_inbox_speaker_")
            break

        case .LockRecordID_Trigger_Doorbell_Button:
            nameLabel.text = LockLocalizedString("lock_record_hub_doorbell")
            avatarImgView.image = UIImage(named: "icon_inbox_door bell_")
            break

        case .LockRecordID_Key_Changed:
            nameLabel.text = LockLocalizedString("lock_record_hub_keyModify")
            avatarImgView.image = UIImage(named: "icon_inbox_PIN_")
            //修改管理员密码，p6锁里上报
            if model.index == "254" {
                nameLabel.text = LockLocalizedString("lock_record_hub_adminPwdChanged")
                 avatarImgView.image = UIImage(named: "icon_inbox_admin change_")
            }
            break

        case .LockRecordID_Infrared_Off:
            nameLabel.text = LockLocalizedString("lock_record_hub_infrared_close")
            avatarImgView.image = UIImage(named: "icon_inbox_infrared_")
            break

        case .LockRecordID_Infrared_On:
            nameLabel.text = LockLocalizedString("lock_record_hub_infrared_open")
            avatarImgView.image = UIImage(named: "icon_inbox_infrared_")
            break

        case .LockRecordID_Exit_Master_Mode:
            nameLabel.text = LockLocalizedString("lock_record_hub_lockadmin_close")
            avatarImgView.image = UIImage(named: "icon_inbox_door bell_")
            break

        case .LockRecordID_Enter_Master_Mode:
            nameLabel.text = LockLocalizedString("lock_record_hub_lockadmin_open")
            avatarImgView.image = UIImage(named: "icon_inbox_door bell_")
            break

        case .LockRecordID_Alarm_Low_Power:
            nameLabel.text = LockLocalizedString("lock_record_hub_low_battery_warning")
            avatarImgView.image = UIImage(named: "icon_inbox_lowpower_")
            break

        case .LockRecordID_Alarm_LockDown:
            nameLabel.text = LockLocalizedString("lock_record_hub_lockin_warning")
            avatarImgView.image = UIImage(named: "icon_inbox_frozen_")
            break

        case .LockRecordID_Alarm_Violent:
            nameLabel.text = LockLocalizedString("lock_record_hub_anti_warning")
            avatarImgView.image = UIImage(named: "icon_inbox_broken_")
            break

        case .LockRecordID_Alarm_Away_Mode:
            nameLabel.text = LockLocalizedString("lock_record_hub_awaymode_warning")
            avatarImgView.image = UIImage(named: "icon_inbox_defence broken_")
            break

        case .LockRecordID_Alarm_Duress:
            nameLabel.text = LockLocalizedString("lock_record_hub_coercive_warning")
            avatarImgView.image = UIImage(named: "icon_inbox_hijack_")
            break

        case .LockRecordID_Alarm_Mechanical_Key:
            nameLabel.text = LockLocalizedString("lock_record_hub_mechanical_warning")
            avatarImgView.image = UIImage(named: "icon_inbox_door bell_")
            break

        case .LockRecordID_Alarm_Mechanical_Failure:
            nameLabel.text = LockLocalizedString("lock_record_hub_mechanical_failure_warning")
            avatarImgView.image = UIImage(named: "icon_inbox_malfunction_")
            break

        case .LockRecordID_Alarm_Input_Failure:
            nameLabel.text = LockLocalizedString("lock_record_hub_put_pwd_error_warning")
            avatarImgView.image = UIImage(named: "icon_inbox_door bell_")
            break

        default:
            nameLabel.text = LockLocalizedString("lock_record_hub_unknow_default_error")
            avatarImgView.image = UIImage(named: "icon_inbox_door bell_")
            break
        }
        
        //非app开门时
        if model.lockevent != nil && model.lockevent != "4" {
            return
        }

        var opendoorName = ""
        if let type = model.type {
            //app 开门(自动开锁,z-wave)
            if type == "170" || type == "103" || type == "104" || type == "105" {
                avatarImgView.image = UIImage(named: "icon_app open_")

                //分享钥匙
                if model.name == nil || model.name == "" {
                    opendoorName = LockLocalizedString("lock_record_open_door_i", comment: "I")
                }
                if type == "104" {
                    avatarImgView.image = UIImage(named: "icon_one_touch_")
                    //自动开锁
                    opendoorName = LockLocalizedString("lock_record_open_door_app_one_touch_unlock")
                }
                if type == "105" {
                    avatarImgView.image = UIImage(named: "icon_zwave_")
                    //z-wave
                    opendoorName = LockLocalizedString("lock_record_open_door_zwave_name", comment: "remotely")
                }

            } else if Int(type)! == 0 {
                //pinkey
                if let index = model.index {
                    if index == "254" {
                        opendoorName = LockLocalizedString("lock_record_open_door_administratorkey", comment: "Administrator key") + " "
                    } else {
                        opendoorName = LockLocalizedString("lock_record_open_door_pinkey", comment: "Pin key ") + index + " "
                    }
                }
                avatarImgView.image = UIImage(named: "icon_inbox_PIN_")

            } else if Int(type)! == 4 {
                if let index = model.index {
                    opendoorName = LockLocalizedString("lock_record_open_door_touchkey", comment: "Touch key ") + index + " "
                }
                avatarImgView.image = UIImage(named: "icon_inbox_fingerprint_")

            } else if Int(type)! == 3 {
                if let index = model.index {
                   opendoorName = LockLocalizedString("lock_record_open_door_cardkey") + index + " "
                }
                avatarImgView.image = UIImage(named: "icon_inbox_card_")

            } else if Int(type)! == 2 {
                //机械开门
                opendoorName = LockLocalizedString("lock_record_open_door_mechanical", comment: "manually")
                avatarImgView.image = UIImage(named: "icon_inbox_manual_")

            }
        }

        if let name = model.name, name.count > 0 {
            nameLabel.setAttribute(LockLocalizedString("lock_opendoor_record_name_open_door", comment: "") + name, boldFontText: name, boldColor: WVColor.black)
        } else {
            //Door unlocked manually / Door unlock remotely
            if opendoorName == LockLocalizedString("lock_record_open_door_mechanical", comment: "manually") ||
                opendoorName == LockLocalizedString("lock_record_open_door_zwave_name", comment: "remotely") {
                nameLabel.setAttribute(LockLocalizedString("lock_opendoor_record_open_door_manually", comment: "") + opendoorName, boldFontText: opendoorName, boldColor: WVColor.black)

            } else {
                //Door unlocked by XXX
                nameLabel.setAttribute(LockLocalizedString("lock_opendoor_record_open_door", comment: "") + opendoorName, boldFontText: opendoorName, boldColor: WVColor.black)
            }
        }
    }
}

//HH:mm
func getHMTime(_ time: String) -> String {
    let date = Date(timeIntervalSince1970: (TimeInterval(time))!)
    let format = DateFormatter()
    format.dateFormat = "HH:mm"
    let retime = format.string(from: date)
    return retime
}

//MMM.dd.yyyy
func getMDYTime(_ time: String) -> String {
    let date = Date(timeIntervalSince1970: (TimeInterval(time))!)
    let format = DateFormatter()
    format.dateFormat = "MMM.dd.yyyy"
    let retime = format.string(from: date)
    return retime
}

extension UILabel {
    
    func setAttribute(_ text: String, boldFontText: String, boldColor: UIColor) {
        
        let attrText = NSMutableAttributedString(string: text)
        let diffBoldRange = (text as NSString).range(of: boldFontText)
        let boldFont = UIFont.boldSystemFont(ofSize: self.font.pointSize)
        if diffBoldRange.location != NSNotFound {
            attrText.addAttribute(NSAttributedString.Key.foregroundColor, value: boldColor, range: diffBoldRange)
            attrText.addAttribute(NSAttributedString.Key.font, value: boldFont, range: diffBoldRange)
        }
        
        self.attributedText = attrText
    }

}
