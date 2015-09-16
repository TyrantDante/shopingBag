//
//  ShoppingHeaderView.m
//  MessageCenter
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 小怪兽. All rights reserved.
//

#import "ShoppingHeaderView.h"

@implementation ShoppingHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _selectButton = [UICellButton buttonWithType:UIButtonTypeCustom];
        _selectButton.frame = CGRectMake(3, 17, 35, 35);
        _selectButton.showsTouchWhenHighlighted = YES;
        [_selectButton setImage:[UIImage imageNamed:@"trade_choose_default"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"trade_choose_OK"] forState:UIControlStateSelected];
        [_selectButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _titleLable = [[UILabel alloc]initWithFrame:CGRectMake(_selectButton.frame.origin.x + _selectButton.frame.size.width + 10, CGRectGetMinY(_selectButton.frame), FULL_WIDTH - (CGRectGetMaxX(_selectButton.frame) + 30), 40)];
        _titleLable.font = FONT(14);
        _titleLable.numberOfLines = 2;
        _titleLable.textAlignment = NSTextAlignmentLeft;
        _titleLable.textColor = [UIColor blackColor];
        [self addSubview:_selectButton];
        [self addSubview:_titleLable];
    }
    return self;
}
- (void)reloadData
{
    if (self.sectionData) {
        _titleLable.text = [self.sectionData objectForKey:@"companyName"];
        _selectButton.selected = [[self.sectionData objectForKey:@"is_Sected"] boolValue];
    }
}
- (void)selectAction:(id)sender
{
    UICellButton *button = (UICellButton *)sender;
    if ([self.delegate respondsToSelector:@selector(carSelectButtonClicked:WithIndexPathSection:WithIndexPathRow:)]) {
        [self.delegate carSelectButtonClicked:self.sectionData WithIndexPathSection:button.sectionTag WithIndexPathRow:button.rowTag];
    }
}
@end
