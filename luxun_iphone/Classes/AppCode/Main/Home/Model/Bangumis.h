//
//  Bangumis.h
//  luxun_iphone
//
//  Created by iURCoder on 4/16/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "BangumiFrameModel.h"

@protocol Bangumi,Set,Quars;
@class Quars;

@interface Bangumis : JSONModel

@property (nonatomic, copy) NSArray<Bangumi> * updating;
@property (nonatomic, copy) NSArray<Quars> *quars;
@property (nonatomic, copy) NSArray<Bangumi> *bangumis;

@end

@interface Quars : JSONModel

@property (nonatomic, strong) NSString *quarter;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, copy) NSArray<Bangumi> * bangumis;

@end


@interface Bangumi : JSONModel

@property (nonatomic, strong) NSString *original;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *quarter;
@property (nonatomic, assign) NSInteger week;
@property (nonatomic, strong) NSString *weekString;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger preview;
@property (nonatomic, assign) NSInteger modified;
@property (nonatomic, copy) NSArray<Set> *sets;
@property (nonatomic, strong) NSString *cur;
@property (nonatomic, strong) NSString *created;
@property (nonatomic, strong) NSString *filename;
@property (nonatomic, strong) BangumiFrameModel *frameModel;

- (NSString *)videoUrlWithUri:(NSString *)uri;

- (NSString *)timeLineBangumiIcon;

@end

@interface Set : JSONModel

@property (nonatomic, copy) NSString * url;
@property (nonatomic, copy) NSString * set;

@end