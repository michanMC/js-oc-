
autoConvertOCType(1);

include('CommonDefine.js')
include('MCdynamicViewCell.js')


defineClass('MCdynamicViewCtl : BaseViewController <UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>', ['tableView','home_Model','ImgArray','Imgtitle'], {
            
            viewDidLoad: function() {
            self.ORIGviewDidLoad();
            require('NSMutableArray');
            dataArray = NSMutableArray.array();
            require('homeModel');
            home_Model = homeModel.alloc().init();

            self.loadData();
            self.prepareUI();

            
            },
            prepareUI:function(){
            require('UITableView');
            tableView = UITableView.alloc().initWithFrame_style({x:0, y:64,width:Main_Screen_Width,height: Main_Screen_Height-64-49} ,1);
            //            tableView.setBackgroundColor(UIColor.redColor());
            tableView.setDelegate(self);
            tableView.setDataSource(self);
            self.view().addSubview(tableView);

            
            },
            headView:function(){
            require('UIView','UIColor','CGColor');
            var view = UIView.alloc().initWithFrame({x:0,y:0,width:Main_Screen_Width,height:MCHeightScale*170});
            var pathArray =  home_Model.thumbnailArray();
            require('SZCirculationImageView,UIColor');
            var titles = home_Model.titleArray();
            var imageView2 = SZCirculationImageView.alloc().initWithFrame_andImageURLsArray_andTitles({x:0,y: 0,width:Main_Screen_Width, height:MCHeightScale*170}, pathArray, titles);
            imageView2.setTitleViewStatus(1);
            imageView2.setTitleAlignment(1);
            imageView2.setTitleColor(UIColor.purpleColor());
            imageView2.setPauseTime(5.0);
            view.addSubview(imageView2);

//
            return view;
            
            },

            loadData:function(){
            self.showLoading();

            var dic = {
            "catId": "1",
            "itemDate": "0",
            "itemId": "0",
            "pageSize": "15",
            "type": "0"
            };
            var weakSelf = __weak(self)
            require('MCNetworkManager');
            self.requestManager().getWithUrl_refreshCache_params_success_fail("home/content", false, dic, block('id', function(resultDic) {
                                                                                                                
                                                                                                                weakSelf.preareData(resultDic);
                                                                                                                
                                                                                                                
                                                                                                                }), block('NSURLSessionDataTask*,NSError*,NSString*', function(operation, error, description) {
                                                                                                                          
                                                                                                                          self.stopshowLoading();
                                                                                                                          
                                                                                                                          }));
            
            
            },
            preareData:function(resultDic){
            self.stopshowLoading();
            self.setTitle("电竞头条");

            require('homeModel');
            var dic = require('NSMutableDictionary').dictionaryWithDictionary(resultDic);
//            homeModel.alloc().init().setResultDic(dic['data']);

          var dic2 = dic['data'];
            var sliderArray = dic2['slider'];
            var columnsArray = dic2['columns'];
            var listArray = dic2['list'];
            var counts = sliderArray.length;

            for (var i = 0; i < counts; i ++) {
            
            var dic3 =sliderArray[i];
            home_Model.addSliderArray(dic3);
            
            }
            var count_c = columnsArray.length;

            for (var i = 0; i < count_c;i++){
                        var dic =columnsArray[i];
                        home_Model.addcolumnsArray(dic);
            
                        }

            var count_l = listArray.length;

            for (var i = 0; i < count_l;i++){
                        var dic =listArray[i];
                        home_Model.addlistArray(dic);
                        
                }
            
            
            
            var count_i= home_Model.thumbnailArray().length;
            if(count_i){
            tableView.setTableHeaderView(self.headView());//tableView头
            }
            tableView.reloadData();
            
            },
            
            numberOfSectionsInTableView: function(tableView) {
            return 10;
            },
            
            tableView_numberOfRowsInSection: function(tableView, section) {
            return 1;
            },
            tableView_heightForFooterInSection: function(tableView, section) {
            return 10;
            }, tableView_heightForHeaderInSection: function(tableView, section) {
            return 0.001;
            },
            tableView_cellForRowAtIndexPath: function(tableView, indexPath) {
            var cell = tableView.dequeueReusableCellWithIdentifier("cell")

            if(indexPath.section() == 0){
            var cell1 = tableView.dequeueReusableCellWithIdentifier("cell1")

            if (!cell1) {
            cell1 = require('MYdynamicViewCell').alloc().initWithStyle_reuseIdentifier(0, "cell1",)
            }
            cell1.setModel(home_Model);
//            cell1.setModel(home_Model);
           cell1.prepareUI1()
            if(!cell1){
            return require('UITableViewCell').alloc().init()
            }

        return cell1;

            
            }
            else{

            if (!cell) {
            cell = require('UITableViewCell').alloc().initWithStyle_reuseIdentifier(0, "cell")
            }
            if(indexPath.section() == 0){
            cell.textLabel().setText("14")

            }
            else{
            cell.textLabel().setText("13")
            }
            }
            if(!cell){
           return require('UITableViewCell').alloc().init()
            }
            return cell
            
            
            
            
            },
            
            tableView_heightForRowAtIndexPath: function(tableView, indexPath) {
            var counts = self.dataSource().length;
            if(indexPath.section() == 0){
            var w = Main_Screen_Width / 4;
            var h = w;
                        return h
            }
            return 44;
            },


            
            
            
})

