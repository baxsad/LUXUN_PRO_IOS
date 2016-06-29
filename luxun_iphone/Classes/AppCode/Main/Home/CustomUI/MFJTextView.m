//
//  MFJTextView.m
//  2HUO
//
//  Created by iURCoder on 4/7/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "MFJTextView.h"
#define kTopY 7.0
#define kLeftX 5.0
@interface MFJTextView()<UITextViewDelegate>
@property(strong,nonatomic) UIColor *placeholder_color;
@property(strong,nonatomic) UIFont * placeholder_font;
/**
 *   显示 Placeholder
 */
@property(strong,nonatomic,readonly)  UILabel *PlaceholderLabel;

@property(assign,nonatomic) float placeholdeWidth;

@property(copy,nonatomic) id eventBlock;
@property(copy,nonatomic) id BeginBlock;
@property(copy,nonatomic) id EndBlock;
@property(copy,nonatomic) id ChangeBlock;

@end
@implementation MFJTextView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.


#pragma mark - life cycle

- (id) initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self awakeFromNib];
    }
    return self;
}
- (void)awakeFromNib {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidChange:) name:UITextViewTextDidChangeNotification object:self];
    
    //UITextViewTextDidBeginEditingNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewBeginNoti:) name:UITextViewTextDidBeginEditingNotification object:self];
    
    //UITextViewTextDidEndEditingNotification
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEndNoti:) name:UITextViewTextDidEndEditingNotification object:self];
    
    float left=kLeftX,top=kTopY,hegiht=30;
    
    self.placeholdeWidth=CGRectGetWidth(self.frame)-2*left;
    
    _PlaceholderLabel=[[UILabel alloc] initWithFrame:CGRectMake(left, top
                                                                , _placeholdeWidth, hegiht)];
    
    _PlaceholderLabel.numberOfLines=0;
    _PlaceholderLabel.lineBreakMode=NSLineBreakByCharWrapping|NSLineBreakByWordWrapping;
    [self addSubview:_PlaceholderLabel];
    
    
    [self defaultConfig];
    
}
-(void)layoutSubviews
{
    float left=kLeftX,top=kTopY,hegiht=self.bounds.size.height;
    self.placeholdeWidth=CGRectGetWidth(self.frame)-2*left;
    CGRect frame=_PlaceholderLabel.frame;
    frame.origin.x=left;
    frame.origin.y=top;
    frame.size.height=hegiht;
    frame.size.width=self.placeholdeWidth;
    _PlaceholderLabel.frame=frame;
    
    [_PlaceholderLabel sizeToFit];
    
}

-(void)dealloc{
    
    [_PlaceholderLabel removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
#pragma mark - System Delegate
#pragma mark - custom Delegate
#pragma mark - Event response

-(void)defaultConfig
{
    self.placeholder_color = [UIColor lightGrayColor];
    self.placeholder_font  = [UIFont systemFontOfSize:14];
    self.maxTextLength=1000;
    self.layoutManager.allowsNonContiguousLayout=NO;
    
    
}

-(void)addMaxTextLengthWithMaxLength:(NSInteger)maxLength andEvent:(void (^)(MFJTextView *text))limit
{
    if (maxLength>0) {
        
        _maxTextLength=maxLength;
        
    }
    
    if (limit) {
        _eventBlock=limit;
        
    }
}

-(void)addTextViewBeginEvent:(void (^)(MFJTextView *))begin{
    
    _BeginBlock=begin;
}

-(void)addTextViewEndEvent:(void (^)(MFJTextView *))End{
    _EndBlock=End;
}

-(void)setUpdateHeight:(float)updateHeight{
    
    CGRect frame=self.frame;
    frame.size.height=updateHeight;
    self.frame=frame;
    _updateHeight=updateHeight;
}

//供外部使用的 api

-(void)setPlaceholderFont:(UIFont *)font
{
    self.placeholder_font=font;
}
-(void)setPlaceholderColor:(UIColor *)color
{
    self.placeholder_color=color;
    
}
-(void)setPlaceholderOpacity:(float)opacity
{
    if (opacity<0) {
        opacity=1;
    }
    self.PlaceholderLabel.layer.opacity=opacity;
}


#pragma mark - Noti Event

-(void)textViewBeginNoti:(NSNotification*)noti{
    
    if (_BeginBlock) {
        void(^begin)(MFJTextView*text)=_BeginBlock;
        begin(self);
    }
}
-(void)textViewEndNoti:(NSNotification*)noti{
    
    if (_EndBlock) {
        void(^end)(MFJTextView*text)=_EndBlock;
        end(self);
    }
}

-(void)addTextViewDidChangeEvent:(void(^)(MFJTextView*text))change
{
    self.ChangeBlock = change;
}

-(void)DidChange:(NSNotification*)noti{
    
    if (self.placeholder.length == 0 || [self.placeholder isEqualToString:@""]) {
        _PlaceholderLabel.hidden=YES;
    }
    
    if (self.text.length > 0) {
        _PlaceholderLabel.hidden=YES;
    }
    else{
        _PlaceholderLabel.hidden=NO;
    }
    
    NSString *lang = [[self.nextResponder textInputMode] primaryLanguage]; // 键盘输入模式
    
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [self markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (self.text.length > self.maxTextLength) {
                self.text = [self.text substringToIndex:self.maxTextLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (self.text.length > self.maxTextLength) {
            self.text = [ self.text substringToIndex:self.maxTextLength];
        }
    }
    
    
    if (_eventBlock && self.text.length > self.maxTextLength) {
        
        void (^limint)(MFJTextView*text) =_eventBlock;
        
        limint(self);
    }
    
    if (_ChangeBlock) {
        
        void (^change)(MFJTextView*text) =_ChangeBlock;
        
        change(self);
        
    }
    
}

#pragma mark - private method

+(float)boundingRectWithSize:(CGSize)size withLabel:(NSString *)label withFont:(UIFont *)font{
    NSDictionary *attribute = @{NSFontAttributeName:font};
    
    // CGSize retSize;
    CGSize retSize = [label boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                      attributes:attribute
                                         context:nil].size;
    
    return retSize.height;
    
}

#pragma mark - getters and Setters

-(void)setText:(NSString *)tex{
    if (tex.length>0) {
        _PlaceholderLabel.hidden=YES;
    }
    [super setText:tex];
}

-(void)setPlaceholder:(NSString *)placeholder{
    if (placeholder.length == 0 || [placeholder isEqualToString:@""]) {
        _PlaceholderLabel.hidden=YES;
    }
    else
    {
        _PlaceholderLabel.text=placeholder;
        _placeholder=placeholder;
        
        //        float  height=  [BRPlaceholderTextView boundingRectWithSize:CGSizeMake(_placeholdeWidth, MAXFLOAT) withLabel:_placeholder withFont:_PlaceholderLabel.font];
        //        if (height>CGRectGetHeight(_PlaceholderLabel.frame) && height< CGRectGetHeight(self.frame)) {
        //
        //            CGRect frame=_PlaceholderLabel.frame;
        //            frame.size.height=height;
        //            _PlaceholderLabel.frame=frame;
        //
        //        }
    }
    
}
-(void)setPlaceholder_font:(UIFont *)placeholder_font
{
    _placeholder_font=placeholder_font;
    _PlaceholderLabel.font=placeholder_font;
}

-(void)setPlaceholder_color:(UIColor *)placeholder_color
{
    _placeholder_color=placeholder_color;
    _PlaceholderLabel.textColor=placeholder_color;
}
@end
