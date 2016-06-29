//
//  User.h
//  2HUO
//
//  Created by iURCoder on 4/7/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@class WBData;

@interface User : JSONModel

@property (nonatomic, copy  ) NSString * avatar;
@property (nonatomic, copy  ) NSString * uid;
@property (nonatomic, copy  ) NSString * url;
@property (nonatomic, copy  ) NSString * wbid;
@property (nonatomic, copy  ) NSString * sss;
@property (nonatomic, assign) NSInteger  lecel;
@property (nonatomic, assign) NSInteger  look;
@property (nonatomic, assign) NSInteger  like;
@property (nonatomic, strong) WBData   * wbdata;
@property (nonatomic, copy  ) NSString * name;
@property (nonatomic, copy  ) NSString * des;

@end

@interface WBData : JSONModel

@property (nonatomic, assign) NSInteger  id;
@property (nonatomic, assign) NSInteger  className;
@property (nonatomic, copy  ) NSString * name;
@property (nonatomic, copy  ) NSString * province;
@property (nonatomic, copy  ) NSString * city;
@property (nonatomic, copy  ) NSString * location;
@property (nonatomic, copy  ) NSString * url;
@property (nonatomic, copy  ) NSString * des;
@property (nonatomic, copy  ) NSString * profile_image_url;
@property (nonatomic, copy  ) NSString * cover_image;
@property (nonatomic, copy  ) NSString * cover_image_phone;
@property (nonatomic, copy  ) NSString * profile_url;
@property (nonatomic, copy  ) NSString * domain;
@property (nonatomic, copy  ) NSString * weihao;
@property (nonatomic, copy  ) NSString * gender;
@property (nonatomic, copy  ) NSString * followers_count;
@property (nonatomic, copy  ) NSString * friends_count;
@property (nonatomic, copy  ) NSString * pagefriends_count;
@property (nonatomic, copy  ) NSString * statuses_count;
@property (nonatomic, copy  ) NSString * favourites_count;
@property (nonatomic, copy  ) NSString * created_at;

@end
