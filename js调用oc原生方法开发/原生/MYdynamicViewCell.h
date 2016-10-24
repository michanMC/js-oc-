//
//  MYdynamicViewCell.h
//  用于JSPatch编写与转换
//
//  Created by MC on 16/10/21.
//  Copyright © 2016年 MC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "homeModel.h"

@interface MYdynamicViewCell : UITableViewCell

@property(nonatomic)homeModel * model;
-(void)prepareUI1;
-(void)prepareUI2;
//-(void)prepareUI1;
//-(void)prepareUI1;



@end
