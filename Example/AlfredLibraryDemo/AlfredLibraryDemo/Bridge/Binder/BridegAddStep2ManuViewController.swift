//
//  BridegAddStep2ManuViewController.swift
//  AlfredDemo
//
//  Created by Tianbao Wang on 2020/12/25.
//

import UIKit
import AlfredBridgeBinder

class BridegAddStep2ManuViewController: BaseViewController {
    var deviceId: String?
    let messTitleLabel = UILabel()
    let gosetView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        querySSID()
        initUIs()
    }
    
    override func PopPrevious() -> UIViewController? {
        self.PopToViewController(BridegAddStep1ViewController.self)
        return nil
    }
    
    //获取ssid和ip后就可以建立tcp连接，不需要等网络变换
    func querySSID() {
        BridgeBinder.shared().connectManual(deviceId ?? "") {
            self.enterAdminVC()
        } failure: { (error, msg) in
            Toast.promptMessage("手动连接失败 errmsg: \(msg ?? "")")
        }
    }
    
    
    //进入管理员密码输入
    func enterAdminVC() {
        let wifilist = BridegAddStep3ViewController()
        PushViewController(wifilist)
    }

    private func initUIs() {
        self.title = LockLocalizedString("add_power_gateway_title")

        let stepIcon = UIImageView()
        stepIcon.image = UIImage(named: "stepper_GW_3b_")
        self.view.addSubview(stepIcon)
        stepIcon.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.view).offset(16)
        }
        
        messTitleLabel.text =  String(format: LockLocalizedString("add_power_gateway_step3_manually_head"), deviceId ?? "")
        messTitleLabel.textAlignment = .center
        messTitleLabel.numberOfLines = 0
        messTitleLabel.font = UIFont.systemFont(ofSize: 20)
        messTitleLabel.textColor = WVColor.WVViewBackColor()
        self.view.addSubview(messTitleLabel)
        messTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(30)
            make.right.equalTo(self.view).offset(-30)
            make.top.equalTo(stepIcon.snp.bottom).offset(24)
        }
        showSetView()
    }
    
    func showSetView() {
        messTitleLabel.text = LockLocalizedString("add_device_wifilock_step2_head1")

        self.view.addSubview(gosetView)
        gosetView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(self.view)
            make.top.equalTo(messTitleLabel.snp.bottom)
        }
        
        let imageView = UIImageView(image: UIImage(named: "bind_GW_step3_"))
        gosetView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(gosetView)
            make.top.equalTo(gosetView).offset(24)
        }
        
        let confirmStr = LockLocalizedString("add_return_to_alfred")
        let confirmLabel = UILabel()
        confirmLabel.textColor = WVColor.WVCommentTextColor()
        confirmLabel.numberOfLines = 0
        confirmLabel.textAlignment = .center
        confirmLabel.font = UIFont.systemFont(ofSize: 12)
        confirmLabel.text = confirmStr
        gosetView.addSubview(confirmLabel)
        confirmLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(gosetView)
            make.top.equalTo(imageView.snp.bottom).offset(25)
            make.left.equalTo(gosetView).offset(40)
            make.right.equalTo(gosetView).offset(-40)
        }
        
        let nextBtn = UIButton()
        nextBtn.setTitle(LockLocalizedString("add_power_gateway_step3_manually_go_set"), for: .normal)
        nextBtn.addTarget(self, action: #selector(goToWiFiSetting), for: .touchUpInside)
        nextBtn.backgroundColor = WVColor.WVBlueColor()
        nextBtn.setTitleColor(WVColor.WVViewBackColor(), for: .normal)
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize:16)
        nextBtn.clipsToBounds = true
        nextBtn.layer.cornerRadius = 28
        gosetView.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(gosetView).offset(-35)
            make.left.equalTo(gosetView).offset(96)
            make.right.equalTo(gosetView).offset(-96)
            make.height.equalTo(56)
        }
    }
    
    @objc
    private func goToWiFiSetting() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
        }
    }

}
