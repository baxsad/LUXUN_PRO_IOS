//
//  LXPlayScene.m
//  luxun_iphone
//
//  Created by iURCoder on 4/16/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "LXPlayScene.h"
#import <ZFPlayer/ZFPlayer.h>
#import "Bangumis.h"
#import "DanMu.h"
#import "UIViewController+GD.h"
#import "LXBangumiInfoCell.h"
#import "LXBangumiSetsCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "LXContentsInputView.h"
#import "LXTableView.h"
#import "MBSwitch.h"
#import <BarrageRenderer/BarrageRenderer.h>

#define KPlayerHeight SCREEN_WIDTH*(9.0f/16.0f) /*> 视频播放器的高度 */
#define KPlayerToolBarHeight 45.0f /*> 视频播放器底部工具条的高度 */
#define kDMMargin 10.0f  /*> 弹幕输入框的外边距 */
#define kDMTextFieldHeight 30.0f  /*> 弹幕输入框的高度 */

@interface LXPlayScene ()<UITableViewDelegate,UITableViewDataSource,LXBangumiSetSelectDelegate,UITextFieldDelegate,NSURLSessionDelegate,ZFPlayerDelegate>
{
    BarrageRenderer * _renderer;
    NSInteger duration;
}
@property (nonatomic, strong) GDReq *getDmRequest;
@property (nonatomic, strong) UIView *playerBackgroundView;
@property (nonatomic, strong) ZFPlayerView *playerView;
@property (nonatomic, strong) UIView *playerToolBarView;
@property (nonatomic, strong) LXTableView * tableView;
@property (nonatomic, strong) LXContentsInputView * contentsInputView;

@property (nonatomic, strong) UIButton * danmakuColorSelectButton;
@property (nonatomic, strong) UITextField * danmakuTextField;
@property (nonatomic, strong) UIView * danmakuTextFieldRightView;
@property (nonatomic, strong) MBSwitch * danmakuSwitch;

@property (nonatomic, strong) GDReq * getDanMuRequest;
@property (nonatomic,   copy) NSString *videoUrl;
@property (nonatomic, strong) NSArray * hostSource;
@property (nonatomic, assign) NSInteger setNumber;
@property (nonatomic, strong) DanMu * danMu;

@end

@implementation LXPlayScene

