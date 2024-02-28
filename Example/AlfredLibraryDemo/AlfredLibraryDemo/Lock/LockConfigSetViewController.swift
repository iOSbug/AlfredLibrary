//
//  LockConfigSetViewController.swift
//  AlfredDemo
//
//  Created by Tianbao Wang on 2020/12/21.
//

import UIKit
import MBProgressHUD
import AlfredCore
import AlfredLockManager
import AlfredBridgeManager
import AlfredNetManager

class LockConfigSetViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    private let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    private let thinTableCellId = "thinTableCellId"
    private let configSetItem = WVSwitchTableItem()
    private var itemGroups: [WVTableGroup] = []
    private let slider = UISlider()
    private let radiusLabel = UILabel()
    var viewType: AlfredLockRequestConfig = .LockRequestConfig_AwayMode
    var device: AlfredLock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
    }
    
    //MARK: -- 设置开关
    private func setLockParams(_ ison: Bool) {
        let value: String = ison ? "1" : "0"
        if let device = device {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            if device.connectBridge {
                //网关连接下
                if let bridge = CacheManager.shared.getLockBindGateway(device) {
                    BridgeManager.shared().setLockConfig(bridge.did ?? "", subdeviceID: device.deviceid ?? "", configID: viewType, values: value) {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        Toast.promptMessage("successful")
                    } failure: { (error) in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.configSetItem.matSwitchOn = !ison
                        self.tableView.reloadData()
                    }
                }
            } else {
                LockManager.shared().setConfig(device.deviceid ?? "", configID:viewType , values: value) { (model, error) in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    if error == .NONE_ERROR {
                        Toast.promptMessage("successful")
                    } else {
                        self.configSetItem.matSwitchOn = !ison
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    
    //开关
    private func showSwitchlock(_ isOn: Bool) {
        //开门情况下不能设置反锁
        if (viewType == .LockRequestConfig_InsideDeadLock || viewType == .LockRequestConfig_AwayMode) && isOn {
            if let device = device {
                if (device.connectState == .LockConnectState_Connected || device.connectBridge) && (device.lockState == AlfredLockStatus.LockState_Unlocked) {
                    Toast.promptMessage(LockLocalizedString("home_share_lock_setting_fail_dooropen", comment: ""))
                    self.configSetItem.matSwitchOn = !isOn
                    self.tableView.reloadData()
                    return
                }
            }
        }
        
        if let device = device {
            if device.connectBridge {
                //绑定网关的情况下，不能设置节电模式
                if viewType == .LockRequestConfig_PowerSafe {
                    Toast.promptMessage(LockLocalizedString("home_setting_hub_powersave_unset_tip"))
                    self.configSetItem.matSwitchOn = !isOn
                    self.tableView.reloadData()
                    return
                }
                self.setLockParams(isOn)
            } else {
                //蓝牙已连接
                if device.connectState == .LockConnectState_Connected {
                    self.setLockParams(isOn)
                } else {
                    //蓝牙未连接，需要先连接
                    self.connectLock(device,isOn)
                }
            }
        }
    }
    
    //连接门锁蓝牙
    private func connectLock(_ model: AlfredLock,_ ison: Bool) {
        LockManager.shared().access(model.deviceid ?? "", timeout: 10) { (device, connectState, error) in
            self.setLockParams(ison)
        } notifyCallback: { (device, obj) in
            
        }
    }

    
    private func initData() {
        if viewType == .LockRequestConfig_InsideDeadLock {
            configSetItem.title = LockLocalizedString("home_lock_setting_anti_lock_title", comment: "Anti-lock")
            //反锁
            if let antilockState = device?.extend?.insidelock {
                configSetItem.matSwitchOn = (antilockState == "0") ? true : false
            }
            if device?.mode == "ML2" || device?.mode == "DB2S" {
                configSetItem.switchEnable = false
            }
        } else if viewType == .LockRequestConfig_Auto {
            configSetItem.title = LockLocalizedString("home_lock_setting_auto_lock_title", comment: "Auto-lock")
            //自动
            if let autoState = device?.extend?.autolock {
                configSetItem.matSwitchOn = (autoState == "1") ? true : false
            }
        } else if viewType == .LockRequestConfig_AwayMode {
            configSetItem.title = LockLocalizedString("home_lock_setting_leave_mode_title", comment: "Away Mode")
            //布防
            if let armingState = device?.extend?.leavemode {
                configSetItem.matSwitchOn = (armingState == "1") ? true : false
            }
            if device?.mode == "ML2" || device?.mode == "DB2S" {
                configSetItem.switchEnable = false
            }
        } else if viewType == .LockRequestConfig_PowerSafe {
            configSetItem.title = LockLocalizedString("home_lock_setting_power_save_title", comment: "Power save")
            //节电
            if let powersave = device?.extend?.powersave {
                configSetItem.matSwitchOn = (powersave == "1") ? true : false
            }
        }
        
        self.title = configSetItem.title

        configSetItem.matSwitchTarget = { [weak self] (ison) in
            self?.showSwitchlock(ison)
        }
        
        let group0 = WVTableGroup()
        group0.items = [configSetItem]
        itemGroups = [group0]
        
        tableView.reloadData()
    }

    
    private func initUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 56
        tableView.backgroundColor = WVColor.WVViewBackColor()
        tableView.register(CommSwitchCell.self, forCellReuseIdentifier: thinTableCellId)
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    // tableview delegate datasource
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headview = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20))
        return headview
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
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
