//
//  Topics.h
//  luxun_iphone
//
//  Created by 王锐 on 16/6/16.
//  Copyright © 2016年 iUR. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol Topic;

@interface Topics : JSONModel

@property (nonatomic, strong) NSArray <Topic>* list;

@end

@interface Topic : JSONModel

@property (nonatomic, copy  ) NSString * bangumis;
@property (nonatomic, copy  ) NSString * created;
@property (nonatomic, copy  ) NSString * text;
@property (nonatomic, copy  ) NSString * title;
@property (nonatomic, copy  ) NSString * type;
@property (nonatomic, copy  ) NSString * direction;
@property (nonatomic, strong) NSArray  * bangumiModels;

@end