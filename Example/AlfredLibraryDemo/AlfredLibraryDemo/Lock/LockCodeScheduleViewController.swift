//
//  LockCodeScheduleViewController.swift
//  AlfredDemo
//
//  Created by Tianbao Wang on 2020/12/23.
//

import UIKit
import AlfredLockManager
import MBProgressHUD
import AlfredNetManager
import AlfredBridgeManager

class LockCodeScheduleViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    private let tableView = UITableView(frame: CGRect(), style: .plain)
    private let okBtn = UIButton()
    private let headTitle = UILabel()

    private var weeks: [Int]?  //选择的星期
    private var startTime: String? //开始时间
    private var endTime: String?  //结束时间

    var device: AlfredLock?
    var lockCode: AlfredLockCode?
        
    var selectType: AlfredLockCodeSchedule = .LockCodeSchedule_Always {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initUIs()
        setFootView()
        self.title = LockLocalizedString("home_lock_Time_plan_setting_title", comment: "Time plan setting")
        headTitle.text = LockLocalizedString("share_time_plan_setting_head", comment: "How often does the guest need to use this key?")
    }
    
    
    //MARK: -- 时间计划设置通过蓝牙
    @objc func setLockSchedule() {
        //周计划
        if selectType == .LockCodeSchedule_Weekly {
            //星期按照 日，一，二，三，四，五，六
            MBProgressHUD.showAdded(to: self.view, animated: true)
            LockManager.shared().setLockCodeSchedule(device?.deviceid ?? "", codeType: lockCode?._type ?? .LockCodeType_PIN, codeIndex: Int32(lockCode?.index ?? "0") ?? 0, startTime: startTime!, endTime: endTime!, weekdays: weeks!) { (model, error) in
                MBProgressHUD.hide(for: self.view, animated: true)
                if error == .NONE_ERROR {
                    NotificationCenter.default.post(name: NSNotification.Name("refreshmykeys"), object: nil)
                    Toast.promptMessage("successful")
                    self.navigationController?.popViewController(animated: true)
                } else {
                    
                }
            }

        } else if selectType == .LockCodeSchedule_Period {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            LockManager.shared().setLockCodeSchedule(device?.deviceid ?? "", codeType: lockCode?._type ?? .LockCodeType_PIN, codeIndex: Int32(lockCode?.index ?? "0") ?? 0, startTime: startTime!, endTime: endTime!) { (model, error) in
                MBProgressHUD.hide(for: self.view, animated: true)
                if error == .NONE_ERROR {
                    NotificationCenter.default.post(name: NSNotification.Name("refreshmykeys"), object: nil)
                    Toast.promptMessage("successful")
                    self.navigationController?.popViewController(animated: true)
                } else {
                    
                }
            }
        }
    }
    
    //MARK: -- 时间计划设置通过网关
    func setLockScheduleByBridge() {
        if let bridge = CacheManager.shared.getLockBindGateway(device) {
            //周计划
            if selectType == .LockCodeSchedule_Weekly {
                MBProgressHUD.showAdded(to: self.view, animated: true)
                BridgeManager.shared().setLockCodeWeeklySchedule(bridge.did ?? "", subdeviceID: device?.deviceid ?? "", codeType: lockCode?._type ?? .LockCodeType_PIN, codeIndex: Int32(lockCode?.index ?? "0") ?? 0, weekdays: weeks!, startTime: startTime!, endTime: endTime!) {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    NotificationCenter.default.post(name: NSNotification.Name("refreshmykeys"), object: nil)
                    Toast.promptMessage("successful")
                    self.navigationController?.popViewController(animated: true)
                } failure: { (error) in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    Toast.promptMessage(error?.eMessage)
                }

            } else if selectType == .LockCodeSchedule_Period {
                MBProgressHUD.showAdded(to: self.view, animated: true)
                BridgeManager.shared().setLockCodePeriodSchedule(bridge.did ?? "", subdeviceID: device?.deviceid ?? "", codeType: lockCode?._type ?? .LockCodeType_PIN, codeIndex: Int32(lockCode?.index ?? "0") ?? 0, startTime: startTime!, endTime: endTime!) {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    NotificationCenter.default.post(name: NSNotification.Name("refreshmykeys"), object: nil)
                    Toast.promptMessage("successful")
                    self.navigationController?.popViewController(animated: true)
                } failure: { (error) in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    Toast.promptMessage(error?.eMessage)
                }
            }
        }
    }
    
    // 时间计划
    @objc func saveTimePlan() {
        if selectType == .LockCodeSchedule_Always {
            Toast.promptMessage(LockLocalizedString("share_bluetooth_time_save_type_tip", comment: ""))
            return
        }
        if startTime == nil || startTime?.count == 0 || endTime == nil || endTime?.count == 0 {
            Toast.promptMessage(LockLocalizedString("share_bluetooth_time_save_time_tip", comment: ""))
            return
        }
        
        if let device = device {
            //网关模式下
            if device.connectBridge {
                self.setLockScheduleByBridge()
            } else {
                //蓝牙已连接
                if device.connectState == .LockConnectState_Connected {
                    self.setLockSchedule()
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
            self.setLockSchedule()
        } notifyCallback: { (device, obj) in
            
        }
    }

    func defaultData() {
        self.startTime = lockCode?.start
        self.endTime = lockCode?.end
        self.weeks = lockCode?.week
        if lockCode?.scheduleid != nil {
            selectType = lockCode?._scheduletype ?? .LockCodeSchedule_Always
        }
    }
    
    private func initUIs() {
        defaultData()
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ShareBluetoothkeyRecurringCell.self, forCellReuseIdentifier: ShareBluetoothkeyRecurringCell.shareTimeRecurringCellIdentifier)
        tableView.register(ShareBluetoothkeyTempCell.self, forCellReuseIdentifier: ShareBluetoothkeyTempCell.shareBluetoothkeyTempCellIdentifier)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        setHeadView()
    }
    
    func setHeadView() {
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        tableView.tableHeaderView = headView
        
        headTitle.text = LockLocalizedString("share_bluetooth_key_info", comment: "How often does the guest need to access the door")
        headTitle.textAlignment = .center
        headTitle.font = UIFont.systemFont(ofSize: 12)
        headTitle.textColor = WVColor.WVCommentTextColor()
        headView.addSubview(headTitle)
        headTitle.snp.makeConstraints { (make) in
            make.left.equalTo(headView).offset(24)
            make.top.equalTo(headView).offset(13)
            make.right.equalTo(headView).offset(-24)
        }
    }
    
    func setFootView() {
        let footView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64+56))
        tableView.tableFooterView = footView
        
        okBtn.setTitle(LockLocalizedString("ok", comment: ""), for: .normal)
        okBtn.setTitleColor(UIColor.white, for: .normal)
        okBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        okBtn.clipsToBounds = true
        okBtn.layer.cornerRadius = 28
        okBtn.isUserInteractionEnabled = true
        okBtn.backgroundColor = WVColor.WVBlueColor()
        okBtn.addTarget(self, action: #selector(saveTimePlan), for: .touchUpInside)
        footView.addSubview(okBtn)
        okBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(footView)
            make.height.equalTo(56)
            make.width.equalTo(183)
            make.centerX.equalTo(footView.snp.centerX)
        }
    }
    
    //选择哪个type
    func selectAction(_ section: Int, ison: Bool) {
        if ison {
            startTime = nil
            endTime = nil
            weeks = nil
            if section == 0 {
                selectType = .LockCodeSchedule_Weekly
            } else {
                selectType = .LockCodeSchedule_Period
            }
        } else {
            selectType = .LockCodeSchedule_Always
        }
    }
    
    //MARK: -- UItableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShareBluetoothkeyTempCell.shareBluetoothkeyTempCellIdentifier, for: indexPath as IndexPath) as! ShareBluetoothkeyTempCell
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.white
            cell.setTempData(selectType)
            if (self.startTime != nil) && (self.endTime != nil) {
                cell.setEditDefaultData(selectType, start: self.startTime!, end: self.endTime!)
            }
            cell.selectStarttimeBlock = { (start) in
                //开始时间
                self.startTime = start
            }
            cell.selectEndtimeBlock = { (end) in
                //结束时间
                self.endTime = end
            }
            cell.selectBlock = { (ison) in
                self.selectAction(indexPath.section, ison: ison)
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: ShareBluetoothkeyRecurringCell.shareTimeRecurringCellIdentifier, for: indexPath as IndexPath) as! ShareBluetoothkeyRecurringCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.white
        cell.setRecurringData(selectType)
        if (self.startTime != nil) && (self.endTime != nil) && weeks != nil && weeks?.count != 0 {
            cell.setEditDefaultData(selectType, start: startTime!, end: endTime!, weeks: weeks!)
        }
        cell.selectStarttimeBlock = { (start) in
            //开始时间
            self.startTime = start
        }
        cell.selectEndtimeBlock = { (end) in
            //结束时间
            self.endTime = end
        }
        cell.selectWeeksBlock = { (weeks) in
            //星期
            self.weeks = weeks
        }
        cell.selectBlock = { (ison) in
            self.selectAction(indexPath.section, ison: ison)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectType.rawValue == indexPath.section + 2 {
            if indexPath.section == 1 {
                return 158
            }
            return 212
        }
        return 56
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headview = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 24))
        return headview
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


