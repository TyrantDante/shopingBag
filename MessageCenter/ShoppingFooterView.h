//
//  ShoppingFooterView.h
//  MessageCenter
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 小怪兽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingFooterView : UITableViewHeaderFooterView
@property (nonatomic,strong) UILabel     *numberLabel;
@property (nonatomic,strong) UILabel     *priceLable;
//@property (nonatomic,strong) NSMutableDictionary     *priceDict;
@property (nonatomic,assign) CGFloat totalPrice;
@property (nonatomic,assign) NSInteger productAmount;
@property (nonatomic,strong)NSDictionary *footerDict;
- (void)reloadData;
-(void)totalPriceChange:(CGFloat)price withAmount:(NSInteger)amount;
@end
