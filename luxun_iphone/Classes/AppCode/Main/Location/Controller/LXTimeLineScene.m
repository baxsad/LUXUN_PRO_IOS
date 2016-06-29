//
//  LXTimeLineScene.m
//  luxun_iphone
//
//  Created by iURCoder on 4/17/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "LXTimeLineScene.h"
#import "LXTimeLineCell.h"
#import "Bangumis.h"
#import "DataCenter.h"
#import "MJRefresh.h"
#import "GDEmptyDataSetter.h"

@interface LXTimeLineScene ()<UITableViewDelegate,UITableViewDataSource,GDPlaceHolderDelegate,NotDataPlaceHolderDelegate>

@property (nonatomic, weak) IBOutlet UITableView * tableView;
@property (nonatomic, strong) GDReq * getTimeLineRequest;
@property (nonatomic, strong) Bangumis * timeLineData;
@property (nonatomic, strong) NSMutableArray * data;

@end

@implementation LXTimeLineScene


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.data.isNotEmpty) return;
    self.getTimeLineRequest.requestNeedActive = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.data = [NSMutableArray array];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"LXTimeLineCell" bundle:nil] forCellReuseIdentifier:@"LXTimeLineCell"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    @weakify(self);
    self.getTimeLineRequest = [LXRequest getTimeLineRequest];
    self.getTimeLineRequest.cachePolicy = GDRequestCachePolicyReadCacheFirst;
    [self.getTimeLineRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
            if ([req.output isKindOfClass:[NSArray class]]) {
                
                @strongify(self);
                self.timeLineData = [[DataCenter defaultCenter] getBangumisFromDic:@{@"list":req.output}];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    @strongify(self);
                    for (Bangumi * bangumi in self.timeLineData.bangumis) {
                        BangumiFrameModel * frameModel = [[BangumiFrameModel alloc] init];
                        frameModel.bangumi = bangumi;
                        bangumi.frameModel = frameModel;
                    }
                });
                
                if (self.tableView.mj_header.isRefreshing) {
                    [self.data removeAllObjects];
                    [self.data addObjectsFromArray:self.timeLineData.bangumis];
                }else{
                    [self.data addObjectsFromArray:self.timeLineData.bangumis];
                }
                
                [self.tableView gd_reloadData];
                
                if (self.tableView.mj_header.isRefreshing) {
                    [self.tableView.mj_header endRefreshing];
                }else{
                    if (self.timeLineData.bangumis.count>0) {
                        [self.tableView.mj_footer endRefreshing];
                    }else{
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }
                
                
            }
        }
        if (req.failed) {
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
            [self.tableView gd_reloadData];
        }
    }];
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView setDefaultGifRefreshWithHeader:header];
    self.tableView.mj_header = header;
    
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.tableView setDefaultGifRefreshWithFooter:footer];
    self.tableView.mj_footer = footer;
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadNewData
{
    [self.tableView.mj_footer resetNoMoreData];
    self.getTimeLineRequest.APPENDPATH = @"";
    self.getTimeLineRequest.requestNeedActive = YES;
}

- (void)loadMoreData
{
    Bangumi * bgm = self.data.lastObject;
    self.getTimeLineRequest.APPENDPATH = bgm.created;
    self.getTimeLineRequest.requestNeedActive = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LXTimeLineCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LXTimeLineCell"];
    Bangumi * model = self.data[indexPath.row];
    [cell configModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Bangumi * bangumi = self.data[indexPath.row];
    [[GDRouter sharedInstance] open:@"luxun://player" extraParams:@{@"bangumi":bangumi}];
}

#pragma mark 没有数据的占位图

- (UIView *)makePlaceHolderView
{
    
    if ([DataCenter defaultCenter].networkAvailable) {
        return [self notDataPlaceHolder];
    }else{
        return [self notNetPlaceHolder];
    }
    
}

- (UIView *)notNetPlaceHolder{
    __block NotNetPlaceHolder *notNetPlaceHolder = [[NotNetPlaceHolder alloc] initWithFrame:CGRectMake(0, 0, 0, 0)
                                                                                reloadBlock:^{
                                                                                    // 刷新数据
                                                                                    [self.tableView.mj_header beginRefreshing];
                                                                                }] ;
    return notNetPlaceHolder;
}

- (UIView *)notDataPlaceHolder{
    NotDataPlaceHolder *notDataPlaceHolder = [[NotDataPlaceHolder alloc] initWithFrame:self.view.frame];
    notDataPlaceHolder.delegate = self;
    return notDataPlaceHolder;
}

#pragma mark - WeChatStylePlaceHolderDelegate Method

- (void)emptyOverlayClicked:(id)sender {
    // 刷新数据
    [self.tableView.mj_header beginRefreshing];
}

@end
