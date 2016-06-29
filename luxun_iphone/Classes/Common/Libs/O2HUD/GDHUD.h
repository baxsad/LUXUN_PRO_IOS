//
//  O2HHud.h
//  2HUO
//
//  Created by iURCoder on 3/16/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface GDHUD : NSObject


+(MBProgressHUD*)showUIBlockingIndicator;
+(MBProgressHUD*)showUIBlockingIndicatorWithText:(NSString*)str;
+(MBProgressHUD*)showUIBlockingIndicatorWithText:(NSString*)str inView:(UIView *)view;
+(MBProgressHUD*)showUIBlockingIndicatorWithText:(NSString*)str withTimeout:(int)seconds;
+(MBProgressHUD*)showUIBlockingProgressIndicatorWithText:(NSString*)str andProgress:(float)progress;

+(MBProgressHUD*)showAlertWithTitle:(NSString*)titleText text:(NSString*)text;
+(MBProgressHUD*)showAlertWithTitle:(NSString*)titleText text:(NSString*)text target:(id)t action:(SEL)sel;

+ (MBProgressHUD *)showMessage:(NSString *)msg timeout:(NSInteger)seconds;

+ (MBProgressHUD *)showCustomLoadingViewWithView:(UIView *)view;

+(void)hideUIBlockingIndicator;
+(void)hideUIBlockingIndicatorWithAnimtaion:(BOOL)animation;

@end
