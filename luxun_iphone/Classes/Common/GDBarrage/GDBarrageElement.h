//
//  GDBarrageElement.h
//  luxun_iphone
//
//  Created by iURCoder on 4/22/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDBarrageSource : NSObject

@property (nonatomic, strong) NSDictionary *info;

+ (instancetype)createWithParam:(NSDictionary *)param;

@end

typedef NS_ENUM (NSUInteger, GDBarrageType) {
    GDBarrageTypeLR = 0,
    GDBarrageTypeCT = 1,
    GDBarrageTypeCB = 2,
};

@interface GDBarrageElement : NSObject

@property (nonatomic,assign) GDBarrageType type;

@property (nonatomic,assign) NSTimeInterval time;

@property (nonatomic, assign) NSTimeInterval survivalTime;

@property (nonatomic,strong) UIFont * font;

@property (nonatomic,strong) NSString * text;

@property (nonatomic,strong) UIColor * textColor;

@property (nonatomic,strong) NSString * rgbColor;

@property (nonatomic,assign) CGRect appearFrame;

@property (nonatomic,assign) CGRect disappearFrame;

- (CGSize)elementSize;

@end

@interface GDBarrageLable : UILabel

@end
