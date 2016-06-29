//
//  LXBangumiSearchHeaderView.m
//  luxun_iphone
//
//  Created by iURCoder on 4/17/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "LXBangumiSearchHeaderView.h"

@interface LXBangumiSearchHeaderView ()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField * searchField;

@end

@implementation LXBangumiSearchHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.searchField.layer.cornerRadius = 3;
    self.searchField.layer.masksToBounds = YES;
    self.searchField.returnKeyType = UIReturnKeySearch;
    self.searchField.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.searchField resignFirstResponder];
    return YES;
}

@end
