//
//  NSObject+YYModel.swift
//
//
//  Created by ericliuhusky on 2022/9/5.
//

import Foundation

public extension NSObject {
    class func yy_model(withJSON json: String?) -> Self? {
        guard let json else { return nil }
        let jsonData = json.data(using: .utf8)
        return yy_model(withJSON: jsonData)
    }
    
    class func yy_model(withJSON json: Data?) -> Self? {
        guard let json else { return nil }
        let dict = try? JSONSerialization.jsonObject(with: json) as? [String: Any]
        return yy_model(with: dict)
    }
    
    class func yy_model(withJSON json: [String: Any]?) -> Self? {
        guard let json else { return nil }
        return yy_model(with: json)
    }
    
    class func yy_model(with dictionary: [String: Any]?) -> Self? {
        guard let dictionary else { return nil }
        
        let one = Self.init()
        if one.yy_modelSet(with: dictionary) {
            return one
        }
        return nil
    }
    
    func yy_modelSet(with dictionary: [String: Any]?) -> Bool {
        guard let dictionary else { return false }
        guard let cls = Class.cached(cls: Self.self) else { return false }
        guard !cls.allProperties.isEmpty else { return false }
        
        if cls.allProperties.count >= dictionary.count {
            dictionary.forEach { key, value in
                guard let propertyMeta = cls.allProperties[key] else { return }
                setValue(value, forProperty: propertyMeta)
            }
        } else {
            // TODO: 模型中关键字少于字典关键字的情况
        }
        return true
    }
    
    func yy_modelToJSONObject() -> Any? {
        ModelToJSONObjectRecursive(self)
    }
}

extension NSObject {
    func setValue<PropertyType: FixedWidthInteger>(_ value: Any, forProperty property: Property, type: PropertyType.Type) {
        if let value = value as? any BinaryInteger {
            objc_msgSend_set(self, property.setter, PropertyType(value))
        } else if let value = value as? String {
            objc_msgSend_set(self, property.setter, PropertyType(value)!)
        }
    }
    
    func setValue<PropertyType: BinaryFloatingPoint & LosslessStringConvertible>(_ value: Any, forProperty property: Property, type: PropertyType.Type) {
        if let value = value as? any BinaryFloatingPoint {
            objc_msgSend_set(self, property.setter, PropertyType(value))
        } else if let value = value as? String {
            objc_msgSend_set(self, property.setter, PropertyType(value)!)
        }
    }
    
    func setValue(_ value: Any, forBoolProperty property: Property) {
        if let value = value as? Bool {
            objc_msgSend_set(self, property.setter, value)
        } else if let value = value as? String {
            objc_msgSend_set(self, property.setter, Bool(value)!)
        }
    }
    
    func value<PropertyType>(forProperty property: Property, type: PropertyType.Type) -> PropertyType? {
        objc_msgSend_get(self, property.getter, type)
    }
    
    func setValue(_ value: Any?, forProperty property: Property) {
        guard let value else { return }
        switch property.type {
        case _ where property.type is Bool.Type:
            setValue(value, forBoolProperty: property)
        case _ where property.type is Int8.Type:
            setValue(value, forProperty: property, type: Int8.self)
        case _ where property.type is UInt8.Type:
            setValue(value, forProperty: property, type: UInt8.self)
        case _ where property.type is Int16.Type:
            setValue(value, forProperty: property, type: Int16.self)
        case _ where property.type is UInt16.Type:
            setValue(value, forProperty: property, type: UInt16.self)
        case _ where property.type is Int32.Type:
            setValue(value, forProperty: property, type: Int32.self)
        case _ where property.type is UInt32.Type:
            setValue(value, forProperty: property, type: UInt32.self)
        case _ where property.type is Int64.Type:
            setValue(value, forProperty: property, type: Int64.self)
        case _ where property.type is UInt64.Type:
            setValue(value, forProperty: property, type: UInt64.self)
        case _ where property.type is Float.Type:
            setValue(value, forProperty: property, type: Float.self)
        case _ where property.type is Double.Type:
            setValue(value, forProperty: property, type: Double.self)
        case _ where property.type is LongDouble.Type:
            setValue(value, forProperty: property, type: LongDouble.self)
        
        
        case _ where property.type is NSString.Type || property.type is NSMutableString.Type:
            if let value = value as? String {
                perform(property.setter, with: value)
            } else if let value = value as? NSNumber {
                perform(property.setter, with: value.stringValue)
            } else if let value = value as? Data {
                perform(property.setter, with: String(data: value, encoding: .utf8))
            } else if let value = value as? URL {
                perform(property.setter, with: value.absoluteString)
            } else if let value = value as? NSAttributedString {
                perform(property.setter, with: value.string)
            }
        case _ where property.type is NSValue.Type:
            if let value = value as? NSValue {
                perform(property.setter, with: value)
            }
        case _ where property.type is NSNumber.Type:
            if let value = value as? NSNumber {
                perform(property.setter, with: value)
            } else if let value = value as? String {
                perform(property.setter, with: value)
            }
        case _ where property.type is NSDecimalNumber.Type:
            if let value = value as? NSDecimalNumber {
                perform(property.setter, with: value)
            } else if let value = value as? NSNumber {
                perform(property.setter, with: NSDecimalNumber(decimal: value.decimalValue))
            } else if let value = value as? String {
                let dec = NSDecimalNumber(string: value)
                if dec.decimalValue.isNaN {
                    perform(property.setter, with: nil)
                } else {
                    perform(property.setter, with: dec)
                }
            }
        case _ where property.type is NSData.Type || property.type is NSMutableData.Type:
            if let value = value as? Data {
                perform(property.setter, with: value)
            } else if let value = value as? String {
                perform(property.setter, with: value.data(using: .utf8))
            }
        case _ where property.type is NSDate.Type:
            if let value = value as? Date {
                perform(property.setter, with: value)
            } else if let value = value as? Double {
                perform(property.setter, with: Date(timeIntervalSinceReferenceDate: value))
            }
        case _ where property.type is NSURL.Type:
            if let value = value as? URL {
                perform(property.setter, with: value)
            } else if let value = value as? String {
                perform(property.setter, with: URL(string: value))
            }
        case _ where property.type is NSArray.Type || property.type is NSMutableArray.Type:
            if let value = value as? [Any] {
                perform(property.setter, with: value)
            } else if let value = value as? Set<AnyHashable> {
                perform(property.setter, with: [AnyHashable](value))
            }
        case _ where property.type is NSDictionary.Type || property.type is NSMutableDictionary:
            if let value = value as? [String: Any] {
                perform(property.setter, with: value)
            }
        case _ where property.type is NSSet || property.type is NSMutableSet:
            if let value = value as? Set<AnyHashable> {
                perform(property.setter, with: value)
            } else if let value = value as? [AnyHashable] {
                perform(property.setter, with: Set<AnyHashable>(value))
            }
        default:
            break
        }
    }
}