- (instancetype)init {
    self = [super init];
    /**
     * 初始化 tableView 
     * 主要来显示分集、是你信息介绍、评论等
     */
    _tableView = [[LXTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView.backgroundColor = [UIColor whiteColor];
    
    /**
     * 初始化播放器背景视图
     */
    _playerBackgroundView = [UIView new];
    _playerBackgroundView.backgroundColor = [UIColor blackColor];
    _playerBackgroundView.clipsToBounds = YES;
    
    /**
     * 初始化播放器视图
     */
    luxunSay(@"鲁迅追番：初始化播放器");
    _playerView = [[ZFPlayerView alloc] init];
    _playerView.backgroundColor = [UIColor blackColor];
    _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
    
    /**
     * 初始化播放器底部工具条视图
     */
    _playerToolBarView = [UIView new];
    _playerToolBarView.backgroundColor = [UIColor whiteColor];
    _playerToolBarView.clipsToBounds = YES;
    
    /**
     * 初始化弹幕输入框
     */
    _danmakuTextField = [[UITextField alloc] init];
    _danmakuTextField.backgroundColor = UIColorHex(0xf2f2f2);
    _danmakuTextField.borderStyle = UITextBorderStyleNone;
    _danmakuTextField.placeholder = @"输入弹幕，回车发送～";
    _danmakuTextField.font = [UIFont systemFontOfSize:13];
    _danmakuTextField.textAlignment = NSTextAlignmentCenter;
    _danmakuTextField.layer.cornerRadius = 7;
    _danmakuTextField.layer.masksToBounds = YES;
    _danmakuTextField.returnKeyType = UIReturnKeySend;
    _danmakuTextField.delegate = self;
    
    /**
     * 初始弹幕
     */
    _renderer = [[BarrageRenderer alloc] init];
    _renderer.canvasMargin = UIEdgeInsetsMake(0, 0, 0, 0);
    
    /**
     * 初始视频源
     */
    luxunSay(@"鲁迅追番：初始化视频源数组");
    self.hostSource = [LXVideoSource makeWithSource:VIDEO_SOURCES];
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.alpha = 1;
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.25
                          delay:0.125
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        self.navigationController.navigationBar.alpha = 0;
    }
                     completion:^(BOOL finished) {
        self.navigationController.navigationBarHidden = YES;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    
    [self.view addSubview:_playerBackgroundView];
    [self.view addSubview:_playerView];
    [self.view addSubview:_playerToolBarView];
    [self.view addSubview:_tableView];
    [self.playerView addSubview:_renderer.view];
    [self.playerToolBarView addSubview:_danmakuTextField];
    [self setupTool];
    [self layout:LXScreenDirectionVertical];
    [_renderer start];
    
    _playerView.delegate = self;
    if (_bangumi.cur && _bangumi.sets.count > 0) {
        
        /**
         * set: 当前打开的是第几集
         */
        NSString * set = _bangumi.cur;
        
        /**
         * 遍历 sets(分集) 找到当前打开的分集
         */
        luxunSay(@"鲁迅追番：查找视频资源");
        NSInteger index = 0;
        __block typeof(NSInteger) blockIndex = index;
        [self.bangumi.sets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Set * s = (Set*)obj;
            blockIndex = idx;
            *stop = [s.set isEqualToString:set] ? YES : NO;
        }];
        index = blockIndex;
        _setNumber = index;
        luxunSay(@"鲁迅追番：视频资源组装");
        NSString * uri = ((Set*)self.bangumi.sets[index]).url;
        luxunSay(@"🎬将要播放视频：《%@》第[%li]话",self.bangumi.title,index+1);
        _videoUrl = [self.bangumi videoUrlWithUri:uri];
        luxunSay(@"鲁迅追番：加载视频资源...");
        self.playerView.videoURL = [NSURL URLWithString:_videoUrl];
    }
    self.playerView.goBackBlock = ^{
        @strongify(self);
        [[GDRouter sharedInstance] pop];
        luxunSay(@"❌关闭了视频：《%@》的播放",self.bangumi.title);
    };
    
    [self getDM];
}

#pragma mark 生成精灵描述 - 过场文字弹幕

- (BarrageDescriptor *)walkTextSpriteDescriptorWithDirection:(NSInteger)direction DanMuData:(DanMuData *)data
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"text"] = data.title;
    descriptor.params[@"textColor"] = data.color;
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(direction);
    descriptor.params[@"clickAction"] = ^{
        
    };
    return descriptor;
}

#pragma mark 获取弹幕数据请求

- (void)getDM
{
    self.getDmRequest = [LXRequest getDanMuRequest];
    self.getDmRequest.APPENDURL = [NSString stringWithFormat:@"%@%@",_bangumi.title,_bangumi.cur].urlEncode;
    self.getDmRequest.requestNeedActive = YES;
    [self.getDmRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
            DanMu * dm = [[[DanMu alloc] initWithDictionary:@{@"danmuList":req.output} error:nil] setUp];
            self.danMu = dm;
        }
        if (req.failed) {
            NSLog(@"%@",req.error);
        }
    }];
}

#pragma mark 初始化弹幕输入框

- (void)setupTool
{
    _danmakuColorSelectButton = [UIButton new];
    _danmakuColorSelectButton.backgroundColor = [UIColor clearColor];
    _danmakuColorSelectButton.frame = CGRectMake(0, 0, kDMTextFieldHeight + 5, kDMTextFieldHeight);
    _danmakuTextField.leftViewMode = UITextFieldViewModeAlways;
    _danmakuTextField.leftView = _danmakuColorSelectButton;
    
    CGSize colorImageSize = CGSizeMake(100.0, 100.0);
    UIImage * colorImage = [UIImage imageWithColor:UIColorHex(0xCACACA) size:colorImageSize];
    colorImage = [colorImage imageByRoundCornerRadius:50.0];
    UIImageView *colorImageView = [[UIImageView alloc] initWithImage:colorImage];
    colorImageView.frame = CGRectMake(0, 0, 17, 17);
    [_danmakuColorSelectButton addSubview:colorImageView];
    colorImageView.center = CGPointMake(_danmakuColorSelectButton.frame.size.width/2, _danmakuColorSelectButton.frame.size.height/2);
    
    _danmakuTextFieldRightView = [[UIView alloc] init];
    _danmakuTextFieldRightView.backgroundColor = [UIColor clearColor];
    _danmakuTextFieldRightView.frame = CGRectMake(0, 0, kDMTextFieldHeight + 15, kDMTextFieldHeight);
    _danmakuTextField.rightViewMode = UITextFieldViewModeAlways;
    _danmakuTextField.rightView = _danmakuTextFieldRightView;
    
    _danmakuSwitch = [[MBSwitch alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0, 17.0)];
    _danmakuSwitch.center = CGPointMake(_danmakuTextFieldRightView.frame.size.width/2, _danmakuTextFieldRightView.frame.size.height/2);
    [_danmakuTextFieldRightView addSubview:_danmakuSwitch];
    
    // Set the OFF border color
    [_danmakuSwitch setTintColor:[UIColor whiteColor]];
    
    // Set the ON tint color
    [_danmakuSwitch setOnTintColor:TEMCOLOR];
    
    // Set the OFF fill color
    [_danmakuSwitch setOffTintColor:UIColorHex(0xffffff)];
    
    // Set the ON thumb tint color
    [_danmakuSwitch setOnThumbTintColor:UIColorHex(0xffffff)];
    
    // Set the OFF thumb tint color
    [_danmakuSwitch setOffThumbTintColor:TEMCOLOR];
    
}

