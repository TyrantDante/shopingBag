//
//  UICellButton.h
//  MessageCenter
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 小怪兽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICellButton : UIButton
@property (nonatomic,assign)NSInteger sectionTag;
@property (nonatomic,assign)NSInteger rowTag;
@end
