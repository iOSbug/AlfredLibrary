//
//  GuestLockCodeScheduleViewController.swift
//  AlfredDemo
//
//  Created by Tianbao Wang on 2021/12/20.
//

import UIKit
import AlfredLockManager
import MBProgressHUD
import AlfredNetManager

class GuestLockCodeScheduleViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    private let tableView = UITableView(frame: CGRect(), style: .plain)
    private let okBtn = UIButton()
    private let headTitle = UILabel()

    private var weeks: [Int]?  //选择的星期
    private var startTime: String? //开始时间
    private var endTime: String?  //结束时间

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
            GuestLockManager.shared().setLockCodeSchedule(deviceId,
                                                          paramStr: paramStr,
                                                          codeType: lockCode?._type ?? .LockCodeType_PIN,
                                                         codeIndex: Int32(lockCode?.index ?? "0") ?? 0,
                                                         startTime: startTime!,
                                                           endTime: endTime!,
                                                          weekdays: weeks!) { (model, error) in
                MBProgressHUD.hide(for: self.view, animated: true)
                if error == .NONE_ERROR {
                    NotificationCenter.default.post(name: NSNotification.Name("refreshmykeys"), object: nil)
                    Toast.promptMessage("successful")
                    self.navigationController?.popViewController(animated: true)
                } else if error == .BLE_LOCKCODE_SCHEDULE_NUM_OVER {
                    Toast.promptMessage("You can only set up 5 groups of time plans at most.")
                } else {
                    
                }
            }

        } else if selectType == .LockCodeSchedule_Period {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            GuestLockManager.shared().setLockCodeSchedule(deviceId,
                                                          paramStr: paramStr,
                                                          codeType: lockCode?._type ?? .LockCodeType_PIN,
                                                          codeIndex: Int32(lockCode?.index ?? "0") ?? 0,
                                                          startTime: startTime!,
                                                          endTime: endTime!,
                                                          timezone: "Asia/Shanghai") { (model, error) in
                MBProgressHUD.hide(for: self.view, animated: true)
                if error == .NONE_ERROR {
                    NotificationCenter.default.post(name: NSNotification.Name("refreshmykeys"), object: nil)
                    Toast.promptMessage("successful")
                    self.navigationController?.popViewController(animated: true)
                } else if error == .BLE_LOCKCODE_SCHEDULE_NUM_OVER {
                    Toast.promptMessage("You can only set up 5 groups of time plans at most.")
                } else {
                    
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
        
        if let device = GuestLockManager.shared().getGuestDevice(deviceId, paramStr: paramStr) {
            //蓝牙已连接
            if device.connectState == .LockConnectState_Connected {
                self.setLockSchedule()
            } else {
                //蓝牙未连接，需要先连接
                self.connectLock(device)
            }
        }
    }
    
    //连接门锁蓝牙
    func connectLock(_ model: AlfredLock) {
        GuestLockManager.shared().access(model.deviceid ?? "", paramStr: paramStr, timeout: 10) { (device, connectState, error) in
            if connectState == .LockConnectState_Connected {
                self.setLockSchedule()
            }
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
