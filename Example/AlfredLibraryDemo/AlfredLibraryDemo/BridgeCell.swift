//
//  BridgeCell.swift
//  AlfredDemo
//
//  Created by Tianbao Wang on 2020/12/18.
//

import UIKit
import AlfredLibrary
import AlfredCore

class BridgeCell: UITableViewCell {
    static let bridgeCellIdentifier = "bridgeCellIdentifier"
    let bgView = UIView()
    let deviceBtn = UIButton()
    let nameLabel = UILabel()
    let childBtn = UIButton()
    let connectBtn = UIButton()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initUIs()
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
        
        deviceBtn.setImage(UIImage(named: "device_GW_online_"), for: .normal)
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
            make.right.equalTo(bgView).offset(-10)
        }
        
        connectBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        connectBtn.setTitleColor(WVColor.WVGrayTextColor(), for: .normal)
        connectBtn.setImage(UIImage(named: "icon_Wi-Fi_signal_3_"), for: .normal)
        bgView.addSubview(connectBtn)
        connectBtn.snp.makeConstraints { (make) in
            make.left.equalTo(bgView).offset(136)
            make.top.equalTo(bgView).offset(48)
        }
        
        childBtn.setTitleColor(WVColor.WVGrayTextColor(), for: .normal)
        childBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        childBtn.setImage(UIImage(named: "icon_chlid device number_"), for: .normal)
        bgView.addSubview(childBtn)
        childBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(bgView.snp.bottom).offset(-24)
            make.left.equalTo(bgView).offset(136)
        }
    }
    
    func setData(_ model: AlfredBridge?) {
        nameLabel.text = model?.info?.base?.aliasName
        // 离线 - 1, 在线 - 2, 升级中 - 4, 休眠中 -8
        if let onlineStatus = model?.info?.base?.onlineStatus {
            if onlineStatus == "2" {
                deviceBtn.setImage(UIImage(named: "device_GW_online_"), for: .normal)
                connectBtn.setTitle(" " + LockLocalizedString("home_device_gateway_status_online", comment: "online"), for: .normal)
                //默认为2格
                connectBtn.setImage(UIImage(named: "icon_Wi-Fi_signal_2_"), for: .normal)
                if let wifiSignal = model?.info?.networkConfig?.wifiSignal {
                    if let _wifiSignal = Int(wifiSignal) {
                        if _wifiSignal >= 0 || _wifiSignal < -85 {
                            connectBtn.setImage(UIImage(named: "icon_Wi-Fi_signal_0_"), for: .normal)
                        } else if _wifiSignal < -70 {
                             connectBtn.setImage(UIImage(named: "icon_Wi-Fi_signal_1_"), for: .normal)
                        } else if _wifiSignal < -55 {
                            connectBtn.setImage(UIImage(named: "icon_Wi-Fi_signal_2_"), for: .normal)
                        } else {
                            connectBtn.setImage(UIImage(named: "icon_Wi-Fi_signal_3_"), for: .normal)
                        }
                    }
                }
            } else if onlineStatus == "1" {
                deviceBtn.setImage(UIImage(named: "device_GW_offline_"), for: .normal)
                connectBtn.setTitle(" " + LockLocalizedString("home_device_gateway_status_offline", comment: "offline"), for: .normal)
                connectBtn.setImage(UIImage(named: "icon_Wi-Fi_signal_0_"), for: .normal)
            }
        }
        
        if let slaves = model?.slaves {
            let slaveNum = String(format: LockLocalizedString("home_gateway_child_devices", comment: ""), "\(slaves.count)")
            childBtn.setTitle(" " + slaveNum, for: .normal)
        } else {
            let slaveNum = String(format: LockLocalizedString("home_gateway_child_devices", comment: ""), "0")
            childBtn.setTitle(" " + slaveNum, for: .normal)
        }
    }
}
