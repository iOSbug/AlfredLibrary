//
//  BridgeAssignLockViewController.swift
//  AlfredDemo
//
//  Created by Tianbao Wang on 2020/12/28.
//

import UIKit
import AlfredNetManager
import AlfredLockManager
import AlfredBridgeManager
import MBProgressHUD

class BridgeAssignLockViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    private let tableView = UITableView(frame: CGRect(), style: .plain)
    private var devList = [AlfredLock]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var selectDev: AlfredLock? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var bridge: AlfredBridge?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LockLocalizedString("home_device_gateway_bind_assign_lock_to_gateway_title", comment: "")
        LockManager.shared().disconnect()
        initUIs()
    }
    
    //MARK: -- 网关关联门锁
    func assignLock() {
        //主机绑定门锁前，先主动断开蓝牙连接防止，app一直连接蓝牙导致主机搜索不到
        LockManager.shared().disconnect()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        BridgeManager.shared().pairSubdevice(bridge?.did ?? "", subdeviceID: selectDev?.deviceid ?? "") {
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
        getMydevices()
    }
    
    //将我的设备和分享设备分离
    func getMydevices() {
        var tempDevices = [AlfredLock]()
        for device in CacheManager.shared.lockList {
            tempDevices.append(device)
        }
        devList = tempDevices
    }
    
    //网关绑定门锁查询可绑定req
    @objc func sureAction() {
        if self.selectDev == nil {
            Toast.promptMessage(LockLocalizedString("add_assign_lock_to_gatway_select_device_error"))
            return
        }
        
        //节电(1表示蓝牙常开（非节电），0表示蓝牙关闭（节电）)
        if let powersave = self.selectDev?.extend?.powersave {
            if powersave == "1" {
                showpowersaveView()
                return
            }
        }
        assignLock()
    }

    //显示节电view
    func showpowersaveView() {
        let powersave = PowersaveView()
        powersave.okBlock = {
            self.assignLock()
        }
        powersave.show()
    }
    
    private func initUIs() {
        let assignBtn = UIButton()
        assignBtn.setTitle(LockLocalizedString("add_assign_button", comment: ""), for: .normal)
        assignBtn.backgroundColor = WVColor.WVBlueColor()
        assignBtn.setTitleColor(WVColor.WVViewBackColor(), for: .normal)
        assignBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        assignBtn.addTarget(self, action: #selector(sureAction), for: .touchUpInside)
        self.view.addSubview(assignBtn)
        assignBtn.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(self.view)
            make.height.equalTo(56)
        }
        
        let tipLabel = UILabel()
        //绑定第一个设备提示
        tipLabel.text = LockLocalizedString("home_gateway_setting_child_devices_bind_first_lock_tip")
        tipLabel.textAlignment = .center
        tipLabel.numberOfLines = 0
        tipLabel.font = UIFont.systemFont(ofSize:12)
        tipLabel.textColor = WVColor.WVCommentTextColor()
        self.view.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(24)
            make.bottom.equalTo(assignBtn.snp.top).offset(-13)
            make.right.equalTo(self.view).offset(-24)
        }
        
        if let gateway = bridge {
            if let slaves = gateway.slaves {
                //绑定第二个设备提示
                if slaves.count >= 1 {
                    tipLabel.text = LockLocalizedString("home_gateway_setting_child_devices_bind_sec_lock_tip")
                }
            }
        }
        
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AssignLockToGatewayCell.self, forCellReuseIdentifier: AssignLockToGatewayCell.assignLockToGatewayCellIdentifier)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
            make.bottom.equalTo(tipLabel.snp.top).offset(-20)
        }
        setHeadView()
    }
    
    func setHeadView() {
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        tableView.tableHeaderView = headView
        
        let title = UILabel()
        title.text = LockLocalizedString("home_gateway_setting_child_devices_bindlock_tip")
        title.textAlignment = .center
        title.numberOfLines = 0
        title.font = UIFont.systemFont(ofSize:12)
        title.textColor = WVColor.WVCommentTextColor()
        headView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.left.equalTo(headView).offset(24)
            make.top.equalTo(headView).offset(13)
            make.right.equalTo(headView).offset(-24)
        }
    }
    
    //MARK: -- UItableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return devList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AssignLockToGatewayCell.assignLockToGatewayCellIdentifier, for: indexPath as IndexPath) as! AssignLockToGatewayCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.white
        let dev = devList[indexPath.section]
        cell.setData(model: dev, select: selectDev)
        cell.selectBlock = {
            self.selectDev = dev
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


class AssignLockToGatewayCell: UITableViewCell {
    static let assignLockToGatewayCellIdentifier = "assignLockToGatewayCellIdentifier"
    let nameLabel = UILabel()
    let idLabel = UILabel()
    let avatarImgView = UIImageView()
    let bgView = UIView()

    let selectBtn = UIButton()
    let beenbound = UIButton()

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
        idLabel.font = UIFont.systemFont(ofSize: 14)
        idLabel.textColor = WVColor.WVCommentTextColor()
        bgView.addSubview(idLabel)
        idLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(bgView.snp.centerY)
            make.left.equalTo(bgView).offset(94)
            make.right.equalTo(bgView).offset(-95)
        }
        
        selectBtn.setImage(UIImage(named: "icon_select-off_big_"), for: .normal)
        selectBtn.setImage(UIImage(named: "icon_select-on_big_"), for: .selected)
        selectBtn.addTarget(self, action: #selector(selectAction), for: .touchUpInside)
        bgView.addSubview(selectBtn)
        selectBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(bgView.snp.centerY)
            make.right.equalTo(bgView).offset(-16)
        }
        
        beenbound.isHidden = true
        beenbound.setTitle(LockLocalizedString("add_lock_been_bound", comment: ""), for: .normal)
        beenbound.setTitleColor(WVColor.WVYellowColor(), for: .normal)
        beenbound.clipsToBounds = true
        beenbound.layer.borderWidth = 1
        beenbound.layer.borderColor = WVColor.WVYellowColor().cgColor
        beenbound.layer.cornerRadius = 10
        beenbound.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        bgView.addSubview(beenbound)
        beenbound.snp.makeConstraints { (make) in
            make.right.equalTo(bgView).offset(-20)
            make.height.equalTo(20)
            make.width.equalTo(56)
            make.centerY.equalTo(bgView.snp.centerY)
        }
    }
    
    @objc func selectAction(sender: UIButton) {
        sender.isSelected = true
        selectBlock?()
    }
    
    func setData(model: AlfredLock?, select: AlfredLock?) {
        nameLabel.text = model?.extend?.name
        if let deviceid = model?.deviceid  {
            idLabel.text = "ID:" + deviceid
        }
        avatarImgView.image = UIImage(named: "bind_device_")
        //门锁未被绑定
        if CacheManager.shared.getLockBindGateway(model) == nil {
            selectBtn.isHidden = false
            beenbound.isHidden = true
            nameLabel.textColor = WVColor.WVBlackTextColor()
            idLabel.textColor = WVColor.WVCommentTextColor()

        } else {
            selectBtn.isHidden = true
            beenbound.isHidden = false
            nameLabel.textColor = WVColor.WVGrayTextColor()
            idLabel.textColor = WVColor.WVdeepGrayTextColor()
        }
        
        if model?._id == select?._id {
            selectBtn.isSelected = true
        } else {
            selectBtn.isSelected = false
        }
    }
    
    func setResultData(model: AlfredLock?, result: Bool) {
        nameLabel.text = model?.extend?.name
        if let deviceid = model?.deviceid  {
            idLabel.text = "ID:" + deviceid
        }
        avatarImgView.image = UIImage(named: "bind_device_")
        beenbound.isHidden = true
        if result {
            selectBtn.setImage(UIImage(named: "pair-L2G_ok_"), for: .normal)
        } else {
            selectBtn.setImage(UIImage(named: "pair-L2G_failure_"), for: .normal)
        }
    }
}


