//
//  LockLanguageAndVoiceViewController.swift
//  AlfredDemo
//
//  Created by Tianbao Wang on 2020/12/21.
//

import UIKit
import MBProgressHUD
import AlfredCore
import AlfredLockManager
import AlfredBridgeManager
import AlfredNetManager

class LockLanguageAndVoiceViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    private let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    let slider = UISlider()
    var currentValue: Float = 0
    let voiceType = UILabel()
    var device: AlfredLock?

    let languages = [LockLocalizedString("home_lock_setting_speaker_language_english", comment: "English"),
                     LockLocalizedString("home_lock_setting_speaker_language_chinese", comment: "Chinese"),
                     LockLocalizedString("home_lock_setting_speaker_language_french", comment: "French"),
                     LockLocalizedString("home_lock_setting_speaker_language_spanish", comment: "Spanish"),
                     LockLocalizedString("home_lock_setting_speaker_language_portuguese", comment: "Portuguese")]
    
    let languageDatas = [AlfredLockLanguage.LockLanguage_EN,
                         AlfredLockLanguage.LockLanguage_ZH,
                         AlfredLockLanguage.LockLanguage_FR,
                         AlfredLockLanguage.LockLanguage_ES,
                         AlfredLockLanguage.LockLanguage_PT]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LockLocalizedString("home_lock_setting_lock_language_voice_title", comment: "")
        initUI()
    }
    
    
    //MARK: -- 设置音量
    func setVoice(_ value: AlfredLockVoice) {
        if let device = device {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            if device.connectBridge {
                //网关连接下
                if let bridge = CacheManager.shared.getLockBindGateway(device) {
                    BridgeManager.shared().setLockConfig(bridge.did ?? "", subdeviceID: device.deviceid ?? "", configID: .LockRequestConfig_Voice, values: value.rawValue) {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        Toast.promptMessage("successful")

                    } failure: { (error) in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        Toast.promptMessage(error?.eMessage)
                    }
                }
            } else {
                LockManager.shared().setConfig(device.deviceid ?? "", configID:.LockRequestConfig_Voice, values: value) { (model, error) in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    if error == .NONE_ERROR {
                        Toast.promptMessage("successful")
                    }
                }
            }
        }
    }
    
    //MARK: -- 设置语言
    func setLanguage(_ language: AlfredLockLanguage) {
        if let device = device {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            if device.connectBridge {
                //网关连接下
                if let bridge = CacheManager.shared.getLockBindGateway(device) {
                    BridgeManager.shared().setLockConfig(bridge.did ?? "", subdeviceID: device.deviceid ?? "", configID: .LockRequestConfig_Language, values: language.rawValue) {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        Toast.promptMessage("successful")
                        self.tableView.reloadData()
                    } failure: { (error) in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        Toast.promptMessage(error?.eMessage)
                    }
                }
            } else {
                LockManager.shared().setConfig(device.deviceid ?? "", configID:.LockRequestConfig_Language, values: language) { (model, error) in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    if error == .NONE_ERROR {
                        Toast.promptMessage("successful")
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    
    //连接门锁蓝牙
    func connectLock(_ model: AlfredLock, _ type: AlfredLockRequestConfig, _ language: AlfredLockLanguage?, _ voice: AlfredLockVoice?) {
        LockManager.shared().access(model.deviceid ?? "", timeout: 10) { (device, connectState, error) in
            if type == .LockRequestConfig_Voice {
                self.setVoice(voice ?? .LockVoice_Loud)
            } else if type == .LockRequestConfig_Language {
                self.setLanguage(language ?? .LockLanguage_EN)
            }
        } notifyCallback: { (device, obj) in
            
        }
    }
    
    //设置语言
    func selectLanguage(_ index: Int) {
        let language = languageDatas[index]
        if let device = device {
            if device.connectBridge {
                self.setLanguage(language)
            } else {
                //蓝牙已连接
                if device.connectState == .LockConnectState_Connected {
                    self.setLanguage(language)
                } else {
                    //蓝牙未连接，需要先连接
                    self.connectLock(device,.LockRequestConfig_Language,language, nil)
                }
            }
        }
    }
    
    func checkBleConnect(_ value: AlfredLockVoice) {
        if let device = device {
            if device.connectBridge {
                self.setVoice(value)
            } else {
                //蓝牙已连接
                if device.connectState == .LockConnectState_Connected {
                    self.setVoice(value)
                } else {
                    //蓝牙未连接，需要先连接
                    self.connectLock(device,.LockRequestConfig_Voice,nil,value)
                }
            }
        }
    }

    
    private func initUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 56
        tableView.backgroundColor = WVColor.WVViewBackColor()
        tableView.register(LanguageCell.self, forCellReuseIdentifier: LanguageCell.languageCellIdentifier)
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        sethead()
    }
    
    func sethead() {
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 128+56))
        tableView.tableHeaderView = headView
        
        let voiceView = UIView()
        headView.addSubview(voiceView)
        voiceView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(headView)
            make.height.equalTo(64+56)
        }
        
        let voiceLabel = UILabel()
        voiceLabel.text = LockLocalizedString("home_lock_setting_speaker_voice", comment: "Lock speaker voice")
        voiceLabel.textAlignment = .center
        voiceLabel.font = UIFont.systemFont(ofSize: 16)
        voiceLabel.textColor = WVColor.WVBlackTextColor()
        voiceView.addSubview(voiceLabel)
        voiceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(voiceView).offset(24)
            make.centerY.equalTo(voiceView.snp.top).offset(32)
        }
        
        voiceType.textAlignment = .center
        voiceType.font = UIFont.systemFont(ofSize:16)
        voiceType.textColor = WVColor.WVCommentTextColor()
        voiceView.addSubview(voiceType)
        voiceType.snp.makeConstraints { (make) in
            make.right.equalTo(voiceView).offset(-24)
            make.centerY.equalTo(voiceLabel.snp.centerY)
        }
        
        slider.frame = CGRect(x: 20, y: 60, width: UIScreen.main.bounds.width-40, height: 30)
        voiceView.addSubview(slider)
        slider.snp.makeConstraints { (make) in
            make.left.equalTo(voiceView).offset(20)
            make.centerY.equalTo(voiceView.snp.top).offset(64+28)
            make.right.equalTo(voiceView).offset(-20)
            make.height.equalTo(20)
        }
        // 设置值（默认值为0.0，且值区间为0.0~1.0）
        slider.minimumValue = 0
        slider.maximumValue = 1
        // 注意：滑动条大小值（minimumTrackTintColor、maximumTrackTintColor）颜色与大小值左右两端图标（minimumValueImage、maximumValueImage）不能同时设置，否则图标设置无效
        slider.minimumValueImage = UIImage(named: "icon_volume_mute_")
        slider.maximumValueImage = UIImage(named: "icon_volume_high_")
        
        // 滑块滑动停止后才触发ValueChanged事件
        slider.isContinuous = false
        // 响应事件
        slider.addTarget(self, action: #selector(sliderValueChange), for: UIControl.Event.valueChanged)
        slider.addTarget(self, action: #selector(sliderEditingDidBegin), for: UIControl.Event.touchDown)
        slider.minimumTrackTintColor = UIColor(rgb: 0x2979FF)
        slider.maximumTrackTintColor = UIColor(rgb: 0xCFD8DC)
        slider.thumbTintColor = UIColor(rgb: 0x2979FF)
        
        setDefaultData()
        
        let lineLabel = UILabel()
        lineLabel.backgroundColor = WVColor.WVTableLineColor()
        headView.addSubview(lineLabel)
        lineLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(headView)
            make.top.equalTo(headView).offset(64+56)
            make.height.equalTo(0.5)
        }
        
        if let mode = device?.mode {
            if mode == "DB1" {
                return
            }
        }
        
        let languageView = UIView()
        headView.addSubview(languageView)
        languageView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(headView)
            make.top.equalTo(lineLabel.snp.bottom)
        }
        
        let languageLabel = UILabel()
        languageLabel.text = LockLocalizedString("home_lock_setting_speaker_language", comment: "Lock speaker language")
        languageLabel.textAlignment = .center
        languageLabel.font = UIFont.systemFont(ofSize:16)
        languageLabel.textColor = WVColor.WVBlackTextColor()
        languageView.addSubview(languageLabel)
        languageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(languageView).offset(24)
            make.centerY.equalTo(languageView.snp.centerY)
        }
    }
    
    func setDefaultData() {
        if let soundVolume = device?.extend?.voice {
            if soundVolume == "\(AlfredLockVoice.LockVoice_Loud.rawValue)" {
                //高音
                voiceType.text = LockLocalizedString("home_lock_setting_speaker_voice_high", comment: "")
                slider.value = 1
            } else if soundVolume == "\(AlfredLockVoice.LockVoice_Sofly.rawValue)" {
                //低音量
                voiceType.text = LockLocalizedString("home_lock_setting_speaker_voice_low", comment: "")
                slider.value = 0.5
            } else if soundVolume == "\(AlfredLockVoice.LockVoice_Mute.rawValue)" {
                //静音
                voiceType.text = LockLocalizedString("home_lock_setting_speaker_voice_silent", comment: "")
                slider.value = 0
            }
        }
        currentValue = slider.value
    }
    
    @objc func sliderValueChange(sld: UISlider) {
        let value = sld.value
        if (currentValue < value && value <= 0.5) || (currentValue > value && value > 0.5) {
            //右滑不到一半, 左滑超过一半
            slider.value = 0.5
            //低音量
            voiceType.text = LockLocalizedString("home_lock_setting_speaker_voice_low", comment: "")
            checkBleConnect(.LockVoice_Sofly)
        } else if currentValue < value && value > 0.5 {
            //右滑超过一半
            slider.value = 1
            //高音
            voiceType.text = LockLocalizedString("home_lock_setting_speaker_voice_high", comment: "")
            checkBleConnect(.LockVoice_Loud)
        } else {
            slider.value = 0
            //静音
            voiceType.text = LockLocalizedString("home_lock_setting_speaker_voice_silent", comment: "")
            checkBleConnect(.LockVoice_Mute)
        }
    }
    
    @objc func sliderEditingDidBegin(sld: UISlider) {
        currentValue = sld.value
    }
    
    // tableview delegate datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        if let mode = device?.mode {
            if mode == "DB1" {
                return 0
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LanguageCell.languageCellIdentifier, for: indexPath) as! LanguageCell
        cell.setData(languages[indexPath.row],device?.extend?.language ?? "en")
        cell.selectBlock = {
            self.selectLanguage(indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }

}

