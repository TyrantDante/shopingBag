//
//  ShoppingHeaderView.h
//  MessageCenter
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 Dante. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICellButton.h"
@protocol ShoppingHeaderViewDelegate <NSObject>

//选中按钮点击
-(void)carSelectButtonClicked:(NSDictionary *)item WithIndexPathSection:(NSInteger)section WithIndexPathRow:(NSInteger)row;
//非选中

-(void)carDeSelectButtonClicked:(NSDictionary *)item WithIndexPathSection:(NSInteger)section WithIndexPathRow:(NSInteger)row;

@end


@interface ShoppingHeaderView : UITableViewHeaderFooterView
@property (nonatomic,assign) id<ShoppingHeaderViewDelegate> delegate;
@property (nonatomic,strong) UILabel     *titleLable;
@property (nonatomic,strong) UICellButton    *selectButton;
@property (nonatomic,strong) NSMutableDictionary     *sectionData;
- (void)reloadData;
@end