#pragma mark 播放器状态变化代理

- (void)ZFPlayer:(ZFPlayerView *)player stateChanged:(ZFPlayerState)state
{
    switch (state) {
        case ZFPlayerStateFailed:
        {
            luxunSay(@"鲁迅追番：播放失败");
            //< 这里尝试切换视频源进行播放 */
            [self changeVideoSource];
        }
            break;
        case ZFPlayerStateBuffering:
        {
            luxunSay(@"鲁迅追番：缓冲中...");
        }
            break;
        case ZFPlayerStateReadyPlay:
        {
            luxunSay(@"鲁迅追番：缓冲完毕准备播放...");
        }
            break;
        case ZFPlayerStatePlaying:
        {
            luxunSay(@"鲁迅追番：播放视频中");
        }
            break;
        case ZFPlayerStateStopped:
        {
            luxunSay(@"鲁迅追番：停止播放（播放完毕）");
        }
            break;
        case ZFPlayerStatePause:
        {
            luxunSay(@"鲁迅追番：暂停播放");
        }
            break;
            
        default:
            break;
    }
}

- (void)ZFPlayer:(ZFPlayerView *)player timeChanged:(NSTimeInterval)time
{
    if (self.danMu && self.danMu.danmuList.count>0) {
        if ([[NSString stringWithFormat:@"%.0f",time] integerValue] == duration) {
            
        }else{
            duration = [[NSString stringWithFormat:@"%.0f",time] integerValue];
            NSString * dataKey = [NSString stringWithFormat:@"key_%.0f",time];
            DanMuData * data = [self.danMu.DMKu objectForKey:dataKey];
            NSLog(@"%@-%@",dataKey,data);
            if (data) {
                [_renderer receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionR2L DanMuData:data]];
            }
        }
    }
}

#pragma mark 切换视频源

- (void)changeVideoSource
{
    for (int i = 0; i<_hostSource.count; i++) {
        LXVideoSource * source = _hostSource[i];
        if (!source.isReadyUse) {
            source.isReadyUse = YES;
            NSString * uri = ((Set*)self.bangumi.sets[_setNumber]).url;
            NSString * ecodeStr = self.bangumi.original.urlEncode;
            NSString * videoUrlString = [NSString stringWithFormat:@"%@/%@/%@",source.sourceHOST,ecodeStr,uri.urlEncode];
            NSURL * videoUrl = [NSURL URLWithString:videoUrlString];
            self.playerView.videoURL = videoUrl;
            luxunSay(@"🎬切换视频源：%@",source.sourceHOST);
            return;
        }else{
            if (i==_hostSource.count-1) {
                luxunSay(@"❌非常抱歉，实在找不到合适的视频源！");
            }
        }
    }
}

#pragma mark 选择弹幕颜色弹幕

- (void)dmColorSelected
{
    
}

#pragma mark 屏幕旋转代理方法

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        
        [self layout:LXScreenDirectionVertical];
        
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        
        [self layout:LXScreenDirectionCross];
        
    }
}

#pragma mark 根据屏幕选装方向进行页面布局

