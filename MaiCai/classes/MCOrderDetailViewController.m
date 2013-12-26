//
//  MCOrderDetailViewController.m
//  MaiCai
//
//  Created by Peng Jack on 13-11-27.
//  Copyright (c) 2013年 JoinSoft. All rights reserved.
//

#import "MCOrderDetailViewController.h"
#import "MCAddress.h"
#import "MCOrderDetailHeader.h"
#import "MCOrderConfirmSectionHeader.h"
#import "MCTradeManager.h"
#import "MCContextManager.h"
#import "MCOrder.h"
#import "MCOrderDetailCell.h"
#import "MCVegetable.h"
#import "MCVegetableManager.h"
#import "MCOrderDetailFooter.h"
#import "MBProgressHUD.h"
#import "Toast+UIView.h"
#import "MCUser.h"

#import "DataSigner.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "AlixPayOrder.h"
#import "AlixLibService.h"



@implementation MCOrderDetailViewController

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
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.tableView setShowsHorizontalScrollIndicator:NO];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
    //safd
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            self.order = [[MCTradeManager getInstance]getOrderDetailByOrderId:[[NSString alloc]initWithFormat:@"%d",self.order.id]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //初始化头
                MCOrderDetailHeader* header = [MCOrderDetailHeader initInstance];
                header.nameLabel.text = [[NSString alloc]initWithFormat:@"收货人：%@", self.order.shipper];
                header.mobileLabel.text = [[NSString alloc]initWithFormat:@"联系电话：%@",self.order.tel];
                header.addressLabel.text = [[NSString alloc]initWithFormat:@"地址：%@",self.order.address];
                self.tableView.tableHeaderView = header;
                
                //初始化尾
                MCOrderDetailFooter* footer = [MCOrderDetailFooter initInstance];
                footer.paymentMethodLabel.text = [[NSString alloc]initWithFormat:@"支付方式：%@",self.order.paymentMethod];
                footer.shipMethodLabel.text = [[NSString alloc]initWithFormat:@"配送方式：%@",self.order.shipMethod];
                footer.orderStatusLabel.text = [[NSString alloc]initWithFormat:@"订单状态：%@",self.order.status];self.order.status;
                self.tableView.tableFooterView = footer;
                
                self.totalPriceLabel.text = [[NSString alloc]initWithFormat:@"总价：%.02f元",self.order.total];
                
                if([self.order.status isEqualToString: @"待付款"]) {
                    [self.payBtn setHidden:NO];
                }else{
                    [self.payBtn setHidden:YES];
                }
            });
        }
        @catch (NSException *exception) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view makeToast:@"无法获取网络资源" duration:2 position:@"center"];
            });
        }
        @finally {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            });
        }
    });
}

-(void)viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MCOrderDetailCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"orderDetailCell"];
    MCVegetable* vegetable = self.order.products[indexPath.row];
    cell.nameLabel.text = [[NSString alloc]initWithFormat:@"%@",vegetable.name];
    cell.quantityLabel.text =[[NSString alloc]initWithFormat:@"数量：%d",vegetable.quantity];

    cell.priceLabel.text = [[NSString alloc]initWithFormat:@"单价：%.02f元",vegetable.price];
    cell.totalPriceLabel.text = [[NSString alloc]initWithFormat:@"小计：%.02f元",vegetable.price*vegetable.quantity];
    NSMutableDictionary* relation = [[MCVegetableManager getInstance]getRelationshipBetweenProductAndImage];
    NSString* imageName = relation[[[NSString alloc]initWithFormat:@"%d",vegetable.product_id]];
    [cell.imageIcon setImage:[UIImage imageNamed:imageName]];
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.order.products.count;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MCOrderConfirmSectionHeader* header =  [MCOrderConfirmSectionHeader initInstance];
    header.shopNameLabel.text = self.order.shopName;
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 20)];
    
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:footer.frame];
    imageView.image = [UIImage imageNamed:@"cart_down"];
    [footer addSubview:imageView];
    footer.backgroundColor = [UIColor clearColor];
    return  footer;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}



- (IBAction)payBtnAction:(id)sender {
    NSString* orderIds = [[NSString alloc]initWithFormat:@"%d",self.order.id];
    NSString* userId = ((MCUser*)[[MCContextManager getInstance]getDataByKey:MC_USER]).userId;
    NSString* pay_no = [[MCTradeManager getInstance]getPaymentNoByUserId:userId OrderIds:orderIds Amount:self.order.total];
     [[MCContextManager getInstance]addKey:MC_PAY_NO Data:pay_no];
    NSString *partner = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Partner"];
    NSString *seller = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Seller"];
    NSString* privateKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSA private key"];
    
    NSString *appScheme = @"MaiCaiAlipay";
    
    AlixPayOrder *order = [[AlixPayOrder alloc] init];
    order.partner = partner;
    order.seller = seller;
    
    order.tradeNO = pay_no; //订单ID（由商家自行制定）
    order.productName = [[NSString alloc]initWithFormat:@"总共需要花费%.2f元",self.order.total]; //商品标题
    order.productDescription = @"商品描述"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",self.order.total]; //商品价格
    order.notifyURL =  [@"http://star-faith.com:8083/maicai/api/ios/v1/public/alipay/notify.do" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; //回调URL
    NSString* signedStr = [self doRsa:[order description]];
    
    NSLog(@"%@",signedStr);
    
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                             [order description], signedStr, @"RSA"];
    
    [AlixLibService payOrder:orderString AndScheme:appScheme seletor:@selector(paymentResult:) target:self];
    
}

-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner([[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSA private key"]);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
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
                [self.view makeToast:@"交易成功" duration:2 position:@"center"];
			}
        }
        else
        {
            //交易失败
        }
    }
    else
    {
        //失败
    }
}


@end
