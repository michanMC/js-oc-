//
//  homeModel.m
//  用于JSPatch编写与转换
//
//  Created by MC on 16/10/18.
//  Copyright © 2016年 MC. All rights reserved.
//

#import "homeModel.h"
@implementation sliderModel
@end
@implementation columnsModel
@end@implementation listModel
@end





@implementation homeModel


-(instancetype)init
{
    
    self = [super init];
    if (self) {
        _sliderArray = [NSMutableArray array];
        _columnsArray = [NSMutableArray array];
        _listArray = [NSMutableArray array];

        _thumbnailArray = [NSMutableArray array];
        _titleArray = [NSMutableArray array];

    }
    return self;
    
}
-(void)addSliderArray:(NSDictionary*)dic{
    
    sliderModel * model = [sliderModel mj_objectWithKeyValues:dic];
    [_sliderArray addObject:model];
    NSLog(@"dic ===== %@",dic);
    
    [_thumbnailArray addObject:model.cover];
    [_titleArray addObject:model.title];
    
}
-(void)addcolumnsArray:(NSDictionary*)dic{
    columnsModel * model = [columnsModel mj_objectWithKeyValues:dic];
    [_columnsArray addObject:model];
   


}
-(void)addlistArray:(NSDictionary*)dic{
    listModel * model = [listModel mj_objectWithKeyValues:dic];
    [_listArray addObject:model];

    
}
-(void)setResultDic:(NSString* )resultDic
{
    _resultDic = resultDic;
    
    NSLog(@"_resultDic =====%@",_resultDic);
}
-(void)setStr:(NSArray *)str{
    NSLog(@"_str =====%@",str);

    
    
}

@end
