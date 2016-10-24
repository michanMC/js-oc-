//
//  MainTabarViewController.m
//  用于JSPatch编写与转换
//
//  Created by MC on 16/10/18.
//  Copyright © 2016年 MC. All rights reserved.
//

#import "MainTabarViewController.h"

@interface MainTabarViewController ()

@end

@implementation MainTabarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)setUpChildController:(UIViewController *)controller title:(NSString *)title imageName:(NSString *)image selectedImageName:(NSString *)selectedImage
{
    
    //设置未选中字体颜色 自定义
    [[UITabBarItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor:RGBACOLOR(122, 122, 123, 1),UITextAttributeFont:[UIFont systemFontOfSize:13]} forState:UIControlStateNormal];
    //设置选中字体颜色 自定义
    [[UITabBarItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor:RGBACOLOR(227, 70, 44, 1),UITextAttributeFont:[UIFont systemFontOfSize:13]} forState:UIControlStateSelected];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
