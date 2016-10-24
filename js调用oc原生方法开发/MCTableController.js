


defineClass('MCTableViewController : BaseViewController <UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>', ['data','tableView'], {
            
            viewDidLoad: function() {
            self.ORIGviewDidLoad();
            //           self.super().viewDidLoad();
            self.dataSource();
            var view = self.view();
            require('UIColor');
            view.setBackgroundColor(UIColor.groupTableViewBackgroundColor());
            
            require('UIButton,UIColor');
            
            require('UITableView');
            tableView = UITableView.alloc().initWithFrame({x:0, y:64,width:Main_Screen_Width,height: Main_Screen_Height-64-49});
            //            tableView.setBackgroundColor(UIColor.redColor());
            tableView.setDelegate(self);
            tableView.setDataSource(self);
            view.addSubview(tableView);
            tableView.setTableHeaderView(self.headView());//tableView头
            
            // MJRefresh
            require('MJRefreshNormalHeader');
            tableView.setMj__header(MJRefreshNormalHeader.headerWithRefreshingTarget_refreshingAction(self, "RefreshHeader"));
            require('MJRefreshBackStateFooter');
            tableView.setMj__footer(MJRefreshBackStateFooter.footerWithRefreshingTarget_refreshingAction(self, "RefreshFooter"));
            
            
            },
            RefreshHeader:function(){
            tableView.mj__header().endRefreshing();
            
            },
            RefreshFooter:function(){
            
            tableView.mj__footer().endRefreshing();
            },
            
            headView:function(){
            require('UIView','UIColor','CGColor');
            var view = UIView.alloc().initWithFrame({x:0,y:0,width:Main_Screen_Width,height:MCHeightScale*100});
            view.setBackgroundColor(UIColor.redColor());
            var view2 = UIView.alloc().initWithFrame({x:10,y:10,width:Main_Screen_Width - 20,height:MCHeightScale*100 - 20});
            view2.setBackgroundColor(UIColor.blueColor());
            view.addSubview(view2);
            
            ViewRadius.Radius(view2,10);
            ViewRadius.Border(view2,1,UIColor.whiteColor());
            
            return view;
            
            },
            dataSource: function() {
            var data = self.data();
            if (data) return data;
            var data = [];
            for (var i = 0; i < 20; i ++) {
            data.push("cell from js " + i);
            }
            self.setData(data)
            
            return data;
            },
            
            numberOfSectionsInTableView: function(tableView) {
            return 1;
            },
            
            tableView_numberOfRowsInSection: function(tableView, section) {
            return self.dataSource().length;
            },
            
            tableView_cellForRowAtIndexPath: function(tableView, indexPath) {
            var cell = tableView.dequeueReusableCellWithIdentifier("cell")
            if (!cell) {
            cell = require('UITableViewCell').alloc().initWithStyle_reuseIdentifier(0, "cell")
            }
            cell.textLabel().setText(self.dataSource()[indexPath.row()])
            return cell
            },
            
            tableView_heightForRowAtIndexPath: function(tableView, indexPath) {
            var counts = self.dataSource().length;
            if (counts > 5){
            return 44
            
            }
            return 60
            },
            
            tableView_didSelectRowAtIndexPath: function(tableView, indexPath) {
            var alertView = require('UIAlertView').alloc().initWithTitle_message_delegate_cancelButtonTitle_otherButtonTitles("Alert",self.dataSource()[indexPath.row()], self, "OK",  null);
            alertView.show()
            },
            alertView_willDismissWithButtonIndex: function(alertView, idx) {
            
            console.log('click btn ' + alertView.buttonTitleAtIndex(idx).toJS())
            }
            })
