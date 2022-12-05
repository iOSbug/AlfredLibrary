//
//  BridgeSettingsViewController.swift
//  AlfredDemo
//
//  Created by Tianbao Wang on 2020/12/28.
//

import UIKit
import MBProgressHUD
import AlfredLibrary
import AlfredBridgeBinder

class BridgeSettingViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    private let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    private let thinTableCellId = "thinTableCellId"
    
    private let childDevicesItem = WVTableItem()
    private let timezoneItem = WVTableItem()
    private let networkItem = WVTableItem()
    
    private let renameItem = WVTableItem()
    private let deviceinfoItem = WVTableItem()
    
    private var itemGroups: [WVTableGroup] = []
    let hubNameLabel = UILabel()
    let connectBtn = UIButton()

    var bridge: AlfredBridge? //网关id
    private var timeZones: [[AlfredTimeConfig]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LockLocalizedString("home_lock_setting_title")
        initUI()
        initData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    //查看network
    func showNetwork() {
//        let control = GatewayPowerViewController()
//        control.hubType = .configHub
//        control.gatewayId = gatewayId
//        PushViewController(control)
    }
    
    //查看timezone
    func showTimezone() {
        //网关离线
        if bridge?.info?.base?.onlineStatus == "1" {
            return
        }
//        if bridge?.info?.capability?.timeZoneVersion ?? "0")! > 0 ||
//            Int(bridge?.info?.capability?.newtz ?? "0")! > 0 {
            let timeZones = BridgeTimezoneViewController()
            let timezone = AlfredTimeConfig()
            timezone.tzName = bridge?.info?.timeConfig?.tzName
            timezone.tzGmt = bridge?.info?.timeConfig?.tzGmt
            timezone.tzValue = bridge?.info?.timeConfig?.tzValue
            timezone.tzUtc = bridge?.info?.timeConfig?.tzUtc
            timezone.tzString = bridge?.info?.timeConfig?.tzString
            timeZones.selectTimezone = timezone
            timeZones.bridge = bridge
            PushViewController(timeZones)
//
//        } else {
//            let timeZones = TimeZoneViewController()
//            timeZones.deviceId = gatewayId
//            timeZones.timeConfig = getGatewayById(gatewayId)?.info?.timeConfig
//            PushViewController(timeZones)
//        }
    }
    
    //查看child devices
    func showChildDevices() {
        let control = BridgeChildDeviceViewController()
        control.bridge = bridge
        PushViewController(control)
    }
    
    //查看名称修改
    @objc func showRename() {
        let control = BridgeRenameViewController()
        control.bridge = bridge
        PushViewController(control)
    }
    
    //设备详情
    func showDeviceInfo() {
        let control = BridgeInfoViewController()
        control.bridge = bridge
        PushViewController(control)
    }
    
    //MARK: -- 解绑设备
    @objc func deleteDevice() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        BridgeBinder.shared().unbindDevice(bridge?.did ?? "") {
            MBProgressHUD.hide(for: self.view, animated: true)
            Toast.promptMessage("successful")
            NotificationCenter.default.post(name: NSNotification.Name("refreshDeviceList"), object: nil)
            self.PopToViewController(HomeViewController.self)
        } failure: { (error, msg) in
            MBProgressHUD.hide(for: self.view, animated: true)
            Toast.promptMessage(msg)
        }
    }
        
    func refreshData() {
        if let slaves = bridge?.slaves {
            childDevicesItem.comment = "\(slaves.count)"
        } else {
            childDevicesItem.comment = "0"
        }
        networkItem.comment = bridge?.info?.networkConfig?.ssid
        if let timeZoneVersion = bridge?.info?.capability?.timeZoneVersion, Int(timeZoneVersion)! > 0 {
            timezoneItem.comment = bridge?.info?.timeConfig?.tzDistrict ?? bridge?.info?.timeConfig?.tzName
        }
//        else {
//            timezoneItem.comment = getLocalTimezonesTzNameToEn(bridge?.info?.timeConfig?.tzName)
//        }
        
        hubNameLabel.text = bridge?.info?.base?.aliasName

        // 离线 - 1, 在线 - 2, 升级中 - 4, 休眠中 -8
        if let onlineStatus = bridge?.info?.base?.onlineStatus {
            if onlineStatus == "2" {
                connectBtn.setTitle(" " + LockLocalizedString("home_device_gateway_status_online", comment: "online"), for: .normal)
                connectBtn.setImage(UIImage(named: "icon_Wi-Fi_signal_2_"), for: .normal)
                if let wifiSignal = bridge?.info?.networkConfig?.wifiSignal {
                    if let _wifiSignal = Int(wifiSignal) {
                        if _wifiSignal >= 0 || _wifiSignal < -85 {
                            connectBtn.setImage(UIImage(named: "icon_Wi-Fi_signal_0_"), for: .normal)
                        } else if _wifiSignal < -70 {
                             connectBtn.setImage(UIImage(named: "icon_Wi-Fi_signal_1_"), for: .normal)
                        } else if _wifiSignal < -55 {
                            connectBtn.setImage(UIImage(named: "icon_Wi-Fi_signal_2_"), for: .normal)
                        } else {
                            connectBtn.setImage(UIImage(named: "icon_Wi-Fi_signal_3_"), for: .normal)
                        }
                    }
                }
            } else if onlineStatus == "4" {
                connectBtn.setTitle(" " + LockLocalizedString("home_device_gateway_status_offline", comment: "offline"), for: .normal)
                connectBtn.setImage(UIImage(named: "icon_Wi-Fi_signal_0_"), for: .normal)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.tableView.reloadData()
        }
    }
    
//    func getLocalTimezonesTzNameToEn(_ tzName: String?) -> String? {
//        if timeZones.count == 0 {
//            if let jsonPath = Bundle.main.path(forResource: "TimeZone_new", ofType: "json") {
//                if let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) {
//                    do  {
//                        let jsonDic = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String, Any>
//
//                        if let res = JSONDeserializer<TimeZones>.deserializeFrom(dict: jsonDic!) {
//                            if let timeZones = res.timeZones {
//                                self.timeZones.append(timeZones)
//                            }
//                        }
//                    } catch {
//                        DLog("----- \(error.localizedDescription)")
//                    }
//                }
//            }
//        }
//
//        var selectTimz: CameraTimeZone?
//        for timezs in timeZones {
//            for timez in timezs {
//                if timez.tzName?.lowercased() == tzName?.lowercased() {
//                    selectTimz = timez
//                    break
//                }
//            }
//        }
//        return selectTimz?.en
//    }
    
    func initData() {
        var gatewayitems = [WVTableItem]()
        childDevicesItem.icon = UIImage(named: "icon_child device_")
        childDevicesItem.title = LockLocalizedString("home_gateway_setting_child_devices_title", comment: "Child devices")
        childDevicesItem.showAccessory = true
        childDevicesItem.execute = { [weak self] in
            self?.showChildDevices()
        }
        gatewayitems.append(childDevicesItem)
        
        timezoneItem.icon = UIImage(named: "icon_time zone_")
        timezoneItem.title = LockLocalizedString("home_gateway_setting_time_zone_title", comment: "Time zone")
        timezoneItem.showAccessory = true
        timezoneItem.execute = { [weak self] in
            self?.showTimezone()
        }
        gatewayitems.append(timezoneItem)

        networkItem.icon = UIImage(named: "icon_network_")
        networkItem.title = LockLocalizedString("home_gateway_setting_network_title", comment: "Network")
        networkItem.showAccessory = true
        networkItem.execute = { [weak self] in
            self?.showNetwork()
        }
        gatewayitems.append(networkItem)
        
        
        var deviceparametersitems = [WVTableItem]()
        renameItem.icon = UIImage(named: "icon_edit_")
        renameItem.title = LockLocalizedString("home_lock_setting_name_title", comment: "Name")
        renameItem.showAccessory = true
        renameItem.accessoryCustomImage = UIImage(named: "arrow_right")
        renameItem.execute = { [weak self] in
            self?.showRename()
        }
        deviceparametersitems.append(renameItem)
        
        deviceinfoItem.icon = UIImage(named: "icon_about_")
        deviceinfoItem.title = LockLocalizedString("lock_device_infomation_title", comment: "Device information")
        deviceinfoItem.showAccessory = true
        deviceinfoItem.accessoryCustomImage = UIImage(named: "arrow_right")
        deviceinfoItem.execute = {  [weak self] in
            self?.showDeviceInfo()
        }
        deviceparametersitems.append(deviceinfoItem)
        
        let group1 = WVTableGroup()
        group1.items = deviceparametersitems
                
        let group0 = WVTableGroup()
        group0.items = gatewayitems
        itemGroups = [group0,group1]
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
        setHeadView()
        setFootView()
    }
    
    func setHeadView() {
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 124))
        tableView.tableHeaderView = headView
        
        let logoImgView = UIImageView(image: UIImage(named: "setting_GW of lock_"))
        headView.addSubview(logoImgView)
        logoImgView.snp.makeConstraints { (make) in
            make.left.equalTo(headView).offset(24)
            make.top.equalTo(headView).offset(34)
            make.height.width.equalTo(60)
        }
        
        hubNameLabel.textAlignment = .left
        hubNameLabel.font = UIFont.systemFont(ofSize: 20)
        hubNameLabel.textColor = WVColor.WVBlackTextColor()
        headView.addSubview(hubNameLabel)
        hubNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headView).offset(24)
            make.left.equalTo(headView).offset(94)
            make.right.equalTo(headView).offset(-40)
        }
        
        connectBtn.titleLabel?.font = UIFont.systemFont(ofSize:14)
        connectBtn.setTitleColor(WVColor.WVCommentTextColor(), for: .normal)
        headView.addSubview(connectBtn)
        connectBtn.snp.makeConstraints { (make) in
            make.left.equalTo(headView).offset(94)
            make.centerY.equalTo(logoImgView)
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
        cell.selectionStyle = .none
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
        return 16
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 16))
        return headView
    }
}
