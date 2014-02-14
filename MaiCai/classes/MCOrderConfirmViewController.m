//
//  MCOrderConfirmViewController.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-24.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCOrderConfirmViewController.h"
#import "MCOrderConfirmHeader.h"
#import "MCOrderConfirmSectionHeader.h"
#import "MCMineCartViewController.h"
#import "MCShop.h"
#import "MCVegetable.h"
#import "MCOrderConfirmCell.h"
#import "MCContextManager.h"
#import "MCUser.h"
#import "MCOrderConfirmHeader_.h"
#import "MCVegetableManager.h"
#import "MCTradeManager.h"
#import "MCAddress.h"
#import "MCAppDelegate.h"
#import "UIImageView+MCAsynLoadImage.h"
#import "DDLogConfig.h"
#import "MCButton.h"
#import "MCMineAddressViewController.h"
#import "MCAddressHelperView.h"
#import "GCPlaceholderTextView.h"
#import "MCOrderConfirmReviewCell.h"
#import "MCOrderConfirmPayCell.h"
#import "MCOrderConfirmDeliveryCell.h"

#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"
#import "AlixLibService.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
@implementation MCOrderConfirmViewController

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
    [self initData];
    //默认支付宝支付
    self.paymentMethod = 0;
    //默认的评论为空
    self.reviewContent= @"";
    
    self.result = @selector(paymentResult:);
    self.totalPriceLabel.text = [[NSString alloc]initWithFormat:@"总价：%.02f元",self.totalPrice];
}

