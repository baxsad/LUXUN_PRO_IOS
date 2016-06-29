//
//  GDClassInfo.h
//  GDKit <https://github.com/ibireme/GDKit>
//
//  Created by ibireme on 15/5/9.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
/**
 * 数据类型
 */
typedef NS_OPTIONS(NSUInteger, GDEncodingType) {
    GDEncodingTypeMask       = 0x1F, ///< mask of type value
    GDEncodingTypeUnknown    = 0, ///< unknown
    GDEncodingTypeVoid       = 1, ///< void
    GDEncodingTypeBool       = 2, ///< bool
    GDEncodingTypeInt8       = 3, ///< char / BOOL
    GDEncodingTypeUInt8      = 4, ///< unsigned char
    GDEncodingTypeInt16      = 5, ///< short
    GDEncodingTypeUInt16     = 6, ///< unsigned short
    GDEncodingTypeInt32      = 7, ///< int
    GDEncodingTypeUInt32     = 8, ///< unsigned int
    GDEncodingTypeInt64      = 9, ///< long long
    GDEncodingTypeUInt64     = 10, ///< unsigned long long
    GDEncodingTypeFloat      = 11, ///< float
    GDEncodingTypeDouble     = 12, ///< double
    GDEncodingTypeLongDouble = 13, ///< long double
    GDEncodingTypeObject     = 14, ///< id
    GDEncodingTypeClass      = 15, ///< Class
    GDEncodingTypeSEL        = 16, ///< SEL
    GDEncodingTypeBlock      = 17, ///< block
    GDEncodingTypePointer    = 18, ///< void*
    GDEncodingTypeStruct     = 19, ///< struct
    GDEncodingTypeUnion      = 20, ///< union
    GDEncodingTypeCString    = 21, ///< char*
    GDEncodingTypeCArray     = 22, ///< char[10] (for example)
    
    GDEncodingTypeQualifierMask   = 0xFE0,  ///< mask of qualifier
    GDEncodingTypeQualifierConst  = 1 << 5, ///< const
    GDEncodingTypeQualifierIn     = 1 << 6, ///< in
    GDEncodingTypeQualifierInout  = 1 << 7, ///< inout
    GDEncodingTypeQualifierOut    = 1 << 8, ///< out
    GDEncodingTypeQualifierBycopy = 1 << 9, ///< bycopy
    GDEncodingTypeQualifierByref  = 1 << 10, ///< byref
    GDEncodingTypeQualifierOneway = 1 << 11, ///< oneway
    
    GDEncodingTypePropertyMask         = 0x1FF000, ///< mask of property
    GDEncodingTypePropertyReadonly     = 1 << 12, ///< readonly
    GDEncodingTypePropertyCopy         = 1 << 13, ///< copy
    GDEncodingTypePropertyRetain       = 1 << 14, ///< retain
    GDEncodingTypePropertyNonatomic    = 1 << 15, ///< nonatomic
    GDEncodingTypePropertyWeak         = 1 << 16, ///< weak
    GDEncodingTypePropertyCustomGetter = 1 << 17, ///< getter=
    GDEncodingTypePropertyCustomSetter = 1 << 18, ///< setter=
    GDEncodingTypePropertyDynamic      = 1 << 19, ///< @dynamic
    GDEncodingTypePropertyGarbage      = 1 << 20,
};

/**
 通过 Type-Encoding string 获取数据类型.
 
 @discussion See also:
 @param typeEncoding   Type-Encoding 字符串.
 @return 类型.
 */
GDEncodingType GDEncodingGetType(const char *typeEncoding);


/**
 * 实例变量信息。
 */
@interface GDClassIvarInfo : NSObject
@property (nonatomic, assign, readonly) Ivar ivar;
@property (nonatomic, strong, readonly) NSString *name; ///< 变量名字
@property (nonatomic, assign, readonly) ptrdiff_t offset; ///< 变量偏移量
@property (nonatomic, strong, readonly) NSString *typeEncoding; ///< 变量类型字符串
@property (nonatomic, assign, readonly) GDEncodingType type; ///< 变量类型
- (instancetype)initWithIvar:(Ivar)ivar;
@end

/**
 * 方法信息
 */
@interface GDClassMethodInfo : NSObject
@property (nonatomic, assign, readonly) Method method;
@property (nonatomic, strong, readonly) NSString *name; ///< 方法名字
@property (nonatomic, assign, readonly) SEL sel; ///< 方法选择器
@property (nonatomic, assign, readonly) IMP imp; ///< 方法 implementation
@property (nonatomic, strong, readonly) NSString *typeEncoding; ///< 方法参数
@property (nonatomic, strong, readonly) NSString *returnTypeEncoding; ///< 返回类型
@property (nonatomic, strong, readonly) NSArray *argumentTypeEncodings; ///< 参数类型
- (instancetype)initWithMethod:(Method)method;
@end

/**
 * 属性信息
 */
@interface GDClassPropertyInfo : NSObject
@property (nonatomic, assign, readonly) objc_property_t property;
@property (nonatomic, strong, readonly) NSString *name; ///< 属性名字
@property (nonatomic, assign, readonly) GDEncodingType type; ///< 属性类型
@property (nonatomic, strong, readonly) NSString *typeEncoding; ///< 属性类型字符串
@property (nonatomic, strong, readonly) NSString *ivarName; ///< 属性的变量名字
@property (nonatomic, assign, readonly) Class cls; ///< 类
@property (nonatomic, strong, readonly) NSString *getter; ///< getter (nonnull)
@property (nonatomic, strong, readonly) NSString *setter; ///< setter (nonnull)
- (instancetype)initWithProperty:(objc_property_t)property;
@end

/**
 Class information for a class.
 */
@interface GDClassInfo : NSObject

@property (nonatomic, assign, readonly) Class cls;
@property (nonatomic, assign, readonly) Class superCls;
@property (nonatomic, assign, readonly) Class metaCls;
@property (nonatomic, assign, readonly) BOOL isMeta;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) GDClassInfo *superClassInfo;

@property (nonatomic, strong, readonly) NSDictionary *ivarInfos;     ///< key:NSString(ivar),     value:GDClassIvarInfo
@property (nonatomic, strong, readonly) NSDictionary *methodInfos;   ///< key:NSString(selector), value:GDClassMethodInfo
@property (nonatomic, strong, readonly) NSDictionary *propertyInfos; ///< key:NSString(property), value:GDClassPropertyInfo

/**
 If the class is changed (for example: you add a method to this class with
 'class_addMethod()'), you should call this method to refresh the class info cache.
 
 After called this method, you may call 'classInfoWithClass' or 
 'classInfoWithClassName' to get the updated class info.
 */
- (void)setNeedUpdate;

/**
 Get the class info of a specified Class.
 
 @discussion This method will cache the class info and super-class info
 at the first access to the Class. This method is thread-safe.
 
 @param cls A class.
 @return A class info, or nil if an error occurs.
 */
+ (instancetype)classInfoWithClass:(Class)cls;

/**
 Get the class info of a specified Class.
 
 @discussion This method will cache the class info and super-class info
 at the first access to the Class. This method is thread-safe.
 
 @param className A class name.
 @return A class info, or nil if an error occurs.
 */
+ (instancetype)classInfoWithClassName:(NSString *)className;

@end
