//
//  GDModelMeta.h
//  2HUO
//
//  Created by iURCoder on 4/15/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDClassInfo.h"

typedef NS_ENUM (NSUInteger, GDEncodingNSType) {
    GDEncodingTypeNSUnknown = 0,
    GDEncodingTypeNSString,
    GDEncodingTypeNSMutableString,
    GDEncodingTypeNSValue,
    GDEncodingTypeNSNumber,
    GDEncodingTypeNSDecimalNumber,
    GDEncodingTypeNSData,
    GDEncodingTypeNSMutableData,
    GDEncodingTypeNSDate,
    GDEncodingTypeNSURL,
    GDEncodingTypeNSArray,
    GDEncodingTypeNSMutableArray,
    GDEncodingTypeNSDictionary,
    GDEncodingTypeNSMutableDictionary,
    GDEncodingTypeNSSet,
    GDEncodingTypeNSMutableSet,
};

@interface GDModelPropertyMeta : NSObject {
@public
    NSString *_name;             ///< property's name
    GDEncodingType _type;        ///< property's type
    GDEncodingNSType _nsType;    ///< property's Foundation type
    BOOL _isCNumber;             ///< is c number type
    Class _cls;                  ///< property's class, or nil
    Class _genericCls;           ///< container's generic class
    SEL _getter;                 ///< getter, or nil if the instances cannot respond
    SEL _setter;                 ///< setter, or nil if the instances cannot respond
    
    NSString *_mappedToKey;      ///< the key mapped to
    NSArray *_mappedToKeyPath;   ///< the key path mapped to (nil if the name is not key path)
    GDModelPropertyMeta *_next; ///< next meta if there are multiple properties mapped to the same key.
}
@end


@interface GDModelMeta : NSObject
{
@public
    /// Key:mapped key and key path, Value:_YYModelPropertyInfo.
    NSDictionary *_mapper;
    /// Array<_YYModelPropertyInfo>, all property meta of this model.
    NSArray *_allPropertyMetas;
    /// Array<_YYModelPropertyInfo>, property meta which is mapped to a key path.
    NSArray *_keyPathPropertyMetas;
    /// The number of mapped key (and key path), same to _mapper.count.
    NSUInteger _keyMappedCount;
    /// Model class type.
    GDEncodingNSType _nsType;
    
}
+ (instancetype)metaWithClass:(Class)cls;


@end