class PowersaveView: UIView {
    var okBlock:(()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUIs()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        let window = UIApplication.shared.delegate?.window
        window!!.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalTo(window!!)
        }
    }
    
    @objc func dismis() {
        self.removeFromSuperview()
    }
    
    private func initUIs() {
        self.backgroundColor = WVColor.WVGrayLoadColor()
        
        let whiteView = UIView()
        whiteView.backgroundColor = UIColor.white
        self.addSubview(whiteView)
        
        let headView = UIView()
        headView.backgroundColor = UIColor.white
        whiteView.addSubview(headView)
        headView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(whiteView)
            make.height.equalTo(50)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = LockLocalizedString("add_power_gateway_step6_assign_lock_powersave_title", comment: "")
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = WVColor.WVBlackTextColor()
        headView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalTo(headView.snp.center)
        }
        
        let lineLabel = UILabel()
        lineLabel.backgroundColor = WVColor.WVTableLineColor()
        headView.addSubview(lineLabel)
        lineLabel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(headView)
            make.height.equalTo(0.5)
        }
        
        let iconimgView = UIImageView(image: UIImage(named: "bind_step1_"))
        whiteView.addSubview(iconimgView)
        iconimgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(whiteView.snp.centerX)
            make.top.equalTo(lineLabel.snp.bottom).offset(16)
        }
        
        let ruleLabel = UILabel()
        ruleLabel.text = LockLocalizedString("add_power_gateway_step6_assign_lock_powersave_info", comment: "")
        ruleLabel.textAlignment = .center
        ruleLabel.numberOfLines = 0
        ruleLabel.font = UIFont.systemFont(ofSize:14)
        ruleLabel.textColor = WVColor.WVBlackTextColor()
        whiteView.addSubview(ruleLabel)
        ruleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(whiteView).offset(16)
            make.top.equalTo(iconimgView.snp.bottom).offset(16)
            make.right.equalTo(whiteView).offset(-16)
        }
        
        let okBtn = UIButton()
        okBtn.layer.cornerRadius = 24
        okBtn.clipsToBounds = true
        okBtn.layer.borderColor = WVColor.WVBlueColor().cgColor
        okBtn.layer.borderWidth = 1
        okBtn.setTitle(LockLocalizedString("add_i_know"), for: .normal)
        okBtn.setTitleColor(WVColor.WVBlueColor(), for: .normal)
        okBtn.titleLabel?.font = UIFont.systemFont(ofSize:14)
        okBtn.addTarget(self, action: #selector(sureAction), for: .touchUpInside)
        whiteView.addSubview(okBtn)
        okBtn.snp.makeConstraints { (make) in
            make.top.equalTo(ruleLabel.snp.bottom).offset(24)
            make.centerX.equalTo(whiteView.snp.centerX)
            make.height.equalTo(48)
            make.width.equalTo(144)
        }
        
        whiteView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(24)
            make.right.equalTo(self).offset(-24)
            make.top.equalTo(self).offset(64)
            make.bottom.equalTo(okBtn.snp.bottom).offset(20)
        }
    }
    
    @objc func sureAction() {
        okBlock?()
        self.dismis()
    }
}
