//
//  MCVegetableMarketViewController.h
//  MaiCai
//
//  Created by Peng Jack on 13-10-25.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCBaseTabViewController.h"


@interface MCVegetableMarketViewController : MCBaseTabViewController<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *newsCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *categoryCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *quickOrderCollectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *newsPageControl;
@property (weak, nonatomic) IBOutlet UIPageControl *vegetablePricePageControl;
@property (weak, nonatomic) IBOutlet UIView *newsView;
@property (weak, nonatomic) IBOutlet UIView *categoryView;
@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (weak,nonatomic) IBOutlet UITableView* tableView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
