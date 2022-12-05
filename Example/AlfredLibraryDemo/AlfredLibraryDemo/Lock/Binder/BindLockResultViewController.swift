//
//  BindLockResultViewController.swift
//  AlfredDemo
//
//  Created by Tianbao Wang on 2020/12/18.
//

import UIKit
import AlfredCore
import AlfredNetManager

class BindLockResultViewController: BaseViewController,UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource {
    private let tableView = UITableView(frame: CGRect(), style: .plain)
    private let cellId = "PairLockcellIdentifer"
    var device: AlfredLock?

    override func viewDidLoad() {
        super.viewDidLoad()
        initUIs()
    }
    
    //MARK: -- 修改名称
    @objc func sureAction() {
        lockNameTf.resignFirstResponder()
        var name = lockNameTf.text
        if name?.count == 0 {
            name = device?.deviceid
        }
        NetManager.shared().renameDevice(device?.deviceid ?? "", deviceDid: device?._id ?? "", deviceType: .DeviceType_DoorLock, alias: name ?? "") {
            NotificationCenter.default.post(name: NSNotification.Name("refreshDeviceList"), object: nil)
            self.PopToViewController(HomeViewController.self)
        } failure: { (error) in
            Toast.promptMessage(error.eMessage)
        }
    }
    
    func initUIs() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: nil, style: .done, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_home_"), style: .done, target: self, action: #selector(sureAction))
        
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        let tableControl = UITableViewController()
        tableControl.tableView = tableView
        self.addChild(tableControl)
        
        sethead()
    }
    
    func sethead() {
        let headView = UIView(frame: self.view.bounds)
        tableView.tableHeaderView = headView
        
        let stepIcon = UIImageView(image: UIImage(named: "stepper_4_"))
        headView.addSubview(stepIcon)
        stepIcon.snp.makeConstraints { (make) in
            make.centerX.equalTo(headView.snp.centerX)
            make.top.equalTo(headView).offset(16)
        }
        
        let iconImgView = UIImageView(image: UIImage(named: "bind_ok_"))
        headView.addSubview(iconImgView)
        iconImgView.snp.makeConstraints { (make) in
            make.centerX.equalTo(headView.snp.centerX)
            make.top.equalTo(headView).offset(56)
        }
        
        let mess1Label = UILabel()
        mess1Label.text = LockLocalizedString("add_power_gateway_step6_head")
        mess1Label.font = UIFont.systemFont(ofSize: 20)
        mess1Label.textColor = WVColor.WVBlackTextColor()
        headView.addSubview(mess1Label)
        mess1Label.snp.makeConstraints { (make) in
            make.top.equalTo(iconImgView.snp.bottom).offset(33)
            make.centerX.equalTo(headView.snp.centerX)
        }
        
        let mess2Label = UILabel()
        mess2Label.text = LockLocalizedString("add_lock_Pair_bind_lock_input_name", comment: "")
        mess2Label.font = UIFont.systemFont(ofSize: 14)
        mess2Label.textColor = WVColor.WVCommentTextColor()
        headView.addSubview(mess2Label)
        mess2Label.snp.makeConstraints { (make) in
            make.top.equalTo(mess1Label.snp.bottom).offset(25)
            make.centerX.equalTo(mess1Label.snp.centerX)
        }
        
        lockNameTf.delegate = self
        headView.addSubview(lockNameTf)
        lockNameTf.snp.makeConstraints { (make) in
            make.left.equalTo(headView).offset(24)
            make.right.equalTo(headView).offset(-24)
            make.top.equalTo(mess2Label.snp.bottom).offset(34)
            make.height.equalTo(56)
        }
        
        let sureBtn = UIButton()
        sureBtn.clipsToBounds = true
        sureBtn.backgroundColor = WVColor.WVBlueColor()
        sureBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        sureBtn.setTitle(LockLocalizedString("ok", comment: ""), for: .normal)
        sureBtn.setTitleColor(WVColor.WVViewBackColor(), for: .normal)
        sureBtn.layer.cornerRadius = 28
        sureBtn.addTarget(self, action: #selector(sureAction), for: .touchUpInside)
        headView.addSubview(sureBtn)
        sureBtn.snp.makeConstraints { (make) in
            make.top.equalTo(lockNameTf.snp.bottom).offset(80)
            make.centerX.equalTo(headView.snp.centerX)
            make.height.equalTo(56)
            make.width.equalTo(183)
        }
        self.title = LockLocalizedString("add_lock_Pair_bind_lock_success", comment: "Pairing successful")
        lockNameTf.placeholder = device?.deviceid
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private lazy var lockNameTf: UITextField = {
        let name = UITextField()
        name.placeholder = LockLocalizedString("add_lock_Pair_bind_lock_name")
        name.autocapitalizationType = .none
        name.returnKeyType = .done
        name.font = UIFont.systemFont(ofSize: 16)
        name.layer.borderWidth = 1
        name.layer.borderColor = WVColor.WVBlueUnableColor().cgColor
        name.textColor = WVColor.WVTextfieldColor()
        return name
    }()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        return cell
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
