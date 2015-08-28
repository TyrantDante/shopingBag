//
//  ShoppingFooterView.m
//  MessageCenter
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 Dante. All rights reserved.
//

#import "ShoppingFooterView.h"

@implementation ShoppingFooterView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _numberLabel = [[UILabel alloc]init];
        _numberLabel.text = @"共选择0件";
        /**
         *  WithFrame:CGRectMake(CGRectGetMaxX(_headerImageView.frame) + 10, CGRectGetMinY(_headerImageView.frame), FULL_WIDTH - (CGRectGetMaxX(_headerImageView.frame) + 30), 40)
         */
        _numberLabel.font = FONT(14);
        _numberLabel.numberOfLines = 1;
        _numberLabel.textAlignment = NSTextAlignmentLeft;
        _numberLabel.textColor = [UIColor blackColor];
        
        
        _priceLable = [[UILabel alloc]init];
        /**
         *  WithFrame:CGRectMake(CGRectGetMinX(_titleLable.frame), CGRectGetHeight(_headerImageView.frame) - 20, CGRectGetWidth(_titleLable.frame), 20)
         *
         *  @param 12 <#12 description#>
         *
         *  @return <#return value description#>
         */
        _priceLable.font = FONT(14);
        _priceLable.textAlignment = NSTextAlignmentLeft;
        [_priceLable setText:@"¥ 0.00"];
        _priceLable.textColor = [UIColor redColor];
        [self addSubview:_numberLabel];
        [self addSubview:_priceLable];
    }
    return self;
}
//- (void)reloadData
//{
//    if (self.priceDict) {
//        _priceLable.text = [NSString stringWithFormat:@"¥ %@",[self.priceDict objectForKey:@"price"]];
////        _selectButton.selected = [[self.sectionData objectForKey:@"is_Sected"] boolValue];
//    }
//}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGSize priceSize = [_priceLable.text boundingRectWithSize:CGSizeMake(200, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size;
    
    _priceLable.frame = CGRectMake(FULL_WIDTH - priceSize.width - 10, 0, 100, self.frame.size.height);
    CGSize titleSize = [_numberLabel.text boundingRectWithSize:CGSizeMake(200, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size;
    _numberLabel.frame = CGRectMake(_priceLable.frame.origin.x - titleSize.width - 10, 0, titleSize.width, self.frame.size.height);
}

-(void)totalPriceChange:(CGFloat)price withAmount:(NSInteger)amount
{
    _totalPrice += price *labs(amount) ;
    _productAmount += amount;
    _priceLable.text = [NSString stringWithFormat:@"¥ %f",_totalPrice];
    _numberLabel.text = [NSString stringWithFormat:@"共选择%ld件",_productAmount];
    
}

@end
