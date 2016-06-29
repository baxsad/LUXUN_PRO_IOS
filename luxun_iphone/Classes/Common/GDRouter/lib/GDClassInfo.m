//
//  GDClassInfo.m
//  GDKit <https://github.com/ibireme/GDKit>
//
//  Created by ibireme on 15/5/9.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "GDClassInfo.h"
#import <objc/runtime.h>
#import <libkern/OSAtomic.h>

GDEncodingType GDEncodingGetType(const char *typeEncoding) {
    char *type = (char *)typeEncoding;
    if (!type) return GDEncodingTypeUnknown;
    size_t len = strlen(type);
    if (len == 0) return GDEncodingTypeUnknown;
    
    GDEncodingType qualifier = 0;
    bool prefix = true;
    while (prefix) {
        switch (*type) {
            case 'r': {
                qualifier |= GDEncodingTypeQualifierConst;
                type++;
            } break;
            case 'n': {
                qualifier |= GDEncodingTypeQualifierIn;
                type++;
            } break;
            case 'N': {
                qualifier |= GDEncodingTypeQualifierInout;
                type++;
            } break;
            case 'o': {
                qualifier |= GDEncodingTypeQualifierOut;
                type++;
            } break;
            case 'O': {
                qualifier |= GDEncodingTypeQualifierBycopy;
                type++;
            } break;
            case 'R': {
                qualifier |= GDEncodingTypeQualifierByref;
                type++;
            } break;
            case 'V': {
                qualifier |= GDEncodingTypeQualifierOneway;
                type++;
            } break;
            default: { prefix = false; } break;
        }
    }

    len = strlen(type);
    if (len == 0) return GDEncodingTypeUnknown | qualifier;

    switch (*type) {
        case 'v': return GDEncodingTypeVoid | qualifier;
        case 'B': return GDEncodingTypeBool | qualifier;
        case 'c': return GDEncodingTypeInt8 | qualifier;
        case 'C': return GDEncodingTypeUInt8 | qualifier;
        case 's': return GDEncodingTypeInt16 | qualifier;
        case 'S': return GDEncodingTypeUInt16 | qualifier;
        case 'i': return GDEncodingTypeInt32 | qualifier;
        case 'I': return GDEncodingTypeUInt32 | qualifier;
        case 'l': return GDEncodingTypeInt32 | qualifier;
        case 'L': return GDEncodingTypeUInt32 | qualifier;
        case 'q': return GDEncodingTypeInt64 | qualifier;
        case 'Q': return GDEncodingTypeUInt64 | qualifier;
        case 'f': return GDEncodingTypeFloat | qualifier;
        case 'd': return GDEncodingTypeDouble | qualifier;
        case 'D': return GDEncodingTypeLongDouble | qualifier;
        case '#': return GDEncodingTypeClass | qualifier;
        case ':': return GDEncodingTypeSEL | qualifier;
        case '*': return GDEncodingTypeCString | qualifier;
        case '?': return GDEncodingTypePointer | qualifier;
        case '[': return GDEncodingTypeCArray | qualifier;
        case '(': return GDEncodingTypeUnion | qualifier;
        case '{': return GDEncodingTypeStruct | qualifier;
        case '@': {
            if (len == 2 && *(type + 1) == '?')
                return GDEncodingTypeBlock | qualifier;
            else
                return GDEncodingTypeObject | qualifier;
        } break;
        default: return GDEncodingTypeUnknown | qualifier;
    }
}

@implementation GDClassIvarInfo

- (instancetype)initWithIvar:(Ivar)ivar {
    if (!ivar) return nil;
    self = [super init];
    _ivar = ivar;
    const char *name = ivar_getName(ivar);
    if (name) {
        _name = [NSString stringWithUTF8String:name];
    }
    _offset = ivar_getOffset(ivar);
    const char *typeEncoding = ivar_getTypeEncoding(ivar);
    if (typeEncoding) {
        _typeEncoding = [NSString stringWithUTF8String:typeEncoding];
        _type = GDEncodingGetType(typeEncoding);
    }
    return self;
}

