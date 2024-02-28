//
//  GuestLockSetViewController.swift
//  AlfredDemo
//
//  Created by Tianbao Wang on 2021/12/20.
//

import UIKit
import AlfredCore
import AlfredLockManager

class GuestLockSetViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    let tableView = UITableView(frame: CGRect(), style: .plain)
    private let pinKeysItem = WVTableItem()
    private let cardKeysItem = WVTableItem()
    
    private var itemGroups: [WVTableGroup] = []
    private let thinTableCellId = "thinTableCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        initUIs()
        initData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
        tableView.reloadData()
    }
    
    //密钥
    func showLockCode(_ type: AlfredLockCodeType) {
        let control = GuestLockCodesViewController()
        control.codeType = type
        PushViewController(control)
    }
    
    func initData() {
        var keyitems = [WVTableItem]()
        pinKeysItem.icon = UIImage(named: "icon_PIN_dark_")
        pinKeysItem.accessoryCustomImage = UIImage(named: "arrow_right")
        pinKeysItem.title = LockLocalizedString("home_lock_setting_pin_keys_title", comment: "Pin Keys")
        pinKeysItem.showAccessory = true
        pinKeysItem.execute = { [weak self] in
            self?.showLockCode(.LockCodeType_PIN)
        }
        keyitems.append(pinKeysItem)
        
        cardKeysItem.icon = UIImage(named: "icon_card_dark_")
        cardKeysItem.accessoryCustomImage = UIImage(named: "arrow_right")
        cardKeysItem.title = LockLocalizedString("home_lock_setting_card_keys_title")
        cardKeysItem.showAccessory = true
        cardKeysItem.execute = { [weak self] in
            self?.showLockCode(.LockCodeType_RFID)
        }
        if GuestLockManager.shared().getGuestDevice(deviceId, paramStr: paramStr)?.mode == "ML2" || GuestLockManager.shared().getGuestDevice(deviceId, paramStr: paramStr)?.mode == "DB2S" {
            keyitems.append(cardKeysItem)
        }
        
        let group0 = WVTableGroup()
        group0.items = keyitems
                
        itemGroups = [group0]
        refreshData()
        tableView.reloadData()
    }
    
    
    func refreshData() {
        if let keys = GuestLockManager.shared().getGuestDevice(deviceId, paramStr: paramStr)?.extend?.keys {
            var pinkeys = [AlfredLockCode]()
            var touchkeys = [AlfredLockCode]()
            var cardkeys = [AlfredLockCode]()
            for key in keys {
                if key._type == .LockCodeType_PIN {
                    pinkeys.append(key)
                }
                if key._type == .LockCodeType_Fingerprint {
                    touchkeys.append(key)
                }
                if key._type == .LockCodeType_RFID {
                    cardkeys.append(key)
                }
            }
            pinKeysItem.comment = "\(pinkeys.count)"
            cardKeysItem.comment = "\(cardkeys.count)"
        }
    }
    
    private func initUIs() {
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 64
        tableView.backgroundColor = WVColor.WVViewBackColor()
        tableView.register(CommSwitchCell.self, forCellReuseIdentifier: thinTableCellId)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    //MARK: -- UItableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemGroups.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let group = itemGroups[section]
        return group.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: thinTableCellId, for: indexPath) as! CommSwitchCell
        
        let items = itemGroups[indexPath.section].items
        let item = items[indexPath.row]
        cell.item = item
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = itemGroups[indexPath.section].items[indexPath.row]
        item.execute?()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
    }

}
