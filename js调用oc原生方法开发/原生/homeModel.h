//
//  homeModel.h
//  用于JSPatch编写与转换
//
//  Created by MC on 16/10/18.
//  Copyright © 2016年 MC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface sliderModel : NSObject

@property(nonatomic,copy)NSString * cover;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * articleType;
@property(nonatomic,copy)NSString * extra;



@end

@interface columnsModel : NSObject
@property(nonatomic,copy)NSString * thumbnail;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * dataId;





@end
@interface listModel : NSObject


@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * createTime;
@property(nonatomic,copy)NSString * updateTime;
@property(nonatomic,copy)NSString * dataId;
@property(nonatomic,copy)NSString * extra;
@property(nonatomic,copy)NSString * articleType;
@property(nonatomic,copy)NSString * styleType;
@property(nonatomic,copy)NSString * tagName;
@property(nonatomic,copy)NSString * tagColor;
@property(nonatomic,copy)NSString * excerpt;
@property(nonatomic,copy)NSString * thumbnail;



@end


@interface homeModel : NSObject

@property(nonatomic,strong)NSMutableArray * sliderArray;
@property(nonatomic,strong)NSMutableArray * columnsArray;
@property(nonatomic,strong)NSMutableArray * listArray;

    
@property(nonatomic,strong)NSMutableArray * thumbnailArray;
@property(nonatomic,strong)NSMutableArray * titleArray;

    
    
    
-(void)addSliderArray:(NSDictionary*)dic;
-(void)addcolumnsArray:(NSDictionary*)dic;
-(void)addlistArray:(NSDictionary*)dic;

@property(nonatomic,copy)NSString* resultDic;
@property(nonatomic,strong)NSArray * columnsModel;

@end
