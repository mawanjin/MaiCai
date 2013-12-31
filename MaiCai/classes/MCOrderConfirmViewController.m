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
#import "MCOrderConfirmFooter.h"
#import "MCTradeManager.h"
#import "MCAddress.h"
#import "Toast+UIView.h"

#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"
#import "AlixLibService.h"


@implementation MCOrderConfirmViewController

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
    
    self.result = @selector(paymentResult:);
    
   
    MCOrderConfirmFooter* footerView = [MCOrderConfirmFooter initInstance];
    footerView.parentView = self;
    self.tableView.tableFooterView = footerView;
    
    self.totalPriceLabel.text = self.previousView.totalPriceLabel.text;
    
    MCUser* user = (MCUser*)[[MCContextManager getInstance]getDataByKey:MC_USER];
    if(user.defaultAddress == nil) {
        self.tableView.tableHeaderView = [MCOrderConfirmHeader_ initInstance];
        self.header_ = self.tableView.tableHeaderView;
        self.header_.parentView = self;
    }else {
        if(self.address == nil) {
            MCAddress* address = user.defaultAddress;
            MCOrderConfirmHeader* header = [MCOrderConfirmHeader initInstance];
            header.nameLabel.text = [[NSString alloc]initWithFormat:@"收货人：%@",address.shipper];
            header.mobileLabel.text = [[NSString alloc]initWithFormat:@"联系电话：%@",address.mobile];
            header.addressLabel.text = [[NSString alloc]initWithFormat:@"地址：%@",address.address];
            header.parentView = self;
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
            header.parentView = self;
            self.tableView.tableHeaderView = header;
            
        }
    }
    
   
}


-(void)initData
{
    NSMutableArray* shops = self.previousView.data;
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
                [copyVegetables addObject:copyVegetable];
            }
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
    MCUser* user = (MCUser*)[[MCContextManager getInstance]getDataByKey:MC_USER];
    MCAddress* address = [[MCAddress alloc]init];
    if(user.defaultAddress == nil) {
        address.shipper = self.header_.nameLabel.text;
        address.mobile = self.header_.mobileLabel.text;
        address.address = self.header_.addressLabel.text;
        
        if(address.shipper == nil || [address.shipper stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
        {
            [self.view makeToast:@"请填写收货人" duration:2 position:@"center"];
            return;
        }
        
        if(address.mobile == nil || [address.mobile stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
        {
            [self.view makeToast:@"请填写联系电话" duration:2 position:@"center"];
            return;
        }
        
        if(address.address == nil || [address.address stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
        {
            [self.view makeToast:@"请填写地址" duration:2 position:@"center"];
            return;
        }
        
        
    }else {
        address = self.address;
    }
   
    NSString* pay_no =  [[MCTradeManager getInstance]submitOrder:self.data PaymentMethod:self.paymentMethod ShipMethod:self.shipMethod Address:address UserId:user.userId TotalPrice:self.previousView.totalPrice];
    
    if(self.paymentMethod == 0) {
        self.pay_no = pay_no;
        [[MCContextManager getInstance]addKey:MC_PAY_NO Data:pay_no];
        NSString *partner = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Partner"];
        NSString *seller = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Seller"];
        NSString* privateKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSA private key"];
        
        NSString *appScheme = @"MaiCaiAlipay";
        
        AlixPayOrder *order = [[AlixPayOrder alloc] init];
        order.partner = partner;
        order.seller = seller;
        
        order.tradeNO = pay_no; //订单ID（由商家自行制定）
        order.productName = [[NSString alloc]initWithFormat:@"总共需要花费%.2f元",self.previousView.totalPrice]; //商品标题
        order.productDescription = @"商品描述"; //商品描述
        order.amount = [NSString stringWithFormat:@"%.2f",self.previousView.totalPrice]; //商品价格
        order.notifyURL = [@"http://star-faith.com:8083/maicai/api/ios/v1/public/alipay/notify.do" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; //回调URL
        NSString* signedStr = [self doRsa:[order description]];
        
        NSLog(@"%@",signedStr);
        
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                 [order description], signedStr, @"RSA"];
        
        [AlixLibService payOrder:orderString AndScheme:appScheme seletor:self.result target:self];
    }else{
        [self.previousView.view makeToast:@"已生成订单，请等待收货" duration:2 position:@"center"];
    }
    [self backBtnAction];
}

-(void)paymentResultDelegate:(NSString *)result
{
    NSLog(@"%@",result);
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
            NSString* key = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSA public key"];//签约帐户后获取到的支付宝公钥
			id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            
			if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                //验证签名成功，交易结果无篡改
                [self backBtnAction];
                [self.previousView.view makeToast:@"交易成功" duration:2 position:@"center"];
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
                        [self.previousView.view makeToast:@"无法获取网络资源" duration:2 position:@"center"];
                    });
                }
                @finally {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self backBtnAction];
                        [self.previousView.view makeToast:@"交易失败" duration:2 position:@"center"];
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
                    [self.previousView.view makeToast:@"无法获取网络资源" duration:2 position:@"center"];
                });
            }
            @finally {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self backBtnAction];
                    [self.previousView.view makeToast:@"交易失败" duration:2 position:@"center"];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MCOrderConfirmCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"orderConfirmCell"];
    MCShop* shop = self.data[indexPath.section];
    MCVegetable* vegetable = shop.vegetables[indexPath.row];
    NSMutableDictionary* relation = [[MCVegetableManager getInstance]getRelationshipBetweenProductAndImage];
    NSString* imageName = relation[[[NSString alloc]initWithFormat:@"%d",vegetable.product_id]];
    cell.imageIcon.image = [UIImage imageNamed:imageName];
    cell.nameLabel.text = [[NSString alloc]initWithFormat:@"%@",vegetable.name];
    cell.quantityLabel.text = [[NSString alloc]initWithFormat:@"数量：%d",vegetable.quantity];
    cell.unitLabel.text = [[NSString alloc]initWithFormat:@"单价：%.02f元/%@",vegetable.price,vegetable.unit];
    cell.priceLabel.text = [[NSString alloc]initWithFormat:@"小计：%.02f元",vegetable.price*vegetable.quantity];
    return cell;
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
    return 68;
}

@end
