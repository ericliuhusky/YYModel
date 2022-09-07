//
//  objc_msgSend.c
//  
//
//  Created by ericliuhusky on 2022/9/5.
//

#include "objc_msgSend.h"


#define objc_msgSend_set(type) \
void objc_msgSend_set_##type(id _Nullable self, SEL _Nonnull op, type arg) { \
    ((void (*)(id, SEL, type))(void *) objc_msgSend)(self, op, arg); \
}

#define objc_msgSend_get(type) \
type objc_msgSend_get_##type(id _Nullable self, SEL _Nonnull op) { \
    return ((type (*)(id, SEL))(void *) objc_msgSend)(self, op); \
}


objc_msgSend_set(bool)
objc_msgSend_set(int8_t)
objc_msgSend_set(uint8_t)
objc_msgSend_set(int16_t)
objc_msgSend_set(uint16_t)
objc_msgSend_set(int32_t)
objc_msgSend_set(uint32_t)
objc_msgSend_set(int64_t)
objc_msgSend_set(uint64_t)
objc_msgSend_set(float)
objc_msgSend_set(double)
objc_msgSend_set(LongDouble)

objc_msgSend_get(bool)
objc_msgSend_get(int8_t)
objc_msgSend_get(uint8_t)
objc_msgSend_get(int16_t)
objc_msgSend_get(uint16_t)
objc_msgSend_get(int32_t)
objc_msgSend_get(uint32_t)
objc_msgSend_get(int64_t)
objc_msgSend_get(uint64_t)
objc_msgSend_get(float)
objc_msgSend_get(double)
objc_msgSend_get(LongDouble)
