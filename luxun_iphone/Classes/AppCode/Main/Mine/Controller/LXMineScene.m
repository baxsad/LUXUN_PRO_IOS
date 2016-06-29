//
//  LXMineScene.m
//  luxun_iphone
//
//  Created by iURCoder on 4/17/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "LXMineScene.h"
#import "GDWBSDK.h"
#import "GDBarrage.h"

@interface LXMineScene ()
@property (nonatomic, weak) IBOutlet UIButton * loginButton;
@property (nonatomic, weak) IBOutlet UIButton * shareButton;
@property (nonatomic, strong) GDReq * loginRequest;

@property (nonatomic, strong) GDBarrage * danmu;
@property (nonatomic, strong) GDBarrageElement * element;

@end

@implementation LXMineScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [_loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [_shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.loginRequest = [LXRequest userLoginRequest];
    [self.loginRequest listen:^(GDReq * _Nonnull req) {
        if (req.succeed) {
            User * user = [[User alloc] initWithDictionary:req.output error:nil];
            [[AccountCenter shareInstance] save:user];
        }
        if (req.failed) {
            [[AccountCenter shareInstance] save:nil];
        }
    }];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    GDBarrageConfiguration * config = [[GDBarrageConfiguration alloc] init];
    config.fontSize = 15;
    
    self.danmu = [[GDBarrage alloc] initWithView:view Configuration:config];
    [self.danmu start];
    _element = [[GDBarrageElement alloc] init];
    _element.text = @"老司机上路请让行！！！";
    _element.textColor = [UIColor whiteColor];
}

- (void)loginAction
{
    [[AccountCenter shareInstance] login:UserLoginTypeWeiBo complete:^(BOOL success, NSString *token, NSString *uid) {
        if (success) {
            NSLog(@"%@,%@",token,uid);
            [self.loginRequest.params setValue:uid forKey:@"uid"];
            [self.loginRequest.params setValue:token forKey:@"access_token"];
            self.loginRequest.requestNeedActive = YES;
        }
    }];
}

- (void)shareAction
{
//    [[GDWBSDK shareInstance] updateAccessTokenUseRefreshToken:nil complete:^(BOOL sucess) {
//        
//    }];
    NSLog(@"开车！");
    
    [self sende];
}

- (void)sende{
    [self.danmu receive:_element];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
