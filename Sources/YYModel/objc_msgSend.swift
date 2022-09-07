//
//  objc_msgSend.swift
//  
//
//  Created by ericliuhusky on 2022/9/6.
//

import objc_msgSend

// 不使用KVC可能是因为效率差，performSelector只是调用了objc_msgSend效率较高
// 但performSelector经过封装之后参数和返回值只能是id对象，对于int, float等基础C类型只能使用objc_msgSend
// 而Swift不支持C风格多参数，所以必须使用C语言封装

typealias LongDouble = objc_msgSend.LongDouble

func objc_msgSend_set<Value>(_ self: Any?, _ op: Selector, _ arg: Value) {
    if let arg = arg as? Bool {
        objc_msgSend_set_bool(self, op, arg)
    } else if let arg = arg as? Int8 {
        objc_msgSend_set_int8_t(self, op, arg)
    } else if let arg = arg as? UInt8 {
        objc_msgSend_set_uint8_t(self, op, arg)
    } else if let arg = arg as? Int16 {
        objc_msgSend_set_int16_t(self, op, arg)
    } else if let arg = arg as? UInt16 {
        objc_msgSend_set_uint16_t(self, op, arg)
    } else if let arg = arg as? Int32 {
        objc_msgSend_set_int32_t(self, op, arg)
    } else if let arg = arg as? UInt32 {
        objc_msgSend_set_uint32_t(self, op, arg)
    } else if let arg = arg as? Int64 {
        objc_msgSend_set_int64_t(self, op, arg)
    } else if let arg = arg as? UInt64 {
        objc_msgSend_set_uint64_t(self, op, arg)
    } else if let arg = arg as? Float {
        objc_msgSend_set_float(self, op, arg)
    } else if let arg = arg as? Double {
        objc_msgSend_set_double(self, op, arg)
    } else if let arg = arg as? LongDouble {
        objc_msgSend_set_LongDouble(self, op, arg)
    }
}

func objc_msgSend_get<Value>(_ self: Any?, _ op: Selector, _ type: Value.Type) -> Value? {
    switch type {
    case _ where type is Bool.Type:
        return objc_msgSend_get_bool(self, op) as? Value
    case _ where type is Int8.Type:
        return objc_msgSend_get_int8_t(self, op) as? Value
    case _ where type is UInt8.Type:
        return objc_msgSend_get_uint8_t(self, op) as? Value
    case _ where type is Int16.Type:
        return objc_msgSend_get_int16_t(self, op) as? Value
    case _ where type is UInt16.Type:
        return objc_msgSend_get_uint16_t(self, op) as? Value
    case _ where type is Int32.Type:
        return objc_msgSend_get_int32_t(self, op) as? Value
    case _ where type is UInt32.Type:
        return objc_msgSend_get_uint32_t(self, op) as? Value
    case _ where type is Int64.Type:
        return objc_msgSend_get_int64_t(self, op) as? Value
    case _ where type is UInt64.Type:
        return objc_msgSend_get_uint64_t(self, op) as? Value
    case _ where type is Float.Type:
        return objc_msgSend_get_float(self, op) as? Value
    case _ where type is Double.Type:
        return objc_msgSend_get_double(self, op) as? Value
    case _ where type is LongDouble.Type:
        return objc_msgSend_get_LongDouble(self, op) as? Value
    default:
        return nil
    }
}
