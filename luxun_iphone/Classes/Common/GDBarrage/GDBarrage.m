//
//  GDBarrage.m
//  luxun_iphone
//
//  Created by iURCoder on 4/22/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "GDBarrage.h"

#import "GDBarrageCanvas.h"
#import "GDBarrageClock.h"
#import "GDBarrageTrack.h"

#define kTrackSpace 3.0f

@implementation GDBarrageConfiguration

@end

@interface GDBarrage ()

@property (nonatomic, strong) GDBarrageConfiguration *configuration;
@property (nonatomic) CGRect frame;
@property (nonatomic,strong) GDBarrageCanvas * canvas;
@property (nonatomic,strong) NSDate * startTime;
@property (nonatomic,assign) NSTimeInterval pausedDuration;
@property (nonatomic,strong) NSDate * pausedTime;
@property (nonatomic,strong) NSMutableArray * preloadedDescriptors;
@property (nonatomic,strong) GDBarrageClock * clock;
@property (nonatomic,assign) __block NSTimeInterval time;
@property (nonatomic) dispatch_queue_t barrageQueue;
@property (nonatomic,assign) NSInteger fontSzie;
@property (nonatomic,strong) NSMutableArray * tracks;
@property (nonatomic,strong) NSMutableArray * optimalPolicys;
@property (nonatomic,strong) NSMutableArray * trackReckon;

@end

@implementation GDBarrage

- (void)dealloc {
    [_canvas removeFromSuperview];
    _startTime = nil;
    _pausedTime = nil;
    _pausedDuration = 0;
    [_clock stop];
}

- (instancetype)initWithView:(UIView *)view Configuration:(GDBarrageConfiguration *)configuration
{
    self = [self init];
    if (self) {
        _canvas = [[GDBarrageCanvas alloc] init];
        _canvas.frame = view.bounds;
        _canvas.userInteractionEnabled = NO;
        _canvas.backgroundColor = [UIColor clearColor];
        _canvas.clipsToBounds = YES;
        _configuration = configuration;
        _startTime = nil;
        _pausedTime = nil;
        _pausedDuration = 0.00f;
        _barrageQueue = dispatch_queue_create("com.gdbarrage.queue", DISPATCH_QUEUE_CONCURRENT);
        _fontSzie = configuration.fontSize;
        [self clock_init];
        [self track_init];
        [view addSubview:_canvas];
    }
    return self;
}

#pragma mark - 心跳

- (void)clock_init
{
    _clock = [GDBarrageClock clockWithHandler:^(NSTimeInterval time){
        _time = time;
    }];
}

#pragma mark - 轨道

- (void)track_init
{
    __weak typeof(self) weak_self = self;
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        __strong typeof(self) strong_self = weak_self;
        
        strong_self.frame = strong_self.canvas.frame;
        CGFloat canvasW = strong_self.frame.size.width;
        CGFloat canvasH = strong_self.frame.size.height;
        CGFloat trackSpace = kTrackSpace;
        NSInteger trackLines = 0;
        CGFloat float_lines = (canvasH - strong_self.fontSzie)/(strong_self.fontSzie + trackSpace) + 1;
        trackLines = floor(float_lines);
        if (float_lines - trackLines != 0)
            trackSpace += (float_lines - trackLines)/(trackLines-1);
        if (!strong_self.tracks) {
            strong_self.tracks = [NSMutableArray array];
            strong_self.optimalPolicys = [NSMutableArray array];
            strong_self.trackReckon = [NSMutableArray array];
        }else{
            [strong_self.tracks removeAllObjects];
            [strong_self.optimalPolicys removeAllObjects];
            [strong_self.trackReckon removeAllObjects];
        }
        for (int i = 0; i < trackLines; i++) {
            GDBarrageTrack * track = [[GDBarrageTrack alloc] init];
            if (i == 0)
                track.trackFrame = CGRectMake(0, i*strong_self.fontSzie, canvasW, strong_self.fontSzie);
            else
                track.trackFrame = CGRectMake(0, i*strong_self.fontSzie + trackSpace*i, canvasW, strong_self.fontSzie);
            track.state = TrackStateFree;
            track.tag = i;
            [strong_self.tracks addObject:track];
        }
        
    });
}

#pragma mark - 计算当前最优轨道

