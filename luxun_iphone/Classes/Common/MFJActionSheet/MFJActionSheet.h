//
//  MFJActionSheet.h
//  2HUO
//
//  Created by iURCoder on 3/25/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MFJActionSheetButtonStyle) {
    MFJActionSheetButtonStyleDefault,
    MFJActionSheetButtonStyleCancel,
    MFJActionSheetButtonStyleRed,
    MFJActionSheetButtonStyleGreen,
    MFJActionSheetButtonStyleBlue,
    MFJActionSheetButtonStyleYellow,
    MFJActionSheetButtonStyleInstagram,
    MFJActionSheetButtonStyleInstagramRed
};

@interface MFJActionSheetSection : UIView

@property (nonatomic, strong, readonly) UILabel * titleLabel;

@property (nonatomic, strong, readonly) UILabel * messageLabel;

@property (nonatomic, strong, readonly) NSArray * buttons;

@property (nonatomic, strong, readonly) UIView  * contentView;

+ (instancetype)sectionWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles buttonStyle:(MFJActionSheetButtonStyle)buttonStyle;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles buttonStyle:(MFJActionSheetButtonStyle)buttonStyle;

+ (instancetype)sectionWithTitle:(NSString *)title message:(NSString *)message contentView:(UIView *)contentView;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message contentView:(UIView *)contentView;

- (void)setButtonStyle:(MFJActionSheetButtonStyle)buttonStyle forButtonAtIndex:(NSUInteger)index;

@end


@interface MFJActionSheet : UIView

@property (nonatomic,   weak, readonly) UIView  * targetView;

@property (nonatomic, strong, readonly) NSArray * sections;

@property (nonatomic, copy) void (^buttonClickBlock)(MFJActionSheet *actionSheet, NSIndexPath *indexPath);

@property (nonatomic, assign, readonly, getter=isVisible) BOOL visible;

+ (instancetype)actionSheetWithSections:(NSArray *)sections;

- (instancetype)initWithSections:(NSArray *)sections;

- (void)showInView:(UIView *)view animated:(BOOL)animated;

- (void)dismissAnimated:(BOOL)animated;

@end
