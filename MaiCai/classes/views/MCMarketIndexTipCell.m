//
//  MCMarketIndexTipCell.m
//  MaiCai
//
//  Created by Peng Jack on 14-1-6.
//  Copyright (c) 2014年 JoinSoft. All rights reserved.
//

#import "MCMarketIndexTipCell.h"
#import "Colours.h"

@implementation MCMarketIndexTipCell

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
    [[UIColor colorFromHexString:DIVIDE_LINE_COLOR]set];
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(currentContext,0.5f);
    CGContextMoveToPoint(currentContext,0.0f,66.0f);
    CGContextAddLineToPoint(currentContext,320.0f,66.0f);
    CGContextStrokePath(currentContext);
}
@end
