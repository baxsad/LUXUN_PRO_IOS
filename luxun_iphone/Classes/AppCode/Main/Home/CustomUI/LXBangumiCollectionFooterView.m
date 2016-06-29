//
//  LXBangumiCollectionFooterView.m
//  luxun_iphone
//
//  Created by iURCoder on 4/17/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "LXBangumiCollectionFooterView.h"
#import "Bangumis.h"
@interface LXBangumiCollectionFooterView ()

@property (nonatomic,weak) IBOutlet UILabel * infoLable;
@property (nonatomic,assign) NSInteger bangumiCount;
@property (nonatomic,assign) NSInteger setsCount;

@end

@implementation LXBangumiCollectionFooterView

- (void)configModel:(NSArray *)bangumis isOver:(BOOL)over
{
    if (!bangumis) {
        return;
    }
    self.bangumiCount = bangumis.count;
    _setsCount = 0;
    for (Bangumi * bangumi in bangumis) {
        self.setsCount += bangumi.sets.count;
    }
    NSString * info = [NSString stringWithFormat:@"%li部新番，共%li话",self.bangumiCount,self.setsCount];
    if (over) {
        info = [NSString stringWithFormat:@"(已完结) %li部，共%li话",self.bangumiCount,self.setsCount];
    }
    self.infoLable.text = info;
}

@end