class ShareBluetoothkeyRecurringCell: UITableViewCell {
    static let shareTimeRecurringCellIdentifier = "shareTimeRecurringCellIdentifier"
    let bgView = UIView()
    let nameLabel = UILabel()
    let selectBtn = UIButton()
    let dateView = UIView()
    let startView = WeekTimeView()
    let endView = WeekTimeView()
    
    let stimeView = HourMinTimeSelectSheet(.time)
    let etimeView = HourMinTimeSelectSheet(.time)

    var selectWeeks = [0,0,0,0,0,0,0] //周日起
    var mytype: AlfredLockCodeSchedule = .LockCodeSchedule_Weekly

    var selectBlock: ((Bool)->())?
    var selectStarttimeBlock: ((String)->())?
    var selectEndtimeBlock: ((String)->())?
    var selectWeeksBlock: (([Int])->())?

    let weeks = [LockLocalizedString("share_bluetooth_key_sun", comment: "Sun"),
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
        //阴影
        let bottomlayerView = UIView()
        bottomlayerView.backgroundColor = UIColor.white
        bottomlayerView.layer.cornerRadius = 2.0
        bottomlayerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        bottomlayerView.layer.shadowColor = UIColor(rgb: 0xe7e7e7).cgColor
        bottomlayerView.layer.shadowOpacity = 1
        self.contentView.addSubview(bottomlayerView)
        bottomlayerView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(24)
            make.right.equalTo(self.contentView).offset(-24)
            make.top.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
        }
        
