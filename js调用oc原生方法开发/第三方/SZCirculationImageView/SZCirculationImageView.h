//
//  SZCirculationImageView.h
//  SZCirculationImage
//
//  Created by 吴三忠 on 16/4/22.
//  Copyright © 2016年 吴三忠. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PlaceOfTitleView){
    kPlaceTopOfView = 1,
    kPlaceBottomOfView
};

typedef NS_ENUM(NSInteger, SZTitleViewStatus){
    
    SZTitleViewBottomOnlyPageControl = 0,
    SZTitleViewBottomOnlyTitle,
    SZTitleViewBottomPageControlAndTitle,
    SZTitleViewBottomPageTitleAndControl,
    SZTitleViewTopOnlyTitle,
    SZTitleViewTopOnlyPageControl,
    SZTitleViewTopPageControlAndTitle,
    SZTitleViewTopPageTitleAndControl,
};

@interface SZCirculationImageView : UIView

/**
 *  图片填充模式
 */
@property (nonatomic, assign) UIViewContentMode imageContentMode;

/**
 *  是否隐藏页面控件，默认为 NO
 */
@property (nonatomic, assign) BOOL hiddenTitleView;

/**
 *  页面控件位置，默认是底部显示pagecontrol
 */
@property (nonatomic, assign) SZTitleViewStatus titleViewStatus;

/**
 *  页面控件未选时颜色，默认为灰色
 */
@property (nonatomic, strong) UIColor *defaultPageColor;

/**
 *  页面控件选中时颜色，默认为红色
 */
@property (nonatomic, strong) UIColor *currentPageColor;

/**
 *  停顿时间, 默认 3s
 */
@property (nonatomic, assign) float pauseTime;

/**
 *  标题的对齐方式
 */
@property (nonatomic, assign) NSTextAlignment titleAlignment;

/**
 *  标题颜色
 */
@property (nonatomic, strong) UIColor *titleColor;


/**
 *  初始化
 *
 *  @param frame
 *  @param array 图片名数组
 *  @param placeImage 加载失败时占位图
 *  @param titles 标题数组
 *
 *  @return
 */
- (instancetype)initWithFrame:(CGRect)frame andImageNamesArray:(NSArray *)array andPlaceImage:(UIImage *)placeImage andTitles:(NSArray *)titles;
- (instancetype)initWithFrame:(CGRect)frame andImageNamesArray:(NSArray *)array;
- (instancetype)initWithFrame:(CGRect)frame andImageNamesArray:(NSArray *)array andTitles:(NSArray *)titles;
- (instancetype)initWithFrame:(CGRect)frame andImageNamesArray:(NSArray *)array andPlaceImage:(UIImage *)placeImage;

/**
 *  初始化
 *
 *  @param frame frame
 *  @param array 图片地址数组
 *  @param placeImage 加载失败时占位图
 *  @param titles 标题数组
 *
 *  @return
 */
- (instancetype)initWithFrame:(CGRect)frame andImageURLsArray:(NSArray *)array andPlaceImage:(UIImage *)placeImage andTitles:(NSArray *)titles;
- (instancetype)initWithFrame:(CGRect)frame andImageURLsArray:(NSArray *)array;
- (instancetype)initWithFrame:(CGRect)frame andImageURLsArray:(NSArray *)array andTitles:(NSArray *)titles;
- (instancetype)initWithFrame:(CGRect)frame andImageURLsArray:(NSArray *)array andPlaceImage:(UIImage *)placeImage;

@end
