//
//  O2HBaseTableViewCell.m
//  2HUO
//
//  Created by iURCoder on 3/18/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "O2HBaseTableViewCell.h"

@interface O2HBaseTableViewCell ()
@property (nonatomic, weak) UIView *topSeparator;
@property (nonatomic, weak) UIView *bottomSeparator;

@end
@implementation O2HBaseTableViewCell
- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}
-(void)addSeparatorWithLeftMargin:(CGFloat)left rightMargin:(CGFloat)right color:(UIColor *)color positon:(SeparatorViewPosition)position{
    
    UIView * _separatorView = [[UIView alloc] initWithFrame:CGRectMake(left, 0, [UIScreen mainScreen].bounds.size.width-left-right, 1/[UIScreen mainScreen].scale)];
    _separatorView.backgroundColor = color;
    [self addSubview:_separatorView];
    
    if (position == SeparatorViewPositionTop) {
        self.topSeparator = _separatorView;
    }else{
        self.bottomSeparator = _separatorView;
    }
}
- (NSIndexPath*)indexPath
{
    UIView* tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]]) {
        tableView = tableView.superview;
    }
    return [(UITableView*)tableView indexPathForCell:self];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect frame =  _topSeparator.frame;
    frame.origin.y = 0;
    self.topSeparator.frame = frame;
    frame = _bottomSeparator.frame;
    frame.origin.y = self.bounds.size.height - frame.size.height;
    self.bottomSeparator.frame = frame;
    
}

@end