- (void)layout:(LXScreenDirection)direction
{
    switch (direction) {
        case LXScreenDirectionVertical:
        {
            self.view.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.919];
            CGRect playBackGroundFrame = CGRectMake(0, 0, SCREEN_WIDTH, KPlayerHeight + 20);
            _playerBackgroundView.frame = playBackGroundFrame;
            _playerView.frame = CGRectMake(0, 20, SCREEN_WIDTH, KPlayerHeight);
            CGRect toolBarFrame = CGRectMake(0, playBackGroundFrame.size.height, SCREEN_WIDTH, KPlayerToolBarHeight);
            _playerToolBarView.frame = toolBarFrame;
            CGRect tableFrame = CGRectMake(0, toolBarFrame.origin.y + KPlayerToolBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - playBackGroundFrame.size.height - KPlayerToolBarHeight);
            _tableView.frame = tableFrame;
            _danmakuTextField.frame = CGRectMake(0, 0, SCREEN_WIDTH - 2*kDMMargin, kDMTextFieldHeight);
            _danmakuTextField.center = CGPointMake(SCREEN_WIDTH/2, KPlayerToolBarHeight/2);
            _playerToolBarView.backgroundColor = [UIColor whiteColor];
        }
            break;
        case LXScreenDirectionCross:
        {
            self.view.backgroundColor = [UIColor blackColor];
            CGRect playBackGroundFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
            _playerBackgroundView.frame = playBackGroundFrame;
            _playerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            CGRect toolBarFrame = CGRectMake(0, SCREEN_HEIGHT - KPlayerToolBarHeight, SCREEN_WIDTH, KPlayerToolBarHeight);
            _playerToolBarView.frame = toolBarFrame;
            CGRect tableFrame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 0);
            _tableView.frame = tableFrame;
            _danmakuTextField.frame = CGRectMake(0, 0, SCREEN_WIDTH - 2*kDMMargin, kDMTextFieldHeight);
            _danmakuTextField.center = CGPointMake(SCREEN_WIDTH/2, KPlayerToolBarHeight/2);
            _playerToolBarView.backgroundColor = [UIColor clearColor];
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 弹幕发送

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_danmakuTextField resignFirstResponder];
    return YES;
}


#pragma TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section ? CONTENTS_INPUT_HEIGHT : 0.0000001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section) {
        return self.contentsInputView;
    }else{
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.00001)];
        view.backgroundColor = [UIColor redColor];
        return view;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section ? 0 : 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSString *cellID = @"SetsCell";
            LXBangumiSetsCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[LXBangumiSetsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            [cell configModel:self.bangumi];
            cell.delegate = self;
            return cell;
        }else{
            NSString *cellID = @"InfoCell";
            LXBangumiInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[LXBangumiInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            [cell configModel:self.bangumi];
            return cell;
        }
    }else{
        
        return nil;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return _bangumi.frameModel.player_setsCellHeight;
        }else{
            return _bangumi.frameModel.player_infoCellHeight;
        }
    }else{
        return 0;
    }
}

#pragma mark 选中分集的代理方法

- (void)setDidSelectedAtIndex:(NSInteger)index
{
    [self sourceReset];
    _setNumber = index;
    [self.playerView resetToPlayNewURL];
    NSString * uri = ((Set*)self.bangumi.sets[index]).url;
    NSString * videoUrlString = [self.bangumi videoUrlWithUri:uri];
    NSURL * videoUrl = [NSURL URLWithString:videoUrlString];
    luxunSay(@"🎬选中了将要播放的视频：《%@》第[%li]话",self.bangumi.title,index+1);
    self.playerView.videoURL = videoUrl;
    _bangumi.cur = ((Set*)self.bangumi.sets[index]).set;
    [self getDM];
}

- (void)sourceReset
{
    for (LXVideoSource * source in _hostSource) {
        source.isReadyUse = NO;
    }
}

#pragma mark getter

#pragma mark 评论输入框

- (LXContentsInputView *)contentsInputView
{
    if (!_contentsInputView) {
        _contentsInputView = [[LXContentsInputView alloc] init];
    }
    return _contentsInputView;
}

- (void)dealloc
{
    [self.playerView cancelAutoFadeOutControlBar];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end

@implementation LXVideoSource

+ (NSArray *)makeWithSource:(NSArray *)sources
{
    NSMutableArray * s = @[].mutableCopy;
    if (sources) {
        for (NSString * host in sources) {
            LXVideoSource * source = [[LXVideoSource alloc] init];
            source.sourceHOST = host;
            if ([host isEqualToString:@"http://usagi.luxun.pro"])
                source.isReadyUse = YES;
            else
                source.isReadyUse = NO;
            [s addObject:source];
        }
    }
    return s;
}

@end
