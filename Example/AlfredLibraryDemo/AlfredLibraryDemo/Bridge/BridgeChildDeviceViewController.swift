//
//  BridgeChildDeviceViewController.swift
//  AlfredDemo
//
//  Created by Tianbao Wang on 2020/12/28.
//

import UIKit
import MJRefresh
import MBProgressHUD
import AlfredNetManager
import AlfredBridgeManager

enum GatewayBindLockStatus {
    case binded      //已绑定门锁
    case unbind     //未绑定门锁，但有门锁
    case noLock    //未绑定门锁，没有门锁
}

class BridgeChildDeviceViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    private let tableView = UITableView(frame: CGRect(), style: .plain)
    var bridge: AlfredBridge?

    private let unbindedView = DeviceEmptyView(UIImage(named: "device_empty_"),
                                       LockLocalizedString("home_gateway_setting_child_devices_unbind_info"),
                                       LockLocalizedString("home_gateway_setting_child_devices_unbind_button"))
    private let noLockView = DeviceEmptyView(UIImage(named: "device_empty_"),
                                        LockLocalizedString("home_gateway_setting_child_devices_no_lock_info"),
                                        LockLocalizedString("home_gateway_setting_child_devices_unbind_button"))
    
    var bindLockStatus: GatewayBindLockStatus = .unbind {
        didSet {
            setUI()
        }
    }
    
    var devList = [AlfredLock]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LockLocalizedString("home_gateway_setting_child_devices_title", comment: "")
        if bridge?.info?.base?.onlineStatus == "2" {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_add_dark_"), style: .done, target: self, action: #selector(addAction))
        }
        initUIs()
    }
    
    //MARK: -- 网关解绑门锁
    func bridgeUnbindLock(_ model: AlfredLock) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        BridgeManager.shared().unpairSubdevice(bridge?.did ?? "", subdeviceID: model.deviceid ?? "") {
            MBProgressHUD.hide(for: self.view, animated: true)
            Toast.promptMessage("successful")
            NotificationCenter.default.post(name: NSNotification.Name("refreshDeviceList"), object: nil)
            self.PopToViewController(HomeViewController.self)
        } failure: { (error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            Toast.promptMessage(error?.eMessage)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLockStatus()
    }
    
    func setUI() {
        switch bindLockStatus {
        case .binded:
            setbindListView()
            getMydevices()
        case .unbind:
            setLockunBindedView()
        case .noLock:
            setNoLockBindedView()
        }
    }
    
    func setLockStatus() {
        if bridge?.slaves == nil || bridge?.slaves?.count == 0 {
            //从缓存里获取
            if CacheManager.shared.lockList.count == 0 {
                bindLockStatus = .noLock
            } else {
                bindLockStatus = .unbind
            }
        } else {
            bindLockStatus = .binded
        }
    }
    
    //绑定新的门锁
    @objc func addAction() {
        if bindLockStatus == .noLock {
            addnewLock()
        } else {
            bindLock()
        }
    }
    
    func addnewLock() {
        PushViewController(AddDeviceViewController())
    }
    
    //获取首页设备列表
    @objc func getMydevices() {
        var tempDevices = [AlfredLock]()
        for device in CacheManager.shared.lockList {
            //找到该网关下绑定的门锁数据
            if let slaves = bridge?.slaves {
                if slaves.contains(device.deviceid!) {
                    tempDevices.append(device)
                }
            }
        }
        devList = tempDevices
    }
    
    //绑定未绑定的门锁
    func bindLock() {
        let control = BridgeAssignLockViewController()
        control.bridge = bridge
        PushViewController(control)
    }
    
    //显示门锁绑定列表
    func setbindListView() {
        unbindedView.removeFromSuperview()
        noLockView.removeFromSuperview()
    }
        
    //网关未绑定门锁，但有门锁
    func setLockunBindedView() {
        unbindedView.backgroundColor = WVColor.WVViewBackColor()
        unbindedView.buttonBlock = {
            self.bindLock()
        }
        self.view.addSubview(unbindedView)
        unbindedView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        self.view.bringSubviewToFront(unbindedView)
        
        //网关离线
        unbindedView.createButton.isEnabled = true
        unbindedView.createButton.layer.borderColor = WVColor.WVBlueColor().cgColor
        unbindedView.createButton.setTitleColor(WVColor.WVBlueColor(), for: .normal)
        if bridge?.info?.base?.onlineStatus == "1" {
            unbindedView.createButton.isEnabled = false
            unbindedView.createButton.layer.borderColor = WVColor.WVdeepGrayTextColor().cgColor
            unbindedView.createButton.setTitleColor(WVColor.WVdeepGrayTextColor(), for: .normal)
        }
    }
    
    //网关未绑定门锁，但没有门锁
    func setNoLockBindedView() {
        noLockView.backgroundColor = WVColor.WVViewBackColor()
        noLockView.buttonBlock = {
            self.addnewLock()
        }
        self.view.addSubview(noLockView)
        noLockView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        self.view.bringSubviewToFront(noLockView)
    }
    
    //选择绑定的门锁
    func selectLock(_ model: AlfredLock) {
        let sheet = UIPinKeyActionSheetView([LockLocalizedString("home_gateway_setting_child_devices_removing_assignment"),
                                             LockLocalizedString("cancel")]) { (tag) in
                                                switch tag {
                                                case 0:
                                                    //解绑门锁
                                                    self.bridgeUnbindLock(model)
                                                default:
                                                    break
                                                }
        }
        sheet.show()
    }
    
    private func initUIs() {
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GatewayChildDevicesCell.self, forCellReuseIdentifier: GatewayChildDevicesCell.gatewayChildDevicesCellIdentifier)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        setheaderView()
    }
    
    private func setheaderView() {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(getMydevices))
        tableView.mj_header = header
    }
    
    //MARK: -- UItableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return devList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GatewayChildDevicesCell.gatewayChildDevicesCellIdentifier, for: indexPath as IndexPath) as! GatewayChildDevicesCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.white
        let dev = devList[indexPath.section]
        cell.setData(model: dev)
        cell.selectBlock = {
            self.selectLock(dev)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
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
}


