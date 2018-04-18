//
//  AssociatedObject.swift
//  Pods
//
//  Created by eme on 2017/4/27.
//
//

import Foundation
class AssociatedObject {
    
    /// 获取关联属性
    ///
    /// - parameter base:        关联类
    /// - parameter key:         属性对应key
    /// - parameter initialiser: 初始化闭包
    ///
    /// - returns: 属性
  static  func associatedObject<ValueType: Any>(base: Any, key: UnsafePointer<UInt8>, initialiser: () -> ValueType) -> ValueType {
        
        if let associated = objc_getAssociatedObject(base, key) as? ValueType {
            return associated
        }
        
        let associated = initialiser()
        
        objc_setAssociatedObject(base, key, associated, .OBJC_ASSOCIATION_RETAIN)
        
        return associated
        
    }
    
    
    /// 设置关联属性值
    ///
    /// - parameter base:  关联类
    /// - parameter key:   属性对应key
    /// - parameter value: 新值
  static  func associatedObject<ValueType: Any>(base: Any, key: UnsafePointer<UInt8>, value: ValueType) {
        
        objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)
        
    }
    
}
