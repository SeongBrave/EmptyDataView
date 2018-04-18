//
//  EmptyDataView.swift
//  EmptyList
//
//  Created by eme on 2017/3/30.
//  Copyright © 2017年 Icy. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

/// 列表数据为空时显示的界面
open class EmptyDataView: UIView {
    
    /// UI控件
    var logo_ImgV = UIImageView()
    var desc_Lb = UILabel()
    public var reload_Btn = UIButton(type: .custom)
    /// 修改logo图片距离顶部的距离默认55
    var verticalOffset: CGFloat = 55{
        didSet{
            self.logo_ImgV.snp.updateConstraints{ make in
                make.top.equalToSuperview().offset(self.verticalOffset)
            }
        }
    }
    let disposeBag = DisposeBag()
    ///图片的宽度
    var img_Width:CGFloat{
        get{
            switch Device.size {
            case .UnknownSize:
                return  100
            case .Screen3_5Inch:
                return 88
            case .Screen4Inch:
                return 95
            case .Screen4_7Inch:
                return 109
            case .Screen5_5Inch:
                return 109
            case .Screen7_9Inch:
                return 109
            default:
                return 109
            }
        }
    }
    /// 图片与lable之间的距离
    var img_v_desc:CGFloat{
        get{
            switch Device.size {
            case .UnknownSize:
                return  18
            case .Screen3_5Inch:
                return 10
            case .Screen4Inch:
                return 16
            case .Screen4_7Inch:
                return 16
            case .Screen5_5Inch:
                return 18
            case .Screen7_9Inch:
                return 18
            default:
                return 18
            }
        }
    }
    
    /// lable距离视图中间的具体
    var desc_v_centerY:CGFloat{
        get{
            switch Device.size {
            case .UnknownSize:
                return  -80
            case .Screen3_5Inch:
                return -40
            case .Screen4Inch:
                return -50
            case .Screen4_7Inch:
                return -70
            case .Screen5_5Inch:
                return -80
            case .Screen7_9Inch:
                return -80
            default:
                return -80
            }
        }
    }
    
    /// lable与btn之间的距离
    var desc_v_btn:CGFloat{
        get{
            switch Device.size {
            case .UnknownSize:
                return  30
            case .Screen3_5Inch:
                return 20
            case .Screen4Inch:
                return 25
            case .Screen4_7Inch:
                return 28
            case .Screen5_5Inch:
                return 30
            case .Screen7_9Inch:
                return 30
            default:
                return 30
            }
        }
    }
    
    func setupSubviews() {
        self.addSubview(self.logo_ImgV)
        desc_Lb.textAlignment = .center
        desc_Lb.numberOfLines = 0
        desc_Lb.font = UIFont(name: "Helvetica", size: 14)
        desc_Lb.textColor = UIColor.lightGray
        self.addSubview(self.desc_Lb)
        reload_Btn.titleLabel?.font = UIFont(name: "Helvetica", size: 17)
        self.addSubview(self.reload_Btn)
        reload_Btn.layer.cornerRadius = 6.0
        reload_Btn.layer.masksToBounds = true
        reload_Btn.backgroundColor = UIColor.white
        reload_Btn.setTitleColor(UIColor.black, for: .normal)
        
        self.logo_ImgV.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(self.verticalOffset)
            make.centerX.equalToSuperview()
            make.width.equalTo(self.img_Width)
            make.height.equalTo(self.logo_ImgV.snp.width).offset(0)
        }
        self.desc_Lb.snp.makeConstraints{ make in
            make.leading.greaterThanOrEqualTo(10)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.logo_ImgV.snp.bottom).offset(self.img_v_desc)
        }
        self.reload_Btn.snp.makeConstraints{ make in
            make.top.equalTo(self.desc_Lb.snp.bottom).offset(self.desc_v_btn)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
        self.reload_Btn.addTarget(self, action: #selector(EmptyDataView.didTapButton), for: .touchUpInside)
        
    }
    @objc func didTapButton(_ button: UIButton) {
        let selector = #selector(UITableView.dzn_Tv_didTapDataButton)
        ///表示父类是uitableivew
        if superview?.responds(to: selector) != nil {
            superview?.perform(selector, with: button, afterDelay: 0)
        }else{
            let selector = #selector(UICollectionView.dzn_Cv_didTapDataButton)
            guard let _ = superview?.responds(to: selector) else {
                return
            }
            ///这块表示执行的是uicollectionview
            superview?.perform(selector, with: button, afterDelay: 0)
        }
    }
    open override func awakeFromNib() {
        setupSubviews()
    }
    open override func draw(_ rect: CGRect) {
        
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    public required  init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

public enum Size: Int {
    case UnknownSize = 0
    case Screen3_5Inch
    case Screen4Inch
    case Screen4_7Inch
    case Screen5_5Inch
    case Screen7_9Inch
    case Screen9_7Inch
    case Screen12_9Inch
}
class Device {
    static var size:Size{
        get{
            let w: Double = Double(UIScreen.main.bounds.width)
            let h: Double = Double(UIScreen.main.bounds.height)
            let screenHeight: Double = max(w, h)
            
            switch screenHeight {
            case 480:
                return Size.Screen3_5Inch
            case 568:
                return Size.Screen4Inch
            case 667:
                return UIScreen.main.scale == 3.0 ? Size.Screen5_5Inch : Size.Screen4_7Inch
            case 736:
                return Size.Screen5_5Inch
            case 1024:
                return Size.Screen9_7Inch
            case 1366:
                return Size.Screen12_9Inch
            default:
                return Size.UnknownSize
            }
        }
    }
}