class GatewayChildDevicesCell: UITableViewCell {
    static let gatewayChildDevicesCellIdentifier = "gatewayChildDevicesCellIdentifier"
    let nameLabel = UILabel()
    let idLabel = UILabel()
    let avatarImgView = UIImageView()
    let bgView = UIView()
    let selectBtn = UIButton()
    
    var selectBlock: (()->())?
    
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
        
        bgView.addSubview(avatarImgView)
        avatarImgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(bgView.snp.centerY)
            make.left.equalTo(bgView).offset(16)
        }
        
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.textColor = WVColor.WVBlackTextColor()
        bgView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(avatarImgView)
            make.left.equalTo(bgView).offset(94)
            make.right.equalTo(bgView).offset(-95)
        }
        
        idLabel.textAlignment = .left
        idLabel.font = UIFont.systemFont(ofSize:14)
        idLabel.textColor = WVColor.WVCommentTextColor()
        bgView.addSubview(idLabel)
        idLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(bgView.snp.centerY)
            make.left.equalTo(bgView).offset(94)
            make.right.equalTo(bgView).offset(-95)
        }
        
        selectBtn.setImage(UIImage(named: "icon_more_"), for: .normal)
        selectBtn.setImage(UIImage(named: "icon_more_"), for: .selected)
        selectBtn.addTarget(self, action: #selector(selectAction), for: .touchUpInside)
        bgView.addSubview(selectBtn)
        selectBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(bgView.snp.centerY)
            make.right.equalTo(bgView).offset(-16)
        }
    }
    
    @objc func selectAction(sender: UIButton) {
        sender.isSelected = true
        selectBlock?()
    }
    
    func setData(model: AlfredLock?) {
        nameLabel.text = model?.extend?.name
        if let deviceid = model?.deviceid  {
            idLabel.text = "ID:" + deviceid
        }
        avatarImgView.image = UIImage(named: "bind_device_")
    }
}
