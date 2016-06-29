//
//  MFJActionSheet.m
//  2HUO
//
//  Created by iURCoder on 3/25/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "MFJActionSheet.h"

#ifndef rgba
#define rgba(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#endif

#ifndef rgb
#define rgb(r, g, b) rgba(r, g, b, 1.0f)
#endif

#define kMargin 10.0f //左右边距
#define kButtonHeight 45.0f //按钮高度
#define kButtonMargin 3.0f //按钮上下间边距
#define kSectionMargin 15.0f //分组之间边距

#define kTopMargin 0.0f //顶部边距
#define kBottomMargin 15.0f //底部边距

#define kTitleFontSize 15.0f //标题大小
#define kMessageFontSize 13.0f //描述大小
#define kTitleMarginToMessage 5.0f //标题和描述之间的边距
#define kMessageLineSpacing 3.0f //描述的行间距
#define kTitleAndMessageTopBottomMargin 10.0f //标题和描述的顶部和底部间距

#define kAnimationDurationForSectionCount(count) MAX(0.22f, MIN(count*0.12f, 0.45f))// 获取动画时间

@interface MFJButton : UIButton

@property (nonatomic, assign) NSUInteger row;

+ (instancetype)buttonWithTitle:(NSString *)title type:(MFJActionSheetButtonStyle)type;

- (void)setButtonStyle:(MFJActionSheetButtonStyle)buttonStyle forButton:(UIButton *)button;

@end

@implementation MFJButton

+ (instancetype)buttonWithTitle:(NSString *)title type:(MFJActionSheetButtonStyle)type
{
    
    MFJButton * b = [[super alloc] init];
    b.layer.cornerRadius  = 2.0f;
    b.layer.masksToBounds = YES;
    b.layer.borderWidth   = 1.0f;
    [b setTitle:title forState:UIControlStateNormal];
    [b setButtonStyle:type forButton:b];
    
    return b;
}

- (void)setButtonStyle:(MFJActionSheetButtonStyle)buttonStyle forButton:(UIButton *)button {
    UIColor *backgroundColor, *borderColor, *titleColor = nil;
    UIFont *font = nil;
    
    if (buttonStyle == MFJActionSheetButtonStyleDefault) {
        font = [UIFont systemFontOfSize:15.0f];
        titleColor = [UIColor blackColor];
        
        backgroundColor = [UIColor colorWithWhite:0.95f alpha:1.0f];
        borderColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    }
    else if (buttonStyle == MFJActionSheetButtonStyleCancel) {
        font = [UIFont boldSystemFontOfSize:15.0f];
        titleColor = [UIColor blackColor];
        
        backgroundColor = [UIColor colorWithWhite:0.95f alpha:1.0f];
        borderColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    }
    else if (buttonStyle == MFJActionSheetButtonStyleRed) {
        font = [UIFont systemFontOfSize:15.0f];
        titleColor = [UIColor whiteColor];
        
        backgroundColor = rgb(231.0f, 76.0f, 60.0f);
        borderColor = rgb(192.0f, 57.0f, 43.0f);
    }
    else if (buttonStyle == MFJActionSheetButtonStyleYellow) {
        font = [UIFont systemFontOfSize:15.0f];
        titleColor = [UIColor whiteColor];
        
        backgroundColor = rgb(255.0f, 212.0f, 56.0f);
        borderColor = rgb(255.0f, 200.0f, 56.0f);
    }
    else if (buttonStyle == MFJActionSheetButtonStyleGreen) {
        font = [UIFont systemFontOfSize:15.0f];
        titleColor = [UIColor whiteColor];
        
        backgroundColor = rgb(46.0f, 204.0f, 113.0f);
        borderColor = rgb(39.0f, 174.0f, 96.0f);
    }
    else if (buttonStyle == MFJActionSheetButtonStyleBlue) {
        font = [UIFont systemFontOfSize:15.0f];
        titleColor = [UIColor whiteColor];
        
        backgroundColor = rgb(52.0f, 152.0f, 219.0f);
        borderColor = rgb(41.0f, 128.0f, 185.0f);
    }
    else if (buttonStyle == MFJActionSheetButtonStyleInstagram) {
        font = [UIFont boldSystemFontOfSize:15.0f];
        titleColor = rgb(6.0f, 57.0f, 102.0f);
        
        backgroundColor = [UIColor whiteColor];
        borderColor = rgb(245.0f, 245.0f, 245.0f);
    }
    else if (buttonStyle == MFJActionSheetButtonStyleInstagramRed) {
        font = [UIFont boldSystemFontOfSize:15.0f];
        titleColor = rgb(250.0f, 17.0f, 19.0f);
        
        backgroundColor = [UIColor whiteColor];
        borderColor = rgb(245.0f, 245.0f, 245.0f);
    }
    
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.font = font;
    
    [button setBackgroundImage:[self pixelImageWithColor:backgroundColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[self pixelImageWithColor:borderColor] forState:UIControlStateHighlighted];
    
    button.layer.borderColor = borderColor.CGColor;
}

- (UIImage *)pixelImageWithColor:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions((CGSize){1.0f, 1.0f}, YES, 0.0f);
    
    [color setFill];
    
    [[UIBezierPath bezierPathWithRect:(CGRect){CGPointZero, {1.0f, 1.0f}}] fill];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return [img resizableImageWithCapInsets:UIEdgeInsetsZero];
}



