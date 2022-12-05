//
//  BridgeInfoViewController.swift
//  AlfredDemo
//
//  Created by Tianbao Wang on 2020/12/30.
//

import UIKit
import AlfredCore

class BridgeInfoViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    private let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    private let thinTableCellId = "thinTableCellId"
    private var itemGroups: [WVTableGroup] = []
    var bridge: AlfredBridge? //网关

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LockLocalizedString("lock_device_infomation_title", comment: "Device information")
        initUI()
        initData()
    }
    
    private func initUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 56
        tableView.backgroundColor = WVColor.WVViewBackColor()
        tableView.register(CommonTableCell.self, forCellReuseIdentifier: thinTableCellId)
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    func initData() {
        let idItem = WVTableItem()
        idItem.title = LockLocalizedString("home_gateway_info_hub_id")
        idItem.comment = bridge?.did

        let versionItem = WVTableItem()
        versionItem.title = LockLocalizedString("home_gateway_info_hub_firmware_version")
        versionItem.comment = bridge?.info?.base?.fwVersion
        
        let ipItem = WVTableItem()
        ipItem.title = LockLocalizedString("home_gateway_info_hub_ip_address")
        ipItem.comment = bridge?.info?.networkConfig?.localIp
        
        let macItem = WVTableItem()
        macItem.title = LockLocalizedString("home_gateway_info_hub_Wifi_mac")
        macItem.comment = bridge?.info?.networkConfig?.wlanMac
                
        let group0 = WVTableGroup()
        group0.items = [idItem,versionItem,ipItem,macItem]
        
        itemGroups = [group0]
        tableView.reloadData()
    }
    
    // tableview delegate datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemGroups.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let group = itemGroups[section]
        return group.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: thinTableCellId, for: indexPath) as! CommonTableCell
        
        let items = itemGroups[indexPath.section].items
        let item = items[indexPath.row]
        cell.item = item
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.1
        }
        return 24
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
