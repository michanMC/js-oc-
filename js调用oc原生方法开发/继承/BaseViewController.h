//
//  BaseViewController.h
//  用于JSPatch编写与转换
//
//  Created by MC on 16/10/18.
//  Copyright © 2016年 MC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MCNetworkManager;

@interface BaseViewController : UIViewController
@property (nonatomic,strong) MCNetworkManager *requestManager;

- (void)showLoading;
-(void)stopshowLoading;
- (void)showAllTextDialog:(NSString *)title;



@end
