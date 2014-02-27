//
//  MCMineCartViewController.m
//  MaiCai
//
//  Created by Peng Jack on 13-10-30.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCMineCartViewController.h"
#import "MCVegetable.h"
#import "MCShop.h"
#import "MCTradeManager.h"
#import "MCVegetableManager.h"
#import "MCCartCell.h"
#import "MCCartChangeNumView.h"
#import "UIViewController+CWPopup.h"
#import "MCCartHeader.h"
#import "MCContextManager.h"
#import "MCLoginViewController.h"
#import "MCUser.h"
#import "MCOrderConfirmViewController.h"
#import "UIImageView+MCAsynLoadImage.h"
#import "MCButton.h"
#import "MCCartTableViewHeader.h"
#import "UIImage+MCScaleSize.h"

@implementation MCMineCartViewController
{
    @private
        float temp_totalPrice;
        NSMutableArray* temp_data;
}

@synthesize data;
@synthesize isTotalChoosed;
@synthesize totalPrice;

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
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(emptyCartAction)];
    item.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = item;
    
    MCCartTableViewHeader* header = [MCCartTableViewHeader initInstance];
    [header.button addTarget:self action:@selector(noticeShutDownAction:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableHeaderView = header;
}



-(void)viewDidAppear:(BOOL)animated
{
    [self showProgressHUD];
    [self resetCart];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([[MCContextManager getInstance]isLogged]) {
            //登入状态
            MCUser* user = (MCUser*)[[MCContextManager getInstance]getDataByKey:MC_USER];
            NSMutableArray* data_ = [[MCTradeManager getInstance]getCartProductsOnlineByUserId:user.userId];
            if (data_) {
                self.data = data_;
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self totalChooseBtnClickAction:nil];
                    [self.tableView reloadData];
                    [self hideProgressHUD];
                });
            }else{
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self hideProgressHUD];
                    //[self showMsgHint:MC_ERROR_MSG_0001];
                });
            }
        }else {
            //非登入状态
            NSString* macId = (NSString*)[[MCContextManager getInstance]getDataByKey:MC_MAC_ID];
            NSMutableArray* data_ = [[MCTradeManager getInstance]getCartProductsByUserId:macId];
            if (data_) {
                self.data = data_;
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self totalChooseBtnClickAction:nil];
                    [self.tableView reloadData];
                    [self hideProgressHUD];
                });
            }else{
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self hideProgressHUD];
                    //[self showMsgHint:MC_ERROR_MSG_0001];
                });
            }
        }
    });
}

