global.Main_Screen_Width = require('UIScreen').mainScreen().bounds().width;
global.Main_Screen_Height = require('UIScreen').mainScreen().bounds().height;

global.MCWidthScale = Main_Screen_Width/320.00000;

global.MCHeightScale = Main_Screen_Height/568;



global.ViewRadius = {
Radius: function(View,Radius) {
    View.layer().setCornerRadius(Radius);
    View.layer().setMasksToBounds(true);
},
Border: function(View,Width,Color) {
    View.layer().setBorderWidth(Width);
    View.layer().setBorderColor(Color.CGColor());
}
 
},

global.MCUIDevice = {
    
IOS7:function(){
    require('UIDevice');
    
    if(UIDevice.currentDevice().systemVersion().floatValue() >= 7.0){
        return true;
    }
    else
    {
        return false;
    }
}
},


global.UIHelper = {
  bottomY: function(view) {
    var f = view.frame();
    return f.height + f.y;
  },
  rightX: function(view) {
    var f = view.frame();
    return f.width + f.x;
  },
  setWidth: function(view, width) {
    var f = view.frame();
    f.width = width
    view.setFrame(f)	
  },
  setHeight: function(view, height) {
    var f = view.frame();
    f.height = height
    view.setFrame(f)	
  },
  setX: function(view, x) {
    var f = view.frame();
    f.x = x
    view.setFrame(f)	
  },
  setY: function(view, y) {
    var f = view.frame();
    f.y = y
    view.setFrame(f)	
  }
}
