//
//  GDModelMeta.m
//  2HUO
//
//  Created by iURCoder on 4/15/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "GDModelMeta.h"
#import <libkern/OSAtomic.h>

#define force_inline __inline__ __attribute__((always_inline))

static force_inline GDEncodingNSType GDClassGetNSType(Class cls) {
    if (!cls) return GDEncodingTypeNSUnknown;
    if ([cls isSubclassOfClass:[NSMutableString class]]) return GDEncodingTypeNSMutableString;
    if ([cls isSubclassOfClass:[NSString class]]) return GDEncodingTypeNSString;
    if ([cls isSubclassOfClass:[NSDecimalNumber class]]) return GDEncodingTypeNSDecimalNumber;
    if ([cls isSubclassOfClass:[NSNumber class]]) return GDEncodingTypeNSNumber;
    if ([cls isSubclassOfClass:[NSValue class]]) return GDEncodingTypeNSValue;
    if ([cls isSubclassOfClass:[NSMutableData class]]) return GDEncodingTypeNSMutableData;
    if ([cls isSubclassOfClass:[NSData class]]) return GDEncodingTypeNSData;
    if ([cls isSubclassOfClass:[NSDate class]]) return GDEncodingTypeNSDate;
    if ([cls isSubclassOfClass:[NSURL class]]) return GDEncodingTypeNSURL;
    if ([cls isSubclassOfClass:[NSMutableArray class]]) return GDEncodingTypeNSMutableArray;
    if ([cls isSubclassOfClass:[NSArray class]]) return GDEncodingTypeNSArray;
    if ([cls isSubclassOfClass:[NSMutableDictionary class]]) return GDEncodingTypeNSMutableDictionary;
    if ([cls isSubclassOfClass:[NSDictionary class]]) return GDEncodingTypeNSDictionary;
    if ([cls isSubclassOfClass:[NSMutableSet class]]) return GDEncodingTypeNSMutableSet;
    if ([cls isSubclassOfClass:[NSSet class]]) return GDEncodingTypeNSSet;
    return GDEncodingTypeNSUnknown;
}

static force_inline BOOL GDEncodingTypeIsCNumber(GDEncodingType type) {
    switch (type & GDEncodingTypeMask) {
        case GDEncodingTypeBool:
        case GDEncodingTypeInt8:
        case GDEncodingTypeUInt8:
        case GDEncodingTypeInt16:
        case GDEncodingTypeUInt16:
        case GDEncodingTypeInt32:
        case GDEncodingTypeUInt32:
        case GDEncodingTypeInt64:
        case GDEncodingTypeUInt64:
        case GDEncodingTypeFloat:
        case GDEncodingTypeDouble:
        case GDEncodingTypeLongDouble: return YES;
        default: return NO;
    }
}


@implementation GDModelPropertyMeta
+ (instancetype)metaWithClassInfo:(GDClassInfo *)classInfo propertyInfo:(GDClassPropertyInfo *)propertyInfo generic:(Class)generic {
    GDModelPropertyMeta *meta = [self new];
    meta->_name = propertyInfo.name;
    meta->_type = propertyInfo.type;
    meta->_genericCls = generic;
    if ((meta->_type & GDEncodingTypeMask) == GDEncodingTypeObject) {
        meta->_nsType = GDClassGetNSType(propertyInfo.cls);
    } else {
        meta->_isCNumber = GDEncodingTypeIsCNumber(meta->_type);
    }
    meta->_cls = propertyInfo.cls;
    if (propertyInfo.getter) {
        SEL sel = NSSelectorFromString(propertyInfo.getter);
        if ([classInfo.cls instancesRespondToSelector:sel]) {
            meta->_getter = sel;
        }
    }
    if (propertyInfo.setter) {
        SEL sel = NSSelectorFromString(propertyInfo.setter);
        if ([classInfo.cls instancesRespondToSelector:sel]) {
            meta->_setter = sel;
        }
    }
    return meta;
}
@end



@implementation GDModelMeta

- (instancetype)initWithClass:(Class)cls {
    GDClassInfo *classInfo = [GDClassInfo classInfoWithClass:cls];
    if (!classInfo) return nil;
    self = [super init];
    
    NSDictionary *genericMapper = nil;
    
    // Create all property metas.
    NSMutableDictionary *allPropertyMetas = [NSMutableDictionary new];
    GDClassInfo *curClassInfo = classInfo;
    while (curClassInfo && curClassInfo.superCls != nil) { // recursive parse super class, but ignore root class (NSObject/NSProxy)
        for (GDClassPropertyInfo *propertyInfo in curClassInfo.propertyInfos.allValues) {
            if (!propertyInfo.name) continue;
            GDModelPropertyMeta *meta = [GDModelPropertyMeta metaWithClassInfo:classInfo
                                                                    propertyInfo:propertyInfo
                                                                         generic:genericMapper[propertyInfo.name]];
            if (!meta || !meta->_name) continue;
            if (!meta->_getter && !meta->_setter) continue;
            if (allPropertyMetas[meta->_name]) continue;
            allPropertyMetas[meta->_name] = meta;
        }
        curClassInfo = curClassInfo.superClassInfo;
    }
    if (allPropertyMetas.count) _allPropertyMetas = allPropertyMetas.allValues.copy;
    
    // create mapper
    NSMutableDictionary *mapper = [NSMutableDictionary new];
    NSMutableArray *keyPathPropertyMetas = [NSMutableArray new];
    
    [allPropertyMetas enumerateKeysAndObjectsUsingBlock:^(NSString *name, GDModelPropertyMeta *propertyMeta, BOOL *stop) {
        propertyMeta->_mappedToKey = name;
        if (mapper[name]) {
            ((GDModelPropertyMeta *)mapper[name])->_next = propertyMeta;
        } else {
            mapper[name] = propertyMeta;
        }
    }];
    
    if (mapper.count) _mapper = mapper;
    if(keyPathPropertyMetas) _keyPathPropertyMetas = keyPathPropertyMetas;
    _keyMappedCount = _allPropertyMetas.count;
    _nsType = GDClassGetNSType(cls);
    
    return self;
}

/// Returns the cached model class meta
+ (instancetype)metaWithClass:(Class)cls {
    if (!cls) return nil;
    static CFMutableDictionaryRef cache;
    static dispatch_once_t onceToken;
    static OSSpinLock lock;
    dispatch_once(&onceToken, ^{
        cache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        lock = OS_SPINLOCK_INIT;
    });
    OSSpinLockLock(&lock);
    GDModelMeta *meta = CFDictionaryGetValue(cache, (__bridge const void *)(cls));
    OSSpinLockUnlock(&lock);
    if (!meta) {
        meta = [[GDModelMeta alloc] initWithClass:cls];
        if (meta) {
            OSSpinLockLock(&lock);
            CFDictionarySetValue(cache, (__bridge const void *)(cls), (__bridge const void *)(meta));
            OSSpinLockUnlock(&lock);
        }
    }
    return meta;
}


@end