- (GDBarrageTrack *)track_optimal_policy
{
    
    // 需要计算出当前轨道上有没有弹幕正在运行
    // 弹幕是否完全展现在轨道上
    // 每个轨道上最后一个弹幕尾部距离轨道开始位置的距离
    // 距离最大的轨道为最优轨道
    // 如果最优轨道比较多则随机取其中一个最优轨道
    // @TODO 如果没有最优轨道怎么办？
    
    __block GDBarrageTrack * optimal_policy_track;
    [_optimalPolicys removeAllObjects];
    [_trackReckon removeAllObjects];
    [_tracks enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GDBarrageTrack * track = (GDBarrageTrack *)obj;
        if (!track.lastElement) {
            track.freeSpace = track.trackFrame.size.width;
            [_optimalPolicys addObject:track];
            track.state = TrackStateFree;
        }else{
            [_trackReckon addObject:track];
        }
    }];
    
    // 如果存在航道上没有弹幕在运行的状况，就直接选出一个最优航道结束计算
    if (_optimalPolicys.count>0) {
        optimal_policy_track = [self sort_track_free_space];
    }
    
    // 已经找出最优航道
    if (optimal_policy_track) {
        return optimal_policy_track;
    }
    
    if (_trackReckon.count>0) {
        [_trackReckon enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GDBarrageTrack * track = (GDBarrageTrack *)obj;
            
            CALayer *layer = track.lastElement.layer;
            CGRect elementLastElementFrame;
            if (layer.presentationLayer) {
                elementLastElementFrame = ((CALayer *)layer.presentationLayer).frame;
            }else{
                elementLastElementFrame = track.lastElement.frame;
            }
            // 预留 ： 弹幕出现方向不同算法将会改变
            CGFloat elementLastElementX = elementLastElementFrame.origin.x;
            CGFloat elementLastElementW = elementLastElementFrame.size.width;
            CGFloat marginBeginOrigin = track.trackFrame.size.width - elementLastElementX - elementLastElementW;
            if (marginBeginOrigin >= 0) {
                track.freeSpace = marginBeginOrigin;
                track.state = TrackStateFree;
                [_optimalPolicys addObject:track];
            }else{
                track.state = TrackStateBusy;
                track.freeSpace = -1;
            }
        }];
    }
    
    // 航道全部繁忙，只有随机取一个航道出来喽😔
    
    if (_optimalPolicys.count == 0) {
        int r = arc4random() % [_tracks count];
        optimal_policy_track = [_tracks objectAtIndex:r];
        return optimal_policy_track;
    }
    
    // 已经计算出了所存在的可用航道
    
    NSArray *sortArray = [_optimalPolicys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        GDBarrageTrack *track1 = obj1;
        GDBarrageTrack *track2 = obj2;
        
        CALayer *layer1 = track1.lastElement.layer;
        CALayer *layer2 = track2.lastElement.layer;
        
        CGRect elementLastElementFrame1;
        CGRect elementLastElementFrame2;
        
        if (layer1.presentationLayer && layer2.presentationLayer) {
            elementLastElementFrame1 = ((CALayer *)layer1.presentationLayer).frame;
            elementLastElementFrame2 = ((CALayer *)layer2.presentationLayer).frame;
        }else{
            elementLastElementFrame1 = track1.lastElement.frame;
            elementLastElementFrame2 = track2.lastElement.frame;
        }
        
        CGFloat elementLastElementX1 = elementLastElementFrame1.origin.x;
        CGFloat elementLastElementW1 = elementLastElementFrame1.size.width;
        
        CGFloat elementLastElementX2 = elementLastElementFrame2.origin.x;
        CGFloat elementLastElementW2 = elementLastElementFrame2.size.width;
        
        CGFloat space1 = track1.trackFrame.size.width - elementLastElementX1 - elementLastElementW1;
        CGFloat space2 = track2.trackFrame.size.width - elementLastElementX2 - elementLastElementW2;
        
        // Integer tag1 = track1.tag;
        // NSInteger tag2 = track2.tag;
        
        CGFloat v1 = space1;
        CGFloat v2 = space2;
        
        NSComparisonResult result = (v1 <= v2) ? NSOrderedDescending : NSOrderedAscending;
        
        return result;
    }];
    
    optimal_policy_track = sortArray.firstObject;
    
    return optimal_policy_track;
}

#pragma mark - 按照航道和空闲排序

- (GDBarrageTrack *)sort_track_free_space
{
    int r = arc4random() % [_optimalPolicys count];
    return [_optimalPolicys objectAtIndex:r];
}

#pragma mark - 开始运行弹幕

