//
//  ShoppingViewController.m
//  MessageCenter
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 Dante. All rights reserved.
//

#import "ShoppingViewController.h"
#import "ShoppingCarCell.h"
#import "ShoppingHeaderView.h"
#import "ShoppingFooterView.h"

@interface ShoppingViewController ()
<UITableViewDelegate,UITableViewDataSource,ShoppingCarCellDelegate,ShoppingHeaderViewDelegate>
{
    ShoppingFooterView *_footerView;
}
@property (nonatomic,strong) NSMutableArray *array;
@property (nonatomic,strong) NSMutableArray *rowArray;

@property (nonatomic,strong) UITableView    *table;
@property (nonatomic,strong) UICellButton       *allSelectButton;
@property (nonatomic,strong) UILabel        *totalPriceLabel;
@property (nonatomic,strong)NSMutableArray *listArray;
@property (nonatomic,assign) CGFloat totalPrice;
//@property (nonatomic,assign) NSInteger quantity;
@end

@implementation ShoppingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"购物车";
    
    /*----------------------------假数据------------------------------*/
    _array = [NSMutableArray array];
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
        [_listArray addObject:dict];
        NSArray *cartVoListArray = [dict objectForKey:@"cartVoList"];
        NSMutableDictionary *dataDictionary;
        for (NSDictionary *cartVoListDict in cartVoListArray) {
            _rowArray = [NSMutableArray array];
            dataDictionary = [NSMutableDictionary dictionaryWithDictionary:cartVoListDict];
            [_rowArray addObject:dataDictionary];
        }
       [_array addObject:_rowArray];
    }
    
    /*----------------------------假数据------------------------------*/
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
    return [(NSArray *)[_array objectAtIndex:section]count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _array.count;
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
    cell.itemData = [_array[indexPath.section] objectAtIndex:indexPath.row];
    cell.selectButton.sectionTag = indexPath.section;
    _allSelectButton.rowTag = indexPath.row;
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
    ShoppingHeaderView *_headerView = [[ShoppingHeaderView alloc] initWithFrame:CGRectMake(0, 0, FULL_WIDTH, 42 * FULL_HEIGHT / 568)];
    _headerView.sectionData = [_listArray objectAtIndex:section];
    _headerView.selectButton.sectionTag = section;
    _headerView.delegate = self;
    
    [_headerView reloadData];
    _headerView.backgroundColor = [UIColor grayColor];
    return  _headerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    _footerView = [[ShoppingFooterView alloc] initWithFrame:CGRectMake(0, 0, FULL_WIDTH, 44.5 * FULL_HEIGHT / 568)];
    _footerView.backgroundColor = [UIColor lightGrayColor];
    return _footerView;
}
//删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //del
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
#pragma mark------刷新每个区的总价
-(void)reloadDataSectionWith:(NSInteger)section withRow:(NSInteger)row
{
    if (!section) {
        NSInteger i =0;
        NSInteger j = 0;
        for (NSArray *listArray in _array) {
            j = 0;
            ShoppingHeaderView *headerView = (ShoppingHeaderView*)[_table headerViewForSection:i];
            headerView.selectButton.selected = NO;
            for (__unused NSDictionary *dict in listArray) {
                NSIndexPath *index = [NSIndexPath indexPathForRow:j inSection:i];
                ShoppingCarCell *cell = (ShoppingCarCell *)[_table cellForRowAtIndexPath:index];
                CGFloat price = [[cell.itemData objectForKey:@"realPrice"] floatValue];
                NSInteger quantity = [[cell.itemData objectForKey:@"quantity"] integerValue];
                if (cell.selectButton.selected) {
                    ShoppingFooterView *footerView = (ShoppingFooterView *)[_table footerViewForSection:i];
                    [footerView totalPriceChange:price* -1 withAmount:quantity *-1];
                    cell.selectButton.selected = NO;
                }
                j++;
            }
            i++;
        }
        _totalPriceLabel.text = [NSString stringWithFormat:@"￥0.00"];
        _totalPrice = 0;
        return;
    }
    
    NSInteger i =0;
    NSInteger j = 0;
    CGFloat totalPrice = 0;
    for (NSArray *listArray in _array) {
        j = 0;
        ShoppingHeaderView *headerView = (ShoppingHeaderView*)[_table headerViewForSection:i];
        headerView.selectButton.selected = YES;
        for (__unused NSDictionary *dict in listArray) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:j inSection:i];
            ShoppingCarCell *cell = (ShoppingCarCell *)[_table cellForRowAtIndexPath:index];
            CGFloat price = [[cell.itemData objectForKey:@"realPrice"] floatValue];
            NSInteger quantity = [[cell.itemData objectForKey:@"quantity"] integerValue];
            totalPrice += price*quantity;
            if (!cell.selectButton.selected) {
                ShoppingFooterView *footerView = (ShoppingFooterView *)[_table footerViewForSection:i];
                [footerView totalPriceChange:price withAmount:quantity];
                cell.selectButton.selected = YES;
            }
            j++;
        }
        i++;
    }
    _totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",totalPrice];
    _totalPrice = totalPrice;
}

