//
//  BridgeTimezoneViewController.swift
//  AlfredDemo
//
//  Created by Tianbao Wang on 2020/12/31.
//

import UIKit
import AlfredNetManager
import AlfredBridgeManager
import MBProgressHUD

class BridgeTimezoneViewController: BaseViewController,UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    private let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    var selectTimezone: AlfredTimeConfig?
    private var timeZones: [AlfredTimeConfig] = []
    private let cellId = "ThinTableCellId"
    
    var tzDistricts : [[TzDistrictModel]] = []
    var bridge: AlfredBridge?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = LockLocalizedString("home_gateway_set_time_zone", comment: "time zone")
        initUI()
        initData()
    }
    
    private func initData() {
        self.timeZones.removeAll()
        BridgeManager.shared().getTimezones(bridge?.did ?? "") { (timezone) in
            self.refreshData(timezone)
        } failure: { (error) in
            
        }
    }
    
    func refreshData(_ model: AlfredTimeZone) {
        self.tzDistricts.removeAll()

        if let timeZones = model.timeZones {
            self.timeZones = timeZones
        }
        if let tzDistricts = model.tzDistricts {
            self.tzDistricts.append(tzDistricts)
        }
        //若之前配置的时区在云端不存在，则手动造一条
        var selectdistri = showTzName(self.selectTimezone?.tzName)
        if selectdistri == nil {
            let tzDis = TzDistrictModel()
            tzDis.tzName = selectTimezone?.tzName
            tzDis.en = selectTimezone?.tzName
            tzDis.tzUtc = selectTimezone?.tzUtc
            selectdistri = tzDis
        }
        
        self.tzDistricts.insert([selectdistri!], at: 0)
        self.tableView.reloadData()
    }
    
    private func setTimezone(_ tzDistrict: TzDistrictModel) {
        let timeZone = showTimezone(tzDistrict.tzName)
        let tzName = timeZone?.tzName ?? ""
        let tzValue = timeZone?.tzValue ?? "0"
        let tzDistrict = tzDistrict.en ?? ""
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        BridgeManager.shared().restart(bridge?.did ?? "", tzName: tzName, tzValue: tzValue, tzDistrict: tzDistrict) {
            MBProgressHUD.hide(for: self.view, animated: true)
            Toast.promptMessage("successful")
            self.navigationController?.popViewController(animated: true)
        } failure: { (error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            Toast.promptMessage(error?.eMessage)
        }
    }
    
    //显示
    func showTzName(_ tzname: String?) -> TzDistrictModel? {
        for districts in tzDistricts {
            for district in districts {
                if district.tzName == tzname {
                    return district
                }
            }
        }
        return nil
    }
    
    func showTimezone(_ tzname: String?) -> AlfredTimeConfig? {
        for timezone in timeZones {
            if timezone.tzName == tzname {
                return timezone
            }
        }
        return nil
    }
    
    private func showAction(title: String, tzDistrict: TzDistrictModel) {
        self.setTimezone(tzDistrict)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.tzDistricts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tzDistricts[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CommonTableCell
        cell.backgroundColor = WVColor.WVViewBackColor()
        if let tzDistrict = self.tzDistricts.element(at: indexPath.section)?.element(at: indexPath.row) {
            let item = CommonTableItem()
            item.title = tzDistrict.en
            item.comment = showTimezone(tzDistrict.tzName)?.tzUtc
            if indexPath.section == 0 {
                item.accessoryCustomImage = UIImage(named: "icon_chosen_")
            }
            if indexPath.section == 0 {
                item.showBottomLine = false
            }
            cell.item = item
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)        
        if let tzDistrict = self.tzDistricts.element(at: indexPath.section)?.element(at: indexPath.row) {
            let title = String(format: "\(LockLocalizedString("set_change_timezone", comment: "Change camera time zone to"))", tzDistrict.en ?? "")
            showAction(title: title, tzDistrict: tzDistrict)
        }
    }
    
    func initUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 56
        tableView.estimatedSectionHeaderHeight = 0
        tableView.backgroundColor = WVColor(rgb:0xF8FAFA)
        tableView.separatorStyle = .none
        tableView.register(CommonTableCell.self, forCellReuseIdentifier: cellId)
        tableView.keyboardDismissMode = .onDrag
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
}

extension Array {
    
    // 安全的通过index获取值，返回可选值结果
    func element(at index: Int) -> Element? {
        guard index < self.count else {
            return nil
        }
        
        return self[index]
    }
}