class LanguageCell: UITableViewCell {
    static let languageCellIdentifier = "languageCellIdentifier"
    let nameLabel = UILabel()
    let selectBtn = UIButton()
    var selectBlock: (()->())?
    
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
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        nameLabel.textColor = WVColor.WVBlackTextColor()
        self.contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(25)
            make.centerY.equalTo(self.contentView.snp.centerY)
        }
        
        selectBtn.setImage(UIImage(named: "icon_select-off_big_"), for: .normal)
        selectBtn.setImage(UIImage(named: "icon_select-on_big_"), for: .selected)
        selectBtn.addTarget(self, action: #selector(selectAction), for: .touchUpInside)
        self.contentView.addSubview(selectBtn)
        selectBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.right.equalTo(self.contentView.snp.right).offset(-24)
        }
    }
    
    @objc func selectAction(sender: UIButton) {
        selectBlock?()
    }
    
    func setData(_ lang: String, _ language: String) {
        nameLabel.text = lang
        if (language == "en" && lang == LockLocalizedString("home_lock_setting_speaker_language_english", comment: "English")) ||
            (language == "zh" && lang == LockLocalizedString("home_lock_setting_speaker_language_chinese", comment: "Chinese")) ||
        (language == "es" && lang == LockLocalizedString("home_lock_setting_speaker_language_spanish", comment: "Spanish")) ||
        (language == "pt" && lang == LockLocalizedString("home_lock_setting_speaker_language_portuguese", comment: "Portuguese")) ||
        (language == "fr" && lang == LockLocalizedString("home_lock_setting_speaker_language_french", comment: "French")) {
            selectBtn.isSelected = true
        } else {
            selectBtn.isSelected = false
        }
    }
}
