//
//  ShoppingViewController.m
//  MessageCenter
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 小怪兽. All rights reserved.
//

#import "ShoppingViewController.h"
#import "ShoppingCarCell.h"
#import "ShoppingHeaderView.h"
#import "ShoppingFooterView.h"

@interface ShoppingViewController ()
<UITableViewDelegate,UITableViewDataSource,ShoppingCarCellDelegate,ShoppingHeaderViewDelegate>
@property (nonatomic,strong) NSMutableArray *rowArray;

@property (nonatomic,strong) UITableView    *table;
@property (nonatomic,strong) UICellButton       *allSelectButton;
@property (nonatomic,strong) UILabel        *totalPriceLabel;
@property (nonatomic,strong)NSMutableArray *listArray;
@property (nonatomic,assign) CGFloat totalPrice;
@end

@implementation ShoppingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"购物车";
    
    _listArray = [NSMutableArray array];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"shopping_json"
                                                     ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:nil];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *sectionDictionary = [dictionary objectForKey:@"data"];
    NSArray *dataArray = [sectionDictionary objectForKey:@"list"];
    for (NSDictionary *dict in dataArray) {
        [dict setValue:@"0" forKey:@"is_Sected"];
        [dict setValue:@"0.00" forKey:@"price"];
        [dict setValue:@"0" forKey:@"quantity"];
        [_listArray addObject:dict];
    }
    [self creatUI];
}
#pragma mark------创建表
- (void)creatUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, FULL_WIDTH, FULL_HEIGHT - NAVBAR_HEIGHT-BOTTOM_HEIGHT) style:UITableViewStylePlain];
    _table.backgroundColor = [UIColor whiteColor];
    _table.delegate = self;
    _table.dataSource = self;
    _table.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_table];
    
    [self addBottomView];
}
#pragma mark------tableViewDataSource  AND delegete
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dict = _listArray[section];
    NSArray *array = [dict objectForKey:@"cartVoList"];
    return array.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShoppingCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[ShoppingCarCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        //        cell.contentView.backgroundColor = [UIColor redColor];
    }
    NSDictionary *dict = _listArray[indexPath.section];
    NSArray *cellDict = [dict objectForKey:@"cartVoList"];
    cell.itemData = cellDict[indexPath.row];
//    cell.itemData = [_array[indexPath.section] objectAtIndex:indexPath.row];
    
    NSString *isSale = [NSString stringWithFormat:@"%@",[cell.itemData objectForKey:@"isSale"]];
    if ([isSale isEqualToString:@"2"]) {
        cell.selectButton.userInteractionEnabled = NO;
        cell.contentView.alpha = 0.5;
    }
    else
    {
        cell.contentView.alpha = 1.0f;
    }
    cell.selectButton.sectionTag = indexPath.section;
    cell.selectButton.rowTag = indexPath.row;
//    _allSelectButton.sectionTag = indexPath.section;
    [cell reloadData];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (42 * FULL_HEIGHT / 568);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 44.5 * FULL_HEIGHT / 568;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ShoppingCarCell cellHeight];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ShoppingHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
    if (!headerView) {
        headerView = [[ShoppingHeaderView alloc] initWithReuseIdentifier:@"Header"];
    }
//    ShoppingHeaderView *headerView = [[ShoppingHeaderView alloc] initWithFrame:CGRectMake(0, 0, FULL_WIDTH, 42 * FULL_HEIGHT / 568)];
    headerView.sectionData = [_listArray objectAtIndex:section];
    headerView.selectButton.sectionTag = section;
    headerView.delegate = self;
    
    [headerView reloadData];
    headerView.contentView.backgroundColor = [UIColor grayColor];
    return  headerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    ShoppingFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Footer"];
    if (!footerView) {
        footerView =[[ShoppingFooterView alloc] initWithReuseIdentifier:@"Footer"];
    }
    footerView.footerDict = [_listArray objectAtIndex:section];
    [footerView reloadData];
    footerView.contentView.backgroundColor = [UIColor lightGrayColor];
    return footerView;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark------全选按钮