@end

@interface MFJActionSheetSection ()

@property (nonatomic, assign) NSUInteger index;

@property (nonatomic, copy) void (^buttonClickBlock)(NSIndexPath * indexPath);

@end

@implementation MFJActionSheetSection

+ (instancetype)sectionWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles buttonStyle:(MFJActionSheetButtonStyle)buttonStyle {
    return [[self alloc] initWithTitle:title message:message buttonTitles:buttonTitles buttonStyle:buttonStyle];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles buttonStyle:(MFJActionSheetButtonStyle)buttonStyle {
    self = [super init];
    
    if (self) {
        if (title && title.length>0) {
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont boldSystemFontOfSize:kTitleFontSize];
            titleLabel.textColor = [UIColor blackColor];
            titleLabel.numberOfLines = 1;
            titleLabel.text = title;
            _titleLabel = titleLabel;
            [self addSubview:_titleLabel];
            
        }
        
        if (message && message.length>0) {
            
            UILabel *messageLabel = [[UILabel alloc] init];
            messageLabel.backgroundColor = [UIColor clearColor];
            messageLabel.textAlignment = NSTextAlignmentCenter;
            messageLabel.font = [UIFont systemFontOfSize:kMessageFontSize];
            messageLabel.textColor = [UIColor blackColor];
            messageLabel.numberOfLines = 0;
            messageLabel.text = message;
            _messageLabel = messageLabel;
            [self addSubview:_messageLabel];
            
        }
        
        if (buttonTitles.count) {
            
            NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:buttonTitles.count];
            NSInteger index = 0;
            
            for (NSString *str in buttonTitles) {
                MFJButton *b = [MFJButton buttonWithTitle:str type:buttonStyle];
                b.row = (NSUInteger)index;
                [self addSubview:b];
                [buttons addObject:b];
                [b addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
                index++;
            }
            _buttons = buttons.copy;
            
        }
    }
    
    return self;
}

- (void)buttonPressed:(MFJButton *)sender
{
    if (self.buttonClickBlock) {
        self.buttonClickBlock([NSIndexPath indexPathForRow:(NSInteger)sender.row inSection:(NSInteger)self.index]);
    }
}

+ (instancetype)sectionWithTitle:(NSString *)title message:(NSString *)message contentView:(UIView *)contentView {
    return [[self alloc] initWithTitle:title message:message contentView:contentView];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message contentView:(UIView *)contentView {
    self = [super init];
    
    if (self) {
        if (title && title.length>0) {
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont boldSystemFontOfSize:kTitleFontSize];
            titleLabel.textColor = [UIColor blackColor];
            titleLabel.numberOfLines = 1;
            titleLabel.text = title;
            _titleLabel = titleLabel;
            [self addSubview:_titleLabel];
            
        }
        
        if (message && message.length>0) {
            
            UILabel *messageLabel = [[UILabel alloc] init];
            messageLabel.backgroundColor = [UIColor clearColor];
            messageLabel.textAlignment = NSTextAlignmentCenter;
            messageLabel.font = [UIFont systemFontOfSize:kMessageFontSize];
            messageLabel.textColor = [UIColor blackColor];
            messageLabel.numberOfLines = 0;
            messageLabel.text = message;
            _messageLabel = messageLabel;
            [self addSubview:_messageLabel];
            
        }
        
        _contentView = contentView;
        [self addSubview:self.contentView];
    }
    
    return self;
}