func ModelToJSONObjectRecursive(_ model: Any?) -> Any? {
    guard let model = model else { return model }
    if let model = model as? String {
        return model
    }
    if let model = model as? NSNumber {
        return model
    }
    if let model = model as? [String: Any] {
        if JSONSerialization.isValidJSONObject(model) {
            return model
        }
        var newDic = [String: Any]()
        model.forEach { key, value in
            let keyStr = "\(key)"
            let jsonObj = ModelToJSONObjectRecursive(value)
            newDic[keyStr] = jsonObj
        }
        return newDic
    }
    if let model = model as? Set<AnyHashable> {
        let array = [AnyHashable](model)
        if JSONSerialization.isValidJSONObject(array) {
            return array
        }
        var newArray = [Any]()
        array.forEach { item in
            if let jsonObj = ModelToJSONObjectRecursive(item) {
                newArray.append(jsonObj)
            }
        }
        return newArray
    }
    if let model = model as? [Any] {
        if JSONSerialization.isValidJSONObject(model) {
            return model
        }
        var newArray = [Any]()
        model.forEach { item in
            if let jsonObj = ModelToJSONObjectRecursive(item) {
                newArray.append(jsonObj)
            }
        }
        return newArray
    }
    if let model = model as? URL {
        return model.absoluteString
    }
    if let model = model as? NSAttributedString {
        return model.string
    }
    if let model = model as? Date {
        return model.timeIntervalSinceReferenceDate
    }
    if let _ = model as? Data {
        return nil
    }
    
    guard let modelMeta = Class.cached(cls: object_getClass(model)!) else { return nil }
    if modelMeta.allProperties.isEmpty { return nil }
    
    var result = [String: Any]()
    modelMeta.allProperties.values.forEach { property in
        switch property.type {
        case _ where property.type is Bool.Type:
            result[property.name] = (model as! NSObject).value(forProperty: property, type: Bool.self)
        case _ where property.type is Int8.Type:
            result[property.name] = (model as! NSObject).value(forProperty: property, type: Int8.self)
        case _ where property.type is UInt8.Type:
            result[property.name] = (model as! NSObject).value(forProperty: property, type: UInt8.self)
        case _ where property.type is Int16.Type:
            result[property.name] = (model as! NSObject).value(forProperty: property, type: Int16.self)
        case _ where property.type is UInt16.Type:
            result[property.name] = (model as! NSObject).value(forProperty: property, type: UInt16.self)
        case _ where property.type is Int32.Type:
            result[property.name] = (model as! NSObject).value(forProperty: property, type: Int32.self)
        case _ where property.type is UInt32.Type:
            result[property.name] = (model as! NSObject).value(forProperty: property, type: UInt32.self)
        case _ where property.type is Int64.Type:
            result[property.name] = (model as! NSObject).value(forProperty: property, type: Int64.self)
        case _ where property.type is UInt64.Type:
            result[property.name] = (model as! NSObject).value(forProperty: property, type: UInt64.self)
        case _ where property.type is Float.Type:
            result[property.name] = (model as! NSObject).value(forProperty: property, type: Float.self)
        case _ where property.type is Double.Type:
            result[property.name] = (model as! NSObject).value(forProperty: property, type: Double.self)
        case _ where property.type is LongDouble.Type:
            result[property.name] = (model as! NSObject).value(forProperty: property, type: LongDouble.self)
        default:
            if let v = (model as! NSObject).perform(property.getter)?.takeRetainedValue() {
                let value = ModelToJSONObjectRecursive(v)
                result[property.name] = value
            }
        }
    }
    return result
}
