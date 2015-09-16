//
//  MessageCell.m
//  MessageCenter
//
//  Created by 小怪兽 on 14/12/29.
//  Copyright (c) 2014年 小怪兽. All rights reserved.
//
//死数据
#define BD_SHOPPING_CAR_CELL_HEIGHT 70.F

#import "ShoppingCarCell.h"
#import "UIImageView+WebCache.h"


@interface ShoppingCarCell()

@property (nonatomic,strong) UIImageView *headerImageView;
@property (nonatomic,strong) UILabel     *titleLable;
@property (nonatomic,strong) UILabel     *priceLable;

@end


@implementation ShoppingCarCell




- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _selectButton = [UICellButton buttonWithType:UIButtonTypeCustom];
        _selectButton.frame = CGRectMake(3, 17, 35, 35);
        _selectButton.showsTouchWhenHighlighted = YES;
        [_selectButton setImage:[UIImage imageNamed:@"trade_choose_default"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"trade_choose_OK"] forState:UIControlStateSelected];
        [_selectButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 5, 60, 60)];
        [_headerImageView setContentMode:UIViewContentModeScaleAspectFill];
        _headerImageView.image = [UIImage imageNamed:@"u14_normal"];
        
        
        
        _titleLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_headerImageView.frame) + 10, CGRectGetMinY(_headerImageView.frame), FULL_WIDTH - (CGRectGetMaxX(_headerImageView.frame) + 30), 40)];
        _titleLable.font = FONT(14);
        _titleLable.numberOfLines = 2;
        _titleLable.textAlignment = NSTextAlignmentLeft;
        _titleLable.textColor = [UIColor blackColor];
        
        
        
        
        _priceLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_titleLable.frame), CGRectGetHeight(_headerImageView.frame) - 20, CGRectGetWidth(_titleLable.frame), 20)];
        _priceLable.font = FONT(12);
        _priceLable.textAlignment = NSTextAlignmentLeft;
        _priceLable.textColor = [UIColor lightGrayColor];
        
        [self.contentView addSubview:_selectButton];
        [self.contentView addSubview:_headerImageView];
        [self.contentView addSubview:_titleLable];
        [self.contentView addSubview:_priceLable];
        
        
    }
    return self;
}

- (void)reloadData
{
    if (self.itemData) {
        _selectButton.selected = [[self.itemData objectForKey:@"selected"] boolValue];
        [_headerImageView sd_setImageWithURL:[NSURL URLWithString:[self.itemData objectForKey:@"imagePath"]] placeholderImage:nil];
        _titleLable.text = [self.itemData objectForKey:@"productName"];
        _priceLable.text = [NSString stringWithFormat:@"￥%@ * %@",[self.itemData objectForKey:@"realPrice"],[self.itemData objectForKey:@"quantity"]];
    }
}


- (void)selectAction:(UICellButton *)button
{
    if ([self.delegate respondsToSelector:@selector(carSelectButtonClicked:WithSectionIndexPath:WithIndexPath:)]) {
            [self.delegate carSelectButtonClicked:self.itemData WithSectionIndexPath:button.sectionTag WithIndexPath:button.rowTag];
        }
}

#pragma mark-------这里固定写死值70
+(float)cellHeight
{
    return BD_SHOPPING_CAR_CELL_HEIGHT;
}
- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