        bgView.backgroundColor = WVColor.WVViewBackColor()
        bgView.layer.cornerRadius = 2.0
        bgView.clipsToBounds = true
        self.contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(24)
            make.right.equalTo(self.contentView).offset(-24)
            make.top.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
        }
        
        nameLabel.font = UIFont.systemFont(ofSize:18)
        nameLabel.textColor = WVColor.WVBlackTextColor()
        bgView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bgView).offset(16)
            make.top.equalTo(bgView).offset(16)
        }
        
        selectBtn.setImage(UIImage(named: "icon_select-off_big_"), for: .normal)
        selectBtn.setImage(UIImage(named: "icon_select-on_big_"), for: .selected)
        selectBtn.addTarget(self, action: #selector(selectAction), for: .touchUpInside)
        bgView.addSubview(selectBtn)
        selectBtn.snp.makeConstraints { (make) in
            make.top.equalTo(bgView).offset(18)
            make.right.equalTo(bgView.snp.right).offset(-18)
            make.height.width.equalTo(24)
        }
        
        bgView.addSubview(dateView)
        dateView.snp.makeConstraints { (make) in
            make.top.equalTo(bgView).offset(65)
            make.left.right.bottom.equalTo(bgView)
        }
        
        var currentBtn: WeekBtn?
        for i in 0...weeks.count-1 {
            let title = weeks[i]
            let weekBtn = WeekBtn()
            weekBtn.setTitle(title, for: .normal)
            weekBtn.setTitleColor(WVColor.WVCommentTextColor(), for: .normal)
            weekBtn.setTitleColor(WVColor.WVBlueColor(), for: .selected)
            weekBtn.titleLabel?.font = UIFont.systemFont(ofSize:14)
            weekBtn.tag = i
            weekBtn.addTarget(self, action: #selector(selectWeek), for: .touchUpInside)
            dateView.addSubview(weekBtn)
            weekBtn.snp.makeConstraints { (make) in
                if currentBtn == nil {
                    make.left.equalTo(dateView)
                } else {
                    make.left.equalTo(currentBtn!.snp.right)
                    make.width.equalTo(currentBtn!.snp.width)
                }
                make.top.equalTo(dateView)
                make.height.equalTo(25)
                if i == weeks.count-1 {
                    make.right.equalTo(dateView)
                }
            }
            currentBtn = weekBtn
        }
        
        startView.nameLabel.text = LockLocalizedString("share_bluetooth_key_start_time", comment: "")
        startView.selectTimeBlock = {
            self.selectStartTime()
        }
        startView.backgroundColor = UIColor.clear
        dateView.addSubview(startView)
        startView.snp.makeConstraints { (make) in
            make.left.right.equalTo(dateView)
            make.top.equalTo(bgView).offset(120)
            make.height.equalTo(40)
        }
        
        endView.nameLabel.text = LockLocalizedString("share_bluetooth_key_end_time", comment: "")
        endView.selectTimeBlock = {
            self.selectEndTime()
        }
        endView.backgroundColor = UIColor.clear
        dateView.addSubview(endView)
        endView.snp.makeConstraints { (make) in
            make.left.right.equalTo(dateView)
            make.top.equalTo(startView.snp.bottom)
            make.height.equalTo(40)
        }
    }
    
    //选择星期
    @objc func selectWeek(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let select = (sender.isSelected ? 1:0)
        selectWeeks.remove(at: sender.tag)
        selectWeeks.insert(select, at: sender.tag)
        selectWeeksBlock?(selectWeeks)
    }
    
    //选择开始时间
    func selectStartTime() {
        if mytype == .LockCodeSchedule_Weekly {
            if endView.timeLabel.text != nil {
                //结束时间-1分钟
                let laterDate = Date(timeIntervalSince1970: etimeView.datePicker.date.timeIntervalSince1970 - 60)
                stimeView.setMaxDate(laterDate)
            }
            stimeView.selectBlock = { (selectStr) in
                self.startView.timeLabel.text = selectStr
                self.selectStarttimeBlock?(selectStr)
            }
            stimeView.show()
        }
    }
    
    //选择结束时间
    func selectEndTime() {
        if mytype == .LockCodeSchedule_Weekly {
            if startView.timeLabel.text != nil {
                //开始时间+1分钟
                let laterDate = Date(timeIntervalSince1970: stimeView.datePicker.date.timeIntervalSince1970 + 60)
                etimeView.setMinDate(laterDate)
            }
            etimeView.selectBlock = { (selectStr) in
                self.endView.timeLabel.text = selectStr
                self.selectEndtimeBlock?(selectStr)
            }
            etimeView.show()
        }
    }

    
    @objc func selectAction(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        selectBlock?(sender.isSelected)
    }
    
    func setRecurringData(_ type: AlfredLockCodeSchedule) {
        mytype = .LockCodeSchedule_Weekly
        nameLabel.text = LockLocalizedString("share_bluetooth_key_recurring", comment: "")
        selectBtn.isSelected = (type == .LockCodeSchedule_Weekly)
        if selectBtn.isSelected {
            dateView.isHidden = false
        } else {
            dateView.isHidden = true
        }
    }
    
    //编辑模式下的初始值
    func setEditDefaultData(_ type: AlfredLockCodeSchedule, start: String, end: String, weeks: [Int]) {
        if type == .LockCodeSchedule_Weekly {
            startView.timeLabel.text = start
            stimeView.datePicker.date = (stimeView.format?.date(from: start))!
            endView.timeLabel.text = end
            etimeView.datePicker.date = (etimeView.format?.date(from: end))!
            selectWeeks = weeks
            for view in dateView.subviews {
                if view is WeekBtn {
                    let weekBtn = view as! WeekBtn
                    weekBtn.isSelected = (weeks[weekBtn.tag] == 1)
                }
            }
        }
    }
}

