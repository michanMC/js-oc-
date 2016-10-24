//
//  AppConfig.h
//  StarGroups
//
//  Created by fenguo on 15-1-19.
//  Copyright (c) 2015年 fenguo. All rights reserved.
//

#ifndef StarGroups_AppConfig_h
#define StarGroups_AppConfig_h
typedef NS_OPTIONS(NSUInteger, HYHidenControlOptions) {
    
    HYHidenControlOptionLeft = 0x01,
    HYHidenControlOptionTitle = 0x01 << 1,
    HYHidenControlOptionRight = 0x01 << 2,
    
};

#define APP_KEY       @"ziji-iphone"
#define SECRECT_KEY   @"TTJjfewEOFLNVAF5F8ff"
#define IMEI          @"127SN4324uf343f3420"

#define EMAPP_KEY     @"ifenguo#fenguoim"
#define ClietnID      @"YXA6QyaUIHFYEeSH4P0GQ4RcaQ"
#define ClientSecret  @"YXA6_d-S3QvuSWqBB-8rW5j8MAhWbis"


// production - hangzhou
#define GTAppId           @"51m8pP34KQ8cuFqB1QwWG2"
#define GTAppKey          @"Yfe40qf3Va5waZkzYiPSa8"
#define GTAppSecret       @"rATNHpy7bq9raABdQJ3UxA"
//#import "EaseUI.h"
//#import "DataSigner.h"

//#import "UITableView+backgroundColor.h"
//RGBCOLOR(232, 48, 17)
//#define AppCOLOR      RGBACOLOR(255, 68, 76, 1);
#define AppCOLOR      RGBCOLOR(207, 0, 51);//RGBCOLOR(232, 48, 17);
#define AppRegTextCOLOR      RGBCOLOR(207, 0, 51);

#define AppTextCOLOR      RGBCOLOR(127, 125, 147);
#define AppFont     [UIFont systemFontOfSize:14]
#define AppBgCOLOR      RGBACOLOR(240, 240, 240, 1);

#define AppMCBgCOLOR    kUIColorFromRGB(0xf0f3f4);// RGBCOLOR(240, 243, 244);//
#define ApphomeBgCOLOR     RGBCOLOR(240, 243, 244);

#define AppVersions @"v1.0.0";



//http://112.74.207.224:9001/api
#endif
