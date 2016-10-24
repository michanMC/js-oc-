autoConvertOCType(1)
include('CommonDefine.js')
include('MCTableController.js')
include('MCdynamicView.js')




defineClass('MainTabarViewController', {
  viewDidLoad: function() {
        self.super().viewDidLoad();

            
            self.setupViews();
            
            
  },
            

        setupViews:function(){

//            require('JPTableViewController');
         var   home = MCdynamicViewCtl.alloc().init();
            self.setUpChildController_title_imageName_selectedImageName(home, "动态", "最新一元点购首页_03", "101_selected_");
            
            var   chatList = MCTableViewController.alloc().init();
            self.setUpChildController_title_imageName_selectedImageName(chatList, "视频", "最新一元点购首页_16", "106_selected_");

            var   oneYuanBuyView = MCTableViewController.alloc().init();
            self.setUpChildController_title_imageName_selectedImageName(oneYuanBuyView, "一", "最新一元点购首页_08", "最新一元点购首页_05");
            
            var   personal = MCTableViewController.alloc().init();
            self.setUpChildController_title_imageName_selectedImageName(personal, "我的", "最新一元点购首页_13", "110_selected_");
            
            },
            
    setUpChildController_title_imageName_selectedImageName: function(controller, title, image, selectedImage) {
            self.ORIGsetUpChildController_title_imageName_selectedImageName(controller, title, image, selectedImage);

            require('UIImage');
           controller.setTitle(title);

            require('UITabBarItem,UIColor,UIFont,NSAttributedString');
          
            
            var UIControlEventTouchUpInside  = 1 << 0;

            controller.tabBarItem().setImage(UIImage.imageNamed(image).imageWithRenderingMode(UIControlEventTouchUpInside));
            
            controller.tabBarItem().setSelectedImage(UIImage.imageNamed(selectedImage).imageWithRenderingMode(UIControlEventTouchUpInside));
            
            require('UINavigationController');
         var  selfnav = UINavigationController.alloc().initWithRootViewController(controller);
            
            self.addChildViewController(selfnav);
    }
            
            
            
            
})

