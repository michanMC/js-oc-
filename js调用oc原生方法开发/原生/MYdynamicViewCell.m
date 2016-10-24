//
//  MYdynamicViewCell.m
//  用于JSPatch编写与转换
//
//  Created by MC on 16/10/21.
//  Copyright © 2016年 MC. All rights reserved.
//

#import "MYdynamicViewCell.h"
#import "UIImageView+WebCache.h"
@implementation MYdynamicViewCell

-(void)prepareUI1{
    for (UIView * view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    UIScrollView * sr = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Width/4)];
    [self.contentView addSubview:sr];
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = Main_Screen_Width/4;
    
    CGFloat h = w;
//    for (NSInteger i = 0; i < _model.columnsArray.count; i++) {
//        columnsModel*model = _model.columnsArray[i];
//    }
//    NSLog(@"_model == %@",_model.c);
    for (columnsModel*model in _model.columnsArray) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(x, y, w, h)];
        view.backgroundColor = [UIColor whiteColor];
        
        UIImageView * imgview = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, h - 40 , h - 40)];
        [imgview sd_setImageWithURL:[NSURL URLWithString:model.thumbnail] placeholderImage:[UIImage imageNamed:@"1.jpg"]];
        ViewRadius(imgview, (h-40)/2);
        [view addSubview:imgview];
        UILabel * lbl = [[UILabel alloc]initWithFrame:CGRectMake(5, h - 25, w - 10, 20)];
        lbl.text = model.title;
//        lbl.backgroundColor = [UIColor redColor];
        lbl.textColor = [UIColor blackColor];
        lbl.font = [UIFont systemFontOfSize:12];
        lbl.textAlignment = NSTextAlignmentCenter;
        [view addSubview:lbl];
        [sr addSubview:view];
        x += w;
        
        
    }
    
    

    
    
}
-(void)prepareUI2{
    for (UIView * view in self.contentView.subviews) {
        [view removeFromSuperview];
    }

    
    
}
    
    
- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
    
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
