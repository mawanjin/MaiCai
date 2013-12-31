//
//  UIImageView+MCAsynLoadImage.m
//  MaiCai
//
//  Created by Peng Jack on 13-12-30.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "UIImageView+MCAsynLoadImage.h"
#import "MCNetwork.h"

@implementation UIImageView (MCAsynLoadImage)
-(void)loadImageByUrl:(NSString*)url
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            UIImage* image = [[MCNetwork getInstance]loadImageFromSource:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = image;
            });
        }
        @catch (NSException *exception) {
            
        }
});

}
@end
