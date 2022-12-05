//
//  LockAdminPwdViewController.swift
//  AlfredDemo
//
//  Created by Tianbao Wang on 2020/12/21.
//

import UIKit
import AlfredCore
import AlfredLockManager

class LockAdminPwdViewController: BaseViewController,UITextFieldDelegate {
    var device: AlfredLock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LockLocalizedString("home_lock_setting_change_admin_password", comment: "")
        initUIs()
    }
    
    //MARK: -- 修改管理员密码（蓝牙）
    func changeAdminPwd() {
        LockManager.shared().setConfig(device?.deviceid ?? "", configID: .LockRequestConfig_MasterPinCode, values: nPasswordTf.text ?? "") { (model, error) in
            if error == .NONE_ERROR {
                Toast.promptMessage("successful")
            }
        }
    }
    
    @objc func sureAction() {
        nPasswordTf.resignFirstResponder()
        //蓝牙已连接
        if let device = device {
            if device.connectState == .LockConnectState_Connected {
                self.changeAdminPwd()
            } else {
                //蓝牙未连接，需要先连接
                self.connectLock(device)
            }
        }
    }
    
    //连接门锁蓝牙
    func connectLock(_ model: AlfredLock) {
        LockManager.shared().access(model.deviceid ?? "", timeout: 10) { (device, connectState, error) in
            self.changeAdminPwd()
        } notifyCallback: { (device, obj) in
            
        }
    }
    
    func initUIs() {
        self.view.addSubview(nPasswordTf)
        nPasswordTf.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
            make.top.equalTo(self.view).offset(24)
            make.height.equalTo(56)
        }
        
        let ruleLabel = UILabel()
        ruleLabel.text = LockLocalizedString("home_change_admin_password_info_msg", comment: "")
        ruleLabel.textAlignment = .left
        ruleLabel.numberOfLines = 0
        ruleLabel.font = UIFont.systemFont(ofSize: 8)
        ruleLabel.textColor = WVColor.WVCommentTextColor()
        self.view.addSubview(ruleLabel)
        ruleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(24)
            make.top.equalTo(nPasswordTf.snp.bottom).offset(20)
            make.right.equalTo(self.view).offset(-24)
        }
        
        self.view.addSubview(okBtn)
        okBtn.snp.makeConstraints { (make) in
            make.top.equalTo(ruleLabel.snp.bottom).offset(24)
            make.centerX.equalTo(self.view.snp.centerX)
            make.height.equalTo(56)
            make.width.equalTo(183)
        }
    }
        
    private var okBtn: UIButton = {
        let button = UIButton()
        button.setTitle(LockLocalizedString("ok"), for: .normal)
        button.addTarget(self, action: #selector(sureAction), for: .touchUpInside)
        button.backgroundColor = WVColor.WVBlueUnableColor()
        button.setTitleColor(WVColor.WVViewBackColor(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.clipsToBounds = true
        button.layer.cornerRadius = 28
        button.isUserInteractionEnabled = false
        return button
    }()
    
    lazy var nPasswordTf: UITextField = {
        let password = UITextField()
        password.placeholder = LockLocalizedString("home_lock_setting_change_admin_password_new", comment: "Admin password")
        password.translatesAutoresizingMaskIntoConstraints = false
        password.autocapitalizationType = .words
        password.backgroundColor = .white
        password.returnKeyType = .done
        password.keyboardType = .numberPad
        password.delegate = self
        password.layer.borderWidth = 1
        password.layer.borderColor = WVColor.WVBlueUnableColor().cgColor
        password.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        return password
    }()
    
    @objc
    private func textFieldValueChanged() {
        if ((nPasswordTf.text?.count)! < 4 ||
            (nPasswordTf.text?.count)! > 10) {
            okBtn.backgroundColor = WVColor.WVBlueUnableColor()
            okBtn.isUserInteractionEnabled = false
        } else {
            if BluetoothUtils.pinkeyLegal(nPasswordTf.text!) {
                okBtn.backgroundColor = WVColor.WVBlueColor()
                okBtn.isUserInteractionEnabled = true
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        nPasswordTf.resignFirstResponder()
    }

}
