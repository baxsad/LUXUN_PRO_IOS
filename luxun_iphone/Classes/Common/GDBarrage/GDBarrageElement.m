//
//  GDBarrageElement.m
//  luxun_iphone
//
//  Created by iURCoder on 4/22/16.
//  Copyright © 2016 iUR. All rights reserved.
//

#import "GDBarrageElement.h"

@implementation GDBarrageSource

+ (instancetype)createWithParam:(NSDictionary *)param
{
    GDBarrageSource *barrageSource = [[GDBarrageSource alloc] init];
    barrageSource.info = param;
    return barrageSource;
}

@end

@interface GDBarrageElement ()

@property (nonatomic, assign) CGSize size;

@end

@implementation GDBarrageElement


- (CGSize)elementSize
{
    if (_size.width > 0 && _size.height > 0) {
        return _size;
    }
    CGSize result;
    if ([_text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = _font;
        CGRect rect = [_text boundingRectWithSize:CGSizeMake(1000, 1000)
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [_text sizeWithFont:_font constrainedToSize:CGSizeMake(1000, 1000) lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
    }
    _size = result;
    return result;
}

@end

@implementation GDBarrageLable

- (void)drawTextInRect:(CGRect)rect
{
    UIColor *textColor = self.textColor;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, 2);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    self.textColor = [UIColor colorWithWhite:0.2 alpha:1];
    [super drawTextInRect:rect];
    
    CGContextSetTextDrawingMode(c, kCGTextFill);
    self.textColor = textColor;
    [super drawTextInRect:rect];
    
}

@end