- (void)allSelectAction:(UICellButton *)button
{
    button.selected = !button.selected;
    CGFloat allAmount = 0.00f;
    NSInteger allQuantity = 0;
    for (NSMutableDictionary *sectionDictionary in _listArray) {
        CGFloat sectionAmount = 0.00f;
        NSInteger sectionQuantity = 0;
        __weak NSArray *array =(NSArray *)[sectionDictionary objectForKey:@"cartVoList"];
        for (__weak NSMutableDictionary* dictionCell in array) {
            NSString *isSale = [NSString stringWithFormat:@"%@",[dictionCell objectForKey:@"isSale"]];
            if ([isSale isEqualToString:@"1"]) {
                [dictionCell setObject:[[NSNumber alloc] initWithBool:button.selected?YES:NO] forKey:@"selected"];
                if (button.selected) {
                    CGFloat realPrice = [[dictionCell objectForKey:@"realPrice"] floatValue];
                    NSInteger quantity = [[dictionCell objectForKey:@"quantity"] integerValue];
                    sectionAmount += realPrice * quantity;
                    sectionQuantity += quantity;
                }
                else
                {
                    sectionQuantity = 0;
                    sectionAmount = 0.00f;
                }
            }
            
        }
        [sectionDictionary setValue:[NSString stringWithFormat:@"%.2f",sectionAmount] forKey:@"price"];
        [sectionDictionary setValue:[NSString stringWithFormat:@"%ld",(long)sectionQuantity] forKey:@"quantity"];
        [sectionDictionary setObject:[[NSNumber alloc] initWithBool:button.selected?YES:NO] forKey:@"is_Sected"];
        allAmount += sectionAmount;
        allQuantity += sectionQuantity;
    }
    _totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",allAmount];
    _totalPrice = allAmount;
    [_table reloadData];
}

