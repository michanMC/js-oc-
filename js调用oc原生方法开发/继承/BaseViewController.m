//
//  BaseViewController.m
//  用于JSPatch编写与转换
//
//  Created by MC on 16/10/18.
//  Copyright © 2016年 MC. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _requestManager = [MCNetworkManager instanceManager];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIColor blackColor], NSForegroundColorAttributeName,
                                                                     [UIFont fontWithName:@"CourierNewPSMT" size:20.0], NSFontAttributeName,
                                                                     nil]];
    self.navigationController.navigationBar.barTintColor =    [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];//RGBCOLOR(127, 125, 147);
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    // Do any additional setup after loading the view.
}
- (void)showLoading
{
    [self showHudInView:self.view hint:nil];
}
-(void)stopshowLoading{
    [self hideHud];
    
}
- (void)showAllTextDialog:(NSString *)title
{
    [self showHint:title];
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
