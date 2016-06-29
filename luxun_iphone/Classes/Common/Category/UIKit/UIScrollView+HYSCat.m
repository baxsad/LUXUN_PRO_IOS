//
//  UIScrollView+HYSCat.m
//  BiHu_iPhone
//
//  Created by iURCoder on 12/2/15.
//  Copyright © 2015 iUR. All rights reserved.
//

#import "UIScrollView+HYSCat.h"

@implementation UIScrollView (HYSCat)

- (void)setDefaultGifRefreshWithHeader:(MJRefreshGifHeader *)gifHeader{
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=1; i++) {
        UIImage *image = [UIImage imageNamed:@"loading 1"];
        [idleImages addObject:image];
    }
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=24; i++) {
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading %zd", i]];
        [refreshingImages addObject:image];
    }
    if (gifHeader) {
        [gifHeader setImages:idleImages forState:MJRefreshStateIdle];
        [gifHeader setImages:refreshingImages forState:MJRefreshStatePulling];
        [gifHeader setImages:refreshingImages forState:MJRefreshStateRefreshing];
        gifHeader.lastUpdatedTimeLabel.hidden = YES;
        gifHeader.stateLabel.hidden = YES;
    }
    
}

- (void)setDefaultGifRefreshWithFooter:(MJRefreshAutoGifFooter *)gifFooter{
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=1; i++) {
        UIImage *image = [UIImage imageNamed:@"loading 1"];
        [idleImages addObject:image];
    }
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=24; i++) {
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading %zd", i]];
        [refreshingImages addObject:image];
    }
    if (gifFooter) {
        [gifFooter setImages:refreshingImages forState:MJRefreshStateRefreshing];
        gifFooter.refreshingTitleHidden = YES;
        [gifFooter setTitle:@"" forState:MJRefreshStateIdle];
        [gifFooter setTitle:@"" forState:MJRefreshStateRefreshing];
        [gifFooter setTitle:@"没有更多啦OAQ" forState:MJRefreshStateNoMoreData];
    }
    
}

- (void)scrollToTop {
    [self scrollToTopAnimated:YES];
}

- (void)scrollToBottom {
    [self scrollToBottomAnimated:YES];
}

- (void)scrollToLeft {
    [self scrollToLeftAnimated:YES];
}

- (void)scrollToRight {
    [self scrollToRightAnimated:YES];
}

- (void)scrollToTopAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = 0 - self.contentInset.top;
    [self setContentOffset:off animated:animated];
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.y = self.contentSize.height - self.bounds.size.height + self.contentInset.bottom;
    [self setContentOffset:off animated:animated];
}

- (void)scrollToLeftAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = 0 - self.contentInset.left;
    [self setContentOffset:off animated:animated];
}

- (void)scrollToRightAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    off.x = self.contentSize.width - self.bounds.size.width + self.contentInset.right;
    [self setContentOffset:off animated:animated];
}



@end
