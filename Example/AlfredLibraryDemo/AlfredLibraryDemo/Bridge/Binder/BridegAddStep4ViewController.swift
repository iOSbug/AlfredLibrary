//
//  BridegAddStep4ViewController.swift
//  AlfredDemo
//
//  Created by Tianbao Wang on 2020/12/24.
//

import UIKit
import MBProgressHUD
import AlfredBridgeBinder

class BridegAddStep4ViewController: BaseViewController, UITextFieldDelegate {
    var hots: AlfredBridgeHotspot?
    let ssidText = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
   //MARK: -- 绑定网关，配网
    @objc
    private func joinAction() {
        passwordTf.resignFirstResponder()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        BridgeBinder.shared().requestWifiConfig(hots!, password: passwordTf.text ?? "") {
            MBProgressHUD.hide(for: self.view, animated: true)
            Toast.promptMessage("successful")
            NotificationCenter.default.post(name: NSNotification.Name("refreshDeviceList"), object: nil)
            self.PopToViewController(HomeViewController.self)
        } failure: { (error, msg) in
            MBProgressHUD.hide(for: self.view, animated: true)

        }
    }
    

    private func initUI() {
        self.title = LockLocalizedString("add_power_gateway_title", comment: "Pair gateway to app")
        
        let stepIcon = UIImageView()
        stepIcon.image = UIImage(named: "stepper_GW_4_")
        self.view.addSubview(stepIcon)
        stepIcon.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.view).offset(16)
        }
        
        let mess1Label = UILabel()
        mess1Label.textAlignment = .center
        mess1Label.numberOfLines = 0
        mess1Label.text = LockLocalizedString("add_power_gateway_step4_head2", comment: "")
        mess1Label.font = UIFont.systemFont(ofSize: 20)
        mess1Label.textColor = WVColor.WVBlackTextColor()
        self.view.addSubview(mess1Label)
        mess1Label.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(54)
            make.right.equalTo(self.view).offset(-54)
            make.top.equalTo(stepIcon.snp.bottom).offset(24)
        }
        
        ssidText.text = hots?.ssid
        ssidText.backgroundColor = UIColor.clear
        ssidText.textColor = WVColor.WVCommentTextColor()
        ssidText.font = UIFont.systemFont(ofSize: 16)
        ssidText.textAlignment = .right
        ssidText.leftViewMode = .always
        ssidText.rightViewMode = .always
        let leftview = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 56))
        ssidText.leftView = leftview
        let networkLabel = UILabel()
        networkLabel.textAlignment = .center
        networkLabel.frame = leftview.frame
        networkLabel.font = UIFont.systemFont(ofSize: 16)
        networkLabel.textColor = WVColor.WVBlackTextColor()
        networkLabel.text = LockLocalizedString("add_power_gateway_step5_network")
        leftview.addSubview(networkLabel)

        let rightview = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 56))
        ssidText.rightView = rightview
        let rightImgView = UIImageView(image: UIImage(named: "arrow_right"))
        rightImgView.frame = CGRect(x: 3, y: 16, width: 24, height: 24)
        rightview.addSubview(rightImgView)
        self.view.addSubview(ssidText)
        ssidText.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
            make.top.equalTo(mess1Label.snp.bottom).offset(24)
            make.height.equalTo(56)
        }

        
        let lineLabel = UILabel()
        lineLabel.backgroundColor = WVColor.WVTableLineColor()
        self.view.addSubview(lineLabel)
        lineLabel.snp.makeConstraints { (make) in
            make.left.equalTo(ssidText.snp.left)
            make.right.equalTo(ssidText.snp.right)
            make.top.equalTo(ssidText.snp.bottom)
            make.height.equalTo(0.5)
        }
        
        
        self.view.addSubview(passwordTf)
        passwordTf.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
            make.top.equalTo(ssidText.snp.bottom).offset(24)
            make.height.equalTo(56)
        }
        
        let joinBtn = UIButton()
        joinBtn.setTitle(LockLocalizedString("add_power_gateway_step5_join"), for: .normal)
        joinBtn.addTarget(self, action: #selector(joinAction), for: .touchUpInside)
        joinBtn.backgroundColor = WVColor.WVBlueColor()
        joinBtn.setTitleColor(WVColor.WVViewBackColor(), for: .normal)
        joinBtn.titleLabel?.font = UIFont.systemFont(ofSize:16)
        joinBtn.clipsToBounds = true
        joinBtn.layer.cornerRadius = 28
        self.view.addSubview(joinBtn)
        joinBtn.snp.makeConstraints { (make) in
            make.height.equalTo(56)
            make.left.equalTo(self.view).offset(96)
            make.right.equalTo(self.view).offset(-96)
            make.top.equalTo(passwordTf.snp.bottom).offset(90)
        }
    }
    
    private lazy var passwordTf: UITextField = {
        let password = UITextField()
        password.placeholder = LockLocalizedString("add_power_gateway_step5_wifi_password")
        password.translatesAutoresizingMaskIntoConstraints = false
        password.autocapitalizationType = .words
        password.backgroundColor = .white
        password.returnKeyType = .done
        password.delegate = self
        password.layer.borderWidth = 1
        password.layer.borderColor = WVColor.WVBlueUnableColor().cgColor
        return password
    }()
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.view.endEditing(true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
