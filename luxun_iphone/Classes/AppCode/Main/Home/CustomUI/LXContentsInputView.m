//
//  LXContentsInputView.m
//  luxun_iphone
//
//  Created by iURCoder on 4/19/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "LXContentsInputView.h"
#import "MFJTextView.h"

#define kToolBarHeight 45.0f

@interface LXContentsInputView ()<UITextViewDelegate>
@property (nonatomic, strong) MFJTextView  * contentView;
@property (nonatomic, strong) UIView  * toolBar;
@property (nonatomic, strong) UIButton * postButton;
@end

@implementation LXContentsInputView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = UIColorHex(0xf2f2f2);
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, CONTENTS_INPUT_HEIGHT);
        [self setup];
    }
    return self;
}

- (void)setup{
    
    _contentView = [[MFJTextView alloc] init];
    [self addSubview:_contentView];
    _contentView.delegate = self;
    _contentView.backgroundColor = UIColorHex(0xf2f2f2);
    _contentView.font = [UIFont systemFontOfSize:14];
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.showsHorizontalScrollIndicator = NO;
    _contentView.scrollEnabled = YES;
    @weakify(self);
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self).offset(5);
        make.left.equalTo(self).offset(5);
        make.bottom.equalTo(self).offset(-kToolBarHeight);
        make.right.equalTo(self).offset(5);
    }];
    _contentView.placeholder = @"评分不足以吐槽？输入简评～";
    [_contentView setPlaceholderFont:[UIFont systemFontOfSize:15]];
    [_contentView setPlaceholderColor:UIColorHex(0xCECED1)];
    [_contentView addTextViewDidChangeEvent:^(MFJTextView *text) {
        
        
    }];
    
    _toolBar = [[UIView alloc] init];
    [self addSubview:_toolBar];
    _toolBar.backgroundColor = UIColorHex(0xf2f2f2);
    [self.toolBar mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.contentView.mas_bottom).offset(0);
        make.left.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
    }];
    
    
    int count = 5;
    UIButton *frontButton = nil;
    for ( int i = 1 ; i <= count ; ++i )
    {
        UIButton *starButton = [UIButton new];
        starButton.tag = i;
        starButton.backgroundColor = UIColorHex(0xf2f2f2);
        [starButton setBackgroundImage:[UIImage imageNamed:@"star_normall"] forState:UIControlStateNormal];
        [_toolBar addSubview:starButton];
        [starButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_toolBar);
            make.size.mas_equalTo(CGSizeMake(28, 28));
            if ( frontButton )
            {
                make.left.mas_equalTo(frontButton.mas_right).offset(1);
            }
            else
            {
                make.left.mas_equalTo(_toolBar).offset(10);
            }
        }];
        frontButton = starButton;
    }
    
    NSString * postTitle = @"提交番评";
    _postButton = [[UIButton alloc] init];
    [_postButton setTitle:postTitle forState:UIControlStateNormal];
    [_postButton setTitleColor:UIColorHex(0x0C60FD) forState:UIControlStateNormal];
    _postButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_postButton addTarget:self action:@selector(postContentsAction) forControlEvents:UIControlEventTouchUpInside];
    [_toolBar addSubview:_postButton];
    
    CGFloat postButtonWidth = [postTitle widthForFont:_postButton.titleLabel.font] + 30;
    _postButton.frame = CGRectMake(SCREEN_WIDTH - postButtonWidth, 0, postButtonWidth, kToolBarHeight);
}

- (void)postContentsAction
{
    [self.contentView resignFirstResponder];
}

@end
