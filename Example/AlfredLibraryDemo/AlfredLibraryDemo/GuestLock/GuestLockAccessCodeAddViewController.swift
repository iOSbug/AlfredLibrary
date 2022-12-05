//
//  GuestLockAccessCodeAddViewController.swift
//  AlfredDemo
//
//  Created by Tianbao Wang on 2021/12/27.
//

import UIKit
import AlfredLockManager
import MBProgressHUD
import AlfredNetManager

class GuestLockAccessCodeAddViewController: BaseViewController {
    var codeType: AlfredLockCodeType = .LockCodeType_RFID

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create Lock Code"
        initUIs()
    }
    
    func initUIs() {
        let logoView = UIImageView(image: UIImage(named: "create_access card_"))
        self.view.addSubview(logoView)
        logoView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view).offset(48)
        }
        
        let infoLabel1 = UILabel()
        infoLabel1.textColor = WVColor.WVGrayTextColor()
        infoLabel1.font = UIFont.systemFont(ofSize: 16)
        infoLabel1.numberOfLines = 0
        infoLabel1.textAlignment = .center
        infoLabel1.text = LockLocalizedString("home_lock_setting_touch_access_keys_create_info1")
        self.view.addSubview(infoLabel1)
        infoLabel1.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(25)
            make.right.equalTo(self.view).offset(-25)
            make.top.equalTo(logoView.snp.bottom).offset(16)
        }
        
        let infoLabel2 = UILabel()
        infoLabel2.textColor = WVColor.WVGrayTextColor()
        infoLabel2.font = UIFont.systemFont(ofSize: 14)
        infoLabel2.numberOfLines = 0
        infoLabel2.textAlignment = .center
        infoLabel2.text = LockLocalizedString("home_lock_setting_touch_access_keys_create_info2")
        self.view.addSubview(infoLabel2)
        infoLabel2.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(25)
            make.right.equalTo(self.view).offset(-25)
            make.top.equalTo(infoLabel1.snp.bottom).offset(8)
        }
        
        self.view.addSubview(createButton)
        createButton.snp.makeConstraints { (make) in
            make.top.equalTo(infoLabel2.snp.bottom).offset(40)
            make.centerX.equalTo(self.view)
            make.width.equalTo(183)
            make.height.equalTo(56)
        }
    }
    
    //创建钥匙
    @objc func createAction() {
        //ML2有250组
        var availableCodeIndex:Int = 0
        var availablecodeIndexs = [Int]()
        var existcodeIndexs = [Int]()
        var error = LockLocalizedString("home_lock_setting_pin_keys_create_password_most")
        if let keys = GuestLockManager.shared().getGuestDevice(deviceId, paramStr: paramStr)?.extend?.keys {
            for key in keys {
                if let index = key.index, codeType == key._type {
                    existcodeIndexs.append(Int(index)!)
                }
            }
        }
        error = LockLocalizedString("home_lock_setting_ml2_pin_keys_create_password_most")
        for i in 1...250 {
            if existcodeIndexs.contains(i) {
                continue
            }
            availablecodeIndexs.append(i)
        }

        if availablecodeIndexs.count == 0 {
            Toast.promptMessage(error)
            return
        } else {
            availableCodeIndex = availablecodeIndexs[0]
        }
        
        if let device = GuestLockManager.shared().getGuestDevice(deviceId, paramStr: paramStr) {
            //蓝牙已连接
            if device.connectState == .LockConnectState_Connected {
                self.createByBLE(availableCodeIndex)
            } else {
                //蓝牙未连接，需要先连接
                self.connectLock(availableCodeIndex, device)
            }
        }
    }
    
    //MARK: -- 通过蓝牙添加密钥
    private func createByBLE(_ codeIndex: Int) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        GuestLockManager.shared().addLockCode(deviceId, paramStr: paramStr, codeType: codeType, codeIndex: Int32(codeIndex), value: "0") { (model, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if error == .NONE_ERROR {
                NotificationCenter.default.post(name: NSNotification.Name("refreshmykeys"), object: nil)
                Toast.promptMessage("successful")
                self.navigationController?.popViewController(animated: true)
            } else {
                if error == .CONNECTION_NOT_CREATED {
                    Toast.promptMessage("BLE Disconnect")
                } else if error == .BLE_REQUEST_TIMEOUT {
                    Toast.promptMessage("Timeout")
                }
            }
        }
    }

    //连接门锁蓝牙
    private func connectLock(_ codeIndex: Int, _ model: AlfredLock) {
        GuestLockManager.shared().access(deviceId, paramStr: paramStr, timeout: 10) { (device, connectState, error) in
            self.createByBLE(codeIndex)
        } notifyCallback: { (device, obj) in
            
        }
    }
    
    private var createButton: UIButton = {
        let button = UIButton()
        button.setTitle(LockLocalizedString("home_lock_setting_pin_keys_create_password_create"), for: .normal)
        button.addTarget(self, action: #selector(createAction), for: .touchUpInside)
        button.backgroundColor = WVColor.WVBlueColor()
        button.setTitleColor(WVColor.WVViewBackColor(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.clipsToBounds = true
        button.layer.cornerRadius = 28
        return button
    }()
}
