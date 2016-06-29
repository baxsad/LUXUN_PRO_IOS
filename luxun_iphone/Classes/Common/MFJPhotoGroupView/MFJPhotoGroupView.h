//
//  MFJPhotoGroupView.h
//  2HUO
//
//  Created by iURCoder on 3/26/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFJPhotoGroupItem.h"

@interface MFJPhotoGroupView : UIView
@property (nonatomic, readonly) NSArray    * groupItems; ///< Array<MFJPhotoGroupItem>
@property (nonatomic, readonly) NSInteger    currentPage;
@property (nonatomic,   assign) BOOL         blurEffectBackground; ///< Default is YES


- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithGroupItems:(NSArray *)groupItems;

- (void)presentFromImageView:(UIView *)fromView
                toController:(UIViewController *)controller
                    animated:(BOOL)animated
                  completion:(void (^)(void))completion;

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion;
- (void)dismiss;
@end