@end

@implementation GDClassMethodInfo

- (instancetype)initWithMethod:(Method)method {
    if (!method) return nil;
    self = [super init];
    _method = method;
    _sel = method_getName(method);
    _imp = method_getImplementation(method);
    const char *name = sel_getName(_sel);
    if (name) {
        _name = [NSString stringWithUTF8String:name];
    }
    const char *typeEncoding = method_getTypeEncoding(method);
    if (typeEncoding) {
        _typeEncoding = [NSString stringWithUTF8String:typeEncoding];
    }
    char *returnType = method_copyReturnType(method);
    if (returnType) {
        _returnTypeEncoding = [NSString stringWithUTF8String:returnType];
        free(returnType);
    }
    unsigned int argumentCount = method_getNumberOfArguments(method);
    if (argumentCount > 0) {
        NSMutableArray *argumentTypes = [NSMutableArray new];
        for (unsigned int i = 0; i < argumentCount; i++) {
            char *argumentType = method_copyArgumentType(method, i);
            if (argumentType) {
                NSString *type = [NSString stringWithUTF8String:argumentType];
                [argumentTypes addObject:type ? type : @""];
                free(argumentType);
            } else {
                [argumentTypes addObject:@""];
            }
        }
        _argumentTypeEncodings = argumentTypes;
    }
    return self;
}

@end

@implementation GDClassPropertyInfo

- (instancetype)initWithProperty:(objc_property_t)property {
    if (!property) return nil;
    self = [self init];
    _property = property;
    const char *name = property_getName(property);
    if (name) {
        _name = [NSString stringWithUTF8String:name];
    }
    
    GDEncodingType type = 0;
    unsigned int attrCount;
    objc_property_attribute_t *attrs = property_copyAttributeList(property, &attrCount);
    for (unsigned int i = 0; i < attrCount; i++) {
        switch (attrs[i].name[0]) {
            case 'T': { // Type encoding
                if (attrs[i].value) {
                    _typeEncoding = [NSString stringWithUTF8String:attrs[i].value];
                    type = GDEncodingGetType(attrs[i].value);
                    if (type & GDEncodingTypeObject) {
                        size_t len = strlen(attrs[i].value);
                        if (len > 3) {
                            char name[len - 2];
                            name[len - 3] = '\0';
                            memcpy(name, attrs[i].value + 2, len - 3);
                            _cls = objc_getClass(name);
                        }
                    }
                }
            } break;
            case 'V': { // Instance variable
                if (attrs[i].value) {
                    _ivarName = [NSString stringWithUTF8String:attrs[i].value];
                }
            } break;
            case 'R': {
                type |= GDEncodingTypePropertyReadonly;
            } break;
            case 'C': {
                type |= GDEncodingTypePropertyCopy;
            } break;
            case '&': {
                type |= GDEncodingTypePropertyRetain;
            } break;
            case 'N': {
                type |= GDEncodingTypePropertyNonatomic;
            } break;
            case 'D': {
                type |= GDEncodingTypePropertyDynamic;
            } break;
            case 'W': {
                type |= GDEncodingTypePropertyWeak;
            } break;
            case 'P': {
                type |= GDEncodingTypePropertyGarbage;
            } break;
            case 'G': {
                type |= GDEncodingTypePropertyCustomGetter;
                if (attrs[i].value) {
                    _getter = [NSString stringWithUTF8String:attrs[i].value];
                }
            } break;
            case 'S': {
                type |= GDEncodingTypePropertyCustomSetter;
                if (attrs[i].value) {
                    _setter = [NSString stringWithUTF8String:attrs[i].value];
                }
            } break;
            default:
                break;
        }
    }
    if (attrs) {
        free(attrs);
        attrs = NULL;
    }
    
    _type = type;
    if (_name.length) {
        if (!_getter) {
            _getter = _name;
        }
        if (!_setter) {
            _setter = [NSString stringWithFormat:@"set%@%@:", [_name substringToIndex:1].uppercaseString, [_name substringFromIndex:1]];
        }
    }
    return self;
}

