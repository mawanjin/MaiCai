//
//  MCLabelDetailViewController.m
//  MaiCai
//
//  Created by Peng Jack on 14-1-10.
//  Copyright (c) 2014年 JoinSoft. All rights reserved.
//

#import "MCLabelDetailViewController.h"
#import "MCHealthDetailProductCell.h"
#import "MCCookBookDetailHeader.h"
#import "MCVegetableManager.h"
#import "MCLabelDetailHeader.h"
#import "UIImageView+MCAsynLoadImage.h"
#import "MCVegetable.h"
#import "MCUser.h"
#import "MCContextManager.h"
#import "MCTradeManager.h"
#import "Toast+UIView.h"

@interface MCLabelDetailViewController ()

@end

@implementation MCLabelDetailViewController

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
    [self.collectionView registerNib:[UINib nibWithNibName:@"MCHealthDetailProductCell" bundle:nil]  forCellWithReuseIdentifier:@"productCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MCLabelDetailHeader" bundle:nil]  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MCLabelDetailHeader"];
    [self.collectionView setCollectionViewLayout:[self flowLayout]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
             self.data = [[MCVegetableManager getInstance]getLabelDetailById:self.labelId];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }
      
    });
	// Do any additional setup after loading the view.
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
    
    /* Set the reference size for the header and the footer views */
    flowLayout.headerReferenceSize = CGSizeMake(300.0f, 114.0f);
    return flowLayout;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{

    UICollectionReusableView *view = nil;
    if(kind == UICollectionElementKindSectionHeader) {
        MCLabelDetailHeader* view_ =
        [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                           withReuseIdentifier:@"MCLabelDetailHeader"
                                                  forIndexPath:indexPath];
        [view_.imageView loadImageByUrl:self.data[@"image"]];
        view_.label.text = self.data[@"description"];
        view = view_;
    }
    
    return view;
    
}

-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    NSArray* prodcuts = self.data[@"products"];
    return prodcuts.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MCHealthDetailProductCell* myCell = nil;
    myCell = [collectionView
              dequeueReusableCellWithReuseIdentifier:@"productCell"
              forIndexPath:indexPath];
    NSArray* prodcuts = self.data[@"products"];
    MCVegetable* vegetable = prodcuts[indexPath.row];
    myCell.checkImageView.hidden = !vegetable.isSelected;
    myCell.nameLabel.text = vegetable.name;
    myCell.priceLabel.text = [[NSString alloc]initWithFormat:@"%.2f元/%@",vegetable.price,vegetable.unit];
    return myCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* prodcuts = self.data[@"products"];
    MCVegetable* vegetable = prodcuts[indexPath.row];
    vegetable.isSelected = !vegetable.isSelected;
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

//一键买菜
- (IBAction)clickAction:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            if ([[MCContextManager getInstance]isLogged]) {
                MCUser* user = [[MCContextManager getInstance]getDataByKey:MC_USER];
                NSMutableArray* choosedProducts = [[NSMutableArray alloc]init];
                NSArray* products = self.data[@"products"];
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
                [[MCTradeManager getInstance]addProductToCartOnlineByUserId:user.userId Products:choosedProducts Recipe:Nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //结束后需要做些什么
                });
            }else {
                NSString* macId = (NSString*)[[MCContextManager getInstance]getDataByKey:MC_MAC_ID];
                NSMutableArray* choosedProducts = [[NSMutableArray alloc]init];
                NSArray* products = self.data[@"products"];
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
                
                [[MCTradeManager getInstance]addProductToCartByUserId:macId Products:choosedProducts Recipe:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //结束后需要做些什么
                });
            }
        }
        @catch (NSException *exception) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%@",exception);
                [self.view makeToast:@"无法连接网络" duration:2 position:@"center"];
            });
        }@finally {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self backBtnAction];
            });
        }
    });
}


@end
