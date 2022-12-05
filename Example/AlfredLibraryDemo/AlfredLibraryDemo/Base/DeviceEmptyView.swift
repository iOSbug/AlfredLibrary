//
//  DeviceEmptyView.swift
//  AlfredDemo
//
//  Created by Tianbao Wang on 2020/12/22.
//

import UIKit

class HomeNoDeviceView: UIView {
    var addDeviceAction: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(icon: UIImage, info: String, action: String) {
        super.init(frame: CGRect())
        self.backgroundColor = WVColor.WVViewBackColor()
        
        let iconView = UIImageView(image: icon)
        self.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self).offset(80)
        }
        
        let infolabel = UILabel()
        infolabel.textAlignment = .center
        infolabel.text = info
        infolabel.textColor = UIColor(rgb: 0x010101)
        infolabel.font = UIFont.systemFont(ofSize: 16)
        self.addSubview(infolabel)
        infolabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(iconView.snp.bottom).offset(32)
        }
        
        
        let addButton = UIButton()
        addButton.setTitle(action, for: .normal)
        addButton.setTitleColor(WVColor.WVBlueColor(), for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        addButton.clipsToBounds = true
        addButton.layer.cornerRadius = 28
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = WVColor.WVBlueColor().cgColor
        addButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        self.addSubview(addButton)
        addButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(infolabel.snp.bottom).offset(32)
            make.width.equalTo(144)
            make.height.equalTo(56)
        }
    }

    @objc func addAction() {
        addDeviceAction?()
    }
}

class DeviceEmptyView: UIView {
    var buttonBlock: (()->())?
    let createButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(_ logoImg: UIImage?, _ info: String?, _ buttonTitle: String?) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = WVColor.WVViewBackColor()
        
        let iconView = UIImageView(image: logoImg)
        self.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self).offset(80)
        }
        
        let infolabel = UILabel()
        infolabel.textAlignment = .center
        infolabel.numberOfLines = 0
        infolabel.text = info
        infolabel.textColor = WVColor.WVInfoHeadColor()
        infolabel.font = UIFont.systemFont(ofSize: 16)
        self.addSubview(infolabel)
        infolabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(24)
            make.right.equalTo(self).offset(-24)
            make.top.equalTo(iconView.snp.bottom).offset(32)
        }
        
        createButton.setTitle(buttonTitle, for: .normal)
        createButton.setTitleColor(WVColor.WVBlueColor(), for: .normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        createButton.clipsToBounds = true
        createButton.layer.cornerRadius = 28
        createButton.layer.borderWidth = 1
        createButton.layer.borderColor = WVColor.WVBlueColor().cgColor
        createButton.addTarget(self, action: #selector(createAction), for: .touchUpInside)
        self.addSubview(createButton)
        createButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(infolabel.snp.bottom).offset(30)
            make.width.equalTo(144)
            make.height.equalTo(56)
        }
    }
    
    @objc func createAction() {
        buttonBlock?()
    }
}



class UIPinKeyActionSheetView: UIView {
    private var selectBtnAction : ((Int)->())?
    
    private let actionsheet = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(_ actionTitles: [String], action: ((Int)->())?) {
        super.init(frame: CGRect.zero)
        selectBtnAction = action
        self.backgroundColor = WVColor.WVGrayLoadColor()
        
        actionsheet.backgroundColor = UIColor.white
        actionsheet.isUserInteractionEnabled = true
        self.addSubview(actionsheet)
        
        var actionButton: UIButton?
        for (i,str) in actionTitles.enumerated() {
            let actionBtn = UIButton()
            actionBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            actionBtn.setTitle(str, for: .normal)
            actionBtn.tag = i
            actionBtn.setTitleColor(WVColor.WVBlackTextColor(), for: .normal)
            if i == actionTitles.count - 1 {
                actionBtn.setTitleColor(WVColor.WVGrayTextColor(), for: .normal)
                actionBtn.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
            } else {
                actionBtn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            }
            actionsheet.addSubview(actionBtn)
            actionBtn.snp.makeConstraints { (make) in
                if actionButton == nil {
                    make.top.equalTo(actionsheet).offset(16)
                } else {
                    make.top.equalTo(actionButton!.snp.bottom)
                }
                make.left.right.equalTo(actionsheet)
                make.height.equalTo(64)
                if i == actionTitles.count - 1 {
                    make.bottom.equalTo(actionsheet).offset(-24)
                }
            }
            
            let line = UILabel()
            line.backgroundColor = WVColor.WVTableLineColor()
            actionBtn.addSubview(line)
            line.snp.makeConstraints { (make) in
                make.bottom.equalTo(actionBtn)
                make.left.equalTo(actionBtn)
                make.right.equalTo(actionBtn)
                make.height.equalTo(1)
            }
            
            actionButton = actionBtn
        }
        
        actionsheet.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(cancelButtonAction))
        self.addGestureRecognizer(tap)
        let nilTap = UITapGestureRecognizer(target: self, action: nil)
        actionsheet.addGestureRecognizer(nilTap)
    }
    
    @objc
    private func cancelButtonAction() {
//        UIView.animate(withDuration: 0.25, animations: {
//            self.actionsheet.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 0)
//        }, completion: { (finish) in
            self.removeFromSuperview()
//        })
    }
    
    func show() {
        let window = UIApplication.shared.delegate?.window
        window!!.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalTo(window!!)
        }
    }
    
    @objc
    private func buttonAction(sender: UIButton) {
//        UIView.animate(withDuration: 0.25, animations: {
//            self.actionsheet.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 0)
//        }, completion: { (finish) in
            self.selectBtnAction?(sender.tag)
            self.removeFromSuperview()
//        })
    }
}