@end

@implementation GDClassInfo {
    BOOL _needUpdate;
}

- (instancetype)initWithClass:(Class)cls {
    if (!cls) return nil;
    self = [super init];
    _cls = cls;
    _superCls = class_getSuperclass(cls);
    _isMeta = class_isMetaClass(cls);
    if (!_isMeta) {
        _metaCls = objc_getMetaClass(class_getName(cls));
    }
    _name = NSStringFromClass(cls);
    [self _update];

    _superClassInfo = [self.class classInfoWithClass:_superCls];
    return self;
}

- (instancetype)initWithClassName:(NSString *)className {
    Class cls = NSClassFromString(className);
    return [self initWithClass:cls];
}

- (void)_update {
    _ivarInfos = nil;
    _methodInfos = nil;
    _propertyInfos = nil;
    
    Class cls = self.cls;
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(cls, &methodCount);
    if (methods) {
        NSMutableDictionary *methodInfos = [NSMutableDictionary new];
        _methodInfos = methodInfos;
        for (unsigned int i = 0; i < methodCount; i++) {
            GDClassMethodInfo *info = [[GDClassMethodInfo alloc] initWithMethod:methods[i]];
            if (info.name) methodInfos[info.name] = info;
        }
        free(methods);
    }
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(cls, &propertyCount);
    if (properties) {
        NSMutableDictionary *propertyInfos = [NSMutableDictionary new];
        _propertyInfos = propertyInfos;
        for (unsigned int i = 0; i < propertyCount; i++) {
            GDClassPropertyInfo *info = [[GDClassPropertyInfo alloc] initWithProperty:properties[i]];
            if (info.name) propertyInfos[info.name] = info;
        }
        free(properties);
    }
    
    unsigned int ivarCount = 0;
    Ivar *ivars = class_copyIvarList(cls, &ivarCount);
    if (ivars) {
        NSMutableDictionary *ivarInfos = [NSMutableDictionary new];
        _ivarInfos = ivarInfos;
        for (unsigned int i = 0; i < ivarCount; i++) {
            GDClassIvarInfo *info = [[GDClassIvarInfo alloc] initWithIvar:ivars[i]];
            if (info.name) ivarInfos[info.name] = info;
        }
        free(ivars);
    }
    _needUpdate = NO;
}

- (void)setNeedUpdate {
    _needUpdate = YES;
}

+ (instancetype)classInfoWithClass:(Class)cls {
    if (!cls) return nil;
    static CFMutableDictionaryRef classCache;
    static CFMutableDictionaryRef metaCache;
    static dispatch_once_t onceToken;
    static OSSpinLock lock;
    dispatch_once(&onceToken, ^{
        classCache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        metaCache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        lock = OS_SPINLOCK_INIT;
    });
    OSSpinLockLock(&lock);
    GDClassInfo *info = CFDictionaryGetValue(class_isMetaClass(cls) ? metaCache : classCache, (__bridge const void *)(cls));
    if (info && info->_needUpdate) {
        [info _update];
    }
    OSSpinLockUnlock(&lock);
    if (!info) {
        info = [[GDClassInfo alloc] initWithClass:cls];
        if (info) {
            OSSpinLockLock(&lock);
            CFDictionarySetValue(info.isMeta ? metaCache : classCache, (__bridge const void *)(cls), (__bridge const void *)(info));
            OSSpinLockUnlock(&lock);
        }
    }
    return info;
}

+ (instancetype)classInfoWithClassName:(NSString *)className {
    Class cls = NSClassFromString(className);
    return [self classInfoWithClass:cls];
}

@end
