//
//  Created by iURCoder on 11/3/15.
//  Copyright © 2015 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>
#undef AS_SINGLETON
#define AS_SINGLETON(__class) \
+(__class*)sharedInstance;
#undef DEF_SINGLETON
#define DEF_SINGLETON(__class)                                                   \
+(__class*)sharedInstance                                                    \
{                                                                            \
static dispatch_once_t once;                                             \
static __class* __singleton__;                                           \
dispatch_once(&once, ^{ __singleton__ = [[[self class] alloc] init]; }); \
return __singleton__;                                                    \
}


#undef NS_CODING
#define NS_CODING \
- (instancetype)initWithCoder:(NSCoder *)aDecoder{\
self = [super init];\
if (self) {\
    \
    unsigned int count = 0;\
    Ivar *ivars = class_copyIvarList([self class], &count);\
    for (int i =0; i<count ; i++) {\
        \
        Ivar ivar = ivars[i];\
        const char *name = ivar_getName(ivar);\
        NSString *key = [NSString stringWithUTF8String:name];\
        [self setValue:[[aDecoder decodeObjectForKey:key] copy] forKey:key];\
        \
    }\
    \
}\
\
return self;\
}\
\
- (void)encodeWithCoder:(NSCoder *)aCoder{\
    \
    unsigned int count = 0;\
    Ivar *ivars = class_copyIvarList([self class], &count);\
    for (int i =0; i<count ; i++) {\
        \
        Ivar ivar = ivars[i];\
        const char *name = ivar_getName(ivar);\
        NSString *key = [NSString stringWithUTF8String:name];\
        [aCoder encodeObject:[self valueForKey:key] forKey:key];\
        \
    }\
    \
}