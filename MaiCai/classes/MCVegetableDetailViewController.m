//
//  MCVegetableDetailViewController.m
//  MaiCai
//
//  Created by Peng Jack on 13-12-5.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCVegetableDetailViewController.h"
#import "HMSegmentedControl.h"
#import "MCVegetable.h"
#import "MCVegetableManager.h"
#import "MCCartConfirmPopupView.h"
#import "MCContextManager.h"
#import "Toast+UIView.h"
#import "MCShop.h"

@interface MCVegetableDetailViewController ()

@end

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@implementation MCVegetableDetailViewController

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
    self.navItem.title = self.vegetable.name;
    
    NSString* product_id =[[NSString alloc]initWithFormat:@"%d",self.vegetable.product_id];
    NSString* image = [[MCVegetableManager getInstance]getRelationshipBetweenProductAndImage][product_id];
    self.imageIcon.image = [UIImage imageNamed:image];
    self.discoutPriceLabel.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSString* lng = ((NSDictionary*)[[MCContextManager getInstance]getDataByKey:MC_CONTEXT_POSITION])[@"lng"];
    NSString* lat = ((NSDictionary*)[[MCContextManager getInstance]getDataByKey:MC_CONTEXT_POSITION])[@"lat"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            self.vegetable = [[MCVegetableManager getInstance]getShopVegetablesByProductId:self.vegetable.id Longitude: lng Latitude:lat][0];
        }
        @catch (NSException *exception) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view makeToast:@"无法获取网络资源" duration:2 position:@"center"];
            });
        }@finally {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                self.priceLabel.text = [[NSString alloc]initWithFormat:@"市场价：%.02f/%@",self.vegetable.price,self.vegetable.unit];
                self.shopLabel.text = self.vegetable.shop.name;
                if(IS_IPHONE_5){
                    
                }else{
                    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width,self.tableView.frame.size.height-90);
                }

            });
        }
    });
    
    }



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView dequeueReusableCellWithIdentifier:@"vegetableDetailCell"];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (IBAction)segementChooseAction:(id)sender {
    //处理显示
    UIButton* btn = (UIButton*)sender;
    [self.cookBookBtn setBackgroundColor:[UIColor clearColor]];
    [self.healthBtn setBackgroundColor:[UIColor clearColor]];
    if(btn == self.cookBookBtn) {
        [self.healthBtn setBackgroundImage:[UIImage imageNamed:@"label_bg"] forState:UIControlStateNormal];
        [self.cookBookBtn setBackgroundImage:Nil forState:UIControlStateNormal];
    }else{
        [self.cookBookBtn setBackgroundImage:[UIImage imageNamed:@"label_bg"] forState:UIControlStateNormal];
        [self.healthBtn setBackgroundImage:Nil forState:UIControlStateNormal];
    }
    
}

- (IBAction)phoneCallAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://10010"]];//打电话
}

- (IBAction)addProductToCartAction:(id)sender {
    MCCartConfirmPopupView *popup = [[MCCartConfirmPopupView alloc] initWithNibName:@"MCCartConfirmPopupView" bundle:nil];
    popup.previousView = self;
    popup.vegetable = self.vegetable;
    [self presentPopupViewController:popup animated:YES completion:nil];
}
@end
