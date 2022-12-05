//
//  BridegAddStep2ViewController.swift
//  AlfredDemo
//
//  Created by Tianbao Wang on 2020/12/24.
//

import UIKit
import AlfredBridgeBinder

class BridegAddStep2ViewController: BaseViewController {
    var deviceId: String?
    private let loadView = UIView()
    private let stepIcon = UIImageView()
    private let messTitleLabel = UILabel()
    private let waitLabel = UILabel()
    private var second = 30
    private let animationView = UIImageView(image: UIImage(named: "icon_refresh_light_"))
    private let loadLabel = UILabel()
 

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        enterConnectWiFi()
    }
    
    //MARK: -- 自动连接网关Wi-Fi
    @objc func autoConnect() {
        BridgeBinder.shared().connect(deviceId ?? "") {
            self.enterAdminVC()
        } failure: { (error, msg) in
            //手动连接
            if error == .BRIDGE_CONNECT_MANUAL {
                self.manualConnect()
            }
        }
    }
    
    //MARK: -- 手动连接网关Wi-Fi
    func manualConnect() {
        let connectVc = BridegAddStep2ManuViewController()
        connectVc.deviceId = self.deviceId
        self.PushViewController(connectVc)
    }
    
    //获取Wi-Fi列表
    func enterAdminVC() {
        let wifilistControl = BridegAddStep3ViewController()
        PushViewController(wifilistControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
    override func PopPrevious() -> UIViewController? {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(autoConnect), object: nil)
        return super.PopPrevious()
    }
    
    @objc
    private func applicationDidBecomeActive(noti: Notification) {
        if BaseViewController.topViewController() is BridegAddStep1ViewController {
            animationView.rotation(false)
        }
    }
    
    //wifi连接动画，ios11之前跳转到手动
    func enterConnectWiFi() {
        self.perform(#selector(autoConnect), with: nil, afterDelay: 6)
    }
    
    private func setLoad() {
        self.title = LockLocalizedString("add_power_gateway_title")

        stepIcon.image = UIImage(named: "stepper_GW_3b_")
        messTitleLabel.text = LockLocalizedString("add_power_gateway_step2_head")

        self.view.addSubview(loadView)
        loadView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(messTitleLabel.snp.bottom)
        }
        
        loadView.addSubview(animationView)
        animationView.snp.makeConstraints { (make) in
              make.top.equalTo(loadView).offset(48)
              make.centerX.equalTo(loadView)
              make.height.width.equalTo(120)
        }
        animationView.rotation(false)
        
        loadLabel.text = LockLocalizedString("add_power_gateway_step3_connect")
        loadLabel.font = UIFont.systemFont(ofSize: 16)
        loadLabel.textColor = WVColor.WVViewBackColor()
        loadView.addSubview(loadLabel)
        loadLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(loadView.snp.centerX)
            make.top.equalTo(loadView).offset(184)
        }
                
        waitLabel.textAlignment = .center
        waitLabel.numberOfLines = 0
        waitLabel.font = UIFont.systemFont(ofSize: 14)
        waitLabel.text = String(format: LockLocalizedString("add_gateway_Pair_load_count", comment: ""), "\(second)")
        waitLabel.textColor = WVColor.WVCommentTextColor()
        loadView.addSubview(waitLabel)
        waitLabel.snp.makeConstraints { (make) in
            make.left.equalTo(loadView).offset(54)
            make.right.equalTo(loadView).offset(-54)
            make.top.equalTo(loadLabel.snp.bottom).offset(8)
        }
        self.view.bringSubviewToFront(loadView)
    }
    
    private func removeLoad() {
        loadView.removeFromSuperview()
    }
    
    private func initUI() {
        self.title = LockLocalizedString("add_device_wifilock_title")
        
        self.view.addSubview(stepIcon)
        stepIcon.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.view).offset(16)
        }
        
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
        
        setLoad()
    }
}