- (void)setButtonStyle:(MFJActionSheetButtonStyle)buttonStyle forButtonAtIndex:(NSUInteger)index
{
    if (index>self.buttons.count || index == self.buttons.count) {
        return;
    }
    MFJButton * bt = self.buttons[index];
    [bt setButtonStyle:buttonStyle forButton:bt];
}

@end

@interface MFJActionSheet ()

@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic, assign) CGRect         showFrame;

@property (nonatomic, assign) CGRect         hidenFrame;

@end

@implementation MFJActionSheet

+ (instancetype)actionSheetWithSections:(NSArray *)sections {
    return [[self alloc] initWithSections:sections];
}

- (instancetype)initWithSections:(NSArray *)sections {
    
    NSAssert(sections.count > 0, @"Must at least provide 1 section");
    self = [super init];
    if (self) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.45f];
        
        _sections = sections;
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
        
        NSInteger index = 0;
        
        _visible = NO;
        
        __weak __typeof(self) weakSelf = self;
        
        void (^clickBlock)(NSIndexPath *) = ^(NSIndexPath *indexPath) {
            [weakSelf buttonClick:indexPath];
        };
        
        for (MFJActionSheetSection *section in self.sections) {
            
            section.index = index;
            [_scrollView addSubview:section];
            [section setButtonClickBlock:clickBlock];
            index++;
            
        }
    }
    
    return self;
}

- (void)buttonClick:(NSIndexPath *)indexPath
{
    if (self.buttonClickBlock) {
        self.buttonClickBlock(self,indexPath);
    }
    [self dismissAnimated:YES];
}

- (void)tapped:(UITapGestureRecognizer *)gesture {
    if ([self hitTest:[gesture locationInView:self] withEvent:nil] == self) {
        [self dismissAnimated:YES];
    }
}

- (void)showInView:(UIView *)view animated:(BOOL)animated
{
    NSAssert(!self.visible, @"Action Sheet is already visisble!");
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    _targetView = view;
    
    // 开始布局
    [self layoutSheet];
    
    void (^completion)(void) = ^{
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    };
    
    [_targetView addSubview:self];
    
    if (!animated) {
        
        completion();
        self.scrollView.frame = self.showFrame;
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.45f];
        
    }
    else {
        CGFloat duration = kAnimationDurationForSectionCount(self.sections.count);
        
        [UIView animateWithDuration:duration animations:^{
            self.scrollView.frame = self.showFrame;
            self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.45f];
        } completion:^(BOOL finished) {
            completion();
        }];
        
    }
    _visible = YES;
}

- (void)layoutSheet{
    self.frame = _targetView.bounds;
    
    for (MFJActionSheetSection * section in self.sections) {
        // 更新section子视图布局
        [self layoutSection:section];
        
    }
    
    // section的布局更新完毕，接下更新section在scrollowview上的布局
    
    CGFloat index = 0;
    for (MFJActionSheetSection * section in self.sections) {
        
        CGRect rect = section.bounds;
        
        CGFloat sectionY = 0;
        if (index>0) {
            for (int i = 0; i<index; i++) {
                MFJActionSheetSection * section = self.sections[i];
                CGRect rect = section.frame;
                sectionY = rect.origin.y + rect.size.height + kSectionMargin;
            }
        }
        
        section.frame = CGRectMake(0, index == 0 ? kTopMargin : sectionY, rect.size.width, rect.size.height);
        
        index ++;
    }
    
    CGRect lastSectiobRect = ((MFJActionSheetSection *)[self.sections lastObject]).frame;
    CGFloat totalHeight = lastSectiobRect.origin.y + kBottomMargin + lastSectiobRect.size.height;
    
    CGRect selfFrame = self.frame;
    
    if (totalHeight<=self.frame.size.height) {
        _scrollView.frame = CGRectMake(0, selfFrame.size.height, selfFrame.size.width, totalHeight);
        _scrollView.contentSize = CGSizeMake(selfFrame.size.width, totalHeight);
        
        self.hidenFrame = CGRectMake(0, selfFrame.size.height, selfFrame.size.width, totalHeight);
        self.showFrame  = CGRectMake(0, selfFrame.size.height - totalHeight, selfFrame.size.width, totalHeight);
    }else{
        _scrollView.frame = CGRectMake(0, selfFrame.size.height, selfFrame.size.width, selfFrame.size.height);
        _scrollView.contentSize = CGSizeMake(selfFrame.size.width, totalHeight + 20);
        self.hidenFrame = CGRectMake(0, selfFrame.size.height, selfFrame.size.width, selfFrame.size.height);
        self.showFrame  = CGRectMake(0, 0, selfFrame.size.width, selfFrame.size.height);
        
        for (MFJActionSheetSection * section in self.sections) {
            CGRect rect = section.frame;
            section.frame = CGRectMake(rect.origin.x, rect.origin.y+20, rect.size.width, rect.size.height);
        }
        
    }
    
    
    
}

