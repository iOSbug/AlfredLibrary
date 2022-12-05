//
//  SearchDeviceViewController.swift
//  AlfredDemo
//
//  Created by Tianbao Wang on 2020/12/14.
//

import UIKit
import MJRefresh
import AlfredCore
import AlfredLockBinder
import AlfredLockManager

class SearchDeviceViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    private let tableView = UITableView(frame: CGRect(), style: .plain)
    var selectModel: AlfredDeviceBindStatus?
    var showSearchListModel = [AlfredDeviceBindStatus]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LockLocalizedString("add_lock_Pair_lock_to_app_step_2", comment: "Pair lock to app")
        initUIs()
    }
    
    //MARK: -- 搜索门锁蓝牙
    @objc func startSearch() {
        LockManager.shared().disconnect()
        showSearchListModel.removeAll()
        LockBinder.shared().searchDeviceList(5, blePreName: "ALF") { (list) in
            self.showSearchListModel = list
            self.saltList()
            self.tableView.mj_header?.endRefreshing()
            if self.showSearchListModel.count == 0 {
                self.setNoDataView()
            } else {
                self.removeNodataView()
            }
        } failure: { (err, msg) in
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LockManager.shared().disconnect()
        self.tableView.mj_header?.beginRefreshing()
    }
    
    //进入绑定页面
    func enterBindVC(_ model: AlfredDeviceBindStatus) {
        let control = BindLockViewController()
        control.bindModel = model
        self.PushViewController(control)
    }
    
    //排序，按照“未绑定”->“已绑定”->"失败"->""
    func saltList() {
        showSearchListModel.sort { (model1, model2) -> Bool in
            if let status1 = model1.status, let status2 = model2.status {
                return status1 < status2
            }
            return model1.deviceId ?? "" > model2.deviceId ?? ""
        }
    }
    
    private func initUIs() {
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.searchResultCellIdentifier)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        setHead()
        setheaderView()
    }
    
    private func setheaderView() {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(startSearch))
        tableView.mj_header = header
    }
    
    func setHead() {
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 90))
        tableView.tableHeaderView = headView
        
        let stepIcon = UIImageView(image: UIImage(named: "stepper_2_"))
        headView.addSubview(stepIcon)
        stepIcon.snp.makeConstraints { (make) in
            make.centerX.equalTo(headView.snp.centerX)
            make.top.equalTo(headView).offset(11)
        }
        
        let nameLabel = UILabel()
        nameLabel.text = LockLocalizedString("add_lock_Pair_select_message", comment: "")
        nameLabel.font = UIFont.systemFont(ofSize: 20)
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        nameLabel.textColor = WVColor.WVBlackTextColor()
        headView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headView).offset(60)
            make.top.equalTo(stepIcon.snp.bottom).offset(25)
            make.right.equalTo(headView).offset(-60)
        }
    }
    
    //未搜索到设备
    func setNoDataView() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.view.bounds.height - 90))
        tableView.tableFooterView = footerView
        
        let iconView = UIImageView(image: UIImage(named: "device_empty_"))
        footerView.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.centerX.equalTo(footerView.snp.centerX)
            make.top.equalTo(footerView).offset(80)
        }
        
        let infolabel = UILabel()
        infolabel.textAlignment = .center
        infolabel.text = LockLocalizedString("add_lock_Pair2_nodata_info1", comment: "")
        infolabel.textColor = WVColor.WVInfoHeadColor()
        infolabel.font = UIFont.systemFont(ofSize: 16)
        footerView.addSubview(infolabel)
        infolabel.snp.makeConstraints { (make) in
            make.left.equalTo(footerView).offset(20)
            make.right.equalTo(footerView).offset(-20)
            make.top.equalTo(iconView.snp.bottom).offset(32)
        }
        
        let info1label = UILabel()
        info1label.textAlignment = .center
        info1label.numberOfLines = 0
        info1label.text = LockLocalizedString("add_lock_Pair2_nodata_info2", comment: "")
        info1label.textColor = WVColor.WVInfoColor()
        info1label.font = UIFont.systemFont(ofSize: 14)
        footerView.addSubview(info1label)
        info1label.snp.makeConstraints { (make) in
            make.left.equalTo(footerView).offset(20)
            make.right.equalTo(footerView).offset(-20)
            make.top.equalTo(infolabel.snp.bottom).offset(17)
        }
    }
    
    func removeNodataView() {
        tableView.tableFooterView = nil
    }
    
    //MARK: -- UItableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return showSearchListModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.searchResultCellIdentifier, for: indexPath as IndexPath) as! SearchResultCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.white
        let model = showSearchListModel[indexPath.section]
        cell.setData(model: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //选择连接哪个蓝牙
        let model = showSearchListModel[indexPath.section]
        enterBindVC(model)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headview = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 24))
        return headview
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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


