//
//  LockCell.swift
//  AlfredDemo
//
//  Created by Tianbao Wang on 2020/12/18.
//

import UIKit
import AlfredCore

class LockCell: UITableViewCell {
    static let lockCellIdentifier = "lockCellIdentifier"
    let bgView = UIView()

    let deviceBtn = UIButton()
    let nameLabel = UILabel()
    let statusLabel = UILabel()
    let connectBtn = UIButton()

    let settingBtn = UIButton()
    let msgBtn = UIButton()
    let shareBtn = UIButton()
    let timeLabel = UILabel()
    let timeView = UIView()
    let touchView = UIView() //用来放置开门记录，分享，设置三个按钮

    let weekStrs = [LockLocalizedString("share_bluetooth_key_sun", comment: "Sun"),
                 LockLocalizedString("share_bluetooth_key_mon", comment: "Mon"),
                 LockLocalizedString("share_bluetooth_key_tues", comment: "Tues"),
                 LockLocalizedString("share_bluetooth_key_wed", comment: "Wed"),
                 LockLocalizedString("share_bluetooth_key_thur", comment: "Thur"),
                 LockLocalizedString("share_bluetooth_key_fri", comment: "Fri"),
                 LockLocalizedString("share_bluetooth_key_sat", comment: "Sat")]

    var messageBlock: (()->())?
    var settingBlock: (()->())?
    var shareBlock: (()->())?
    var openDoorBlock: (()->())?
    var delBlock: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initUIs()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUIs() {
        //阴影
        let bottomlayerView = UIView()
        bottomlayerView.backgroundColor = UIColor.white
        bottomlayerView.layer.cornerRadius = 2.0
        bottomlayerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        bottomlayerView.layer.shadowColor = UIColor(rgb: 0xe7e7e7).cgColor
        bottomlayerView.layer.shadowOpacity = 1
        self.contentView.addSubview(bottomlayerView)
        bottomlayerView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(24)
            make.right.equalTo(self.contentView).offset(-24)
            make.top.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
        }
        
        bgView.backgroundColor = WVColor.WVViewBackColor()
        bgView.layer.cornerRadius = 2.0
        bgView.clipsToBounds = true
        self.contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(24)
            make.right.equalTo(self.contentView).offset(-24)
            make.top.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
        }
        
        deviceBtn.setImage(UIImage(named: "operating_connection_s_"), for: .normal)
        deviceBtn.addTarget(self, action: #selector(deviceTap), for: .touchUpInside)
        bgView.addSubview(deviceBtn)
        deviceBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(bgView.snp.centerY)
            make.left.equalTo(bgView.snp.left).offset(16)
        }
        
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.textColor = WVColor.WVBlackTextColor()
        bgView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bgView).offset(24)
            make.left.equalTo(bgView).offset(137)
            make.right.equalTo(bgView).offset(-20)
        }
        
        statusLabel.text = LockLocalizedString("home_device_lock_status_connectable")
        statusLabel.textAlignment = .left
        statusLabel.font = UIFont.systemFont(ofSize: 12)
        statusLabel.textColor = WVColor.WVCommentTextColor()
        bgView.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bgView).offset(48)
            make.left.equalTo(bgView).offset(137)
            make.right.equalTo(bgView).offset(-20)
        }
        
        connectBtn.setTitle(" " + LockLocalizedString("home_device_lock_bluetooth_unlock"), for: .normal)
        connectBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        connectBtn.setTitleColor(WVColor.WVGrayTextColor(), for: .normal)
