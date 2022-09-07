//
//  YYClassInfo.swift
//  
//
//  Created by ericliuhusky on 2022/9/5.
//

import Foundation

class Class {
    let superclass: Class?
    let properties: [Property]
    
    private init?(cls: AnyClass?) {
        // 忽略NSObject和SwiftObject
        guard let superCls = class_getSuperclass(cls) else { return nil }
        superclass = Class(cls: superCls)
        
        var propertyCount: UInt32 = 0
        let propertiesPtr = class_copyPropertyList(cls, &propertyCount)
        let propertiesBuffer = UnsafeBufferPointer(start: propertiesPtr, count: Int(propertyCount))
        properties = propertiesBuffer.map { Property(property: $0) }
        free(propertiesPtr)
    }
    
    // 缓存某一个模型对应的Class
    static func cached(cls: AnyClass) -> Class? {
        let key = String(cString: class_getName(cls))
        if let cls = Cache[key] {
            return cls
        }
        let cls = Class(cls: cls)
        Cache[key] = cls
        return cls
    }
    
    // 必须声明为lazy var，否则每次调用都需要重新遍历计算
    lazy var allProperties: [String: Property] = {
        var allProperties = [String: Property]()
        var cur: Class? = self
        while cur != nil {
            cur?.properties.forEach({ property in
                allProperties[property.name] = property
            })
            cur = cur?.superclass
        }
        return allProperties
    }()
}

class Property {
    let name: String
    let type: Any
    
    init(property: objc_property_t) {
        name = String(cString: property_getName(property))
        
        let typeAttribute = String(cString: property_copyAttributeValue(property, "T")!)
        type = typeAttribute.objcType
    }
    
    var getter: Selector {
        sel_registerName(name)
    }
    
    var setter: Selector {
        sel_registerName("set\(name.firstLetterUppercased):")
    }
}


extension String {
    var firstLetterUppercased: String {
        (first?.uppercased() ?? "") + dropFirst()
    }
    
    var objcType: Any {
        let encoding = [Character](self)
        let type = encoding[0]
        switch type {
        case "v": return Void.self
        case "B": return Bool.self
        case "c": return Int8.self
        case "C": return UInt8.self
        case "s": return Int16.self
        case "S": return UInt16.self
        case "i": return Int32.self
        case "I": return UInt32.self
        case "l": return Int32.self
        case "L": return UInt32.self
        case "q": return Int64.self
        case "Q": return UInt64.self
        case "f": return Float.self
        case "d": return Double.self
        case "D": return LongDouble.self
        case "@":
            if !(encoding[1] == "?") {
                let endIndex = encoding[2...].firstIndex(of: "\"")!
                let clsName = String(encoding[2..<endIndex])
                let cls: AnyClass? = objc_getClass(clsName) as? AnyClass
                return cls!
            }
        default:
            fatalError()
        }
        fatalError()
    }
}


struct Cache {
    private static var cls = [String: Class]()
    private static let clsLock = NSLock()
    static subscript(key: String) -> Class? {
        get {
            clsLock.lock()
            let cls = cls[key]
            clsLock.unlock()
            return cls
        }
        
        set {
            clsLock.lock()
            cls[key] = newValue
            clsLock.unlock()
        }
    }
}
