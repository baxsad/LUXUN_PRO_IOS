//
//  IHBaseWebViewController.h
//  BiHu_iPhone
//
//  Created by iURCoder on 11/14/15.
//  Copyright © 2015 iUR. All rights reserved.
//

#import "IHBaseViewController.h"

@interface IHBaseWebViewController : IHBaseViewController
@property (nonatomic,   weak) UIWebView    * webView;
@property (nonatomic,   copy) NSString     * HOST;
@property (nonatomic, strong) NSDictionary * paramDic;
@property (nonatomic,   copy) NSString     * source;
@property (nonatomic,   copy) NSString     * absoluteString;
@property (nonatomic,   copy) NSString     * fullUrl;
@end
