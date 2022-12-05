//
//  BridegAddStep3ViewController.swift
//  AlfredDemo
//
//  Created by Tianbao Wang on 2020/12/24.
//

import UIKit
import MJRefresh
import AlfredBridgeBinder

class BridegAddStep3ViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    private var tableView = UITableView(frame: CGRect.zero, style: .plain)
    private let cellId = "CommonTableCellId"
    var wifilist = [AlfredBridgeHotspot]() {
        didSet {
            if self.tableView.mj_header != nil {
                self.tableView.mj_header!.endRefreshing()
            }
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUIs()
        sendData()
    }

    //MARK: -- 获取Wi-Fi列表
    @objc
    private func sendData() {
        BridgeBinder.shared().requestWifiList { (list) in
            self.wifilist = list
        } failure: { (error, msg) in
            self.tableView.mj_header!.endRefreshing()
            Toast.promptMessage("获取Wi-Fi列表失败 errcode: \(msg ?? "")")
        }
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wifilist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WiFiTableCell
        cell.backgroundColor = WVColor.WVViewBackColor()
        cell.setData(wifilist[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let wifiSet = BridegAddStep4ViewController()
        wifiSet.hots = wifilist[indexPath.row]
        PushViewController(wifiSet)
    }
    
    private func initUIs() {
        self.title = LockLocalizedString("add_power_gateway_title")

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
        mess1Label.text = "Drop down refresh"
        mess1Label.font = UIFont.systemFont(ofSize: 20)
        mess1Label.textColor = WVColor.WVBlackTextColor()
        self.view.addSubview(mess1Label)
        mess1Label.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
            make.top.equalTo(stepIcon.snp.bottom).offset(24)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionIndexBackgroundColor = WVColor.WVViewBackColor()
        tableView.backgroundColor = WVColor.WVViewBackColor()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 56
        tableView.register(WiFiTableCell.self, forCellReuseIdentifier: cellId)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(mess1Label.snp.bottom).offset(24)
        }
        
        setheaderView()
    }
    
    private func setheaderView() {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(sendData))
        tableView.mj_header = header
    }
}

class WiFiTableCell: UITableViewCell {
    let ssidLabel = UILabel()
    let signlView = UIImageView()
    let secView = UIImageView(image: UIImage(named: "icon_locked_"))
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUIs()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUIs() {
        ssidLabel.textColor = WVColor.WVBlackTextColor()
        ssidLabel.font = UIFont.systemFont(ofSize: 16)
        self.contentView.addSubview(ssidLabel)
        ssidLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(20)
        }
        
        self.contentView.addSubview(secView)
        secView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.right.equalTo(self.contentView).offset(-20)
        }
        
        self.contentView.addSubview(signlView)
        signlView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.right.equalTo(self.contentView).offset(-60)
        }
    }
    
    func setData(_ model: AlfredBridgeHotspot) {
        ssidLabel.text = model.ssid
        secView.isHidden = false
        if model.open {
            secView.isHidden = true
        }
        signlView.image = signalStrengthImage(model.signal)
    }
    
    func signalStrengthImage(_ strength: Int) -> UIImage? {
        if strength <= 33 {
            return UIImage(named: "pair_signal_1_")
        } else if strength <= 66 {
            return UIImage(named: "pair_signal_2_")
        } else {
            return UIImage(named: "pair_signal_3_")
        }
    }

}