-(void)viewDidDisappear:(BOOL)animated
{
     data = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MCShop* shop  = data[section];
    return shop.vegetables.count;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MCCartChangeNumView *popup = [[MCCartChangeNumView alloc] initWithNibName:@"MCCartChangeNumView" bundle:nil];
    //popup.previousView = self;
    //popup.indexPath = indexPath;
    MCShop* shop  = data[indexPath.section];
    [popup setActionCancel:^{
        if (self.popupViewController != nil) {
            [self dismissPopupViewControllerAnimated:YES completion:^{
            }];
        }
        isTotalChoosed = false;
        [self totalChooseBtnClickAction:nil];
    }];
    
    [popup setActionComplete:^(MCVegetable *vegetable) {
        [self showProgressHUD];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if ([[MCContextManager getInstance]isLogged]) {
                //登入状态
                //如果是MCMineCartViewController
                MCUser* user = (MCUser*)[[MCContextManager getInstance]getDataByKey:MC_USER];
                if ([[MCTradeManager getInstance]changeProductNumInCartOnlineByUserId:user.userId ProductId:vegetable.id Quantity:vegetable.quantity]) {
                    self.data = [[MCTradeManager getInstance]getCartProductsOnlineByUserId:user.userId];
                }
            }else {
                //注销状态
                //如果是MCMineCartViewController
                NSString* macId = (NSString*)[[MCContextManager getInstance]getDataByKey:MC_MAC_ID];
                if ([[MCTradeManager getInstance]changeProductNumInCartByUserId:macId ProductId:vegetable.id Quantity:vegetable.quantity]) {
                     self.data = [[MCTradeManager getInstance]getCartProductsByUserId:macId];
                }
                
            }

            dispatch_sync(dispatch_get_main_queue(), ^{
                if (self.popupViewController != nil) {
                    [self dismissPopupViewControllerAnimated:NO completion:^{
                    }];
                }
                isTotalChoosed = false;
                [self totalChooseBtnClickAction:nil];
                [self hideProgressHUD];
            });
        });
    }];
    
    popup.vegetable = shop.vegetables[indexPath.row];
    [self presentPopupViewController:popup animated:YES completion:nil];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return data.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MCShop* shop  = data[section];
    MCCartHeader* header = [MCCartHeader initMCCartHeader];
    header.chooseBtn.tag = section;
    header.titleLabel.text = shop.name;
    [header.chooseBtn addTarget:self action:@selector(shopHeaderChooseAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if(shop.isSelected) {
        [ header.chooseBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_btn_selected"] forState:UIControlStateNormal];
    }else{
        [ header.chooseBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_btn_normal"] forState:UIControlStateNormal];
    }

    return  header;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 10)];
    
    [footer setBackgroundColor:[UIColor clearColor]];
    return  footer;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MCCartCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"cartCell"];
    MCShop* shop = data[indexPath.section];
    NSMutableArray* vegetables = shop.vegetables;
    MCVegetable* vegetable = vegetables[indexPath.row];
    [cell.imageIcon loadImageByUrl:vegetable.image];
    cell.nameLabel.text = vegetable.name;
    cell.quantityLabel.text = [[NSString alloc]initWithFormat:@"数量：%d",vegetable.quantity];
    cell.priceLabel.text = [[NSString alloc]initWithFormat:@"单价：%0.02f元/%@",vegetable.price,vegetable.unit];
    cell.subTotalPriceLabel.text = [[NSString alloc]initWithFormat:@"小计：%0.02f元",vegetable.price*vegetable.quantity];
    
    [cell.chooseBtn setParam:indexPath];
    [cell.chooseBtn addTarget:self action:@selector(tableCellChooseAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage* normal = [UIImage imageNamed:@"cart_choose_btn_normal_long"];
    UIImage* selected = [UIImage imageNamed:@"cart_choose_btn_selected_long"];
   
    if(vegetable.isSelected) {
        [cell.chooseBtn setBackgroundImage:selected forState:UIControlStateNormal];
    }else {
        [cell.chooseBtn setBackgroundImage:normal forState:UIControlStateNormal];
    }
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MCShop* shop = data[indexPath.section];
        NSMutableArray* vegetables = shop.vegetables;
        MCVegetable* vegetable = vegetables[indexPath.row];
        NSMutableArray* array = [[NSMutableArray alloc]init];
        [array addObject:[[NSNumber alloc]initWithInt:vegetable.id]];
        if ([[MCContextManager getInstance]isLogged]) {
            MCUser* user = (MCUser*)[[MCContextManager getInstance]getDataByKey:MC_USER];
            [self showProgressHUD];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                if ([[MCTradeManager getInstance]deleteProductsInCartOnlineByUserId:user.userId ProductIds:array]) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self hideProgressHUD];
                        [vegetables removeObjectAtIndex:indexPath.row];
                        if(vegetables.count == 0) {
                            [data removeObjectAtIndex:indexPath.section];
                        }
                        [self.tableView reloadData];
                    });
                }else {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self hideProgressHUD];
                        //[self showMsgHint:MC_ERROR_MSG_0001];
                    });
                }
            });
        }else {
            NSString* macId = (NSString*)[[MCContextManager getInstance]getDataByKey:MC_MAC_ID];
            [self showProgressHUD];
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                 if ([[MCTradeManager getInstance]deleteProductsInCartByUserId:macId ProductIds:array]) {
                     dispatch_sync(dispatch_get_main_queue(), ^{
                         [self hideProgressHUD];
                         [vegetables removeObjectAtIndex:indexPath.row];
                         if(vegetables.count == 0) {
                             [data removeObjectAtIndex:indexPath.section];
                         }
                         [self.tableView reloadData];
                     });
                 }else {
                     dispatch_sync(dispatch_get_main_queue(), ^{
                         [self hideProgressHUD];
                         //[self showMsgHint:MC_ERROR_MSG_0001];
                     });
                 }
            });
        }
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

