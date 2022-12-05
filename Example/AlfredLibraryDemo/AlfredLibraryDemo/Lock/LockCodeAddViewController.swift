//
//  LockCodeAddViewController.swift
//  AlfredDemo
//
//  Created by Tianbao Wang on 2020/12/23.
//

import UIKit
import AlfredLockManager
import MBProgressHUD
import AlfredBridgeManager
import AlfredNetManager

class LockCodeAddViewController: BaseViewController,UITextFieldDelegate {
    var device: AlfredLock?
    var codeType: AlfredLockCodeType = .LockCodeType_PIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create Lock Code"
        initUIs()
    }
    
    //MARK: -- 通过蓝牙添加密钥
    private func createByBLE(_ codeIndex: Int) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        LockManager.shared().addLockCode(device?.deviceid ?? "", codeType: codeType, codeIndex: Int32(codeIndex), value: lockKeyTf.text!) { (model, error) in
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
    
    //MARK: -- 通过网关添加密钥
    private func createByBridge(_ codeIndex: Int) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        if let bridge = CacheManager.shared.getLockBindGateway(device) {
            BridgeManager.shared().addLockCode(bridge.did ?? "", subdeviceID: device?.deviceid ?? "", codeType: codeType, codeIndex: Int32(codeIndex), value: lockKeyTf.text!) { (lockCode) in
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
    
    //创建钥匙
    @objc func createAction() {
        lockKeyTf.resignFirstResponder()
        //DB系列门锁默认只有20组密钥，ML2有250组
        var availableCodeIndex:Int = 0
        var availablecodeIndexs = [Int]()
        var existcodeIndexs = [Int]()
        var error = LockLocalizedString("home_lock_setting_pin_keys_create_password_most")
        if let keys = device?.extend?.keys {
            for key in keys {
                if let index = key.index, codeType == key._type {
                    existcodeIndexs.append(Int(index)!)
                }
            }
        }
        if device?.mode == "ML2" {
            error = LockLocalizedString("home_lock_setting_ml2_pin_keys_create_password_most")
            for i in 1...250 {
                if existcodeIndexs.contains(i) {
                    continue
                }
                availablecodeIndexs.append(i)
            }
        } else {
            for i in 0...19 {
                if existcodeIndexs.contains(i) {
                    continue
                }
                availablecodeIndexs.append(i)
            }
        }

        if availablecodeIndexs.count == 0 {
            Toast.promptMessage(error)
            return
        } else {
            availableCodeIndex = availablecodeIndexs[0]
        }
        
        
        if let device = device {
            //网关模式下
            if device.connectBridge {
                self.createByBridge(availableCodeIndex)
            } else {
                //蓝牙已连接
                if device.connectState == .LockConnectState_Connected {
                    self.createByBLE(availableCodeIndex)
                } else {
                    //蓝牙未连接，需要先连接
                    self.connectLock(availableCodeIndex, device)
                }
            }
        }
    }
    
    //连接门锁蓝牙
    private func connectLock(_ codeIndex: Int, _ model: AlfredLock) {
        LockManager.shared().access(model.deviceid ?? "", timeout: 10) { (device, connectState, error) in
            self.createByBLE(codeIndex)
        } notifyCallback: { (device, obj) in
            
        }
    }
        
    private func initUIs() {
        self.view.addSubview(lockKeyTf)
        lockKeyTf.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(24)
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
            make.height.equalTo(64)
        }
        
        let msgLabel = UILabel()
        msgLabel.text = LockLocalizedString("home_lock_setting_pin_keys_create_password_detail", comment: "")
        msgLabel.textColor = WVColor.WVGrayTextColor()
        msgLabel.font = UIFont.systemFont(ofSize: 12)
        msgLabel.textAlignment = .left
        msgLabel.numberOfLines = 0
        self.view.addSubview(msgLabel)
        msgLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
            make.top.equalTo(lockKeyTf.snp.bottom).offset(20)
        }
        
        self.view.addSubview(createButton)
        createButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(msgLabel.snp.bottom).offset(82)
            make.width.equalTo(183)
            make.height.equalTo(56)
        }
    }
    
    @objc func editChange() {
        if (lockKeyTf.text?.count)! < 4 || (lockKeyTf.text?.count)! > 10 {
            createButton.backgroundColor = WVColor.WVBlueUnableColor()
            createButton.isUserInteractionEnabled = false
        } else {
            if BluetoothUtils.pinkeyLegal(lockKeyTf.text!) {
                createButton.backgroundColor = WVColor.WVBlueColor()
                createButton.isUserInteractionEnabled = true
            }
        }
    }
    
    private var createButton: UIButton = {
        let button = UIButton()
        button.setTitle(LockLocalizedString("home_lock_setting_pin_keys_create_password_create"), for: .normal)
        button.addTarget(self, action: #selector(createAction), for: .touchUpInside)
        button.backgroundColor = WVColor.WVBlueUnableColor()
        button.setTitleColor(WVColor.WVViewBackColor(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.clipsToBounds = true
        button.layer.cornerRadius = 28
        button.isUserInteractionEnabled = false
        return button
    }()

    
    private lazy var lockKeyTf: UITextField = {
        let name = UITextField()
        name.placeholder = LockLocalizedString("home_lock_setting_pin_keys_create_password_placehold")
        name.autocapitalizationType = .none
        name.returnKeyType = .done
        name.font = UIFont.systemFont(ofSize: 16)
        name.textColor = WVColor.WVTextfieldColor()
        name.delegate = self
        name.keyboardType = .numberPad
        name.addTarget(self, action: #selector(editChange), for: .editingChanged)
        name.layer.borderWidth = 1
        name.layer.borderColor = WVColor.WVBlueUnableColor().cgColor
        return name
    }()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        lockKeyTf.resignFirstResponder()
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
