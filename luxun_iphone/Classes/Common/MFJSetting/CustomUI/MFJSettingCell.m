//
//  MFJSettingCell.m
//  2HUO
//
//  Created by iURCoder on 3/24/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "MFJSettingCell.h"
#import "MFJSettingItem.h"

#define MFJImgSrcName(file) [@"MFJSetting.bundle" stringByAppendingPathComponent:file]

@interface MFJSettingCell()

@property (nonatomic, weak) IBOutlet UIImageView * icon;
@property (nonatomic, weak) IBOutlet UILabel     * title;
@property (nonatomic, weak) IBOutlet UIImageView * arrow;
@property (nonatomic, weak) IBOutlet UISwitch    * Switch;
@property (nonatomic, weak) IBOutlet UILabel     * arrowLable;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * subTitleRight;
@property (nonatomic, weak) IBOutlet UIView      * bottomLine;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * bottomLineHeight;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * bottomLineLeft;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint * titleLeft;

@end

@implementation MFJSettingCell

+ (id)settingCellWithTableView:(UITableView *)tableView
{
    // 0.用static修饰的局部变量，只会初始化一次
    static NSString *ID = @"MFJSettingCell";
    
    // 1.拿到一个标识先去缓存池中查找对应的Cell
    MFJSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    return cell;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.bottomLineHeight.constant = 1/[UIScreen mainScreen].scale;
    self.bottomLineLeft.constant = 49;
    NSString * imgName = MFJImgSrcName(@"arrow");
    self.arrow.image = [UIImage imageNamed:imgName];
    [self.Switch addTarget:self action:@selector(switchStatusChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)setItem:(MFJSettingItem *)item
{
    _item = item;
    self.subTitleRight.constant = 10;
    self.icon.image = [UIImage imageNamed:item.icon];
    self.title.text = item.title;
    
    if (item.icon && item.icon.length>0) {
        self.bottomLineLeft.constant = 49;
        self.titleLeft.constant = 15;
    }else{
        self.bottomLineLeft.constant = 9;
        self.titleLeft.constant = -25;
    }
    
    if (item.type == MFJSettingItemTypeNone) {
        
        self.arrow.hidden = YES;
        self.Switch.hidden = YES;
        self.arrowLable.hidden = YES;
        
    }else if (item.type == MFJSettingItemTypeArrow) {
        
        self.arrow.hidden = NO;
        self.Switch.hidden = YES;
        self.arrowLable.hidden = YES;
        
    } else if (item.type == MFJSettingItemTypeSwitch) {
        
        self.Switch.hidden = NO;
        self.arrow.hidden = YES;
        self.arrowLable.hidden = YES;
        self.switchChangeBlock = item.switchBlock;
        
       
    } else if (item.type == MFJSettingItemTypeSubTitle) {
        
        self.Switch.hidden = YES;
        self.arrow.hidden = YES;
        self.arrowLable.hidden = NO;
        self.arrowLable.text = item.subTitle;
        self.subTitleRight.constant = -8;
        
    } else if (item.type == MFJSettingItemTypeArrowSubTitle) {
        
        self.Switch.hidden = YES;
        self.arrow.hidden = NO;
        self.arrowLable.hidden = NO;
        self.arrowLable.text = item.subTitle;
        
    }

}

#pragma mark - SwitchValueChanged

- (void)switchStatusChanged:(UISwitch *)sender
{
    if (self.switchChangeBlock) {
        self.switchChangeBlock(sender.on);
    }
}

@end
