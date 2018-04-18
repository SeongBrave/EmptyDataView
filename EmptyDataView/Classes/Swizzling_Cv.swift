//
//  Swizzling_Cv.swift
//  Pods
//
//  Created by eme on 2017/4/27.
//
//

import UIKit
import SnapKit

internal struct Static_Cv{
    static var isSwizzleEndUpdates_Cv = false
    static var isSwizzleReloadData_Cv = false
}

internal extension UICollectionView{
    func  swizzleReloadData_Cv(){
        if Static_Cv.isSwizzleEndUpdates_Cv {
            return
        }
        SwizzleMethod.swizzleMethod(self.classForCoder, originalSelector: #selector(UICollectionView.reloadData), swizzledSelector: #selector(UICollectionView.dzn_Cv_reloadData))
        Static_Cv.isSwizzleEndUpdates_Cv = true
    }
    @objc func dzn_Cv_reloadData(){
        dzn_Cv_reloadData()
        dzn_Cv_reloadEmptyDataSet()
    }
    func dzn_Cv_reloadEmptyDataSet() {
        guard dzn_Cv_canDisplay() else {
            return
        }
        if (dzn_Cv_emptyDelegate?.shouldDisplay(emptyView: self) ?? true && dzn_Cv_itemsCount == 0) ||
            dzn_Cv_emptyDelegate?.shouldBeForcedToDisplay(emptyView: self) ?? false {
            dzn_Cv_emptyDelegate?.willAppear(emptyView: self)
            guard let view = emptyView_Cv else {
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
            view.desc_Lb.attributedText = dzn_Cv_emptyDataSource?.description(emptyView: self)
            view.logo_ImgV.image = dzn_Cv_emptyDataSource?.image(emptyView: self)
            if let verticalOffset = dzn_Cv_emptyDataSource?.verticalOffset(emptyView: self), verticalOffset > 0{
                view.verticalOffset = verticalOffset
            }
            if let buttonTitle = dzn_Cv_emptyDataSource?.buttonTitle(emptyView: self, state: .normal) {
                view.reload_Btn.setAttributedTitle(buttonTitle, for: .normal)
                view.reload_Btn.setAttributedTitle(dzn_Cv_emptyDataSource?.buttonTitle(emptyView: self, state: .highlighted), for: .highlighted)
                view.reload_Btn.setBackgroundImage(dzn_Cv_emptyDataSource?.buttonBackgroundImage(emptyView: self, forState: .normal), for: .normal)
                view.reload_Btn.setBackgroundImage(dzn_Cv_emptyDataSource?.buttonBackgroundImage(emptyView: self, forState: .highlighted), for: .highlighted)
                view.reload_Btn.isHidden = false
            }else{
                view.reload_Btn.isHidden = true
            }
            view.backgroundColor = dzn_Cv_emptyDataSource?.backgroundColor(emptyView: self)
            view.isHidden = false
            view.clipsToBounds = false
            // 配置可被点击
            view.isUserInteractionEnabled = dzn_Cv_emptyDelegate?.shouldAllowTouch(emptyView: self) ?? true
            UIView.performWithoutAnimation {
                view.layoutIfNeeded()
            }
            isScrollEnabled = dzn_Cv_emptyDelegate?.shouldAllowScroll(emptyView: self) ?? true
            dzn_Cv_emptyDelegate?.didAppear(emptyView: self)
            
        } else if emptyView_Cv?.isHidden ?? false {
            dzn_Cv_invalidate()
        }else{
            emptyView_Cv?.isHidden = true
        }
    }
}

