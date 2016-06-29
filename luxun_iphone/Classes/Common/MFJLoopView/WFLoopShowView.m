//
//  WFLoopShowView.m
//  WFLoopShowView
//
//  Created by wang feng on 15/4/27.
//  Copyright (c) 2015年 WrightStudio. All rights reserved.
//

#import "WFLoopShowView.h"
#import <YYWebImage/YYWebImage.h>

static CGFloat const kPageControlWidth = 100;
static CGFloat const kPageControlHeigth = 18;

@interface WFLoopShowView ()<UIScrollViewDelegate>
/**
 *  当前展示的视图索引
 */
@property (nonatomic, assign) NSInteger currentViewIndex;

/**
 *  内容视图数组，其中包含3个视图，当前显示的视图，之前的视图，之后的视图
 */
@property (nonatomic, strong) NSMutableArray *contentViews;

/**
 *  pageControl
 */
@property (nonatomic, strong) UIPageControl *pageControl;

/**
 *  自动循环展示的计时器
 */
@property (nonatomic, strong) NSTimer *animationTimer;

/**
 *  循环展示的时间间隔
 */
@property (nonatomic, assign) NSTimeInterval animationDuration;

/**
 *  所有要展示的视图
 */
@property (nonatomic, strong) NSMutableArray *imageViews;

@end

@implementation WFLoopShowView

#pragma mark -
#pragma mark - setter for TotalViewsCount
- (void)setTotalViewsCount:(NSInteger)totalViewsCount
{
    _totalViewsCount = totalViewsCount;
    if (_totalViewsCount > 0) {
        [self configContentView];
        [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
    }
}
#pragma mark -
#pragma mark - setter for animationTimer
- (void)setAnimationDuration:(NSTimeInterval)animationDuration{
    _animationDuration = animationDuration;
    if (animationDuration > 0.0) {
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationDuration
                                                               target:self
                                                             selector:@selector(animationTimerFired:)
                                                             userInfo:nil
                                                              repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.animationTimer forMode:NSRunLoopCommonModes];
        [self.animationTimer pauseTimer];
    }
}

#pragma mark -
#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame image:(NSArray *)imagesData animationDuration:(NSTimeInterval)animationDuration
{
    self = [self initWithFrame:frame];
    
    if (animationDuration > 0.0) {
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:(self.animationDuration = animationDuration)
                                                               target:self
                                                             selector:@selector(animationTimerFired:)
                                                             userInfo:nil
                                                              repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.animationTimer forMode:NSRunLoopCommonModes];
        [self.animationTimer pauseTimer];
    }
    
    [self loadImage:imagesData];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Init ScrowView
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.scrollView.contentMode = UIViewContentModeCenter;
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame) * 3, CGRectGetHeight(self.scrollView.frame));
        self.scrollView.contentOffset = CGPointMake(_scrollView.width, 0);
        self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
        self.scrollView.scrollsToTop = NO;
        [self addSubview:self.scrollView];
        self.currentViewIndex = 0;
        
        // Init PageControl
        self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0,0, kPageControlWidth, kPageControlHeigth)];
        self.pageControl.center = CGPointMake(self.scrollView.centerX, self.scrollView.bottom-15);
        self.pageControl.userInteractionEnabled = YES;
        self.pageControl.numberOfPages = self.totalViewsCount;
        self.pageControl.currentPage = 0;
        [self addSubview:self.pageControl];
    }
    return self;
}

#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.animationTimer pauseTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int contentOffsetX = scrollView.contentOffset.x;
    
    if (contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
        self.currentViewIndex = [self getViewValidIndex:self.currentViewIndex + 1];
        [self configContentView];
    }
    
    if (contentOffsetX <= 0) {
        self.currentViewIndex = [self getViewValidIndex:self.currentViewIndex - 1];
        [self configContentView];
    }
    
    self.pageControl.currentPage = self.currentViewIndex;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0)];
}

- (void)configContentView
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setScrollViewContentData];
    
    NSInteger counter = 0;
    for (UIView *contentView in self.contentViews) {
        CGRect contentRect = contentView.frame;
        contentRect.origin = CGPointMake(CGRectGetWidth(self.scrollView.frame) * (counter++), 0);
        
        contentView.frame = contentRect;
        [self.scrollView addSubview:contentView];
    }
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0)];
    
    self.pageControl.numberOfPages = self.totalViewsCount;
}

#pragma mark -
#pragma private method
- (NSInteger)getViewValidIndex:(NSInteger) NextIndex
{
    if(NextIndex == -1) {
        return self.totalViewsCount - 1;
    } else if (NextIndex == self.totalViewsCount) {
        return 0;
    } else {
        return NextIndex;
    }
}

- (void)setScrollViewContentData
{
    NSInteger previousViewIndex = [self getViewValidIndex:self.currentViewIndex - 1];
    NSInteger rearViewIndex = [self getViewValidIndex:self.currentViewIndex + 1];
    
    if (self.contentViews == nil) {
        self.contentViews = [NSMutableArray array];
    }
    [self.contentViews removeAllObjects];
    
    if (self.imageViews) {
        [self.contentViews addObject:self.imageViews[previousViewIndex]];
        [self.contentViews addObject:self.imageViews[self.currentViewIndex]];
        [self.contentViews addObject:self.imageViews[rearViewIndex ]];
    }
}

- (void)loadImage:(NSArray *)imagesData
{
    self.imageViews = [NSMutableArray array];
    
    for (int i = 0; i < [imagesData count]; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.contentMode = UIViewContentModeScaleToFill;
        NSString *imageUrl = imagesData[i];
        if ([imageUrl hasPrefix:@"http"]) {
            [imageView yy_setImageWithURL:[NSURL URLWithString:imageUrl] options:YYWebImageOptionUseNSURLCache];
        }else{
            imageView.image = [UIImage imageNamed:imagesData[i]];
        }
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapAction:)];
        [imageView addGestureRecognizer:tapGesture];
        
        [self.imageViews addObject:imageView];
    }
    
    self.totalViewsCount = [self.imageViews count];
}



- (void)animationTimerFired:(NSTimer *)timer
{
    NSInteger page = self.scrollView.contentOffset.x  / self.scrollView.frame.size.width;
    
    CGPoint newOffset = CGPointMake((page+1) * CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:newOffset animated:YES];
}

- (void)imageViewTapAction:(UITapGestureRecognizer *)tap
{
    if (self.loopShowViewDelegate) {
        [self.loopShowViewDelegate loopSHowView:self didTapAtIndex:self.currentViewIndex];
    }
}
@end

@implementation NSTimer (Addition)

- (void)pauseTimer
{
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate distantFuture]];
}

- (void)resumeTimer
{
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate date]];
}

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval
{
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
