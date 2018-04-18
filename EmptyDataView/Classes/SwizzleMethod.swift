//
//  SwizzleMethod.swift
//  Pods
//
//  Created by eme on 2017/4/27.
//
//

import Foundation



class SwizzleMethod {
    
   static func swizzleMethod(_ cls: AnyClass,originalSelector: Selector, swizzledSelector: Selector) {
        
        let originalMethod = class_getInstanceMethod(cls, originalSelector)
        let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector)
        
        let didAddMethod = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
        
        
        if didAddMethod {
            class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        } else {
            method_exchangeImplementations(originalMethod!, swizzledMethod!);
        }
        
    }
    
}
