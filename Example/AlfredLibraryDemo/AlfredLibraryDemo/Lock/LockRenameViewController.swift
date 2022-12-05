//
//  LockRenameViewController.swift
//  AlfredDemo
//
//  Created by Tianbao Wang on 2020/12/21.
//

import UIKit
import AlfredCore
import AlfredNetManager
import MBProgressHUD

class LockRenameViewController: BaseViewController,UITextFieldDelegate  {
    var device: AlfredLock?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LockLocalizedString("home_lock_setting_rename_title", comment: "")
        initUIs()
    }
    
    //MARK: -- 修改名称
    @objc func renameAction() {
        nameTf.resignFirstResponder()
        if nameTf.text?.count == 0 {
            Toast.promptMessage(LockLocalizedString("home_lock_setting_rename_textfield_input_title", comment: ""))
            return
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NetManager.shared().renameDevice(device?.deviceid ?? "",
                                         deviceDid: device?._id ?? "",
                                         deviceType: .DeviceType_DoorLock,
                                         alias: nameTf.text ?? "") {
            MBProgressHUD.hide(for: self.view, animated: true)
            self.device?.extend?.name = self.nameTf.text
            NotificationCenter.default.post(name: NSNotification.Name("refreshDeviceList"), object: nil)
            Toast.promptMessage("successful")
        } failure: { (error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            Toast.promptMessage(error.eMessage)
        }
    }
    
    func initUIs() {
        nameTf.clearButtonMode = .whileEditing
        nameTf.delegate = self
        nameTf.text = device?.extend?.name
        nameTf.placeholder = LockLocalizedString("home_lock_setting_rename_lock_textfield_title")

        self.view.addSubview(nameTf)
        nameTf.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
            make.top.equalTo(self.view).offset(24)
            make.height.equalTo(56)
        }
        
        self.view.addSubview(okBtn)
        okBtn.snp.makeConstraints { (make) in
            make.height.equalTo(56)
            make.top.equalTo(nameTf.snp.bottom).offset(50)
            make.width.equalTo(183)
            make.centerX.equalTo(self.view.snp.centerX)
        }
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private lazy var okBtn: UIButton = {
        let button = UIButton()
        button.setTitle(LockLocalizedString("ok"), for: .normal)
        button.addTarget(self, action: #selector(renameAction), for: .touchUpInside)
        button.backgroundColor = WVColor.WVBlueColor()
        button.setTitleColor(WVColor.WVViewBackColor(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.clipsToBounds = true
        button.layer.cornerRadius = 28
        return button
    }()
    
    private lazy var nameTf: UITextField = {
        let name = UITextField()
        name.placeholder = LockLocalizedString("home_lock_setting_rename_textfield_title")
        name.autocapitalizationType = .none
        name.returnKeyType = .done
        name.font = UIFont.systemFont(ofSize: 16)
        name.textColor = WVColor.WVTextfieldColor()
        name.layer.borderWidth = 1
        name.layer.borderColor = WVColor.WVBlueUnableColor().cgColor
        return name
    }()

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
