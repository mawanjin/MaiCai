//
//  UILabel+MCAutoResize.m
//  MaiCai
//
//  Created by Peng Jack on 13-12-31.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "UILabel+MCAutoResize.h"

@implementation UILabel (MCAutoResize)
-(void)autoResizeByText:(NSString*)text PositionX:(float)x PositionY:(float)y
{
    self.frame = CGRectMake(0, 0, 0, 0);
    [self setNumberOfLines:0];
    UIFont *font = [UIFont fontWithName:@"Arial" size:13];
    CGSize size = CGSizeMake(320,2000);
    CGSize labelsize = [text sizeWithFont:font constrainedToSize:size lineBreakMode:self.lineBreakMode];
    self.text = text;
    self.font = font;
    self.frame = CGRectMake(x, y, labelsize.width, labelsize.height );
    self.textColor = [UIColor blackColor];
}

+(CGFloat)calculateHeightByText:(NSString*)text
{
    CGSize maxSize = CGSizeMake(320, 9999);
    UIFont* font = [UIFont fontWithName:@"Arial" size:13];
    CGSize expectedSize = [text sizeWithFont:font constrainedToSize:maxSize lineBreakMode:UILineBreakModeWordWrap];
    return expectedSize.height;
}
@end
