//
//  LXTieleView.m
//  luxun_iphone
//
//  Created by iURCoder on 4/17/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "LXTitleView.h"

@interface LXTitleView ()

@property (nonatomic) CGRect customFram;

@property (nonatomic, strong) NSMutableArray * buttonArray;

@end

@implementation LXTitleView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.buttonArray = [NSMutableArray array];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.buttonArray = [NSMutableArray array];
    }
    return self;
}

- (void)setButtons:(NSArray *)titles
{
    for (int i = 0; i<titles.count; i++) {
        UIButton * bt = [self makeButton:titles[i] index:i];
        [self addSubview:bt];
        if (i == titles.count - 1) {
            self.frame = CGRectMake(0, 0, bt.frame.origin.x+bt.frame.size.width, bt.frame.size.height);
        }
    }
}

- (UIButton *)makeButton:(NSString *)title index:(NSInteger)index
{
    
    UIButton * bt;
    bt = [[UIButton alloc] init];
    bt.tag = index;
    [bt setTitle:title forState:UIControlStateNormal];
    [bt setBackgroundColor:TEMCOLOR];
    bt.layer.cornerRadius = 3;
    bt.layer.masksToBounds = YES;
    bt.titleLabel.font = [UIFont systemFontOfSize:16];
    [bt setTitleColor:UIColorHex(0xFDBEE2) forState:UIControlStateNormal];
    CGFloat width = [title widthForFont:[UIFont systemFontOfSize:15]] + 33;
    CGFloat height = 30;
    if (self.buttonArray.count>0) {
        UIButton * obt = [self.buttonArray lastObject];
        bt.frame = CGRectMake(obt.frame.origin.x + obt.frame.size.width, 0, width, height);
    }else{
        bt.frame = CGRectMake(0, 0, width, height);
    }
    [bt addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonArray addObject:bt];
    return bt;
}

- (void)selectAction:(UIButton *)sender
{
    if (sender.tag == _selectIndex) return;
    if (self.rootViewController) {
        if (sender.tag == 0) {
            if (!ISLOGIN) {
                NSLog(@"请登录！");
                return;
            }
        }
        self.rootViewController.selectedIndex = sender.tag;
    }
    UIButton * sbtn = [self.buttonArray objectAtIndex:sender.tag];
    [self setButtonHight:sbtn];
    
    UIButton * obtn = [self.buttonArray objectAtIndex:_selectIndex];
    [self setButtonNormal:obtn];
    
    _selectIndex = sender.tag;
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    if (self.rootViewController) {
        self.rootViewController.selectedIndex = selectIndex;
    }
    _selectIndex = selectIndex;
    UIButton * btn = [self.buttonArray objectAtIndex:selectIndex];
    [self setButtonHight:btn];
}

- (void)setButtonNormal:(UIButton *)btn
{
    [UIView animateWithDuration:0.125 animations:^{
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setBackgroundColor:TEMCOLOR];
        [btn setTitleColor:UIColorHex(0xFDBEE2) forState:UIControlStateNormal];
    }];
    
}

- (void)setButtonHight:(UIButton *)btn
{
    [UIView animateWithDuration:0.125 animations:^{
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [btn setBackgroundColor:UIColorHex(0xCC256E)];
        [btn setTitleColor:UIColorHex(0xffffff) forState:UIControlStateNormal];
    }];
    
}

@end