#pragma mark-----ShoppingHeaderViewDelegate
-(void)carSelectButtonClicked:(NSDictionary *)item WithIndexPathSection:(NSInteger)section WithIndexPathRow:(NSInteger)row
{
    __weak NSMutableDictionary *sectionDict = _listArray[section];
    BOOL sectionSelected = ![[sectionDict objectForKey:@"is_Sected"] boolValue];
    __weak NSArray *cellArray = [sectionDict objectForKey:@"cartVoList"];
    CGFloat sectionAmount = 0.00f;
    NSInteger sectionQuantity = 0;
    for (__weak NSMutableDictionary *cellDict in cellArray) {
        NSString *isSale = [NSString stringWithFormat:@"%@",[cellDict objectForKey:@"isSale"]];
        if ([isSale isEqualToString:@"1"]) {
            [cellDict setObject:[[NSNumber alloc] initWithBool:sectionSelected?YES:NO] forKey:@"selected"];
            if (sectionSelected) {
                CGFloat realPrice = [[cellDict objectForKey:@"realPrice"] floatValue];
                NSInteger quantity = [[cellDict objectForKey:@"quantity"] integerValue];
                sectionAmount += realPrice * quantity;
                sectionQuantity += quantity;
            }
            else
            {
                sectionAmount = 0.00f;
                sectionQuantity = 0;
            }
        }
    }
    CGFloat price = [[sectionDict objectForKey:@"price"] floatValue];
    [sectionDict setValue:[NSString stringWithFormat:@"%.2f",sectionAmount] forKey:@"price"];
    [sectionDict setValue:[NSString stringWithFormat:@"%ld",(long)sectionQuantity] forKey:@"quantity"];
    [sectionDict setObject:[[NSNumber alloc] initWithBool:sectionSelected] forKey: @"is_Sected"];
    _totalPrice += sectionAmount - price;
    _totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",_totalPrice];
    if (sectionSelected) {
        BOOL allSelect = YES;
        for (__weak NSDictionary *sectionDict in _listArray) {
            BOOL sectSelected = [[sectionDict objectForKey:@"is_Sected"] boolValue];
            allSelect = allSelect && sectSelected;
        }
        _allSelectButton.selected = allSelect;
    }
    else
    {
        _allSelectButton.selected = NO;
    }
    [_table reloadData];
}
#pragma mark------ShoppingCarCellDelegate
-(void)carSelectButtonClicked:(NSDictionary *)item WithSectionIndexPath:(NSInteger)section WithIndexPath:(NSInteger)row
{
    __weak NSMutableDictionary *sectionDict = _listArray[section];
    __weak NSArray *cellArray = [sectionDict objectForKey:@"cartVoList"];
    __weak NSMutableDictionary *cellDict = cellArray[row];
    
        BOOL cellSelected = ![[cellDict objectForKey:@"selected"] boolValue];
        [cellDict setObject:[[NSNumber alloc] initWithBool:cellSelected] forKey:@"selected"];
        BOOL sectionSelected = YES;
        CGFloat currentSectionAmount = 0.00f;
        NSInteger currentSectionQuantity = 0;
    
        for (__weak NSMutableDictionary *dictCell in cellArray) {
            NSString *isSale = [NSString stringWithFormat:@"%@",[dictCell objectForKey:@"isSale"]];
            if ([isSale isEqualToString:@"1"]) {
//            NSString *isSale = [cellDict objectForKey:@"isSale"];
            BOOL selectedCell = [[dictCell objectForKey:@"selected"] boolValue];
            sectionSelected = sectionSelected && selectedCell;
            CGFloat realPrice = [[dictCell objectForKey:@"realPrice"] floatValue];
            NSInteger quantity = [[dictCell objectForKey:@"quantity"] integerValue];
            if (selectedCell) {
                currentSectionAmount += realPrice * quantity;
                currentSectionQuantity += quantity;
            }
            }
        }
        CGFloat currentSectionPrice = [[sectionDict objectForKey:@"price"] floatValue];
        [sectionDict setValue:[NSString stringWithFormat:@"%.2f",currentSectionAmount] forKey:@"price"];
        [sectionDict setValue:[NSString stringWithFormat:@"%ld",currentSectionQuantity] forKey:@"quantity"];
        [sectionDict setObject:[[NSNumber alloc] initWithBool:sectionSelected] forKey:@"is_Sected" ];
        _totalPrice += currentSectionAmount - currentSectionPrice;
        _totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",_totalPrice];
        if (sectionSelected) {
            for (NSDictionary *dict in _listArray) {
                BOOL secSelect = [[dict objectForKey:@"is_Sected"] boolValue];
                sectionSelected = sectionSelected && secSelect;
            }
            _allSelectButton.selected = sectionSelected;
        }
        else
        {
            _allSelectButton.selected = NO;
        }
        [_table reloadData];
    
}
#pragma mark------创建底部View
- (void)addBottomView
{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, FULL_HEIGHT-BOTTOM_HEIGHT, FULL_WIDTH, BOTTOM_HEIGHT)];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    
    CALayer *layer = [CALayer layer];
    [layer setFrame:CGRectMake(0, 0, FULL_WIDTH, 0.5)];
    [layer setBackgroundColor:LINE_OR_FRAME_COLOR.CGColor];
    [bottomView.layer addSublayer:layer];
    
    _allSelectButton = [UICellButton buttonWithType:UIButtonTypeCustom];
    _allSelectButton.frame = CGRectMake(0, 10, 80, 30);
    _allSelectButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [_allSelectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_allSelectButton setTitle:@"全选" forState:UIControlStateNormal];
    [_allSelectButton setImage:[UIImage imageNamed:@"trade_choose_default"] forState:UIControlStateNormal];
    [_allSelectButton setImage:[UIImage imageNamed:@"trade_choose_OK"] forState:UIControlStateSelected];
    [_allSelectButton addTarget:self action:@selector(allSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [_allSelectButton setTitleEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 5)];
    [_allSelectButton setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 0)];
    
    
    
    UILabel *tmpTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_allSelectButton.frame.origin.x + _allSelectButton.frame.size.width+5, 10, 42, 30)];
    [tmpTitleLabel setText:@"总计:"];
    [tmpTitleLabel setFont:FONT(17)];
    [tmpTitleLabel setTextColor:[UIColor blackColor]];
    
    
    _totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(tmpTitleLabel.frame.origin.x + tmpTitleLabel.frame.size.width+5, 10, 150, 30)];
    [_totalPriceLabel setText:@"￥0.00"];
    [_totalPriceLabel setFont:FONT(17)];
    
    
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.backgroundColor = RGB(255, 135, 0);
    confirmButton.frame = CGRectMake(FULL_WIDTH - 120, (BOTTOM_HEIGHT - 30)/2, 100, 30);
    [confirmButton setTitle:@"提交" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmButton.layer.cornerRadius = 5;
    
    
    [self.view addSubview:bottomView];
    [bottomView addSubview:_allSelectButton];
    [bottomView addSubview:tmpTitleLabel];
    [bottomView addSubview:_totalPriceLabel];
    [bottomView addSubview:confirmButton];
    
    
}
@end