- (void)layoutSection:(MFJActionSheetSection *)section
{
    CGRect selfFrame = self.frame;
    CGFloat titleAndMessageHeight = 0;
    if (section.titleLabel) {
        section.titleLabel.frame = CGRectMake(kMargin, kTitleAndMessageTopBottomMargin, selfFrame.size.width - kMargin*2, kTitleFontSize);
        titleAndMessageHeight += kTitleAndMessageTopBottomMargin + kTitleFontSize;
    }
    if (section.messageLabel) {
        NSString * message = section.messageLabel.text;
        
        NSMutableDictionary* att = [NSMutableDictionary dictionary];
        [att setObject:section.messageLabel.font forKey:NSFontAttributeName];
        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:kMessageLineSpacing];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        [att setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        [att setObject:section.messageLabel.textColor forKey:NSForegroundColorAttributeName];
        NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc]initWithString:message attributes:att];
        
        section.messageLabel.attributedText = attributedText;
        
        CGSize expectedLabelSize = CGSizeZero;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
            NSMutableParagraphStyle *paragraphStyle =
            [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            paragraphStyle.lineSpacing  = kMessageLineSpacing;
            NSDictionary *attributes = @{
                                         NSFontAttributeName : section.messageLabel.font,
                                         NSParagraphStyleAttributeName : paragraphStyle.copy
                                         };
            
            expectedLabelSize =
            [message boundingRectWithSize:CGSizeMake(selfFrame.size.width - kMargin*2, 1000)
                               options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                            attributes:attributes
                               context:nil]
            .size;
        } else {
#pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            expectedLabelSize = [message sizeWithFont:section.messageLabel.font
                                 constrainedToSize:CGSizeMake(selfFrame.size.width - kMargin*2, 1000)
                                     lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
        }
        
        CGSize messageSize = CGSizeMake(ceil(expectedLabelSize.width),
                          ceil(expectedLabelSize.height));
        titleAndMessageHeight += kTitleAndMessageTopBottomMargin + kTitleMarginToMessage + messageSize.height;
        section.messageLabel.frame = CGRectMake(kMargin, kTitleAndMessageTopBottomMargin + kTitleMarginToMessage + kTitleFontSize, selfFrame.size.width - kMargin*2, messageSize.height);
    }
    
    if (section.contentView) {
        CGRect cRect = section.contentView.frame;
        section.frame = CGRectMake(0, 0, selfFrame.size.width, cRect.size.height+titleAndMessageHeight);
        section.contentView.center = CGPointMake(section.frame.size.width/2, cRect.size.height/2+titleAndMessageHeight);
        return;
    }
    CGFloat index = 0;
    for (MFJButton * bt in section.buttons) {
        bt.frame = CGRectMake(kMargin, titleAndMessageHeight + index * kButtonHeight + (index == 0 ? 0 : kButtonMargin*index), selfFrame.size.width - kMargin*2, kButtonHeight);
        index ++;
    }
    CGFloat count = section.buttons.count;
    section.frame = CGRectMake(0, 0, selfFrame.size.width, count * kButtonHeight + kButtonMargin*(count-1) + titleAndMessageHeight);
    
}

- (void)dismissAnimated:(BOOL)animated
{
    CGFloat duration = animated ? kAnimationDurationForSectionCount(self.sections.count) : 0;
    
    [UIView animateWithDuration:duration animations:^{
        self.scrollView.frame = self.hidenFrame;
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        _visible = NO;
    }];
}

@end
