//
//  BridegAddStep1ViewController.swift
//  AlfredDemo
//
//  Created by Tianbao Wang on 2020/12/24.
//

import UIKit
import AlfredBridgeBinder
class BridegAddStep1ViewController: BaseViewController,UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUIs()
        //定位授权
        BridgeBinder.shared().accessLocation()
    }
    
    func initUIs() {
        self.title = LockLocalizedString("add_power_gateway_title")
        
        let stepIcon = UIImageView(image: UIImage(named: "stepper_GW_1_"))
        self.view.addSubview(stepIcon)
        stepIcon.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.view).offset(16)
        }
        
        let messTitleLabel = UILabel()
        messTitleLabel.text = LockLocalizedString("add_power_gateway_manual_input") + " " + LockLocalizedString("add_enter_manually_put_sn")
        messTitleLabel.textAlignment = .center
        messTitleLabel.numberOfLines = 0
        messTitleLabel.font = UIFont.systemFont(ofSize: 20)
        messTitleLabel.textColor = WVColor.WVBlackTextColor()
        self.view.addSubview(messTitleLabel)
        messTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(30)
            make.right.equalTo(self.view).offset(-30)
            make.top.equalTo(stepIcon.snp.bottom).offset(24)
        }
        
        snTf.text = "G3B949FJWNK8BMJB"
        self.view.addSubview(snTf)
        snTf.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
            make.height.equalTo(44)
            make.top.equalTo(messTitleLabel.snp.bottom).offset(30)
        }
        
        let confirmLabel = UILabel()
        confirmLabel.textAlignment = .left
        confirmLabel.numberOfLines = 0
        confirmLabel.text = LockLocalizedString("add_power_gateway_manual_input_info")
        confirmLabel.font = UIFont.systemFont(ofSize: 12)
        confirmLabel.textColor = WVColor.WVCommentTextColor()
        self.view.addSubview(confirmLabel)
        confirmLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(24)
            make.top.equalTo(snTf.snp.bottom).offset(40)
            make.right.equalTo(self.view).offset(-24)
        }
        
        self.view.addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view).offset(-35)
            make.left.equalTo(self.view).offset(96)
            make.right.equalTo(self.view).offset(-96)
            make.height.equalTo(56)
        }
        editChange()
    }
    
    @objc func sureAction() {
        let control = BridegAddStep2ViewController()
        control.deviceId = snTf.text
        self.PushViewController(control)
    }
    
    private lazy var snTf: UITextField = {
        let name = UITextField()
        name.placeholder = LockLocalizedString("add_enter_manually_put_sn")
        name.translatesAutoresizingMaskIntoConstraints = false
        name.autocapitalizationType = .allCharacters
        name.returnKeyType = .done
        name.layer.borderWidth = 1
        name.layer.borderColor = WVColor.WVBlueUnableColor().cgColor
        name.font = UIFont.systemFont(ofSize:16)
        name.textColor = WVColor.WVTextfieldColor()
        name.delegate = self
        name.addTarget(self, action: #selector(editChange), for: .editingChanged)
        return name
    }()
    
    private var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle(LockLocalizedString("next"), for: .normal)
        button.addTarget(self, action: #selector(sureAction), for: .touchUpInside)
        button.backgroundColor = WVColor.WVBlueUnableColor()
        button.setTitleColor(WVColor.WVViewBackColor(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize:16)
        button.clipsToBounds = true
        button.layer.cornerRadius = 28
        button.isUserInteractionEnabled = false
        return button
    }()
    
    
    @objc func editChange() {
        if snTf.text?.count == 0 {
            nextButton.backgroundColor = WVColor.WVBlueUnableColor()
            nextButton.isUserInteractionEnabled = false
        } else {
            nextButton.backgroundColor = WVColor.WVBlueColor()
            nextButton.isUserInteractionEnabled = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        snTf.resignFirstResponder()
    }
}
