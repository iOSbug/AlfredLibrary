//
//  AddDeviceViewController.swift
//  AlfredDemo
//
//  Created by Tianbao Wang on 2020/12/18.
//

import UIKit
import AlfredLibrary

struct SelectDeviceType {
    var image: String
    var detailType: String
    var type: String
    var deviceType: AlfredDeviceType = AlfredDeviceType.DeviceType_DoorLock
}

class AddDeviceViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    private var tableView = UITableView(frame: CGRect.zero, style: .grouped)
    private let cellId = "DeviceTypeTableViewCellId"
    
    private let deviceArr = [SelectDeviceType(image: "bind_step0_model-1_",
                                              detailType: LockLocalizedString("add_device_Lock"),
                                              type: "DB",
                                              deviceType: .DeviceType_DoorLock),
                             SelectDeviceType(image: "bind_step0_model-2_",
                                              detailType: LockLocalizedString("add_device_gateway"),
                                              type: "850G",
                                              deviceType: .DeviceType_Gateway)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    
    private func connectTypeAction(_ item: SelectDeviceType) {
        if item.deviceType == .DeviceType_DoorLock {
            PushViewController(SearchDeviceViewController())
        } else if item.deviceType == .DeviceType_Gateway {
            PushViewController(BridegAddStep1ViewController())
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return deviceArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DeviceTypeTableViewCell
        
        let item = deviceArr[indexPath.section]
        cell.setData(item)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let backImg = UIImage(named: "bind_step0_model-1_")
        return backImg?.size.height ?? 240
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = deviceArr[indexPath.section]
        self.connectTypeAction(item)
    }
    
    private func initUI() {
        self.title = LockLocalizedString("add_select_device_type_nav", comment: "Selection of device type")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionIndexBackgroundColor = WVColor.clear
        tableView.backgroundColor = WVColor.clear
        tableView.separatorStyle = .none
        tableView.sectionHeaderHeight = 24
        tableView.sectionFooterHeight = 0.01
        tableView.showsVerticalScrollIndicator = false
        tableView.register(DeviceTypeTableViewCell.self, forCellReuseIdentifier: cellId)
        self.view.addSubview(tableView)

        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
}

class DeviceTypeTableViewCell: UITableViewCell {
    
    private let backImgView = UIImageView()
    private let bgView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initUIs()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setData(_ item: SelectDeviceType) {
        self.backImgView.image = UIImage(named: item.image)
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
        
        bgView.addSubview(backImgView)
        backImgView.snp.makeConstraints { (make) in
            make.center.equalTo(bgView.snp.center)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

