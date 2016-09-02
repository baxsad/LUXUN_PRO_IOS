//
//  LXBangumiCollectionHeaderView.m
//  luxun_iphone
//
//  Created by iURCoder on 4/17/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "LXBangumiCollectionHeaderView.h"

@interface LXBangumiCollectionHeaderView ()

@property (nonatomic, weak) IBOutlet UILabel * info;

@end

@implementation LXBangumiCollectionHeaderView

- (void)configDate:(NSString *)date
{
    self.info.text = [self numberToChinese:date];
}

- (NSString *)numberToChinese:(NSString *)num
{
    if (num.length != 4) {
        return @"";
    }
    NSMutableString * str = [NSMutableString string];
    
    NSInteger  year = [[num substringToIndex:2] integerValue];
    NSInteger  month = [[num substringFromIndex:2] integerValue];
    
    NSInteger s = year/10;
    NSInteger g = year%10;
    
    switch (s) {
        case 0:
            [str appendString:@"零"];
            break;
        case 1:
            [str appendString:@"一"];
            break;
        case 2:
            [str appendString:@"二"];
            break;
        case 3:
            [str appendString:@"三"];
            break;
        case 4:
            [str appendString:@"四"];
            break;
        case 5:
            [str appendString:@"五"];
            break;
        case 6:
            [str appendString:@"六"];
            break;
        case 7:
            [str appendString:@"七"];
            break;
        case 8:
            [str appendString:@"八"];
            break;
        case 9:
            [str appendString:@"九"];
            break;
            
        default:
            break;
    }
    
    switch (g) {
        case 0:
            [str appendString:@"零"];
            break;
        case 1:
            [str appendString:@"一"];
            break;
        case 2:
            [str appendString:@"二"];
            break;
        case 3:
            [str appendString:@"三"];
            break;
        case 4:
            [str appendString:@"四"];
            break;
        case 5:
            [str appendString:@"五"];
            break;
        case 6:
            [str appendString:@"六"];
            break;
        case 7:
            [str appendString:@"七"];
            break;
        case 8:
            [str appendString:@"八"];
            break;
        case 9:
            [str appendString:@"九"];
            break;
            
        default:
            break;
    }
    
    [str appendString:@"年"];
    [str appendString:@" "];
    
    if (month>=3 && month<=5) {
        [str appendString:@"春"];
        return str;
    }
    if (month>=6 && month<=8) {
        [str appendString:@"夏"];
        return str;
    }
    if (month>=9 && month<=11) {
        [str appendString:@"秋"];
        return str;
    }else{
        [str appendString:@"冬"];
        return str;
    }
}


@end
