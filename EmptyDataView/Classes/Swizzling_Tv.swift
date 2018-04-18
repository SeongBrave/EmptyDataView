//
//  Swizzling_Tv.swift
//  Pods
//
//  Created by eme on 2017/4/27.
//
//

import UIKit
import SnapKit

internal struct Static_Tv{
    static var isSwizzleEndUpdates_Tv = false
    static var isSwizzleReloadData_Tv = false
}

internal extension UITableView{
    
    func  swizzleReloadData_Tv(){
        if Static_Tv.isSwizzleEndUpdates_Tv {
            return
        }
        SwizzleMethod.swizzleMethod(self.classForCoder, originalSelector: #selector(UITableView.reloadData), swizzledSelector: #selector(UITableView.dzn_tv_reloadData))
        Static_Tv.isSwizzleEndUpdates_Tv = true
    }
    @objc func dzn_tv_reloadData(){
        dzn_tv_reloadData()
        dzn_tv_reloadEmptyDataSet()
    }
    func dzn_tv_reloadEmptyDataSet() {
        guard dzn_Tv_canDisplay() else {
            return
        }
        if (dzn_tv_emptyDelegate?.shouldDisplay(emptyView: self) ?? true && dzn_Tv_itemsCount == 0) ||
            dzn_tv_emptyDelegate?.shouldBeForcedToDisplay(emptyView: self) ?? false {
            
            dzn_tv_emptyDelegate?.willAppear(emptyView: self)
            
            guard let view = emptyView_Tv else {
                return
            }
            if view.superview == nil {
                
                if self.subviews.count > 1 {
                    insertSubview(view, at: 0)
                } else {
                    addSubview(view)
                }
            }
            view.snp.makeConstraints({ (make) in
                make.width.equalToSuperview()
                make.height.equalToSuperview()
                make.center.equalToSuperview()
            })
            view.desc_Lb.attributedText = dzn_tv_emptyDataSource?.description(emptyView: self)
            view.logo_ImgV.image = dzn_tv_emptyDataSource?.image(emptyView: self)
            if let verticalOffset = dzn_tv_emptyDataSource?.verticalOffset(emptyView: self), verticalOffset > 0{
                view.verticalOffset = verticalOffset
            }
            if let buttonTitle = dzn_tv_emptyDataSource?.buttonTitle(emptyView: self, state: .normal) {
                view.reload_Btn.setAttributedTitle(buttonTitle, for: .normal)
                view.reload_Btn.setAttributedTitle(dzn_tv_emptyDataSource?.buttonTitle(emptyView: self, state: .highlighted), for: .highlighted)
                view.reload_Btn.setBackgroundImage(dzn_tv_emptyDataSource?.buttonBackgroundImage(emptyView: self, forState: .normal), for: .normal)
                view.reload_Btn.setBackgroundImage(dzn_tv_emptyDataSource?.buttonBackgroundImage(emptyView: self, forState: .highlighted), for: .highlighted)
                view.reload_Btn.isHidden = false
            }else{
                view.reload_Btn.isHidden = true
            }
            view.backgroundColor = dzn_tv_emptyDataSource?.backgroundColor(emptyView: self)
            view.isHidden = false
            view.clipsToBounds = false
            // 配置可被点击
            view.isUserInteractionEnabled = dzn_tv_emptyDelegate?.shouldAllowTouch(emptyView: self) ?? true
            UIView.performWithoutAnimation {
                view.layoutIfNeeded()
            }
            isScrollEnabled = dzn_tv_emptyDelegate?.shouldAllowScroll(emptyView: self) ?? true
            dzn_tv_emptyDelegate?.didAppear(emptyView: self)
            
        } else if emptyView_Tv?.isHidden ?? false {
            dzn_Tv_invalidate()
        }else{
            emptyView_Tv?.isHidden = true
        }
        
    }
    
    
    
    
}

