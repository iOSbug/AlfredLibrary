//
//  BindLockViewController.swift
//  AlfredDemo
//
//  Created by Tianbao Wang on 2020/12/15.
//

import UIKit
import AlfredCore
import AlfredLockBinder
import MBProgressHUD

class BindLockViewController: BaseViewController,UITextFieldDelegate {
    var bindModel: AlfredDeviceBindStatus?
    private let adminView = UIView()
    private let loadView = UIView()
    private let failView = UIView()
    private let messTitleLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LockLocalizedString("add_lock_Pair_lock_to_app_step_3", comment: "Pair lock to app")
        initUIs()
    }
    
    //MARK: -- 绑定门锁
    @objc func nextAction() {
        passwordTf.resignFirstResponder()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        LockBinder.shared().registerDevice(bindModel!, masterPincode: passwordTf.text!) {(lock) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.enterBindSuccessVC(device: lock)
        } failure: { (err, msg) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if err == AlfredError.MASTERPINCODE_ERROR {
                //管理员密码错误
                Toast.promptMessage(LockLocalizedString("add_lock_Pair3_admin_password_error"))
            }
        }

    }
    
    func setAdmin() {
        self.view.addSubview(adminView)
        adminView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(messTitleLabel.snp.bottom).offset(20)
        }
        
        adminView.addSubview(passwordTf)
        passwordTf.snp.makeConstraints { (make) in
            make.left.equalTo(adminView).offset(24)
            make.right.equalTo(adminView).offset(-24)
            make.top.equalTo(adminView).offset(10)
            make.height.equalTo(56)
        }
        adminView.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTf.snp.bottom).offset(95)
            make.centerX.equalTo(adminView.snp.centerX)
            make.height.equalTo(56)
            make.width.equalTo(183)
        }
        self.view.bringSubviewToFront(adminView)
    }
    
    func removeAdmin() {
        adminView.removeFromSuperview()
    }
    
    
    func initUIs() {
        let stepIcon = UIImageView(image: UIImage(named: "stepper_3_"))
        self.view.addSubview(stepIcon)
        stepIcon.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.view).offset(11)
        }
        
        messTitleLabel.textAlignment = .center
        messTitleLabel.numberOfLines = 0
        messTitleLabel.text = LockLocalizedString("add_lock_Pair3_title_info", comment: "")
        messTitleLabel.font = UIFont.systemFont(ofSize: 20)
        messTitleLabel.textColor = WVColor.WVBlackTextColor()
        self.view.addSubview(messTitleLabel)
        messTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
            make.top.equalTo(stepIcon.snp.bottom).offset(16)
        }
        setAdmin()
    }
    
    //绑定成功页面
    func enterBindSuccessVC(device: AlfredLock?) {
        let control = BindLockResultViewController()
        control.device = device
        PushViewController(control)
    }
    
    private lazy var passwordTf: UITextField = {
        let password = UITextField()
        password.placeholder = LockLocalizedString("add_lock_Pair3_admin_password", comment: "Admin password")
        password.translatesAutoresizingMaskIntoConstraints = false
        password.autocapitalizationType = .words
        password.backgroundColor = .white
        password.layer.borderWidth = 1
        password.layer.borderColor = WVColor.WVBlueUnableColor().cgColor
        password.returnKeyType = .done
        password.keyboardType = .numberPad
        password.delegate = self
        password.addTarget(self, action: #selector(textFieldValueChanged), for: .editingChanged)
        return password
    }()
    
    private var nextBtn: UIButton = {
        let button = UIButton()
        button.setTitle(LockLocalizedString("next"), for: .normal)
        button.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        button.backgroundColor = WVColor.WVBlueUnableColor()
        button.setTitleColor(WVColor.WVViewBackColor(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.clipsToBounds = true
        button.layer.cornerRadius = 28
        button.isUserInteractionEnabled = false
        return button
    }()
    
    @objc
    private func textFieldValueChanged() {
        if passwordTf.text?.count != 0 {
            nextBtn.backgroundColor = WVColor.WVBlueColor()
            nextBtn.isUserInteractionEnabled = true
        } else {
            nextBtn.backgroundColor = WVColor.WVBlueUnableColor()
            nextBtn.isUserInteractionEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        passwordTf.resignFirstResponder()
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
