//
//  MCLabelDetailViewController.h
//  MaiCai
//
//  Created by Peng Jack on 14-1-10.
//  Copyright (c) 2014年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCBaseNavViewController.h"

@interface MCLabelDetailViewController :MCBaseNavViewController<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property unsigned int labelId;
@property NSDictionary* data;

- (IBAction)clickAction:(id)sender;
@end