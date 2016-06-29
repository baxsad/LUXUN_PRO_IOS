//
//  O2HHud.m
//  2HUO
//
//  Created by iURCoder on 3/16/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "GDHUD.h"
#import "QuartzCore/QuartzCore.h"

static UIView* lastViewWithHUD = nil;

@interface GlowButton : UIButton <MBProgressHUDDelegate>

@end

@implementation GlowButton
{
    NSTimer* timer;
    float glowDelta;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //effect
        self.layer.shadowColor = [UIColor whiteColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(1,1);
        self.layer.shadowOpacity = 0.9;
        
        glowDelta = 0.2;
        timer = [NSTimer timerWithTimeInterval:0.05
                                        target:self
                                      selector:@selector(glow)
                                      userInfo:nil
                                       repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    }
    return self;
}

-(void)glow
{
    if (self.layer.shadowRadius>7.0 || self.layer.shadowRadius<0.1) {
        glowDelta *= -1;
    }
    self.layer.shadowRadius += glowDelta;
}

-(void)dealloc
{
    [timer invalidate];
    timer = nil;
}

@end

@implementation GDHUD

+(UIView*)rootView
{
    //return [UIApplication sharedApplication].keyWindow.rootViewController.view;
    
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController.view;
}

+(MBProgressHUD*)showUIBlockingIndicator
{
    return [self showUIBlockingIndicatorWithText:nil];
}

+(MBProgressHUD*)showUIBlockingIndicatorWithText:(NSString*)str
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //show the HUD
    UIView* targetView = [self rootView];
    if (targetView==nil) return nil;
    
    lastViewWithHUD = targetView;
    
    [MBProgressHUD hideHUDForView:targetView animated:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:targetView animated:YES];
    if (str!=nil) {
        hud.labelText = str;
    } else {
        hud.labelText = @"";
    }
    
    return hud;
}

+(MBProgressHUD*)showUIBlockingIndicatorWithText:(NSString*)str inView:(UIView *)view {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //show the HUD
    
    if (view==nil) return nil;
    
    lastViewWithHUD = view;
    
    [MBProgressHUD hideHUDForView:view animated:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    if (str!=nil) {
        hud.labelText = str;
    } else {
        hud.labelText = @"Loading...";
    }
    
    return hud;
}
+ (MBProgressHUD *)showMessage:(NSString *)msg timeout:(NSInteger)seconds {
    UIView* targetView = [self rootView];
    if (targetView==nil) return nil;
    lastViewWithHUD = targetView;
    
    [MBProgressHUD hideHUDForView:targetView animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:targetView animated:YES];
    hud.mode = MBProgressHUDModeText;
    if (msg) {
        hud.labelText = msg;
    } else {
        hud.labelText = @"Loading...";
    }
    [hud hide:YES afterDelay:seconds];
    return hud;
}
+ (MBProgressHUD *)showCustomLoadingViewWithView:(UIView *)view{
    [MBProgressHUD hideHUDForView:view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    lastViewWithHUD = view;
    UIImageView *loadingView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading 1"]];
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=24; i++) {
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading %zd", i]];
        [refreshingImages addObject:image];
    }
    loadingView.animationImages = refreshingImages;
    loadingView.animationDuration = 0.5;
    [loadingView startAnimating];
    hud.mode = MBProgressHUDModeCustomView;
    hud.color = [UIColor clearColor];
    hud.customView = loadingView;
    hud.userInteractionEnabled = NO;
    return hud;
}
+(MBProgressHUD*)showUIBlockingIndicatorWithText:(NSString*)str withTimeout:(int)seconds
{
    MBProgressHUD* hud = [self showUIBlockingIndicatorWithText:str];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"il_finish"]];
    hud.mode = MBProgressHUDModeCustomView;
    [hud hide:YES afterDelay:seconds];
    return hud;
}
+(MBProgressHUD*)showAlertWithTitle:(NSString*)titleText text:(NSString*)text
{
    return [self showAlertWithTitle:titleText text:text target:nil action:NULL];
}

+(MBProgressHUD*)showAlertWithTitle:(NSString*)titleText text:(NSString*)text target:(id)t action:(SEL)sel
{
    [GDHUD hideUIBlockingIndicator];
    
    //show the HUD
    UIView* targetView = [self rootView];
    if (targetView==nil) return nil;
    
    lastViewWithHUD = targetView;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:targetView animated:YES];
    
    //set the text
    hud.labelText = titleText;
    hud.detailsLabelText = text;
    
    //set the close button
    GlowButton* btnClose = [GlowButton buttonWithType:UIButtonTypeCustom];
    if (t!=nil && sel!=NULL) {
        [btnClose addTarget:t action:sel forControlEvents:UIControlEventTouchUpInside];
    } else {
        [btnClose addTarget:hud action:@selector(hide:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIImage* imgClose = [UIImage imageNamed:@"il_finish"];
    [btnClose setImage:imgClose forState:UIControlStateNormal];
    [btnClose setFrame:CGRectMake(0,0,imgClose.size.width,imgClose.size.height)];
    
    //hud settings
    hud.customView = btnClose;
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    
    return hud;
}
+(void)hideUIBlockingIndicatorWithAnimtaion:(BOOL)animation{
    [MBProgressHUD hideHUDForView:lastViewWithHUD animated:animation];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


+(void)hideUIBlockingIndicator
{
    [MBProgressHUD hideHUDForView:lastViewWithHUD animated:YES];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


+(MBProgressHUD*)showUIBlockingProgressIndicatorWithText:(NSString*)str andProgress:(float)progress
{
    [GDHUD hideUIBlockingIndicator];
    
    //show the HUD
    UIView* targetView = [self rootView];
    if (targetView==nil) return nil;
    
    lastViewWithHUD = targetView;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:targetView animated:YES];
    
    //set the text
    hud.labelText = str;
    
    hud.mode = MBProgressHUDModeDeterminate;
    hud.progress = progress;
    hud.removeFromSuperViewOnHide = YES;
    
    return hud;
}



@end