#pragma mark- others
-(void)emptyCartAction
{
    NSMutableArray* array = [[NSMutableArray alloc]init];
    for(int i=0;i<self.data.count;i++) {
        MCShop* shop = self.data[i];
        for(int j=0;j<shop.vegetables.count;j++) {
            MCVegetable* vegetable = shop.vegetables[j];
            if (vegetable.isSelected) {
                [array addObject:[NSNumber numberWithInt:vegetable.id]];
            }
        }
    }
    if ([[MCContextManager getInstance]isLogged]) {
        MCUser* user = (MCUser*)[[MCContextManager getInstance]getDataByKey:MC_USER];
        [self showProgressHUD];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if ([[MCTradeManager getInstance]deleteProductsInCartOnlineByUserId:user.userId ProductIds:array]) {
                self.data = [[MCTradeManager getInstance]getCartProductsOnlineByUserId:user.userId];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self hideProgressHUD];
                    [self.tableView reloadData];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideProgressHUD];
                    //[self showMsgHint:MC_ERROR_MSG_0001];
                });
            }
        });
    }else {
        NSString* macId = (NSString*)[[MCContextManager getInstance]getDataByKey:MC_MAC_ID];
        [self showProgressHUD];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if ([[MCTradeManager getInstance]deleteProductsInCartByUserId:macId ProductIds:array]) {
                self.data = [[MCTradeManager getInstance]getCartProductsByUserId:macId];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self hideProgressHUD];
                    [self.tableView reloadData];
                });
            }else {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self hideProgressHUD];
                    //[self showMsgHint:MC_ERROR_MSG_0001];
                });
            }
        });
    }
}

-(void)noticeShutDownAction:(id)sender
{
    self.tableView.tableHeaderView = nil;
}

-(int)calculateSelectedNum {
    int count = 0;
    for(int i=0;i<data.count;i++) {
        MCShop* shop = data[i];
        for(int j=0;j<shop.vegetables.count;j++) {
            MCVegetable* vegetable = shop.vegetables[j];
            if(vegetable.isSelected) {
                ++count;
            }
        }
    }
    return count;
}

-(void)resetCart
{
    isTotalChoosed = NO;
    [self dispLayTotalChoosedBtn];
    self.totalPriceLabel.text =[[NSString alloc]initWithFormat:@"总价：0.00元"];
    totalPrice = 0.0f;
}

-(void)calculateTotalPrice
{
    float totalPrice_ = 0.0f;
    unsigned int i = 0;
    unsigned int j = 0;
    for(i=0;i<data.count;i++) {
        MCShop* shop = data[i];
        for(j=0;j<shop.vegetables.count;j++) {
            MCVegetable* vegetable = shop.vegetables[j];
            if(vegetable.isSelected) {
                totalPrice_ += vegetable.quantity*vegetable.price;
            }
        }
    }
    totalPrice = totalPrice_;
    self.totalPriceLabel.text = [[NSString alloc]initWithFormat:@"总价：%.02f元",totalPrice];
}

- (IBAction)totalChooseBtnClickAction:(UIButton *)sender {
    isTotalChoosed = !isTotalChoosed;
    unsigned int i=0;
    unsigned int j=0;
    float totalPrice_ = 0.0f;
    for(i=0;i<data.count;i++) {
        MCShop* shop = data[i];
        for(j=0;j<shop.vegetables.count;j++) {
            MCVegetable* vegetable = shop.vegetables[j];
            vegetable.isSelected = isTotalChoosed;
            totalPrice_ += vegetable.price*vegetable.quantity;
        }
        shop.isSelected = isTotalChoosed;
    }
    totalPrice = totalPrice_;
    if(isTotalChoosed)
        self.totalPriceLabel.text = [[NSString alloc]initWithFormat:@"总价：%.02f元",totalPrice];
    else
        self.totalPriceLabel.text = [[NSString alloc]initWithFormat:@"总价：0.00元"];
    [self.tableView reloadData];
    [self dispLayTotalChoosedBtn];
    
}

