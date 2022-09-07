//
//  objc_msgSend.h
//  
//
//  Created by ericliuhusky on 2022/9/5.
//

#ifndef objc_msgSend_h
#define objc_msgSend_h

#include <objc/message.h>


#define objc_msgSend_set_define(type) \
void objc_msgSend_set_##type(id _Nullable self, SEL _Nonnull op, type arg);

#define objc_msgSend_get_define(type) \
type objc_msgSend_get_##type(id _Nullable self, SEL _Nonnull op);


typedef long double LongDouble;

objc_msgSend_set_define(bool)
objc_msgSend_set_define(int8_t)
objc_msgSend_set_define(uint8_t)
objc_msgSend_set_define(int16_t)
objc_msgSend_set_define(uint16_t)
objc_msgSend_set_define(int32_t)
objc_msgSend_set_define(uint32_t)
objc_msgSend_set_define(int64_t)
objc_msgSend_set_define(uint64_t)
objc_msgSend_set_define(float)
objc_msgSend_set_define(double)
objc_msgSend_set_define(LongDouble)

objc_msgSend_get_define(bool)
objc_msgSend_get_define(int8_t)
objc_msgSend_get_define(uint8_t)
objc_msgSend_get_define(int16_t)
objc_msgSend_get_define(uint16_t)
objc_msgSend_get_define(int32_t)
objc_msgSend_get_define(uint32_t)
objc_msgSend_get_define(int64_t)
objc_msgSend_get_define(uint64_t)
objc_msgSend_get_define(float)
objc_msgSend_get_define(double)
objc_msgSend_get_define(LongDouble)


#endif /* objc_msgSend_h */