class UICommActionSheetView: UIView {
    
    private var cancelBtnAction : (()->Void)?
    private var sureBtnAction : (()->Void)?
    
    private let actionsheet = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String, detail: String, cancelButtonTitle: String, destructiveButtonTitle: String, sureColor: UIColor = WVColor.WVBlueColor(), cancleAction: @escaping (()->Void), sureAction: @escaping (()->Void)) {
        super.init(frame: CGRect.zero)
        
        cancelBtnAction = cancleAction
        sureBtnAction = sureAction
        
        self.backgroundColor = WVColor.WVGrayLoadColor()
        
        actionsheet.backgroundColor = UIColor.white
        actionsheet.isUserInteractionEnabled = true
        self.addSubview(actionsheet)
        
        let cancelBtn = UIButton()
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelBtn.setTitle(cancelButtonTitle, for: .normal)
        cancelBtn.setTitleColor(WVColor.WVLightgrayTextColor(), for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        actionsheet.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-20)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.height.equalTo(64)
        }
        
        let line3 = UILabel()
        line3.backgroundColor = WVColor.WVTableLineColor()
        cancelBtn.addSubview(line3)
        line3.snp.makeConstraints { (make) in
            make.bottom.equalTo(cancelBtn.snp.bottom)
            make.left.equalTo(cancelBtn)
            make.right.equalTo(cancelBtn)
            make.height.equalTo(1)
        }
        
        let sureBtn = UIButton()
        sureBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        sureBtn.setTitle(destructiveButtonTitle, for: .normal)
        sureBtn.setTitleColor(sureColor, for: .normal)
        sureBtn.addTarget(self, action: #selector(sureButtonAction), for: .touchUpInside)
        actionsheet.addSubview(sureBtn)
        sureBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(cancelBtn.snp.top)
            make.left.right.height.equalTo(cancelBtn)
            make.height.equalTo(64)
        }
        
        let line1 = UILabel()
        line1.backgroundColor = WVColor.WVTableLineColor()
        sureBtn.addSubview(line1)
        line1.snp.makeConstraints { (make) in
            make.top.equalTo(sureBtn.snp.top)
            make.left.equalTo(sureBtn)
            make.right.equalTo(sureBtn)
            make.height.equalTo(1)
        }
        
        let line2 = UILabel()
        line2.backgroundColor = WVColor.WVTableLineColor()
        sureBtn.addSubview(line2)
        line2.snp.makeConstraints { (make) in
            make.bottom.equalTo(sureBtn.snp.bottom)
            make.left.equalTo(sureBtn)
            make.right.equalTo(sureBtn)
            make.height.equalTo(1)
        }

        let detailLabel = UILabel()
        detailLabel.textColor = UIColor.darkGray
        detailLabel.textAlignment = .center
        detailLabel.font = UIFont.systemFont(ofSize: 13)
        detailLabel.lineBreakMode = .byTruncatingTail
        detailLabel.numberOfLines = 0
        detailLabel.text = detail
        detailLabel.sizeToFit()
        actionsheet.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.bottom.equalTo(sureBtn.snp.top).offset(-20)
        }
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.text = title
        titleLabel.textColor = WVColor.WVBlackTextColor()
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        actionsheet.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.bottom.equalTo(detailLabel.snp.top).offset(-20)
        }
        
        actionsheet.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.top.equalTo(titleLabel.snp.top).offset(-20)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(cancelButtonAction))
        self.addGestureRecognizer(tap)
        let nilTap = UITapGestureRecognizer(target: self, action: nil)
        actionsheet.addGestureRecognizer(nilTap)
    }
    
    func show() {
        let window = UIApplication.shared.delegate?.window
        window!!.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalTo(window!!)
        }
    }
    
    @objc
    private func cancelButtonAction() {
//        UIView.animate(withDuration: 0.25, animations: {
//            self.actionsheet.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 0)
//        }, completion: { (finish) in
            self.cancelBtnAction?()
            self.removeFromSuperview()
//        })
    }
    
    @objc
    private func sureButtonAction() {
//        UIView.animate(withDuration: 0.25, animations: {
//            self.actionsheet.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 0)
//        }, completion: { (finish) in
            self.sureBtnAction?()
            self.removeFromSuperview()
//        })
    }
}
