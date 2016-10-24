//
//  SZCirculationImageView.m
//  SZCirculationImage
//
//  Created by 吴三忠 on 16/4/22.
//  Copyright © 2016年 吴三忠. All rights reserved.
//

#import "SZCirculationImageView.h"
#import "UIImageView+WebCache.h"

#define W (self.bounds.size.width)
#define H (self.bounds.size.height)

@interface SZCirculationImageView ()<UIScrollViewDelegate>

@property (nonatomic, assign) BOOL          isURL;
@property (nonatomic, assign) NSInteger     index;
@property (nonatomic, strong) NSTimer       *timer;
@property (nonatomic, strong) NSArray       *titleArray;
@property (nonatomic, strong) NSArray       *imagesArray;
@property (nonatomic, strong) UILabel       *titleLbl;
@property (nonatomic, strong) UIView        *titleView;
@property (nonatomic, strong) UIImage       *placeImage;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIImageView   *leftImageView;
@property (nonatomic, strong) UIImageView   *rightImageView;
@property (nonatomic, strong) UIImageView   *centerImageView;
@property (nonatomic, strong) UIScrollView  *imageScrollView;

@end

@implementation SZCirculationImageView

#pragma mark - init

- (instancetype)init {
    
    @throw [NSException exceptionWithName:@"初始化方法" reason:@"请使用 initWithFrame: withImageName(URL)sArray: 初始化" userInfo:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    @throw [NSException exceptionWithName:@"初始化方法" reason:@"请使用 initWithFrame: withImageName(URL)sArray: 初始化" userInfo:nil];
}

- (instancetype)initWithFrame:(CGRect)frame andImageNamesArray:(NSArray *)array {
    
    return [self initWithFrame:frame andImageNamesArray:array andPlaceImage:nil];
}

- (instancetype)initWithFrame:(CGRect)frame andImageNamesArray:(NSArray *)array andPlaceImage:(UIImage *)placeImage {
    
    return [self initWithFrame:frame andImageNamesArray:array andPlaceImage:placeImage andTitles:nil];
}

- (instancetype)initWithFrame:(CGRect)frame andImageNamesArray:(NSArray *)array andTitles:(NSArray *)titles {
    
    return [self initWithFrame:frame andImageNamesArray:array andPlaceImage:nil andTitles:titles];
}

- (instancetype)initWithFrame:(CGRect)frame andImageNamesArray:(NSArray *)array andPlaceImage:(UIImage *)placeImage andTitles:(NSArray *)titles {
    
    NSAssert(array.count > 2, @"图片的数量不能少于3张");
    if (titles != nil || titles.count > 0) {
        NSAssert(array.count == titles.count, @"图片和名称数组数量不对应");
    }
    self = [super initWithFrame:frame];
    if (self) {
        self.index = 0;
        self.isURL = NO;
        self.placeImage = placeImage;
        self.imagesArray = array;
        self.titleArray = titles;
        [self setupLayout];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andImageURLsArray:(NSArray *)array {
    
    return [self initWithFrame:frame andImageURLsArray:array andPlaceImage:nil];
}

- (instancetype)initWithFrame:(CGRect)frame andImageURLsArray:(NSArray *)array andPlaceImage:(UIImage *)placeImage {
    
    return [self initWithFrame:frame andImageURLsArray:array andPlaceImage:placeImage andTitles:nil];
}

- (instancetype)initWithFrame:(CGRect)frame andImageURLsArray:(NSArray *)array andTitles:(NSArray *)titles {
    
    return [self initWithFrame:frame andImageURLsArray:array andPlaceImage:nil andTitles:titles];
}

- (instancetype)initWithFrame:(CGRect)frame andImageURLsArray:(NSArray *)array andPlaceImage:(UIImage *)placeImage andTitles:(NSArray *)titles {
    
    NSAssert(array.count > 2, @"图片的数量不能少于3张");
    if (titles != nil || titles.count > 0) {
        NSAssert(array.count == titles.count, @"图片和名称数组数量不对应");
    }
    self = [super initWithFrame:frame];
    if (self) {
        self.index = 0;
        self.isURL = YES;
        self.placeImage = placeImage;
        self.imagesArray = array;
        self.titleArray = titles;
        [self setupLayout];
    }
    return self;
}

#pragma mark - private method

- (void)setupLayout {
    
    self.leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, W, H)];
    self.centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(W, 0, W, H)];
    self.rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(W * 2, 0, W, H)];
    
    [self setupImage];
    
    [self.imageScrollView addSubview:self.leftImageView];
    [self.imageScrollView addSubview:self.centerImageView];
    [self.imageScrollView addSubview:self.rightImageView];
    
    [self addSubview:self.titleView];
    [self startTimer];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
    [self addGestureRecognizer:tap];
}

