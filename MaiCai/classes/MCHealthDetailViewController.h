//
//  MCHealthDetailViewController.h
//  MaiCai
//
//  Created by Peng Jack on 13-12-31.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCBaseNavViewController.h"
@class MCHealth;

@interface MCHealthDetailViewController : MCBaseNavViewController<UICollectionViewDataSource,UICollectionViewDelegate>
@property MCHealth* health;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)clickAction:(id)sender;
@end