//        connectBtn.setImage(UIImage(named: "icon_bluetooth_signal_0_"), for: .normal)
        bgView.addSubview(connectBtn)
        connectBtn.snp.makeConstraints { (make) in
            make.left.equalTo(bgView).offset(136)
            make.top.equalTo(bgView).offset(65)
        }
                
        touchView.backgroundColor = UIColor.clear
        bgView.addSubview(touchView)
        touchView.snp.makeConstraints { (make) in
            make.left.equalTo(bgView).offset(137)
            make.bottom.equalTo(bgView).offset(-20)
            make.right.equalTo(bgView.snp.right).offset(-16)
            make.height.equalTo(30)
        }
        
        msgBtn.setImage(UIImage(named: "icon_message_dark_"), for: .selected)
        msgBtn.setImage(UIImage(named: "icon_message_light_"), for: .normal)
        msgBtn.addTarget(self, action: #selector(messageAction), for: .touchUpInside)
        touchView.addSubview(msgBtn)
        msgBtn.snp.makeConstraints { (make) in
            make.left.equalTo(touchView)
            make.bottom.equalTo(touchView)
            make.height.width.equalTo(24)
        }
        
        settingBtn.setImage(UIImage(named: "icon_setting_dark_"), for: .selected)
        settingBtn.setImage(UIImage(named: "icon_setting_light_"), for: .normal)
        settingBtn.addTarget(self, action: #selector(settingAction), for: .touchUpInside)
        touchView.addSubview(settingBtn)
        settingBtn.snp.makeConstraints { (make) in
            make.right.equalTo(touchView.snp.right)
            make.bottom.equalTo(touchView)
            make.height.width.equalTo(24)
        }
        
        shareBtn.isHidden = true
        shareBtn.setImage(UIImage(named: "icon_share_dark_"), for: .selected)
        shareBtn.setImage(UIImage(named: "icon_share_light_"), for: .normal)
        shareBtn.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
        touchView.addSubview(shareBtn)
        shareBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(touchView.snp.centerX)
            make.bottom.equalTo(touchView)
            make.height.width.equalTo(24)
        }
        
        bgView.addSubview(timeView)
        timeView.snp.makeConstraints { (make) in
            make.bottom.equalTo(bgView).offset(-17)
            make.left.equalTo(bgView).offset(133)
            make.right.equalTo(bgView).offset(-20)
            make.height.equalTo(35)
        }
        
        let timeBtn = UIButton()
        timeBtn.setImage(UIImage(named: "time_"), for: .normal)
        timeView.addSubview(timeBtn)
        timeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(timeView)
            make.centerY.equalTo(timeView.snp.centerY)
        }
        
        timeLabel.numberOfLines = 0
        timeLabel.textAlignment = .left
        timeLabel.textColor = WVColor.WVGrayTextColor()
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        timeView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeView).offset(28)
            make.right.equalTo(timeView)
            make.centerY.equalTo(timeBtn.snp.centerY)
        }
    }
    
    @objc func messageAction() {
        messageBlock?()
    }
    
    @objc func settingAction() {
        settingBlock?()
    }
    
    @objc func shareAction() {
        shareBlock?()
    }
    
    //我的门锁开门
    @objc func deviceTap() {
        openDoorBlock?()
    }
    
    //确认删除分享钥匙
    @objc func deleteShareKey() {
        delBlock?()
    }
    
    //我的门锁
    func setData(model: AlfredLock) {
        nameLabel.text = model.extend?.name
        
        statusLabel.text = LockLocalizedString("home_device_lock_status_connectable")
        deviceBtn.setImage(UIImage(named: "operating_connection_s_"), for: .normal)
        connectBtn.setTitle(" " + LockLocalizedString("home_device_lock_status_connectable"), for: .normal)
        connectBtn.setImage(UIImage(named: "icon_bluetooth_signal_0_"), for: .normal)
        connectBtn.isHidden = false
        
        //蓝牙已连接
        if !model.connectBridge && model.connectState == AlfredLockConnectState.LockConnectState_Connected {
            connectBtn.setImage(UIImage(named: "icon_bluetooth_signal_3_"), for: .normal)
            //=0:Lock =1:Unlock
            if model.lockState == .LockState_Locked {
                statusLabel.text = LockLocalizedString("home_device_lock_status_openable")
                deviceBtn.setImage(UIImage(named: "operating_open_s_"), for: .normal)
                connectBtn.setTitle(" " + LockLocalizedString("home_device_lock_bluetooth_unlock"), for: .normal)
            } else {
                statusLabel.text = LockLocalizedString("home_device_lock_status_lockable")
                deviceBtn.setImage(UIImage(named: "operating_close_s_"), for: .normal)
                connectBtn.setTitle(" " + LockLocalizedString("home_device_lock_bluetooth_lock"), for: .normal)
            }
        }
        //网关已连接
        if model.connectBridge {
            connectBtn.setImage(UIImage(named: "icon_Wi-Fi_signal_3_"), for: .normal)
            if let gatewayLockBleSignal = model.gatewayLockBleSignal {
                if let _wifiBleSignal = Int(gatewayLockBleSignal) {
                    if _wifiBleSignal > 0 || _wifiBleSignal < -85 {
                        connectBtn.setImage(UIImage(named: "icon_Wi-Fi_signal_0_"), for: .normal)
                    } else if _wifiBleSignal < -70 {
                         connectBtn.setImage(UIImage(named: "icon_Wi-Fi_signal_1_"), for: .normal)
                    } else if _wifiBleSignal < -55 {
                        connectBtn.setImage(UIImage(named: "icon_Wi-Fi_signal_2_"), for: .normal)
                    } else {
                        connectBtn.setImage(UIImage(named: "icon_Wi-Fi_signal_3_"), for: .normal)
                    }
                }
            }
            
            //网关情况下显示门锁开关门状态，门锁状态，1是开门 0是关门
            if model.lockState == .LockState_Locked {
                statusLabel.text = LockLocalizedString("home_device_lock_status_openable")
                deviceBtn.setImage(UIImage(named: "operating_open_s_"), for: .normal)
                connectBtn.setTitle(" " + LockLocalizedString("home_device_lock_wifi_unlock"), for: .normal)
            } else {
                statusLabel.text = LockLocalizedString("home_device_lock_status_lockable")
                deviceBtn.setImage(UIImage(named: "operating_close_s_"), for: .normal)
                connectBtn.setTitle(" " + LockLocalizedString("home_device_lock_wifi_lock"), for: .normal)
            }
        }

        statusLabel.isHidden = false
        msgBtn.isHidden = false
        settingBtn.isHidden = false
        shareBtn.isHidden = true
        timeView.isHidden = true
    }
}