- (void)setupImage {
    
    if (self.isURL) {
        [self.centerImageView sd_setImageWithURL:[self pathToURL:self.index] placeholderImage:self.placeImage];
        [self.leftImageView sd_setImageWithURL:[self pathToURL:self.index-1>=0?self.index-1:self.imagesArray.count-1] placeholderImage:self.placeImage];
        [self.rightImageView sd_setImageWithURL:[self pathToURL:self.index+1 <=self.imagesArray.count-1?self.index+1:0] placeholderImage:self.placeImage];
    }
    else {
        self.centerImageView.image
        = [self addImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imagesArray[self.index]]]];
        self.leftImageView.image
        = [self addImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imagesArray[self.index-1>=0?self.index-1:self.imagesArray.count-1]]]];
        self.rightImageView.image
        = [self addImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imagesArray[self.index+1 <=self.imagesArray.count-1?self.index+1:0]]]];
    }
}

- (NSURL *)pathToURL:(NSInteger)integer {
    if (self.imagesArray.count > integer) {
        return [NSURL URLWithString:self.imagesArray[integer]];

    }
    return [[NSURL alloc]init];
}

- (UIImage *)addImage:(UIImage *)image {
    
    if (image == nil) {
        return self.placeImage;
    }
    else {
        return image;
    }
}

- (void)clickImage:(UITapGestureRecognizer *)tap {
    
    [self closeTimer];
    if (tap.state == UIGestureRecognizerStateEnded) {
        [self startTimer];
    }
}

#pragma mark - get

- (float)pauseTime {
    
    return (_pauseTime ? _pauseTime : 3.0);
}

#pragma mark - set

- (void)setImageContentMode:(UIViewContentMode)imageContentMode {
    
    _imageContentMode = imageContentMode;
    self.leftImageView.contentMode = _imageContentMode;
    self.centerImageView.contentMode = _imageContentMode;
    self.rightImageView.contentMode = _imageContentMode;
}

- (void)setHiddenTitleView:(BOOL)hiddenTitleView {
    
    self.titleView.hidden = hiddenTitleView;
}

- (void)setDefaultPageColor:(UIColor *)defaultPageColor {
    
    self.pageControl.pageIndicatorTintColor = defaultPageColor;
}

- (void)setCurrentPageColor:(UIColor *)currentPageColor {
    
    self.pageControl.currentPageIndicatorTintColor = currentPageColor;
}

- (void)setTitleAlignment:(NSTextAlignment)titleAlignment {
    
    _titleAlignment = titleAlignment;
    self.titleLbl.textAlignment = titleAlignment;
}

- (void)setTitleColor:(UIColor *)titleColor {
    
    _titleColor = titleColor;
    self.titleLbl.textColor = titleColor;
}

- (void)setTitleViewStatus:(SZTitleViewStatus)titleViewStatus {
    
    _titleViewStatus = titleViewStatus;
    [self.titleView removeFromSuperview];
    self.titleView = nil;
    [self addSubview:self.titleView];
}

#pragma mark - timer

- (void)startTimer
{
    if(self.timer == nil){
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.pauseTime target:self selector:@selector(timerStart) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:UITrackingRunLoopMode];
    }
}

- (void)closeTimer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)timerStart
{
    self.imageScrollView.contentOffset = CGPointMake(0, 0);
    [self.imageScrollView setContentOffset:CGPointMake(W, 0) animated:YES];
    
    self.index++;
    if (self.index  > self.imagesArray.count-1 ) {
        self.index = 0;
    }
    [self setupImage];
    self.pageControl.currentPage = self.index;
    self.titleLbl.text = self.titleArray.count ? self.titleArray[self.index] : @"";
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self closeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (decelerate == NO) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.x < W/2.0) {
        scrollView.contentOffset = CGPointMake(W, 0);
        self.index--;
        if (self.index < 0) {
            self.index = self.imagesArray.count-1;
        }
        [self setupImage];
    }
    if (scrollView.contentOffset.x > W *1.5) {
        
        scrollView.contentOffset = CGPointMake(W, 0);
        self.index++;
        if (self.index  > self.imagesArray.count-1 ) {
            self.index = 0;
        }
        [self setupImage];
    }
    self.pageControl.currentPage = self.index;
    self.titleLbl.text = self.titleArray.count ? self.titleArray[self.index] : @"";
    [self startTimer];
}