class WeekBtn: UIButton {
    private let lineLabel = UILabel()
    override var isSelected: Bool {
        didSet {
            if isSelected {
                showLabel()
            } else {
                hideLabel()
            }
        }
    }
    
    private func showLabel() {
        lineLabel.backgroundColor = WVColor.WVBlueColor()
        self.addSubview(lineLabel)
        lineLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLabel!.snp.left).offset(2)
            make.right.equalTo(self.titleLabel!).offset(-2)
            make.top.equalTo(self.snp.bottom)
            make.height.equalTo(0.5)
        }
    }
    
    private func hideLabel() {
        lineLabel.removeFromSuperview()
    }
}

class WeekTimeView: UIView {
    let nameLabel = UILabel()
    let timeLabel = UILabel()
    var selectTimeBlock:(()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUIs()
    }
    
    
    func initUIs() {
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.textColor = WVColor.WVCommentTextColor()
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(self).offset(16)
        }
        
        timeLabel.font = UIFont.systemFont(ofSize:16)
        timeLabel.textColor = WVColor.WVBlackTextColor()
        self.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.right.equalTo(self).offset(-40)
        }
        
        let nextBtn = UIButton()
        nextBtn.setImage(UIImage(named: "icon_next_"), for: .normal)
        self.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.right.equalTo(self).offset(-16)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectTime))
        self.addGestureRecognizer(tap)
    }
    
    @objc func selectTime() {
        selectTimeBlock?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


class ShareBluetoothkeyTempCell: UITableViewCell {
    static let shareBluetoothkeyTempCellIdentifier = "shareBluetoothkeyTempCellIdentifier"
    let bgView = UIView()
    let nameLabel = UILabel()
    let selectBtn = UIButton()
    let dateView = UIView()
    let startView = WeekTimeView()
    let endView = WeekTimeView()
    
    let stimeView = HourMinTimeSelectSheet(.dateAndTime)
    let etimeView = HourMinTimeSelectSheet(.dateAndTime)
    
    var mytype: AlfredLockCodeSchedule = .LockCodeSchedule_Period
    
    var selectBlock: ((Bool)->())?
    var selectStarttimeBlock: ((String)->())?
    var selectEndtimeBlock: ((String)->())?
    
    
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
        //阴影
        let bottomlayerView = UIView()
        bottomlayerView.backgroundColor = UIColor.white
        bottomlayerView.layer.cornerRadius = 2.0
        bottomlayerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        bottomlayerView.layer.shadowColor = UIColor(rgb: 0xe7e7e7).cgColor
        bottomlayerView.layer.shadowOpacity = 1
        self.contentView.addSubview(bottomlayerView)
        bottomlayerView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(24)
            make.right.equalTo(self.contentView).offset(-24)
            make.top.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
        }
        
        bgView.backgroundColor = WVColor.WVViewBackColor()
        bgView.layer.cornerRadius = 2.0
        bgView.clipsToBounds = true
        self.contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(24)
            make.right.equalTo(self.contentView).offset(-24)
            make.top.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
        }
        
        nameLabel.font = UIFont.systemFont(ofSize:18)
        nameLabel.textColor = WVColor.WVBlackTextColor()
        bgView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bgView).offset(16)
            make.top.equalTo(bgView).offset(16)
        }
        
        selectBtn.setImage(UIImage(named: "icon_select-off_big_"), for: .normal)
        selectBtn.setImage(UIImage(named: "icon_select-on_big_"), for: .selected)
        selectBtn.addTarget(self, action: #selector(selectAction), for: .touchUpInside)
        bgView.addSubview(selectBtn)
        selectBtn.snp.makeConstraints { (make) in
            make.top.equalTo(bgView).offset(18)
            make.right.equalTo(bgView.snp.right).offset(-18)
            make.height.width.equalTo(24)
        }
        
        bgView.addSubview(dateView)
        dateView.snp.makeConstraints { (make) in
            make.top.equalTo(bgView).offset(65)
            make.left.right.bottom.equalTo(bgView)
        }
        
        startView.nameLabel.text = LockLocalizedString("share_bluetooth_key_start_time", comment: "")
        startView.selectTimeBlock = {
            self.selectStartTime()
        }
        startView.backgroundColor = UIColor.clear
        dateView.addSubview(startView)
        startView.snp.makeConstraints { (make) in
            make.left.right.equalTo(dateView)
            make.top.equalTo(dateView).offset(10)
            make.height.equalTo(40)
        }
        
        endView.nameLabel.text = LockLocalizedString("share_bluetooth_key_end_time", comment: "")
        endView.selectTimeBlock = {
            self.selectEndTime()
        }
        endView.backgroundColor = UIColor.clear
        dateView.addSubview(endView)
        endView.snp.makeConstraints { (make) in
            make.left.right.equalTo(dateView)
            make.top.equalTo(startView.snp.bottom)
            make.height.equalTo(40)
        }
    }
    
    //选择开始时间
    func selectStartTime() {
        if mytype == .LockCodeSchedule_Period {
            if endView.timeLabel.text != nil {
                let bforeDate = Date(timeIntervalSince1970: etimeView.datePicker.date.timeIntervalSince1970 - 60)
                stimeView.setMaxDate(bforeDate)
            } else {
                stimeView.setMinToday()
            }
            stimeView.selectBlock = { (selectStr) in
                //控件显示的是utc时间+（未设置s时区）手机时区
                self.startView.timeLabel.text = selectStr
                //从控件里拿出来的时间是utc时间
                self.selectStarttimeBlock?("\(Int(self.stimeView.datePicker.date.timeIntervalSince1970))")
            }
            stimeView.format = ymdFormatter()
            stimeView.show()
        }
    }
    
    //选择结束时间
    func selectEndTime() {
        if mytype == .LockCodeSchedule_Period {
            if startView.timeLabel.text != nil {
                //开始时间+1分钟
                let laterDate = Date(timeIntervalSince1970: stimeView.datePicker.date.timeIntervalSince1970 + 60)
                etimeView.setMinDate(laterDate)
            } else {
                //当前时间+1分钟
                let laterDate =  Date(timeIntervalSince1970: Date().timeIntervalSince1970 + 60)
                etimeView.setMinDate(laterDate)
            }
            etimeView.selectBlock = { (selectStr) in
                self.endView.timeLabel.text = selectStr
                self.selectEndtimeBlock?("\(Int(self.etimeView.datePicker.date.timeIntervalSince1970))")
            }
            etimeView.format = ymdFormatter()
            etimeView.show()
        }
    }
    
    
    @objc func selectAction(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        selectBlock?(sender.isSelected)
    }
    
    func setTempData(_ type: AlfredLockCodeSchedule) {
        mytype = .LockCodeSchedule_Period
        nameLabel.text = LockLocalizedString("share_bluetooth_key_temporary", comment: "")
        selectBtn.isSelected = (type == .LockCodeSchedule_Period)
        if selectBtn.isSelected {
            dateView.isHidden = false
        } else {
            dateView.isHidden = true
        }
    }
    
    //编辑模式下的初始值
    func setEditDefaultData(_ type: AlfredLockCodeSchedule, start: String, end: String) {
        if type == .LockCodeSchedule_Period {
            let formatStart = ymdFormatter().string(from: Date(timeIntervalSince1970: TimeInterval(start)!))
            startView.timeLabel.text = formatStart
            stimeView.setDefaultDate(now: (ymdFormatter().date(from: formatStart))!)
            
            let formatEnd = ymdFormatter().string(from: Date(timeIntervalSince1970: TimeInterval(end)!))
            endView.timeLabel.text = formatEnd
            etimeView.setDefaultDate(now: (ymdFormatter().date(from: formatEnd))!)
        }
    }
    
    
}