- (void)start
{
    // 尚未启动,则初始化时间系统
    if (!_startTime) {
        _startTime = [NSDate date];
    }
     // 开始前处于暂停状态
    else if(_pausedTime)
    {
        // 如果暂停了计算从暂停开始暂停了多久
        _pausedDuration += [[NSDate date]timeIntervalSinceDate:_pausedTime];
    }
    _pausedTime = nil;
    [_clock start];
    _barrageState = BarrageStart;
    for (GDBarrageElement * element in _preloadedDescriptors) {
        [self receive:element];
    }
}

#pragma mark - 弹幕暂停

- (void)pause
{
    // 没有运行, 则暂停无效
    if (!_startTime) {
        return;
    }
    // 当前没有暂停
    if (!_pausedTime) {
        [_clock pause];
        _pausedTime = [NSDate date];
        _barrageState = BarragePause;
    }
    // 当前暂停中
    else
    {
        _pausedDuration += [[NSDate date]timeIntervalSinceDate:_pausedTime];
        _pausedTime = [NSDate date];
    }
}

#pragma mark - 弹幕停止

- (void)stop
{
    _startTime = nil;
    [_clock stop];
    _barrageState = BarrageStop;
}

#pragma mark - 接收弹幕消息, 如果尚未start, 则调用无效.

- (void)receive:(GDBarrageElement *)element
{
    
    dispatch_async(_barrageQueue, ^{
        
        if (!_canvas.superview) return; // 弹幕幕布没有被加载
        if (!_startTime) return; // 如果没有启动,则抛弃接收弹幕
        
        element.font = [UIFont systemFontOfSize:_fontSzie];
        
        // 导航就位：分配航道...
        GDBarrageTrack * track = [self track_optimal_policy];
        NSLog(@"分配航道:%li",track.tag);
        
        // 司机准备：驾驶时间...
        GDBarrageElement * readyElement = [self prepareElement:element inTrack:track];
        
        // 记录车辆：入库备案...
        [self registerElement:element];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 开始开车：司机上路...
            [self beginLaunch:readyElement inTrack:track];
        });
    });
    
}

#pragma mark - 加载弹幕

- (void)load:(NSArray<GDBarrageElement> *)elements
{
    // 如果已经开始的话就直接加载弹幕
    if (_startTime) {
        for (GDBarrageElement * element in elements) {
            [self receive:element];
        }
    }else{
        _barrageState = BarrageWait;
        if (!_preloadedDescriptors) {
            _preloadedDescriptors = [[NSMutableArray alloc]init];
        }
        for (GDBarrageElement * element in elements) {
            [_preloadedDescriptors addObject:[element copy]];
        }
        [self start];
    }
}

- (void)registerElement:(GDBarrageElement *)element
{
    [_preloadedDescriptors addObject:element];
}

- (GDBarrageElement *)prepareElement:(GDBarrageElement *)element inTrack:(GDBarrageTrack *)track
{
    CGFloat w = element.elementSize.width;
    CGFloat y = track.trackFrame.origin.y;
    CGFloat h = track.trackFrame.size.height;
    CGRect beginFrame = CGRectMake(track.trackFrame.size.width, y, w, h);
    CGRect endFrame = CGRectMake(-w,y, w, h);
    element.appearFrame = beginFrame;
    element.disappearFrame = endFrame;
    return element;
}

- (void)beginLaunch:(GDBarrageElement *)element inTrack:(GDBarrageTrack *)track
{

    __block GDBarrageLable * lable = [[GDBarrageLable alloc] init];
    lable.frame = element.appearFrame;
    lable.font = element.font;
    lable.textColor = element.textColor;
    lable.text = element.text;
    [_canvas addSubview:lable];
    track.lastElement = lable;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:10 delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        lable.frame = element.disappearFrame;
    } completion:^(BOOL finished) {
        track.lastElement = nil;
        [weakSelf removElement:lable];
    }];
    
}

- (void)removElement:(GDBarrageLable *)lable
{
    [lable removeFromSuperview];
    [lable.layer removeFromSuperlayer];
    [lable.layer removeAllAnimations];
    lable = nil;
}

#pragma mark - 弹幕显示的视图

- (UIView *)view
{
    return _canvas;
}

#pragma mark - 获取暂停了的时间

- (NSTimeInterval)pausedDuration
{
    return _pausedDuration + (_pausedTime?[[NSDate date]timeIntervalSinceDate:_pausedTime]:0); // 当前处于暂停当中
}

#pragma mark - 获取当前时间

- (NSTimeInterval)currentTime
{
    NSTimeInterval currentTime = 0.0f;
    {
        currentTime = [[NSDate date]timeIntervalSinceDate:_startTime]-self.pausedDuration;
    }
    return currentTime;
}

@end