enum LockSearchState {
    case search        //搜索中
    case success     //搜索成功
    case paired         //已绑定
    case failure    //失败（查询后台超时或者未在后台登记）
}

class SearchResultCell: UITableViewCell {
    static let searchResultCellIdentifier = "searchResultCellIdentifier"
    let iconImgView = UIImageView(image: UIImage(named: "bind_device_"))
    let nameLabel = UILabel()
    let typeLabel = UILabel()
    let reasonLabel = UILabel()

    let bgView = UIView()
    let beenbound = UIButton()
    let loadView = UIImageView(image: UIImage(named: "icon_refresh_light_"))
    let arrowView = UIImageView(image: UIImage(named: "arrow_right"))

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
        
        bgView.addSubview(iconImgView)
        iconImgView.snp.makeConstraints { (make) in
            make.left.equalTo(bgView).offset(16)
            make.centerY.equalTo(self.contentView.snp.centerY)
        }
        
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        nameLabel.textColor = WVColor.WVBlackTextColor()
        bgView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bgView).offset(93)
            make.top.equalTo(iconImgView.snp.top)
            make.right.equalTo(bgView).offset(-30)
        }
        
        typeLabel.font = UIFont.systemFont(ofSize: 14)
        typeLabel.textColor = WVColor.WVCommentTextColor()
        bgView.addSubview(typeLabel)
        typeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bgView).offset(93)
            make.centerY.equalTo(iconImgView.snp.centerY).offset(4)
            make.right.equalTo(bgView).offset(-30)
        }
        
        reasonLabel.font = UIFont.systemFont(ofSize: 12)
        reasonLabel.textColor = WVColor.WVCommentTextColor()
        bgView.addSubview(reasonLabel)
        reasonLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bgView).offset(93)
            make.bottom.equalTo(iconImgView.snp.bottom)
            make.right.equalTo(bgView).offset(-30)
        }
        
        bgView.addSubview(loadView)
        loadView.snp.makeConstraints { (make) in
            make.right.equalTo(bgView).offset(-20)
            make.centerY.equalTo(bgView.snp.centerY)
        }

        bgView.addSubview(arrowView)
        arrowView.snp.makeConstraints { (make) in
            make.right.equalTo(bgView).offset(-20)
            make.centerY.equalTo(bgView.snp.centerY)
        }
        
        beenbound.isHidden = true
        beenbound.setTitleColor(WVColor.WVYellowColor(), for: .normal)
        beenbound.clipsToBounds = true
        beenbound.layer.borderWidth = 1
        beenbound.layer.borderColor = WVColor.WVYellowColor().cgColor
        beenbound.layer.cornerRadius = 10
        beenbound.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        bgView.addSubview(beenbound)
        beenbound.snp.makeConstraints { (make) in
            make.right.equalTo(bgView).offset(-20)
            make.height.equalTo(20)
            make.width.equalTo(56)
            make.centerY.equalTo(bgView.snp.centerY)
        }
    }
    
    func setData(model: AlfredDeviceBindStatus) {
        if let deviceid = model.deviceId {
            nameLabel.text = deviceid
        } else {
            nameLabel.text = model.localName
        }
        
        arrowView.isHidden = true
        loadView.isHidden = true
        loadView.rotation(false)
        //status，返还绑定状态（0-无绑定；1-已绑定，且属于此账号；2-已绑定，不属于此账号）
        if model.status == "0" {
            beenbound.isHidden = true
            arrowView.isHidden = false
            loadView.isHidden = true
            reasonLabel.isHidden = false
            reasonLabel.text = LockLocalizedString("add_lock_Pair_lock_can_pair", comment: "")
            if let mode = model.mode {
                typeLabel.text = LockLocalizedString("add_lock_Pair_lock_default_type", comment: "") + " " + mode
            }
        } else if model.status == "1" || model.status == "2" {
            beenbound.isHidden = false
            arrowView.isHidden = true
            loadView.isHidden = true
            reasonLabel.isHidden = true
            if let mode = model.mode {
                typeLabel.text = LockLocalizedString("add_lock_Pair_lock_default_type", comment: "") + " " + mode
            }
            beenbound.setTitle(LockLocalizedString("add_lock_been_bound", comment: ""), for: .normal)
        } else if model.status == "3" {
            beenbound.isHidden = false
            arrowView.isHidden = true
            loadView.isHidden = true
            reasonLabel.isHidden = false
            typeLabel.text = LockLocalizedString("add_lock_Pair_lock_default_type", comment: "")
            beenbound.setTitle(LockLocalizedString("add_lock_Pair_lock_failure", comment: ""), for: .normal)
            reasonLabel.text = LockLocalizedString("add_lock_Pair_lock_failure_info", comment: "")
            
        }
    }
    
}
