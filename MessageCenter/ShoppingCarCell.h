//
//  MessageCell.h
//  MessageCenter
//
//  Created by Dante on 14/12/29.
//  Copyright (c) 2014年 Dante. All rights reserved.
//
#import "UICellButton.h"
#import <UIKit/UIKit.h>

/*-------------------------代理----------------------------------*/
@protocol ShoppingCarCellDelegate <NSObject>

//选中按钮点击
-(void)carSelectButtonClicked:(NSDictionary *)item WithSectionIndexPath:(NSInteger)section WithIndexPath:(NSInteger)row;
//非选中
-(void)carDeSelectButtonClicked:(NSDictionary *)item WithSectionIndexPath:(NSInteger)section WithIndexPath:(NSInteger)row;

@end
/*-------------------------代理----------------------------------*/

@interface ShoppingCarCell : UITableViewCell

@property (nonatomic,assign) id<ShoppingCarCellDelegate> delegate;
@property (nonatomic,strong) NSMutableDictionary     *itemData;
@property (nonatomic,strong) UICellButton    *selectButton;

- (void)reloadData;
+ (float)cellHeight;

@end
