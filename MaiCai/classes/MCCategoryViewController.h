//
//  MCVegetableTradeViewController.h
//  MaiCai
//
//  Created by Peng Jack on 13-10-25.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  "MCBaseNavViewController.h"
@class HMSegmentedControl;


@interface MCCategoryViewController :MCBaseNavViewController<UIScrollViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
@property NSMutableArray* data;
@property NSMutableArray* sourceData;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)sender;
@end
