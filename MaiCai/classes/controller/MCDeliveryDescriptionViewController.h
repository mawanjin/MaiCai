//
//  MCDeliveryDescriptionViewController.h
//  MaiCai
//
//  Created by Peng Jack on 14-2-27.
//  Copyright (c) 2014年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCBaseNavViewController.h"
@class DTAttributedTextView;

@interface MCDeliveryDescriptionViewController : MCBaseNavViewController

@property (weak, nonatomic) IBOutlet DTAttributedTextView *textView;
@property NSMutableArray* data;
@end
