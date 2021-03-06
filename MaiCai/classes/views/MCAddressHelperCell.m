//
//  MCAddressHelperCell.m
//  MaiCai
//
//  Created by Peng Jack on 14-2-21.
//  Copyright (c) 2014年 JoinSoft. All rights reserved.
//

#import "MCAddressHelperCell.h"
#import "Colours.h"

@implementation MCAddressHelperCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    //背景
    CGContextSetFillColorWithColor(currentContext, [UIColor whiteColor].CGColor);
    CGContextFillRect(currentContext, rect);
    
    //分割线
    [[UIColor colorFromHexString:DIVIDE_LINE_COLOR]set];
    CGContextSetLineWidth(currentContext,0.5f);
    CGContextMoveToPoint(currentContext,0.0f,rect.size.height);
    CGContextAddLineToPoint(currentContext,rect.size.width,rect.size.height);
    CGContextStrokePath(currentContext);
}

@end
