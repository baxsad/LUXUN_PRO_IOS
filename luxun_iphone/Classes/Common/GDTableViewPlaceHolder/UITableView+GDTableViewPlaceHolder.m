//
//  UITableView+GDTableViewPlaceHolder.m
//  luxun_iphone
//
//  Created by iURCoder on 4/20/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "UITableView+GDTableViewPlaceHolder.h"
#import "GDPlaceHolderDelegate.h"
#import <objc/runtime.h>

@interface UITableView ()

@property (nonatomic, assign) BOOL scrollWasEnabled;
@property (nonatomic, strong) UIView *placeHolderView;

@end

@implementation UITableView (GDTableViewPlaceHolder)

- (BOOL)scrollWasEnabled {
    NSNumber *scrollWasEnabledObject = objc_getAssociatedObject(self, @selector(scrollWasEnabled));
    return [scrollWasEnabledObject boolValue];
}

- (void)setScrollWasEnabled:(BOOL)scrollWasEnabled {
    NSNumber *scrollWasEnabledObject = [NSNumber numberWithBool:scrollWasEnabled];
    objc_setAssociatedObject(self, @selector(scrollWasEnabled), scrollWasEnabledObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)placeHolderView {
    return objc_getAssociatedObject(self, @selector(placeHolderView));
}

- (void)setPlaceHolderView:(UIView *)placeHolderView {
    objc_setAssociatedObject(self, @selector(placeHolderView), placeHolderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)gd_reloadData {
    [self reloadData];
    [self gd_checkEmpty];
}

- (void)gd_checkEmpty {
    BOOL isEmpty = YES;
    id<UITableViewDataSource> src = self.dataSource;
    NSInteger sections = 1;
    if ([src respondsToSelector: @selector(numberOfSectionsInTableView:)]) {
        sections = [src numberOfSectionsInTableView:self];
    }
    for (int i = 0; i<sections; ++i) {
        NSInteger rows = [src tableView:self numberOfRowsInSection:i];
        if (rows) {
            isEmpty = NO;
        }
    }
    //  no != yes
    if (!isEmpty != !self.placeHolderView) {
        if (isEmpty) {
            self.scrollWasEnabled = self.scrollEnabled;
            BOOL scrollEnabled = NO;
            if ([self respondsToSelector:@selector(enableScrollWhenPlaceHolderViewShowing)]) {
                scrollEnabled = [self performSelector:@selector(enableScrollWhenPlaceHolderViewShowing)];
                if (!scrollEnabled) {
                    NSString *reason = @"There is no need to return  NO for `-enableScrollWhenPlaceHolderViewShowing`, it will be NO by default";
                    @throw [NSException exceptionWithName:NSGenericException
                                                   reason:reason
                                                 userInfo:nil];
                }
            } else if ([self.delegate respondsToSelector:@selector(enableScrollWhenPlaceHolderViewShowing)]) {
                scrollEnabled = [self.delegate performSelector:@selector(enableScrollWhenPlaceHolderViewShowing)];
                if (!scrollEnabled) {
                    NSString *reason = @"There is no need to return  NO for `-enableScrollWhenPlaceHolderViewShowing`, it will be NO by default";
                    @throw [NSException exceptionWithName:NSGenericException
                                                   reason:reason
                                                 userInfo:nil];
                }
            }
            self.scrollEnabled = scrollEnabled;
            if ([self respondsToSelector:@selector(makePlaceHolderView)]) {
                self.placeHolderView = [self performSelector:@selector(makePlaceHolderView)];
            } else if ( [self.delegate respondsToSelector:@selector(makePlaceHolderView)]) {
                self.placeHolderView = [self.delegate performSelector:@selector(makePlaceHolderView)];
            } else {
                NSString *selectorName = NSStringFromSelector(_cmd);
                NSString *reason = [NSString stringWithFormat:@"You must implement makePlaceHolderView method in your custom tableView or its delegate class if you want to use %@", selectorName];
                @throw [NSException exceptionWithName:NSGenericException
                                               reason:reason
                                             userInfo:nil];
            }
            self.placeHolderView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            [self addSubview:self.placeHolderView];
        } else {
            self.scrollEnabled = self.scrollWasEnabled;
            [self.placeHolderView removeFromSuperview];
            self.placeHolderView = nil;
        }
    } else if (isEmpty) {
        // Make sure it is still above all siblings.
        [self.placeHolderView removeFromSuperview];
        [self addSubview:self.placeHolderView];
    }
}


@end
