//
//  DanMu.h
//  luxun_iphone
//
//  Created by 王锐 on 16/8/18.
//  Copyright © 2016年 iUR. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DanMu : JSONModel

@property (nonatomic, strong) NSArray * danmuList;
@property (nonatomic, strong) NSDictionary * DMKu;
- (instancetype)setUp;

@end

@interface DanMuData : JSONModel

@property (nonatomic,   copy) NSString * n1;
@property (nonatomic,   copy) NSString * n2;
@property (nonatomic,   copy) NSString * title;
@property (nonatomic, strong) UIColor  * color;
@property (nonatomic,   copy) NSString * showTime;
@property (nonatomic,   copy) NSString * note;

@end