class HourMinTimeSelectSheet: UIView {
    let datePicker = UIDatePicker()
    private let actionsheet = UIView()
    private let timeLabel = UILabel()
    var selectBlock: ((String)->())?
    var format: DateFormatter?
    
    func formatter() -> DateFormatter {
        let format = DateFormatter()
        format.dateFormat = "HH:mm"
        return format
    }
    
    func timeformatter() -> DateFormatter {
        let format = DateFormatter()
        format.dateFormat = "EEEE,MMM d,yyyy HH:mm"
        return format
    }
    
    //设置最小时间
    func setMinDate(_ minDate: Date) {
        datePicker.minimumDate = minDate
    }
    
    //设置最大时间
    func setMaxDate(_ maxDate: Date) {
        datePicker.maximumDate = maxDate
    }
    
    func setMinToday() {
        datePicker.minimumDate = Date()
    }
    
    //设置默认初始时间
    func setDefaultDate(now: Date) {
        datePicker.date = now
        timeLabel.text = self.timeformatter().string(from: self.datePicker.date)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(_ model: UIDatePicker.Mode) {
        super.init(frame: CGRect())
        self.backgroundColor = UIColor(rgb: 0x000000, alpha: 0.2)
        
        format = formatter()
        actionsheet.backgroundColor = UIColor.white
        actionsheet.isUserInteractionEnabled = true
        self.addSubview(actionsheet)
        actionsheet.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(321)
        }
        
        let sureBtn = UIButton()
        sureBtn.setTitle(LockLocalizedString("confirm", comment: "confirm"), for: .normal)
        sureBtn.titleLabel?.font = UIFont.systemFont(ofSize:16)
        sureBtn.setTitleColor(WVColor.WVBlueColor(), for: .normal)
        sureBtn.addTarget(self, action: #selector(sureAction), for: .touchUpInside)
        actionsheet.addSubview(sureBtn)
        sureBtn.snp.makeConstraints { (make) in
            make.top.right.equalTo(actionsheet)
            make.height.equalTo(56)
            make.width.equalTo(80)
        }
        
        let cancelBtn = UIButton()
        cancelBtn.setTitle(LockLocalizedString("cancel", comment: ""), for: .normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize:16)
        cancelBtn.setTitleColor(WVColor.WVGrayTextColor(), for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        actionsheet.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.top.left.equalTo(actionsheet)
            make.height.equalTo(56)
            make.width.equalTo(80)
        }
        
        let lineLabel = UILabel()
        lineLabel.backgroundColor = WVColor.WVTableLineColor()
        actionsheet.addSubview(lineLabel)
        lineLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(actionsheet)
            make.top.equalTo(actionsheet).offset(56)
            make.height.equalTo(1)
        }
        
        datePicker.datePickerMode = model
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        actionsheet.addSubview(datePicker)
        
        if model == .dateAndTime {
            timeLabel.font = UIFont.systemFont(ofSize:16)
            timeLabel.textColor = WVColor.WVBlackTextColor()
            timeLabel.textAlignment = .center
            actionsheet.addSubview(timeLabel)
            timeLabel.snp.makeConstraints { (make) in
                make.left.equalTo(actionsheet).offset(20)
                make.right.equalTo(actionsheet).offset(-20)
                make.top.equalTo(lineLabel.snp.bottom).offset(20)
            }
            timeLabel.text = self.timeformatter().string(from: self.datePicker.date)

            
            let lineLabel1 = UILabel()
            lineLabel1.backgroundColor = WVColor.WVTableLineColor()
            actionsheet.addSubview(lineLabel1)
            lineLabel1.snp.makeConstraints { (make) in
                make.left.right.equalTo(actionsheet)
                make.top.equalTo(timeLabel.snp.bottom).offset(20)
                make.height.equalTo(1)
            }
            
            actionsheet.snp.remakeConstraints { (make) in
                make.left.right.bottom.equalTo(self)
                make.height.equalTo(321 + 50)
            }
            
            datePicker.snp.remakeConstraints { (make) in
                make.left.right.bottom.equalTo(actionsheet)
                make.top.equalTo(actionsheet).offset(57 + 50)
            }
            
            datePicker.addTarget(self, action: #selector(timeChange), for: .valueChanged)
            
        } else {
            datePicker.snp.makeConstraints { (make) in
                make.left.right.bottom.equalTo(actionsheet)
                make.top.equalTo(actionsheet).offset(57)
            }
        }
    }
    
    @objc private func timeChange() {
        timeLabel.text = self.timeformatter().string(from: self.datePicker.date)
    }
    
    func show() {
        let window = UIApplication.shared.delegate?.window
        window!!.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalTo(window!!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    @objc func sureAction() {
        self.selectBlock?(self.format!.string(from: self.datePicker.date))
        self.removeFromSuperview()
    }
    
    @objc
    private func cancelAction() {
        self.removeFromSuperview()
    }
}
