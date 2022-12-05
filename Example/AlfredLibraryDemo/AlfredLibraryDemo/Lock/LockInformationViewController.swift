//
//  LockInformationViewController.swift
//  AlfredDemo
//
//  Created by Tianbao Wang on 2020/12/21.
//

import UIKit
import AlfredCore

class LockInformationViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    private let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    private let thinTableCellId = "thinTableCellId"
    private var itemGroups: [WVTableGroup] = []
    var device: AlfredLock?
    

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
        let modelItem = WVTableItem()
        modelItem.title = LockLocalizedString("lock_device_infomation_model", comment: "Model")
        modelItem.comment = device?.mode
        
//        let modelnumberItem = WVTableItem()
//        modelnumberItem.title = LockLocalizedString("lock_device_infomation_model_number", comment: "Model number")
//        modelnumberItem.comment = getSelectDevLock()?.extend?.modelnum
//
//        let systemidItem = WVTableItem()
//        systemidItem.title = LockLocalizedString("lock_device_infomation_systemid", comment: "System ID")
//        systemidItem.comment = getSelectDevLock()?.extend?.systemId

        let serialnumberItem = WVTableItem()
        serialnumberItem.title = LockLocalizedString("lock_device_infomation_serial_number", comment: "Serial number")
        serialnumberItem.comment = device?.deviceid
//        serialnumberItem.showAccessory = false
//        serialnumberItem.accessoryCustomImage = UIImage(named: "arrow_right_white")
//        serialnumberItem.execute = { [weak self] in
//            self?.pasteSN()
//        }
  
        let bluetoothNameItem = WVTableItem()
        bluetoothNameItem.title = LockLocalizedString("lock_device_infomation_bluetooth_name", comment: "bluetoothname")
        bluetoothNameItem.comment = device?.extend?.bluetoothname

        let firmwareItem = WVTableItem()
        firmwareItem.title = LockLocalizedString("lock_device_infomation_firmware_rev", comment: "Firmware Rev")
        firmwareItem.comment = device?.extend?.fwversion

        let hardwareItem = WVTableItem()
        hardwareItem.title = LockLocalizedString("lock_device_infomation_hardware_rev", comment: "Hardware Rev")
        hardwareItem.comment = device?.extend?.hardversion

        let softwareItem = WVTableItem()
        softwareItem.title = LockLocalizedString("lock_device_infomation_software_rev", comment: "Software Rev")
        softwareItem.comment = device?.extend?.softversion

        let group0 = WVTableGroup()
        group0.items = [modelItem,serialnumberItem,bluetoothNameItem]
        
        let group1 = WVTableGroup()
        group1.items = [firmwareItem,hardwareItem,softwareItem]
        
        itemGroups = [group0, group1]
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
        if item.title == LockLocalizedString("lock_device_infomation_firmware_rev", comment: "Firmware Rev") {
            cell.setTopLine()
        }
        
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