-(void)viewDidAppear:(BOOL)animated
{
    MCUser* user = (MCUser*)[[MCContextManager getInstance]getDataByKey:MC_USER];
    if(user.defaultAddress == nil) {
        self.tableView.tableHeaderView = [MCOrderConfirmHeader_ initInstance];
        self.header_ = (MCOrderConfirmHeader_*)self.tableView.tableHeaderView;
        [self.header_.helpBtn addTarget:self action:@selector(helperAction:) forControlEvents:UIControlEventTouchUpInside];
    }else {
        if(self.address == nil) {
            MCAddress* address = user.defaultAddress;
            MCOrderConfirmHeader* header = [MCOrderConfirmHeader initInstance];
            header.nameLabel.text = [[NSString alloc]initWithFormat:@"收货人：%@",address.shipper];
            header.mobileLabel.text = [[NSString alloc]initWithFormat:@"联系电话：%@",address.mobile];
            header.addressLabel.text = [[NSString alloc]initWithFormat:@"地址：%@",address.address];
            [header.button addTarget:self action:@selector(changeAddressAction:) forControlEvents:UIControlEventTouchUpInside];
            self.address = address;
            self.tableView.tableHeaderView = header;
        }else {
            MCOrderConfirmHeader* header =  (MCOrderConfirmHeader*)self.tableView.tableHeaderView;
            if(header == nil) {
                header = [MCOrderConfirmHeader initInstance];
            }
            header.nameLabel.text = [[NSString alloc]initWithFormat:@"收货人：%@",self.address.shipper];
            header.mobileLabel.text = [[NSString alloc]initWithFormat:@"联系电话：%@",self.address.mobile];
            header.addressLabel.text = [[NSString alloc]initWithFormat:@"地址：%@",self.address.address];
            [header.button addTarget:self action:@selector(changeAddressAction:) forControlEvents:UIControlEventTouchUpInside];
            self.tableView.tableHeaderView = header;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- others
-(void)initData
{
    NSMutableArray* shops = self.data;
    unsigned int i=0;
    unsigned int j=0;
    NSMutableArray* copyShops = [[NSMutableArray alloc]init];
    for(i=0;i<shops.count;i++) {
        MCShop* shop = shops[i];
        MCShop* copyShop = [[MCShop alloc]init];
        copyShop.id = shop.id;
        copyShop.name = shop.name;
        copyShop.star = shop.star;
        copyShop.market = shop.market;
        copyShop.isSelected = shop.isSelected;
        NSMutableArray* copyVegetables = [[NSMutableArray alloc]init];
        for (j=0; j<shop.vegetables.count; j++) {
            MCVegetable* vegetable = shop.vegetables[j];
            if(vegetable.isSelected) {
                MCVegetable* copyVegetable = [[MCVegetable alloc]init];
                copyVegetable.id = vegetable.id;
                copyVegetable.name = vegetable.name;
                copyVegetable.product_id = vegetable.product_id;
                copyVegetable.shop_product_id = vegetable.shop_product_id;
                copyVegetable.price = vegetable.price;
                copyVegetable.shop = vegetable.shop;
                copyVegetable.unit = vegetable.unit;
                copyVegetable.quantity = vegetable.quantity;
                copyVegetable.isSelected = vegetable.isSelected;
                copyVegetable.image = vegetable.image;
                [copyVegetables addObject:copyVegetable];
            }
        }
        for(int z=0;z<3;z++) {
            MCVegetable* copyVegetable = [[MCVegetable alloc]init];
            [copyVegetables addObject:copyVegetable];
        }
        copyShop.vegetables = copyVegetables;
        if(copyShop.vegetables == nil || copyShop.vegetables.count == 0) {
            
        }else {
            [copyShops addObject:copyShop];
        }
    }
    
    self.data = copyShops;
}



- (IBAction)submitOrderAction:(id)sender {
    for(int i=0;i<self.data.count;i++) {
        MCShop* shop = self.data[i];
        [shop.vegetables removeLastObject];
        [shop.vegetables removeLastObject];
        [shop.vegetables removeLastObject];
    }

    MCUser* user = (MCUser*)[[MCContextManager getInstance]getDataByKey:MC_USER];
    MCAddress* address = [[MCAddress alloc]init];
    if(user.defaultAddress == nil) {
        address.shipper = self.header_.nameLabel.text;
        address.mobile = self.header_.mobileLabel.text;
        address.address = self.header_.addressLabel.text;
        
        if(address.shipper == nil || [address.shipper stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
        {
            [self showMsgHint:MC_ERROR_MSG_0002];
            return;
        }
        
        if(address.mobile == nil || [address.mobile stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
        {
            [self showMsgHint:MC_ERROR_MSG_0003];
            return;
        }
        
        if(address.address == nil || [address.address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
        {
            [self showMsgHint:MC_ERROR_MSG_0004];
            return;
        }
        
        
    }else {
        address = self.address;
    }
    
    float totalPrice = 0.0f;
    totalPrice = self.totalPrice;
    NSString* pay_no =  [[MCTradeManager getInstance]submitOrder:self.data PaymentMethod:self.paymentMethod ShipMethod:self.shipMethod Address:address UserId:user.userId TotalPrice:totalPrice Review:self.reviewContent];
    
    if(self.paymentMethod == 0) {
        self.pay_no = pay_no;
        NSString *partner = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Partner"];
        NSString *seller = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Seller"];
        //NSString* privateKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSA private key"];
        
        NSString *appScheme = @"MaiCaiAlipay";
        
        AlixPayOrder *order = [[AlixPayOrder alloc] init];
        order.partner = partner;
        order.seller = seller;
        
        order.tradeNO = pay_no; //订单ID（由商家自行制定）
        order.productName = [[NSString alloc]initWithFormat:@"总共需要花费%.2f元",totalPrice]; //商品标题
        order.productDescription = @"商品描述"; //商品描述
        order.amount = [NSString stringWithFormat:@"%.2f",totalPrice]; //商品价格
        order.notifyURL = [@"http://star-faith.com:8083/maicai/api/ios/v1/public/alipay/notify.do" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; //回调URL
        NSString* signedStr = [self doRsa:[order description]];
        
        DDLogVerbose(@"%@",signedStr);
        
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                 [order description], signedStr, @"RSA"];
        
        MCAppDelegate* delegate = (MCAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate setPay_no:pay_no];
        [delegate setAlipayEndAction:^{
            self.showMsg(@"交易失败");
            [self backBtnAction];

        }];
        
        [delegate setAlipayErrorAction:^{
            self.showMsg(MC_ERROR_MSG_0001);
            [self backBtnAction];
        }];
        [AlixLibService payOrder:orderString AndScheme:appScheme seletor:self.result target:self];
    }else{
        if(self.showMsg) {
            self.showMsg(@"已生成订单，请等待收货");
            self.showMsg = nil;
        }
        [self backBtnAction];
    }
    
}

-(void)paymentResultDelegate:(NSString *)result
{
    DDLogVerbose(@"%@",result);
}

//wap回调函数
-(void)paymentResult:(NSString *)resultd
{

    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
	if (result)
    {
		
		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
//            NSString* key = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSA public key"];//签约帐户后获取到的支付宝公钥
//			id<DataVerifier> verifier;
//            verifier = CreateRSADataVerifier(key);
//            
//			if ([verifier verifyString:result.resultString withSign:result.signString])
//            {
//                //验证签名成功，交易结果无篡改
//                [self backBtnAction:^{
//                    [self.previousView showMsgHint:@"交易成功"];
//                }];
//                
//			}
        }
        else
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                @try {
                    [[MCTradeManager getInstance]cancelPaymentByPaymentNo:self.pay_no];
                }
                @catch (NSException *exception) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(self.showMsg){
                            self.showMsg(MC_ERROR_MSG_0001);
                            self.showMsg = nil;
                        }
                        
                        [self backBtnAction];
                        
                    });
                }
                @finally {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (self.showMsg) {
                            self.showMsg(@"交易失败");
                            self.showMsg = nil;
                        }
                        
                        [self backBtnAction];
                        
                    });
                }
            });
        }
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @try {
                [[MCTradeManager getInstance]cancelPaymentByPaymentNo:self.pay_no];
            }
            @catch (NSException *exception) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(self.showMsg){
                        self.showMsg(MC_ERROR_MSG_0001);
                        self.showMsg = nil;
                    }
                    [self backBtnAction];
                });
            }
            @finally {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.showMsg) {
                        self.showMsg(@"交易失败");
                        self.showMsg = nil;
                    }

                    [self backBtnAction];
                    
                });
            }
        });
    }
}

