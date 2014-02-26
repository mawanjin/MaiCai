//
//  MCAddressHelperCell.m
//  MaiCai
//
//  Created by Peng Jack on 14-2-21.
//  Copyright (c) 2014年 JoinSoft. All rights reserved.
//

#import "MCAddressHelperCell.h"
#import "UIColor+ColorWithHex.h"

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
    [[UIColor colorWithHexString:DIVIDE_LINE_COLOR andAlpha:1.0f]set];
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(currentContext,0.5f);
    CGContextMoveToPoint(currentContext,0.0f,55.0f);
    CGContextAddLineToPoint(currentContext,320.0f,55.0f);
    CGContextStrokePath(currentContext);
}

@end
