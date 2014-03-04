//
//  UILabel+MCAutoResize.m
//  MaiCai
//
//  Created by Peng Jack on 13-12-31.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "UILabel+MCAutoResize.h"

@implementation UILabel (MCAutoResize)
-(void)autoResizeByText:(NSString*)text PositionX:(float)x PositionY:(float)y FontSize:(int)fontSize
{
    self.frame = CGRectMake(0, 0, 0, 0);
    [self setNumberOfLines:0];
    UIFont *font = [UIFont fontWithName:@"Arial" size:fontSize];
    CGSize size = CGSizeMake(290,2000);
    CGSize labelsize = [text sizeWithFont:font constrainedToSize:size lineBreakMode:self.lineBreakMode];
    self.text = text;
    self.font = font;
    self.frame = CGRectMake(x, y, labelsize.width, labelsize.height );
    self.textColor = [UIColor blackColor];
}

+(CGFloat)calculateHeightByText:(NSString*)text FontSize:(int)fontSize
{
    CGSize maxSize = CGSizeMake(290, 9999);
    UIFont* font = [UIFont fontWithName:@"Arial" size:fontSize];
    CGSize expectedSize = [text sizeWithFont:font constrainedToSize:maxSize lineBreakMode:UILineBreakModeWordWrap];
    return expectedSize.height;
}
@end
