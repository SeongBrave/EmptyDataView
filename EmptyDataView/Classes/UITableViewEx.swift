//
//  UITableViewEx.swift
//  Pods
//
//  Created by eme on 2017/4/27.
//
//

import UIKit

internal var kEmptyDataSetSource_Tv = "emptyDataSetSource"
internal var kEmptyDelegate_Tv      = "emptyDelegate"
internal var kEmptyDataSetView_Tv   = "emptyDataSetView"
internal var kEmptyImage_Tv         = "emptyImage"

extension UITableView {
    
    
    /**
     空数据显现数据代理对象
     */
    weak public var dzn_tv_emptyDataSource: EmptyDataSource?  {
        get {
            return objc_getAssociatedObject(self, &kEmptyDataSetSource_Tv) as? EmptyDataSource
        }
        set(newValue) {
            objc_setAssociatedObject(self, &kEmptyDataSetSource_Tv, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if newValue == nil || !dzn_Tv_canDisplay() {
                dzn_Tv_invalidate()
            }
            swizzleReloadData_Tv()
        }
    }
    /**
     空数据显现代理对象
     */
    weak public var dzn_tv_emptyDelegate: EmptyDelegate? {
        
        get {
            return objc_getAssociatedObject(self, &kEmptyDelegate_Tv) as? EmptyDelegate
        }
        set(newValue) {
            if newValue != nil {
                dzn_Tv_invalidate()
            }
            objc_setAssociatedObject(self, &kEmptyDelegate_Tv, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
extension UITableView {
    
    public var emptyView_Tv: EmptyDataView? {
        
        get {
            
            if let view = objc_getAssociatedObject(self, &kEmptyDataSetView_Tv) as? EmptyDataView {
                return view
            }
            
            let view = EmptyDataView()
            objc_setAssociatedObject(self, &kEmptyDataSetView_Tv, view, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            return view
            
        }
        set(newValue) {
            objc_setAssociatedObject(self, &kEmptyDataSetView_Tv, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
    }
    /// item个数
    var dzn_Tv_itemsCount: Int {
        
        get {
            
            let items = tableViewItemsCount()
            
            
            return items
            
        }
    }
    
    /**
     获取tableView 有多少项
     */
    func tableViewItemsCount() -> Int {
        var items = 0
        if !responds(to: #selector(getter: UITableView.dataSource)) {
            return items
        }
        let sections = self.dataSource?.numberOfSections?(in: self) ?? 0
        for sectionIndex in 0..<sections {
            
            items += self.dataSource?.tableView(self, numberOfRowsInSection: sectionIndex) ?? 0
        }
        return items
        
    }
    
    
    /**
     初始化
     */
    func dzn_Tv_invalidate() {
        dzn_tv_emptyDelegate?.didAppear(emptyView: self)
        emptyView_Tv?.removeFromSuperview()
        emptyView_Tv = nil
        isScrollEnabled = true
        dzn_tv_emptyDelegate?.didDisappear(emptyView: self)
    }
    
    /**
     是否可以显示
     
     - Returns: 是否显示
     - true 可以显示
     - false 不能显示
     */
    func dzn_Tv_canDisplay() -> Bool {
        
        guard let _ = dzn_tv_emptyDataSource else {
            return false
        }
        return true
    }
    
    
   @objc func dzn_Tv_didTapDataButton(_ sender: UIButton) {
        guard let deletage = self.dzn_tv_emptyDelegate else {
            return
        }
        
        deletage.didTap(emptyView: self, button: sender)
        
    }
    
}