#pragma mark - lazy load

- (UIScrollView *)imageScrollView {
    
    if (_imageScrollView == nil) {
        _imageScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _imageScrollView.showsHorizontalScrollIndicator = NO;
        _imageScrollView.showsVerticalScrollIndicator = NO;
        _imageScrollView.contentOffset = CGPointMake(W, 0);
        _imageScrollView.contentSize = CGSizeMake(W * 3, H);
        _imageScrollView.pagingEnabled = YES;
        _imageScrollView.delegate = self;
        _imageScrollView.bounces = NO;
        [self addSubview:_imageScrollView];
    }
    return _imageScrollView;
}

- (UIView *)titleView {
    
    if (_titleView == nil) {
        
        CGRect prect = CGRectZero;
        CGRect trect = CGRectZero;
        CGRect rect = [self setupPageControlFrame:&prect titleLabelFrame:&trect];
        
        _titleView = [[UIView alloc] initWithFrame:rect];
        [self addSubview:_titleView];
        
        UILabel *mask = [[UILabel alloc] initWithFrame:_titleView.bounds];
        mask.backgroundColor = [UIColor colorWithRed:.8 green:.8 blue:.8 alpha:.3];
        [_titleView addSubview:mask];
        
        if(prect.size.width != 0) {
            self.pageControl = [[UIPageControl alloc] initWithFrame:prect];
            self.pageControl.currentPage = self.index;
            self.pageControl.userInteractionEnabled = NO;
            self.pageControl.numberOfPages = self.imagesArray.count;
            self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
            self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
            [_titleView addSubview:self.pageControl];
        }
        
        self.titleLbl = [[UILabel alloc] initWithFrame:trect];
        self.titleLbl.font = [UIFont systemFontOfSize:14];
        self.titleLbl.text = self.titleArray.count ? self.titleArray[self.index] : @"";
        [_titleView addSubview:self.titleLbl];
    }
    return _titleView;
}

- (CGRect)setupPageControlFrame:(CGRect *)frame titleLabelFrame:(CGRect *)titleFrame {
    
    CGRect rect = CGRectMake(0, H - H * 0.1, W, H * 0.1);
    CGRect prect = CGRectZero;
    CGRect trect = CGRectZero;
    switch (self.titleViewStatus) {
            
        case SZTitleViewBottomOnlyPageControl:
            prect = CGRectMake(0, 0, W, H * 0.1);
            break;
            
        case SZTitleViewBottomOnlyTitle:
            trect = CGRectMake(0, 0, W, H * 0.1);
            break;
            
        case SZTitleViewBottomPageControlAndTitle:
            prect = CGRectMake(0, 0, W * 0.3, H * 0.1);
            trect = CGRectMake(W * 0.3, 0, W * 0.7, H * 0.1);
            break;
            
        case SZTitleViewBottomPageTitleAndControl:
            trect = CGRectMake(0, 0, W * 0.7, H * 0.1);
            prect = CGRectMake(W * 0.7, 0, W * 0.3, H * 0.1);
            break;
            
        case SZTitleViewTopOnlyTitle:
            rect = CGRectMake(0, 0, W, H * 0.1);
            trect = CGRectMake(0, 0, W, H * 0.1);
            break;
            
        case SZTitleViewTopOnlyPageControl:
            rect = CGRectMake(0, 0, W, H * 0.1);
            prect = CGRectMake(0, 0, W, H * 0.1);
            break;
            
        case SZTitleViewTopPageControlAndTitle:
            rect = CGRectMake(0, 0, W, H * 0.1);
            prect = CGRectMake(0, 0, W * 0.3, H * 0.1);
            trect = CGRectMake(W * 0.3, 0, W * 0.7, H * 0.1);
            break;
            
        case SZTitleViewTopPageTitleAndControl:
            rect = CGRectMake(0, 0, W, H * 0.1);
            trect = CGRectMake(0, 0, W * 0.7, H * 0.1);
            prect = CGRectMake(W * 0.7, 0, W * 0.3, H * 0.1);
            break;
            
        default:
            break;
    }
    *frame = prect;
    *titleFrame = trect;
    return rect;
}

- (void)dealloc {
    
    [self closeTimer];
}

@end
