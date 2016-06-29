//
//  LXSquareScene.m
//  luxun_iphone
//
//  Created by iURCoder on 4/17/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "LXSquareScene.h"
#import "Topics.h"
#import "Bangumis.h"
#import "LXTopicListCell.h"
#import "LXTopicOneCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface LXSquareScene ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,   weak) IBOutlet UITableView * tableView;
@property (nonatomic, strong) GDReq * getTopicsRequest;
@property (nonatomic, strong) Topics * topics;

@end

@implementation LXSquareScene

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"LXTopicListCell" bundle:nil] forCellReuseIdentifier:@"LXTopicListCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LXTopicOneCell" bundle:nil] forCellReuseIdentifier:@"LXTopicOneCell"];
    
    self.getTopicsRequest = [LXRequest getTopicsRequest];
    self.getTopicsRequest.requestNeedActive = YES;
    [self.getTopicsRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
            self.topics = [[Topics alloc] initWithDictionary:@{@"list":req.output} error:nil];
        }
        if (req.failed) {
            
        }
    }];
    
    [[RACObserve(self, topics) filter:^BOOL(Topics * value) {
        return value.list.count>0;
    }] subscribeNext:^(id x) {
        @strongify(self);
        NSString * direction = @"left";
        for (Topic * t in self.topics.list) {
            Bangumis * b = [[DataCenter defaultCenter] getBangumisFromTopicsBangumis:t.bangumis];
            t.bangumiModels = b.bangumis;
            if ([t.type isEqualToString:@"one"]) {
                t.direction = direction;
                if ([direction isEqualToString:@"left"]) {
                    direction = @"right";
                }else if ([direction isEqualToString:@"right"]) {
                    direction = @"left";
                }
            }
        }
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topics.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Topic * t = self.topics.list[indexPath.row];
    if ([t.type isEqualToString:@"list"]) {
        return [tableView fd_heightForCellWithIdentifier:@"LXTopicListCell" cacheByIndexPath:indexPath configuration:^(LXTopicListCell * cell) {
            [cell configModel:t];
        }];
    }
    if ([t.type isEqualToString:@"one"]) {
        return [tableView fd_heightForCellWithIdentifier:@"LXTopicOneCell" cacheByIndexPath:indexPath configuration:^(LXTopicOneCell * cell) {
            [cell configModel:t];
        }];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Topic * t = self.topics.list[indexPath.row];
    if ([t.type isEqualToString:@"list"]) {
        LXTopicListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LXTopicListCell"];
        [cell configModel:t];
        return cell;
    }
    if ([t.type isEqualToString:@"one"]) {
        LXTopicOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LXTopicOneCell"];
        [cell configModel:t];
        return cell;
    }
    return nil;
}

@end
