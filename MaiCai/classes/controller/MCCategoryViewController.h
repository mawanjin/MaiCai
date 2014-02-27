//
//  MCVegetableTradeViewController.h
//  MaiCai
//
//  Created by Peng Jack on 13-10-25.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  "MCBaseTabViewController.h"
#import "MJRefresh.h"
@class HMSegmentedControl;


@interface MCCategoryViewController :MCBaseTabViewController<UIScrollViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,MJRefreshBaseViewDelegate>
@property NSMutableArray* data;
@property NSMutableArray* categories;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak)MJRefreshHeaderView *header;
- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)sender;
@end
