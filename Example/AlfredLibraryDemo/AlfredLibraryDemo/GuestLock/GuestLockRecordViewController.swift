//
//  GuestLockRecordViewController.swift
//  AlfredDemo
//
//  Created by Tianbao Wang on 2021/12/20.
//

import UIKit
import MJRefresh
import AlfredLockManager
import MBProgressHUD

class GuestLockRecordViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    private let tableView = UITableView(frame: CGRect(), style: .plain)
    private var logAlllist = [AlfredLockRecord]() //门锁所有数据，不过滤数据

    private var timeLogs = [[String: [AlfredLockRecord]]](){
        didSet {
            tableView.reloadData()
        }
    }
    private var currentpage = 1
    private let limit = 20

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LockLocalizedString("home_lock_record_title", comment: "")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_refresh_dark_"), style: .done, target: self, action: #selector(updateLockMsg))
        initUIs()
        downloadData()
    }
    
    //MARK: -- 通过蓝牙同步开门记录
    func updateLockMsgByBLE() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        GuestLockManager.shared().syncRecords(deviceId, paramStr: paramStr, page: Int32(currentpage), limit: Int32(limit)) { (model, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let data = model as? [AlfredLockRecord], error == .NONE_ERROR {
                self.parseData(data)
            }
        }
    }

    //从门锁里获取开门记录来更新
    @objc func updateLockMsg() {
        if let device = GuestLockManager.shared().getGuestDevice(deviceId, paramStr: paramStr) {
            //蓝牙已连接
            if device.connectState == .LockConnectState_Connected {
                self.updateLockMsgByBLE()
            } else {
                //蓝牙未连接，需要先连接
                self.connectLock(device)
            }
        }
    }
        
    //连接门锁蓝牙
    func connectLock(_ model: AlfredLock) {
        GuestLockManager.shared().access(deviceId, paramStr: paramStr, timeout: 10) { (device, connectState, error) in
            if connectState == .LockConnectState_Connected {
                self.updateLockMsgByBLE()
            }
        } notifyCallback: { (device, obj) in
            
        }
    }
    
    //下拉刷新
    @objc func downloadData() {
        currentpage = 1
        updateLockMsg()
    }
    
    //上拉刷新
    @objc func uploadData() {
        currentpage += 1
        updateLockMsg()
    }
    
    func parseData(_ model: [AlfredLockRecord]) {
        self.setFooterView()
        self.timeLogs.removeAll()
        //下拉
        if self.currentpage == 1 {
            self.logAlllist.removeAll()
            //不足10个没有下拉
            if model.count != 20 {
                self.removeFooterView()
            }
        } else {
            //不足10个没有下拉
            if model.count != 20 {
                self.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }
        }
        for data in model {
            self.logAlllist.append(data)
        }
        
        if self.logAlllist.count%20 != 0 || self.logAlllist.count == 0 {
            self.removeFooterView()
        }
        
        for data in self.logAlllist {
            self.sortLogs(data)
        }
        self.tableView.reloadData()
    }
    
    func sortLogs(_ model: AlfredLockRecord) {
        if let time = model.time {
            let headtime = getMDYTime(time)
            if timeLogs.count == 0 {
                var logs = [AlfredLockRecord]()
                var timeDic = [String: [AlfredLockRecord]]()
                logs.append(model)
                timeDic[headtime] = logs
                timeLogs.append(timeDic)
            } else {
                var isexist = false
                //日期存在的话，找出数组，并排序
                for (i,timedic) in timeLogs.enumerated() {
                    if var elogs = timedic[headtime] {
                        elogs.append(model)
                        elogs.sort { (log1, log2) -> Bool in
                            //按照时间生序排列
                            return log1.time! > log2.time!
                        }
                        var addtimeDic = [String: [AlfredLockRecord]]()
                        addtimeDic[headtime] = elogs
                        isexist = true
                        timeLogs.remove(at: i)
                        timeLogs.insert(addtimeDic, at: i)
                        break
                    }
                }
                if !isexist {
                    //新增的日期不存在，则先创建日期dic，然后比较总数组日期排序
                    var nlogs = [AlfredLockRecord]()
                    var ntimeDic = [String: [AlfredLockRecord]]()
                    nlogs.append(model)
                    ntimeDic[headtime] = nlogs
                    timeLogs.insert(ntimeDic, at: 0)
                    timeLogs.sort { (dic1, dic2) -> Bool in
                        var log1: AlfredLockRecord?
                        var log2: AlfredLockRecord?
                        for (_,values) in dic1 {
                            log1 = values[0]
                            break
                        }
                        
                        for (_,values) in dic2 {
                            log2 = values[0]
                            break
                        }
                        
                        //按照时间生序排列
                        return log1!.time! > log2!.time!
                    }
                }
            }
        }
    }
    
    private func initUIs() {
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
            tableView.estimatedRowHeight = 0
            tableView.estimatedSectionFooterHeight = 0
            tableView.estimatedSectionHeaderHeight = 0
        }
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LockRecordCell.self, forCellReuseIdentifier: LockRecordCell.lockRecordCellIdentifier)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        setheaderView()
    }
    
    private func setheaderView() {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(downloadData))
        tableView.mj_header = header
    }
    
    private func setFooterView() {
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(uploadData))
        tableView.mj_footer = footer
    }
    
    private func removeFooterView() {
        tableView.mj_footer = nil
    }
    
    //MARK: -- UItableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return timeLogs.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let timedic = timeLogs[section]
        for (_,value) in timedic {
            return value.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LockRecordCell.lockRecordCellIdentifier, for: indexPath as IndexPath) as! LockRecordCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.white
        let timedic = timeLogs[indexPath.section]
        for (_,value) in timedic {
            let log = value[indexPath.row]
            cell.setData(model: log)
            if indexPath.row == 0 {
                cell.topLabel.isHidden = true
            }
            if indexPath.row == value.count - 1 {
                cell.bottomLabel.isHidden = true
            }
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headview = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 25))
        headview.backgroundColor = WVColor.WVViewBackColor()

        let timeLabel = UILabel()
        timeLabel.textColor = WVColor.WVBlackTextColor()
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        headview.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(headview)
            make.left.equalTo(headview).offset(25)
        }
        
        let timedic = timeLogs[section]
        for (key,_) in timedic {
            timeLabel.text = key
            break
        }
        return headview
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footview = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 15))
        return footview
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