-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner([[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSA private key"]);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}


- (void)chooseAction:(id)sender {
    MCButton* btn = sender;
    MCOrderConfirmPayCell* footer = [btn param];
    if(!btn.isSelected) {
        [btn setSelected:YES];
        self.paymentMethod = [btn.titleLabel.text integerValue];
        if(btn == footer.alipayBtn) {
            [footer.cashpayBtn setSelected:NO];
        }else{
            [footer.alipayBtn setSelected:NO];
        }
    }
}

- (void)chooseShipMethodAction:(id)sender {
    MCButton* btn = sender;
    MCOrderConfirmDeliveryCell* footer = [btn param];
    if(!btn.isSelected) {
        [btn setSelected:YES];
        self.shipMethod = [btn.titleLabel.text integerValue];
        if(btn == footer.deliveryToHomeBtn) {
            [footer.getBySelfBtn setSelected:NO];
        }else{
            [footer.deliveryToHomeBtn setSelected:NO];
        }
    }
}

- (void)changeAddressAction:(UIButton *)sender {
    MCMineAddressViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MCMineAddressViewController"];
    vc.previousView = (MCBaseViewController*)self;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)helperAction:(UIButton *)sender {
    MCAddressHelperView *popup = [[MCAddressHelperView alloc] initWithNibName:@"MCAddressHelperView" bundle:nil];
    popup.previousView = self;
    [self presentPopupViewController:popup animated:YES completion:nil];
}

#pragma mark- tableview
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MCShop* shop = self.data[indexPath.section];
    MCVegetable* vegetable = shop.vegetables[indexPath.row];
    if(indexPath.row == (shop.vegetables.count-3)) {
        MCOrderConfirmReviewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"orderConfirmReviewCell"];
        cell.content.placeholderColor = [UIColor lightGrayColor];
        cell.content.placeholder = @"请留下你的宝贵意见。";
        return cell;
    }else if(indexPath.row == (shop.vegetables.count-2)) {
        MCOrderConfirmPayCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"orderConfirmPayCell"];
        [cell.alipayBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_btn_normal"] forState:UIControlStateNormal];
        [cell.alipayBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_btn_selected"] forState:UIControlStateSelected];
        
        [cell.cashpayBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_btn_normal"] forState:UIControlStateNormal];
        [cell.cashpayBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_btn_selected"] forState:UIControlStateSelected];
        
        [cell.alipayBtn setSelected:YES];
        [cell.cashpayBtn setSelected:NO];
        
        [cell.cashpayBtn setParam:cell];
        [cell.alipayBtn setParam:cell];
        
        [cell.cashpayBtn addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.alipayBtn addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else if(indexPath.row == (shop.vegetables.count-1)) {
        MCOrderConfirmDeliveryCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"orderConfirmDeliveryCell"];
        
        [cell.getBySelfBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_btn_normal"] forState:UIControlStateNormal];
        [cell.getBySelfBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_btn_selected"] forState:UIControlStateSelected];
        
        [cell.deliveryToHomeBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_btn_normal"] forState:UIControlStateNormal];
        [cell.deliveryToHomeBtn setBackgroundImage:[UIImage imageNamed:@"cart_choose_btn_selected"] forState:UIControlStateSelected];
        
        [cell.deliveryToHomeBtn setSelected:YES];
        [cell.getBySelfBtn setSelected:NO];
        
        [cell.getBySelfBtn setParam:cell];
        [cell.deliveryToHomeBtn setParam:cell];
        
        [cell.getBySelfBtn addTarget:self action:@selector(chooseShipMethodAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.deliveryToHomeBtn addTarget:self action:@selector(chooseShipMethodAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else {
        MCOrderConfirmCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"orderConfirmCell"];
        [cell.imageIcon loadImageByUrl:vegetable.image];
        cell.nameLabel.text = [[NSString alloc]initWithFormat:@"%@",vegetable.name];
        cell.quantityLabel.text = [[NSString alloc]initWithFormat:@"数量：%d",vegetable.quantity];
        cell.unitLabel.text = [[NSString alloc]initWithFormat:@"单价：%.02f元/%@",vegetable.price,vegetable.unit];
        cell.priceLabel.text = [[NSString alloc]initWithFormat:@"小计：%.02f元",vegetable.price*vegetable.quantity];
        return cell;
    }
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return self.data.count;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MCShop* shop = self.data[section];
    return shop.vegetables.count;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MCOrderConfirmSectionHeader* header =  [MCOrderConfirmSectionHeader initInstance];
    MCShop* shop = self.data[section];
    header.shopNameLabel.text = shop.name;
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView* footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 20)];
//    
//    UIImageView* imageView = [[UIImageView alloc]initWithFrame:footer.frame];
//    imageView.image = [UIImage imageNamed:@"cart_down"];
//    [footer addSubview:imageView];
//    footer.backgroundColor = [UIColor clearColor];
//    return  footer;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MCShop* shop = self.data[indexPath.section];
    if(indexPath.row == (shop.vegetables.count-3)) {
        return 82;
    }else if(indexPath.row == (shop.vegetables.count-2)) {
        return 55;
    }else if(indexPath.row == (shop.vegetables.count-1)) {
        return 55;
    }else {
        return 68;
    }

}

#pragma mark- uitextview
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        self.reviewContent = textView.text;
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

@end
