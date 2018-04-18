//
//  UICollectionViewEx.swift
//  Pods
//
//  Created by eme on 2017/4/27.
//
//
import UIKit

internal var kEmptyDataSetSource_Cv = "emptyDataSetSource"
internal var kEmptyDelegate_Cv      = "emptyDelegate"
internal var kEmptyDataSetView_Cv   = "emptyDataSetView"
internal var kEmptyImage_Cv         = "emptyImage"

extension UICollectionView {
    /**
     空数据显现数据代理对象
     */
    weak public var dzn_Cv_emptyDataSource: EmptyDataSource?  {
        get {
            return objc_getAssociatedObject(self, &kEmptyDataSetSource_Cv) as? EmptyDataSource
        }
        set(newValue) {
            objc_setAssociatedObject(self, &kEmptyDataSetSource_Cv, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if newValue == nil || !dzn_Cv_canDisplay() {
                dzn_Cv_invalidate()
            }
            swizzleReloadData_Cv()
        }
    }
    /**
     空数据显现代理对象
     */
    weak public var dzn_Cv_emptyDelegate: EmptyDelegate? {
        
        get {
            return objc_getAssociatedObject(self, &kEmptyDelegate_Cv) as? EmptyDelegate
        }
        set(newValue) {
            if newValue != nil {
                dzn_Cv_invalidate()
            }
            objc_setAssociatedObject(self, &kEmptyDelegate_Cv, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}
extension UICollectionView {
    var emptyView_Cv: EmptyDataView? {
        get {
            if let view = objc_getAssociatedObject(self, &kEmptyDataSetView_Cv) as? EmptyDataView {
                return view
            }
            let view = EmptyDataView()
            objc_setAssociatedObject(self, &kEmptyDataSetView_Cv, view, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return view
        }
        set(newValue) {
            objc_setAssociatedObject(self, &kEmptyDataSetView_Cv, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
    }
    /// item个数
    var dzn_Cv_itemsCount: Int {
        
        get {
            let items = collectionViewItemsCount()
            return items
        }
    }
    
    /**
     collectionView 有多少项
     */
    func collectionViewItemsCount() -> Int {
        var items = 0
        if !responds(to: #selector(getter: UICollectionView.dataSource)) {
            return items
        }
        let sections = self.dataSource?.numberOfSections?(in: self) ?? 0
        
        for sectionsIndex in 0..<sections {
            
            items += self.dataSource?.collectionView(self, numberOfItemsInSection: sectionsIndex) ?? 0
        }
        return items
        
    }
    /**
     初始化
     */
    func dzn_Cv_invalidate() {
        dzn_Cv_emptyDelegate?.didAppear(emptyView: self)
        emptyView_Cv?.removeFromSuperview()
        emptyView_Cv = nil
        isScrollEnabled = true
        dzn_Cv_emptyDelegate?.didDisappear(emptyView: self)
    }
    /**
     是否可以显示
     
     - Returns: 是否显示
     - true 可以显示
     - false 不能显示
     */
    func dzn_Cv_canDisplay() -> Bool {
        guard let _ = dzn_Cv_emptyDataSource else {
            return false
        }
        return true
    }
    
    
   @objc func dzn_Cv_didTapDataButton(_ sender: UIButton) {
        dzn_Cv_emptyDelegate?.didTap(emptyView: self, button: sender)
    }
    
}