-(void)dispLayTotalChoosedBtn
{
    if(isTotalChoosed) {
        [self.totalChooseBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_btn_selected"] forState:UIControlStateNormal];
    }else {
        [self.totalChooseBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_btn_normal"] forState:UIControlStateNormal];
    }
}

-(IBAction)submitBtnAction:(UIButton *)sender {
    
    if([[MCContextManager getInstance]isLogged]){
        if ([self calculateSelectedNum]<=0) {
            [self showMsgHint:@"请选择至少一样商品"];
            return;
        }
        
        if (self.totalPrice < 15.0f) {
            [self showMsgHint:@"需要购买至少15元的商品才能下单"];
            return;
        }
        
        MCOrderConfirmViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCOrderConfirmViewController"];
        
        vc.data = self.data;
        vc.totalPrice = self.totalPrice;
        
        [vc setShowMsg:^(NSString *msg) {
            [self showMsgHint:msg];
        }];
        
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        if ([self calculateSelectedNum]<=0) {
            [self showMsgHint:@"请选择至少一样商品"];
            return;
        }
        
        if (self.totalPrice < 15.0f) {
            [self showMsgHint:@"需要购买至少15元的商品才能下单"];
            return;
        }
        
        temp_data = self.data;
        temp_totalPrice = self.totalPrice;
        MCLoginViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCLoginViewController"];
        [vc setLoginComplete:^{
            MCOrderConfirmViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCOrderConfirmViewController"];
            
            vc.data = temp_data;
            vc.totalPrice = temp_totalPrice;
            
            [vc setShowMsg:^(NSString *msg) {
                [self showMsgHint:msg];
            }];
            
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        vc.hidesBottomBarWhenPushed = YES;
       [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)shopHeaderChooseAction:(id)sender{
    int section =  [sender tag];
    MCShop* shop = data[section];
    shop.isSelected = !shop.isSelected;
    unsigned int i = 0;
    if(shop.isSelected == true) {
        for(i=0;i<shop.vegetables.count;i++) {
            MCVegetable* temp = shop.vegetables[i];
            temp.isSelected = true;
        }
    }else {
        for(i=0;i<shop.vegetables.count;i++) {
            MCVegetable* temp = shop.vegetables[i];
            temp.isSelected = false;
        }
    }
    
    int count = 0;
    for(i=0;i<data.count;i++) {
        MCShop* temp = data[i];
        if(temp.isSelected == true) {
            count++;
        }
    }
    if(count == data.count) {
        isTotalChoosed = YES;
    }else {
        isTotalChoosed = NO;
    }
    
    [self.tableView reloadData];
    [self calculateTotalPrice];
    [self dispLayTotalChoosedBtn];
}

- (void)tableCellChooseAction:(id)sender {
    NSIndexPath* indexPath =[(MCButton*)sender param];
    
    MCShop* shop = data[indexPath.section];
    MCVegetable* vegetable = shop.vegetables[indexPath.row];
    vegetable.isSelected = !vegetable.isSelected;
    unsigned int count = 0;
    unsigned int i=0;
    for(i=0;i<shop.vegetables.count;i++) {
        MCVegetable* temp = shop.vegetables[i];
        if(temp.isSelected) {
            count++;
        }
    }
    if(count == shop.vegetables.count) {
        shop.isSelected = true;
    }else {
        shop.isSelected = false;
    }
    
    count = 0;
    
    for(i=0;i<data.count;i++) {
        MCShop* temp = data[i];
        if(temp.isSelected == true) {
            count++;
        }
    }
    if(count == data.count) {
        isTotalChoosed = YES;
    }else{
        isTotalChoosed = NO;
    }
    
    [self.tableView reloadData];
    [self calculateTotalPrice];
    [self dispLayTotalChoosedBtn];
}


@end