#pragma mark------全选按钮
- (void)allSelectAction:(UICellButton *)button
{
    button.selected = !button.selected;
//    for (NSMutableDictionary *sectionDictionary in _listArray) {
//            for (NSArray *array in _array) {
//                for (NSMutableDictionary *rowDict in array) {
//                    [rowDict setObject:[[NSNumber alloc] initWithBool:button.selected?YES:NO] forKey:@"selected"];
//                }
//            }
//        [sectionDictionary setObject:[[NSNumber alloc] initWithBool:button.selected?YES:NO] forKey:@"is_Sected"];
//    }
    [self reloadDataSectionWith:button.selected withRow:button.rowTag];
}
#pragma mark-----ShoppingHeaderViewDelegate
-(void)carSelectButtonClicked:(NSDictionary *)item WithIndexPathSection:(NSInteger)section WithIndexPathRow:(NSInteger)row
{
    NSInteger i =0;
    for (__unused id dict in (NSArray *)_array[section]) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:section];
        ShoppingCarCell *cell = (ShoppingCarCell *)[_table cellForRowAtIndexPath:index];
        CGFloat price = [[cell.itemData objectForKey:@"realPrice"] floatValue];
        NSInteger quantity = [[cell.itemData objectForKey:@"quantity"] integerValue];
        if (!cell.selectButton.selected) {
            ShoppingFooterView *footerView = (ShoppingFooterView *)[_table footerViewForSection:section];
            [footerView totalPriceChange:price withAmount:quantity];
            [self changeTotalPrice:price andQuantity:quantity];
            cell.selectButton.selected = YES;
        }
        i++;
    }
    int j = 0;
    for (__unused id listArray in _array) {
        ShoppingHeaderView *headerView  = (ShoppingHeaderView *)[_table headerViewForSection:j];
        _allSelectButton.selected = YES;
        if (!headerView.selectButton.selected) {
            _allSelectButton.selected = NO;
            return;
        }
        j++;
    }
}
-(void)carDeSelectButtonClicked:(NSDictionary *)item WithIndexPathSection:(NSInteger)section WithIndexPathRow:(NSInteger)row
{
    NSInteger i =0;
    for (__unused id dict in (NSArray *)_array[section]) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:section];
        ShoppingCarCell *cell = (ShoppingCarCell *)[_table cellForRowAtIndexPath:index];
        CGFloat price = [[cell.itemData objectForKey:@"realPrice"] floatValue];
        NSInteger quantity = [[cell.itemData objectForKey:@"quantity"] integerValue];
        if (cell.selectButton.selected) {
            ShoppingFooterView *footerView = (ShoppingFooterView *)[_table footerViewForSection:section];
            [footerView totalPriceChange:price * -1 withAmount:quantity * -1];
            [self changeTotalPrice:price *-1 andQuantity:quantity *-1];
            cell.selectButton.selected = NO;
        }
        i++;
    }
    
    _allSelectButton.selected = NO;
}
#pragma mark------ShoppingCarCellDelegate
-(void)carSelectButtonClicked:(NSDictionary *)item WithSectionIndexPath:(NSInteger)section WithIndexPath:(NSInteger)row
{
    //footer refresh
    __weak ShoppingFooterView *view =(ShoppingFooterView *)[_table footerViewForSection:section];
    CGFloat price = [[item objectForKey:@"realPrice"] floatValue];
    NSInteger amount = [[item objectForKey:@"quantity"] integerValue];
    [view totalPriceChange:price withAmount:amount];
    [self changeTotalPrice:price andQuantity:amount];
    int i = 0;
    for (__unused id dict in _array[section]) {
        NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:section];
        i ++;
        ShoppingCarCell *cell = (ShoppingCarCell *)[_table cellForRowAtIndexPath:index];
        __weak ShoppingHeaderView *headerView = (ShoppingHeaderView *)[_table headerViewForSection:section];
        headerView.selectButton.selected = YES;
        _allSelectButton.selected = YES;
        if (!cell.selectButton.selected) {
            headerView.selectButton.selected = NO;
            _allSelectButton.selected = NO;
            return;
        }
    }
    int j = 0;
    for (__unused id listArray in _array) {
        ShoppingHeaderView *headerView  = (ShoppingHeaderView *)[_table headerViewForSection:j];
        _allSelectButton.selected = YES;
        if (!headerView.selectButton.selected) {
            _allSelectButton.selected = NO;
            return;
        }
        j++;
    }
    
}
-(void)carDeSelectButtonClicked:(NSDictionary *)item WithSectionIndexPath:(NSInteger)section WithIndexPath:(NSInteger)row
{
    __weak ShoppingFooterView *view =(ShoppingFooterView *)[_table footerViewForSection:section];
    CGFloat price = [[item objectForKey:@"realPrice"] floatValue];
    NSInteger amount = [[item objectForKey:@"quantity"] integerValue];
    [view totalPriceChange:price * -1 withAmount:amount *-1];
    [self changeTotalPrice:price * -1 andQuantity:amount* -1];
    __weak ShoppingHeaderView *headerView = (ShoppingHeaderView *)[_table headerViewForSection:section];
    headerView.selectButton.selected = NO;
    _allSelectButton.selected = NO;
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
-(void)changeTotalPrice:(CGFloat)price andQuantity:(NSInteger)Quantity
{
    _totalPrice += price *labs(Quantity);
    _totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",_totalPrice];
}
@end
