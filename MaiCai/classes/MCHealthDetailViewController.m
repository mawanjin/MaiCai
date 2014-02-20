//
//  MCHealthDetailViewController.m
//  MaiCai
//
//  Created by Peng Jack on 13-12-31.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCHealthDetailViewController.h"
#import "UILabel+MCAutoResize.h"
#import "MCVegetableManager.h"
#import "MCHealth.h"
#import "UIImageView+MCAsynLoadImage.h"
#import "MCNetwork.h"
#import "MCHealthDetailProductCell.h"
#import "MCVegetable.h"
#import "MCContextManager.h"
#import "MCUser.h"
#import "MCTradeManager.h"
#import "DDLogConfig.h"

@interface MCHealthDetailViewController ()

@end

@implementation MCHealthDetailViewController

#pragma mark- base
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         self.health = [[MCVegetableManager getInstance]getHealthDetailById:self.health.id];
        dispatch_async(dispatch_get_main_queue(), ^{
           
            self.scrollView.scrollEnabled = YES;
            UIImageView* bigImageView = [[UIImageView alloc]initWithFrame:CGRectMake(35, 0, 250, 100)];
            [bigImageView loadImageByUrl:self.health.bigImage];
            [self.scrollView addSubview:bigImageView];
            
            UILabel* introduction = [[UILabel alloc]init];
            [introduction autoResizeByText:self.health.introduction PositionX:0.0 PositionY:bigImageView.frame.size.height];
            [self.scrollView addSubview:introduction];
            
            NSMutableArray* items = self.health.items;
            
            unsigned int height = bigImageView.frame.size.height+introduction.frame.size.height;
            
            for(int i=0;i<items.count;i++) {
                NSDictionary* item = items[i];
                
                UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(35,height, 250, 100)];
                [imageView loadImageByUrl:item[@"image"]];
                [self.scrollView addSubview:imageView];
                height = height+imageView.frame.size.height;
                
                UILabel* label = [[UILabel alloc]init];
                [label autoResizeByText:item[@"content"] PositionX:0 PositionY:height];
                [self.scrollView addSubview:label];
                height = height+label.frame.size.height;
            }
            
            UICollectionView* collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, height, 320, (self.health.products.count/3+1)*50+20) collectionViewLayout:[self flowLayout]];

            [collectionView registerNib:[UINib nibWithNibName:@"MCHealthDetailProductCell" bundle:nil]  forCellWithReuseIdentifier:@"productCell"];
            collectionView.delegate = self;
            collectionView.dataSource = self;
            [collectionView setBackgroundColor:[UIColor clearColor]];
            [self.scrollView addSubview:collectionView];
            height += collectionView.frame.size.height;
            self.scrollView.contentSize = CGSizeMake(320,height+10);
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - uicollectionview
- (UICollectionViewFlowLayout *) flowLayout{
    UICollectionViewFlowLayout *flowLayout =
    [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 10.0f;
    flowLayout.minimumInteritemSpacing = 5.0f;
    flowLayout.itemSize = CGSizeMake(80.0f, 50.0f);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(5.0f, 20.0f, 5.0f, 20.0f);
    return flowLayout;
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    UICollectionView* view = (UICollectionView*)scrollView;
//    if([view.restorationIdentifier isEqualToString:@"newsCollectionView"]){
//        CGFloat pageWidth = self.newsCollectionView.frame.size.width;
//        self.newsPageControl.currentPage = self.newsCollectionView.contentOffset.x / pageWidth;
//    }else if([view.restorationIdentifier isEqualToString:@"quickOrderCollectionView"]){
//        CGFloat pageWidth = self.quickOrderCollectionView.frame.size.width-10;
//        self.vegetablePricePageControl.currentPage = self.quickOrderCollectionView.contentOffset.x / pageWidth;
//    }
}


-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return self.health.products.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MCHealthDetailProductCell* myCell = nil;
    myCell = [collectionView
                  dequeueReusableCellWithReuseIdentifier:@"productCell"
                  forIndexPath:indexPath];
    MCVegetable* vegetable = self.health.products[indexPath.row];
    myCell.checkImageView.hidden = !vegetable.isSelected;
    myCell.nameLabel.text = vegetable.name;
    myCell.priceLabel.text = [[NSString alloc]initWithFormat:@"%.2f元/%@",vegetable.price,vegetable.unit];
    return myCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     MCVegetable* vegetable = self.health.products[indexPath.row];
    vegetable.isSelected = !vegetable.isSelected;
    [collectionView reloadData];
}

#pragma mark- others
//一键买菜
- (IBAction)clickAction:(id)sender {
    [self showProgressHUD];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([[MCContextManager getInstance]isLogged]) {
            MCUser* user = (MCUser*)[[MCContextManager getInstance]getDataByKey:MC_USER];
            NSMutableArray* choosedProducts = [[NSMutableArray alloc]init];
            NSArray* products = self.health.products;
            for(int i=0;i<products.count;i++) {
                MCVegetable* vegetable = products[i];
                if(vegetable.isSelected) {
                    NSDictionary* product = @{
                                              @"id":[[NSNumber alloc]initWithInt:vegetable.id],
                                              @"quantity":[[NSNumber alloc]initWithInt:vegetable.quantity],
                                             // @"dosage":vegetable.dosage
                                              };
                    [choosedProducts addObject:product];
                }
            }
            
            if ([[MCTradeManager getInstance]addProductToCartOnlineByUserId:user.userId Products:choosedProducts Recipe:Nil]) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    //结束后需要做些什么
                    if(self.showMsg) {
                        self.showMsg(@"加入菜篮成功");
                        self.showMsg = nil;
                    }
                    
                    [self hideProgressHUD];
                    [self backBtnAction];
                });
            }else {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    //[self showMsgHint:MC_ERROR_MSG_0001];
                });
            }
        }else {
            NSString* macId = (NSString*)[[MCContextManager getInstance]getDataByKey:MC_MAC_ID];
            NSMutableArray* choosedProducts = [[NSMutableArray alloc]init];
            NSArray* products = self.health.products;
            for(int i=0;i<products.count;i++) {
                MCVegetable* vegetable = products[i];
                if(vegetable.isSelected) {
                    NSDictionary* product = @{
                                              @"id":[[NSNumber alloc]initWithInt:vegetable.id],
                                              @"quantity":[[NSNumber alloc]initWithInt:vegetable.quantity]
                                              };
                    [choosedProducts addObject:product];
                }
            }

            if ([[MCTradeManager getInstance]addProductToCartByUserId:macId Products:choosedProducts Recipe:nil]) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    //结束后需要做些什么
                    if(self.showMsg) {
                        self.showMsg(@"加入菜篮成功");
                        self.showMsg = nil;
                    }
                    [self hideProgressHUD];
                    [self backBtnAction];
                });
            }else {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    //[self showMsgHint:MC_ERROR_MSG_0001];
                });
            }
            
        }
    });
}
@end
