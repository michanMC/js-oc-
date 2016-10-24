//
//  MCNetworkManager.m
//  MCNetworkManager
//
//  Created by MC on 16/4/14.
//  Copyright © 2016年 MC. All rights reserved.
//
//#define AppURL @"http://snsshop.111.xcrozz.com/Shop/"//#define AppURL应该放在pch文件里的

#import "MCNetworkManager.h"
static NSString * EPHttpApiBaseURL = AppURL;

static MCNetworkManager *_instanceManager = nil;
static NSDictionary *sg_httpHeaders = nil;
static NSMutableArray *sg_requestTasks;

@implementation NSString (md5)

+ (NSString *)hybnetworking_md5:(NSString *)string {
    if (string == nil || [string length] == 0) {
        return nil;
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([string UTF8String], (int)[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02x", (int)(digest[i])];
    }
    
    return [ms copy];
}

@end

@implementation MCNetworkManager
+ (instancetype)instanceManager
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instanceManager = [[MCNetworkManager alloc] init];
        _instanceManager.httpClient = [ExproHttpClient sharedClient];
        
    });
    
    return _instanceManager;
}
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}
- (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders {
    sg_httpHeaders = httpHeaders;
    for (NSString *key in sg_httpHeaders.allKeys) {
        if (sg_httpHeaders[key] != nil) {
            [_instanceManager.httpClient.requestSerializer setValue:sg_httpHeaders[key] forHTTPHeaderField:key];
        }
    }

}
- (void)cancelRequestWithURL:(NSString *)url {
    if (url == nil) {
        return;
    }
    
    @synchronized(self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(MCURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[MCURLSessionTask class]]
                && [task.currentRequest.URL.absoluteString hasSuffix:url]) {
                [task cancel];
                [[self allTasks] removeObject:task];
                return;
            }
        }];
    };
}

- (void)cancelAllRequest {
    @synchronized(self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(MCURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[MCURLSessionTask class]]) {
                [task cancel];
            }
        }];
        
        [[self allTasks] removeAllObjects];
    };
}
- (NSMutableArray *)allTasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sg_requestTasks == nil) {
            sg_requestTasks = [[NSMutableArray alloc] init];
        }
    });
    
    return sg_requestTasks;
}

#pragma mark-GET请求接口

/*!
 *
 *  GET请求接口，若前面不指定baseurl，可传完整的url
 *
 *  @param url     接口路径，如/path/getArticleList
 *  @param refreshCache 是否刷新缓存。由于请求成功也可能没有数据，对于业务失败，只能通过人为手动判断
 *  @param params  接口中所需要的拼接参数，如@{"categoryid" : @(12)}
 *  @param completeBlock 接口成功请求到数据的回调
 *  @param errorBlock    接口请求数据失败的回调
 *
 */

- (void)getWithUrl:(NSString *)url
      refreshCache:(BOOL)refreshCache
           success:(HttpResponseSucBlock)completeBlock
              fail:(HttpResponseErrBlock)errorBlock{
    [MCNetworkManager getWithUrl:url refreshCache:YES success:^(id resultDic) {
        NSDictionary *result_Dic = nil;
        NSError *parserError = nil;

        @try {
            result_Dic = [self datamanage:resultDic];//数据处理，data->dic
        }
        @catch (NSException *exception) {
            [NSException raise:@"网络接口返回数据异常" format:@"Error domain %@\n,code=%ld\n,userinfo=%@",parserError.domain,(long)parserError.code,parserError.userInfo];
            //发出消息错误的通知
        }
        @finally {
            //业务产生的状态码
            NSString *logicCode = [NSString stringWithFormat:@"%ld",[result_Dic[@"status"] integerValue]];
            
            //成功获得数据
            if ([logicCode isEqualToString:@"200000"]) {
                
                completeBlock(result_Dic);
                
            }
            else{
                //业务逻辑错误
                NSString *message = [resultDic objectForKey:@"message"];
                NSError *error = [NSError errorWithDomain:@"服务器业务逻辑错误" code:logicCode.intValue userInfo:nil];
                errorBlock(nil,error,message);
            }
        }

    } fail:^(NSURLSessionDataTask *operation, NSError *error, NSString *description) {
         errorBlock(operation,error,@"数据请求失败");
        
    }];
    
}
/*
 *多一个params参数
 */
- (void )getWithUrl:(NSString *)url
       refreshCache:(BOOL)refreshCache
             params:(NSDictionary *)params
            success:(HttpResponseSucBlock)completeBlock
               fail:(HttpResponseErrBlock)errorBlock{
    
    
    
    [MCNetworkManager getWithUrl:url refreshCache:refreshCache params:params success:^(id resultDic) {
        NSDictionary *result_Dic = nil;
        NSError *parserError = nil;
        
        @try {
            result_Dic = [self datamanage:resultDic];//数据处理，data->dic
            NSLog(@"result_Dic == %@",result_Dic);

        }
        @catch (NSException *exception) {
            [NSException raise:@"网络接口返回数据异常" format:@"Error domain %@\n,code=%ld\n,userinfo=%@",parserError.domain,(long)parserError.code,parserError.userInfo];
            //发出消息错误的通知
        }
        @finally {
            //业务产生的状态码
            NSString *logicCode = [NSString stringWithFormat:@"%ld",[result_Dic[@"code"] integerValue]];
            
            //成功获得数据
            if ([logicCode isEqualToString:@"10000"]) {
                
                
                completeBlock(result_Dic);
                
            }
            else{
                //业务逻辑错误
                NSString *message = [result_Dic objectForKey:@"message"];
                NSError *error = [NSError errorWithDomain:@"服务器业务逻辑错误" code:logicCode.intValue userInfo:nil];
                errorBlock(nil,error,message);
            }
        }

    } fail:^(NSURLSessionDataTask *operation, NSError *error, NSString *description) {
        
        errorBlock(operation,error,@"数据请求失败");

    }];
}

/*
 *带有params参数
 *带进度回调
 */
- (void)getWithUrl:(NSString *)url
      refreshCache:(BOOL)refreshCache
            params:(NSDictionary *)params
          progress:(MCGetProgress)progress
           success:(HttpResponseSucBlock)completeBlock
              fail:(HttpResponseErrBlock)errorBlock{
    [MCNetworkManager getWithUrl:url refreshCache:refreshCache params:params progress:^(int64_t bytesRead, int64_t totalBytesRead) {
        if (progress) {
            progress(bytesRead,totalBytesRead);

        }
        
    } success:^(id resultDic) {
        NSDictionary *result_Dic = nil;
        NSError *parserError = nil;
        
        @try {
            result_Dic = [self datamanage:resultDic];//数据处理，data->dic
        }
        @catch (NSException *exception) {
            [NSException raise:@"网络接口返回数据异常" format:@"Error domain %@\n,code=%ld\n,userinfo=%@",parserError.domain,(long)parserError.code,parserError.userInfo];
            //发出消息错误的通知
        }
        @finally {
            //业务产生的状态码
            NSString *logicCode = [NSString stringWithFormat:@"%ld",[result_Dic[@"status"] integerValue]];
            
            //成功获得数据
            if ([logicCode isEqualToString:@"200000"]) {
                
                completeBlock(result_Dic);
                
            }
            else{
                //业务逻辑错误
                NSString *message = [resultDic objectForKey:@"message"];
                NSError *error = [NSError errorWithDomain:@"服务器业务逻辑错误" code:logicCode.intValue userInfo:nil];
                errorBlock(nil,error,message);
            }
        }
        

    } fail:^(NSURLSessionDataTask *operation, NSError *error, NSString *description) {
        errorBlock(operation,error,@"数据请求失败");

    }];
    
    
    
    
}
+ (MCURLSessionTask *)getWithUrl:(NSString *)url
                    refreshCache:(BOOL)refreshCache
                         success:(HttpResponseSucBlock)completeBlock
                            fail:(HttpResponseErrBlock)errorBlock {
    return [self getWithUrl:url
               refreshCache:refreshCache
                     params:nil
                    success:completeBlock
                       fail:errorBlock];
}
+ (MCURLSessionTask *)getWithUrl:(NSString *)url
                    refreshCache:(BOOL)refreshCache
                          params:(NSDictionary *)params
                         success:(HttpResponseSucBlock)completeBlock
                            fail:(HttpResponseErrBlock)errorBlock {
    return [self getWithUrl:url
               refreshCache:refreshCache
                     params:params
                   progress:nil
                    success:completeBlock
                       fail:errorBlock];
}
+ (MCURLSessionTask *)getWithUrl:(NSString *)url
                    refreshCache:(BOOL)refreshCache
                          params:(NSDictionary *)params
                        progress:(MCGetProgress)progress
                         success:(HttpResponseSucBlock)completeBlock
                            fail:(HttpResponseErrBlock)errorBlock {
    
    return [self _requestWithUrl:url
                    refreshCache:refreshCache
                       httpMedth:1
                          params:params
                        progress:progress
                         success:completeBlock
                            fail:errorBlock];
}

#pragma mark-POST请求接口

/*************************/
/*!
 *
 *  POST请求接口，若不指定baseurl，可传完整的url
 *
 *  @param url     接口路径，如/path/getArticleList
 *  @param params  接口中所需的参数，如@{"categoryid" : @(12)}
 *  @param completeBlock 接口成功请求到数据的回调
 *  @param errorBlock    接口请求数据失败的回调
 *
 */
- (void )postWithUrl:(NSString *)url
        refreshCache:(BOOL)refreshCache
              params:(NSDictionary *)params
             success:(HttpResponseSucBlock)completeBlock
                fail:(HttpResponseErrBlock)errorBlock{
    
    [MCNetworkManager postWithUrl:url refreshCache:refreshCache params:params success:^(id resultDic) {
        NSDictionary *result_Dic = nil;
        NSError *parserError = nil;
        
        @try {
            result_Dic = [self datamanage:resultDic];//数据处理，data->dic
            NSLog(@"result_Dic ==%@",result_Dic);
        }
        @catch (NSException *exception) {
            [NSException raise:@"网络接口返回数据异常" format:@"Error domain %@\n,code=%ld\n,userinfo=%@",parserError.domain,(long)parserError.code,parserError.userInfo];
            //发出消息错误的通知
        }
        @finally {
            //业务产生的状态码
            /*配对好你后台返回来的状态码，要不然拿不到数据或蹦*/
            NSString *logicCode = [NSString stringWithFormat:@"%ld",[result_Dic[@"code"] integerValue]];
            
            //成功获得数据
            if ([logicCode isEqualToString:@"1"]) {
                
                completeBlock(result_Dic);
                
            }
            else{
                //业务逻辑错误
                NSString *message = [result_Dic objectForKey:@"message"];
                NSError *error = [NSError errorWithDomain:@"服务器业务逻辑错误" code:logicCode.intValue userInfo:nil];
                errorBlock(nil,error,message);
            }
        }
        

    } fail:^(NSURLSessionDataTask *operation, NSError *error, NSString *description) {
        errorBlock(operation,error,@"数据请求失败");

    }];
}
/*
 *带进度回调
 */

- ( void)postWithUrl:(NSString *)url
        refreshCache:(BOOL)refreshCache
              params:(NSDictionary *)params
            progress:(MCPostProgress)progress
             success:(HttpResponseSucBlock)completeBlock
                fail:(HttpResponseErrBlock)errorBlock{
    
    [MCNetworkManager postWithUrl:url refreshCache:refreshCache params:params progress:^(int64_t bytesRead, int64_t totalBytesRead) {
        if (progress) {
            progress(bytesRead,totalBytesRead);
            
        }

    } success:^(id resultDic) {
        NSDictionary *result_Dic = nil;
        NSError *parserError = nil;
        
        @try {
            result_Dic = [self datamanage:resultDic];//数据处理，data->dic
            NSLog(@"result_Dic ==%@",result_Dic);
            
        }
        @catch (NSException *exception) {
            [NSException raise:@"网络接口返回数据异常" format:@"Error domain %@\n,code=%ld\n,userinfo=%@",parserError.domain,(long)parserError.code,parserError.userInfo];
            //发出消息错误的通知
        }
        @finally {
            //业务产生的状态码
            /*配对好你后台返回来的状态码，要不然拿不到数据或蹦*/
            NSString *logicCode = [NSString stringWithFormat:@"%ld",[result_Dic[@"code"] integerValue]];
            
            //成功获得数据
            if ([logicCode isEqualToString:@"1"]) {
                
                completeBlock(result_Dic);
                
            }
            else{
                //业务逻辑错误
                NSString *message = [result_Dic objectForKey:@"message"];
                NSError *error = [NSError errorWithDomain:@"服务器业务逻辑错误" code:logicCode.intValue userInfo:nil];
                errorBlock(nil,error,message);
            }
        }
        

    } fail:^(NSURLSessionDataTask *operation, NSError *error, NSString *description) {
        errorBlock(operation,error,@"数据请求失败");

    }];
    
}

+ (MCURLSessionTask *)postWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                           params:(NSDictionary *)params
                          success:(HttpResponseSucBlock)completeBlock
                             fail:(HttpResponseErrBlock)errorBlock {
    return [self postWithUrl:url
                refreshCache:refreshCache
                      params:params
                    progress:nil
                     success:completeBlock
                        fail:errorBlock];
}
+ (MCURLSessionTask *)postWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                           params:(NSDictionary *)params
                         progress:(MCPostProgress)progress
                          success:(HttpResponseSucBlock)completeBlock
                             fail:(HttpResponseErrBlock)errorBlock {
    return [self _requestWithUrl:url
                    refreshCache:refreshCache
                       httpMedth:2
                          params:params
                        progress:progress
                         success:completeBlock
                            fail:errorBlock];
}

#pragma mark-触发请求
+ (MCURLSessionTask *)_requestWithUrl:(NSString *)url
                         refreshCache:(BOOL)refreshCache
                            httpMedth:(NSUInteger)httpMethod
                               params:(NSDictionary *)params
                             progress:(MCDownloadProgress)progress
                              success:(HttpResponseSucBlock)completeBlock
                                 fail:(HttpResponseErrBlock)errorBlock {
    MCURLSessionTask *session = nil;
    NSString *absolute = [self absoluteUrlWithPath:url];
    if (refreshCache) {
        
        id response = [MCNetworkManager cahceResponseWithURL:absolute
                                                  parameters:params];
        
        if (response) {
            if (completeBlock) {
                [self successResponse:response callback:completeBlock];
            }
            
            //return nil;
        }
        
    }
    

    if (httpMethod == 1) {//GET
        
     session = [_instanceManager.httpClient GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
         if (progress) {
             progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
         }
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         if (refreshCache && responseObject) {
             [self cacheResponseObject:responseObject request:task.currentRequest parameters:params];

         }
         completeBlock(responseObject);
         [[_instanceManager allTasks] removeObject:task];

         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

         errorBlock(task,error,@"请求失败");
         [[_instanceManager allTasks] removeObject:task];

     } ];
       
    }
    else if(httpMethod == 2){//POST
        [_instanceManager.httpClient POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            if (progress) {
                progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
            }

        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (refreshCache && responseObject) {
                [self cacheResponseObject:responseObject request:task.currentRequest parameters:params];
                
            }
            completeBlock(responseObject);
            [[_instanceManager allTasks] removeObject:task];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

            errorBlock(task,error,@"请求失败");
            [[_instanceManager allTasks] removeObject:task];

        }];
        
    }
    if (session) {
        [[_instanceManager allTasks] addObject:session];
    }
    return session;
    
}

#pragma mark-图片上传
/**
 *
 *	图片上传接口，若不指定baseurl，可传完整的url
 *
 *	@param image			图片对象
 *	@param url				上传图片的接口路径，如/path/images/
 *	@param filename		给图片起一个名字，默认为当前日期时间,格式为"yyyyMMddHHmmss"，后缀为`jpg`
 *	@param name				与指定的图片相关联的名称，这是由后端写接口的人指定的，如imagefiles
 *	@param mimeType		默认为image/jpeg
 *	@param parameters	参数
 *	@param progress		上传进度
 *	@param completeBlock		上传成功回调
 *	@param errorBlock				上传失败回调
 *
 */
- ( void)uploadWithImage:(UIImage *)image
                     url:(NSString *)url
                filename:(NSString *)filename
                    name:(NSString *)name
                mimeType:(NSString *)mimeType
              parameters:(NSDictionary *)parameters
                progress:(MCUploadProgress)progress
                 success:(HttpResponseSucBlock)completeBlock
                    fail:(HttpResponseErrBlock)errorBlock{
    
    
    
    [MCNetworkManager uploadWithImage:image url:url filename:filename name:name mimeType:mimeType parameters:parameters progress:^(int64_t bytesWritten, int64_t totalBytesWritten) {
        if (progress) {
            progress(bytesWritten,totalBytesWritten);
            
        }

    } success:^(id resultDic) {
        NSDictionary *result_Dic = nil;
        NSError *parserError = nil;
        
        @try {
            result_Dic = [self datamanage:resultDic];//数据处理，data->dic
            NSLog(@"result_Dic ==%@",result_Dic);
        }
        @catch (NSException *exception) {
            [NSException raise:@"网络接口返回数据异常" format:@"Error domain %@\n,code=%ld\n,userinfo=%@",parserError.domain,(long)parserError.code,parserError.userInfo];
            //发出消息错误的通知
        }
        @finally {
            //业务产生的状态码
            /*配对好你后台返回来的状态码，要不然拿不到数据或蹦*/
            NSString *logicCode = [NSString stringWithFormat:@"%ld",[result_Dic[@"code"] integerValue]];
            
            //成功获得数据
            if ([logicCode isEqualToString:@"1"]) {
                
                completeBlock(result_Dic);
                
            }
            else{
                //业务逻辑错误
                NSString *message = [result_Dic objectForKey:@"message"];
                NSError *error = [NSError errorWithDomain:@"服务器业务逻辑错误" code:logicCode.intValue userInfo:nil];
                errorBlock(nil,error,message);
            }
        }
        

    } fail:^(NSURLSessionDataTask *operation, NSError *error, NSString *description) {
        errorBlock(operation,error,@"数据请求失败");

    }];
    
}
+ (MCURLSessionTask *)uploadWithImage:(UIImage *)image
                                  url:(NSString *)url
                             filename:(NSString *)filename
                                 name:(NSString *)name
                             mimeType:(NSString *)mimeType
                           parameters:(NSDictionary *)parameters
                             progress:(MCUploadProgress)progress
                              success:(HttpResponseSucBlock)completeBlock
                                 fail:(HttpResponseErrBlock)errorBlock {
    
    
    MCURLSessionTask *session = nil;
session = [_instanceManager.httpClient POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    NSString *imageFileName = filename;
    if (filename == nil || ![filename isKindOfClass:[NSString class]] || filename.length == 0) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        imageFileName = [NSString stringWithFormat:@"%@.jpg", str];
    }
    
    // 上传图片，以文件流的格式
    [formData appendPartWithFileData:imageData name:name fileName:imageFileName mimeType:mimeType];
    

} progress:^(NSProgress * _Nonnull uploadProgress) {
    if (progress) {
        progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
    }

} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    completeBlock(responseObject);
    [[_instanceManager allTasks] removeObject:task];


} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    errorBlock(task,error,@"请求失败");
    [[_instanceManager allTasks] removeObject:task];


}];
    if (session) {
        [[_instanceManager allTasks] addObject:session];
    }

    return session;

}

#pragma mark-上传文件
- ( void)uploadFileWithUrl:(NSString *)url
             uploadingFile:(NSString *)uploadingFile
                  progress:(MCUploadProgress)progress
                   success:(HttpResponseSucBlock)completeBlock
                      fail:(HttpResponseErrBlock)errorBlock{
    
    [MCNetworkManager uploadFileWithUrl:url uploadingFile:uploadingFile progress:^(int64_t bytesWritten, int64_t totalBytesWritten) {
        if (progress) {
            progress(bytesWritten, totalBytesWritten);
        }

    } success:^(id resultDic) {
        completeBlock(resultDic);

    } fail:^(NSURLSessionDataTask *operation, NSError *error, NSString *description) {
        errorBlock(operation,error,@"请求失败");

    }];
    
    
}
+ (MCURLSessionTask *)uploadFileWithUrl:(NSString *)url
                          uploadingFile:(NSString *)uploadingFile
                               progress:(MCUploadProgress)progress
                                success:(HttpResponseSucBlock)completeBlock
                                   fail:(HttpResponseErrBlock)errorBlock {
    MCURLSessionTask *session = nil;
    NSURL *uploadURL = nil;
    uploadURL = [NSURL URLWithString:url];

    NSURLRequest *request = [NSURLRequest requestWithURL:uploadURL];
    
   session = [_instanceManager.httpClient uploadTaskWithRequest:request fromFile:[NSURL URLWithString:uploadingFile] progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }

    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"responseObject = %@",responseObject);
        NSDictionary *result_Dic = nil;
        NSError *parserError = nil;
        
        @try {
            result_Dic = [_instanceManager datamanage:responseObject];//数据处理，data->dic
            NSLog(@"result_Dic ==%@",result_Dic);
        }
        @catch (NSException *exception) {
            [NSException raise:@"网络接口返回数据异常" format:@"Error domain %@\n,code=%ld\n,userinfo=%@",parserError.domain,(long)parserError.code,parserError.userInfo];
            //发出消息错误的通知
        }
        @finally {
            //业务产生的状态码
            /*配对好你后台返回来的状态码，要不然拿不到数据或蹦*/
            NSString *logicCode = [NSString stringWithFormat:@"%ld",[result_Dic[@"code"] integerValue]];
            
            //成功获得数据
            if ([logicCode isEqualToString:@"1"]) {
                
                completeBlock(result_Dic);
                 [[_instanceManager allTasks] removeObject:session];
                
            }
            else{
                //业务逻辑错误
                NSString *message = [result_Dic objectForKey:@"message"];
                NSError *error = [NSError errorWithDomain:@"服务器业务逻辑错误" code:logicCode.intValue userInfo:nil];
                errorBlock(nil,error,message);
                [[_instanceManager allTasks] removeObject:session];
            }
        }
        
    }];
    if (session) {
        [[_instanceManager allTasks] addObject:session];
    }

    return session;
    
}
#pragma mark-文件下载
- (void)downloadWithUrl:(NSString *)url
             saveToPath:(NSString *)saveToPath
               progress:(MCDownloadProgress)progressBlock
                success:(HttpResponseSucBlock)completeBlock
                failure:(HttpResponseErrBlock)errorBlock{
    
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDownloadTask *downloadTask = [self.httpClient downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressBlock) {
            progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if (error == nil) {
                if (completeBlock) {
                    completeBlock(filePath.absoluteString);
                     [[_instanceManager allTasks] removeObject:downloadTask];
                }
            }
            else
            {
                errorBlock(nil,error,@"失败");
                 [[_instanceManager allTasks] removeObject:downloadTask];
            }

    }];
    [downloadTask resume];
    if (downloadTask) {
        [[_instanceManager allTasks] addObject:downloadTask];
    }

    
}
#pragma mark-数据处理
-(NSDictionary*)datamanage:(id)response{
    NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    NSString *responseString1 =  [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *responseString2 = [responseString1 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    NSString *responseString3 = [responseString2 stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    NSData *jsonData = [responseString3 dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    
    NSDictionary *  resultDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
    return resultDic;
    
}


#pragma mark-缓存数据
/**************缓存数据***********************/

static inline NSString *cachePath() {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/MCNetworkingCaches"];
}
// 仅对一级字典结构起作用
+ (NSString *)generateGETAbsoluteURL:(NSString *)url params:(id)params {
    if (params == nil || ![params isKindOfClass:[NSDictionary class]] || [params count] == 0) {
        return url;
    }
    
    NSString *queries = @"";
    for (NSString *key in params) {
        id value = [params objectForKey:key];
        
        if ([value isKindOfClass:[NSDictionary class]]) {
            continue;
        } else if ([value isKindOfClass:[NSArray class]]) {
            continue;
        } else if ([value isKindOfClass:[NSSet class]]) {
            continue;
        } else {
            queries = [NSString stringWithFormat:@"%@%@=%@&",
                       (queries.length == 0 ? @"&" : queries),
                       key,
                       value];
        }
    }
    
    if (queries.length > 1) {
        queries = [queries substringToIndex:queries.length - 1];
    }
    
    if (([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) && queries.length > 1) {
        if ([url rangeOfString:@"?"].location != NSNotFound
            || [url rangeOfString:@"#"].location != NSNotFound) {
            url = [NSString stringWithFormat:@"%@%@", url, queries];
        } else {
            queries = [queries substringFromIndex:1];
            url = [NSString stringWithFormat:@"%@?%@", url, queries];
        }
    }
    
    return url.length == 0 ? queries : url;
}
+ (NSString *)absoluteUrlWithPath:(NSString *)path {
    if (path == nil || path.length == 0) {
        return @"";
    }
    
    if (EPHttpApiBaseURL == nil || [EPHttpApiBaseURL length] == 0) {
        return path;
    }
    
    NSString *absoluteUrl = path;
    
    if (![path hasPrefix:@"http://"] && ![path hasPrefix:@"https://"]) {
        absoluteUrl = [NSString stringWithFormat:@"%@%@",
                       EPHttpApiBaseURL, path];
    }
    
    return absoluteUrl;
}

+ (id)cahceResponseWithURL:(NSString *)url parameters:params {
    id cacheData = nil;
    
    if (url) {
        // Try to get datas from disk
        NSString *directoryPath = cachePath();
        
        NSString *absoluteURL = [self generateGETAbsoluteURL:url params:params];
        NSString *key = [NSString hybnetworking_md5:absoluteURL];
        NSString *path = [directoryPath stringByAppendingPathComponent:key];
        
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
        if (data) {
            cacheData = data;
            NSLog(@"Read data from cache for url: %@\n", url);
        }
    }
    
    return cacheData;
}
+ (void)cacheResponseObject:(id)responseObject request:(NSURLRequest *)request parameters:params {
    if (request && responseObject && ![responseObject isKindOfClass:[NSNull class]]) {
        NSString *directoryPath = cachePath();
        
        NSError *error = nil;
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error];
            if (error) {
                NSLog(@"create cache dir error: %@\n", error);
                return;
            }
        }
        
        NSString *absoluteURL = [self generateGETAbsoluteURL:request.URL.absoluteString params:params];
        NSString *key = [NSString hybnetworking_md5:absoluteURL];
        NSString *path = [directoryPath stringByAppendingPathComponent:key];
        NSDictionary *dict = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            dict = (NSDictionary *)responseObject;
        }
        
        NSData *data = nil;
        if ([responseObject isKindOfClass:[NSData class]]) {
            data = responseObject;
        } else {
            data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
        }
        
        if (data && error == nil) {
            BOOL isOk = [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
            if (isOk) {
                NSLog(@"cache file ok for request: %@\n", absoluteURL);
            } else {
                NSLog(@"cache file error for request: %@\n", absoluteURL);
            }
        }
    }
}

+ (void)successResponse:(id)responseData callback:(HttpResponseSucBlock)success {
    if (success) {
        success(responseData);
    }
}
/**
 *
 *	获取缓存总大小/bytes
 *
 *	@return 缓存大小
 */
- (unsigned long long)totalCacheSize {
    NSString *directoryPath = cachePath();
    NSLog(@"缓存路径directoryPath====%@",directoryPath);
    BOOL isDir = NO;
    unsigned long long total = 0;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDir]) {
        if (isDir) {
            NSError *error = nil;
            NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:&error];
            
            if (error == nil) {
                for (NSString *subpath in array) {
                    NSString *path = [directoryPath stringByAppendingPathComponent:subpath];
                    NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path
                                                                                          error:&error];
                    if (!error) {
                        total += [dict[NSFileSize] unsignedIntegerValue];
                    }
                }
            }
        }
    }
    
    return total;
}
/**
 *
 *	清除缓存
 */
- (void)clearCaches {
    NSString *directoryPath = cachePath();
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:directoryPath error:&error];
        
        if (error) {
            NSLog(@"MCNetworking clear caches error: %@", error);
        } else {
            NSLog(@"MCNetworking clear caches ok");
        }
    }
}






@end












@implementation ExproHttpClient

+ (instancetype)sharedClient
{
    static ExproHttpClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //创建
        _sharedClient = [[ExproHttpClient alloc]initWithBaseURL:[NSURL URLWithString:EPHttpApiBaseURL]];
       
        /*
         AFSSLPinningModeNone: 代表客户端无条件地信任服务器端返回的证书。
         AFSSLPinningModePublicKey: 代表客户端会将服务器端返回的证书与本地保存的证书中，PublicKey的部分进行校验；如果正确，才继续进行。
         AFSSLPinningModeCertificate: 代表客户端会将服务器端返回的证书和本地保存的证书中的所有内容，包括PublicKey和证书部分，全部进行校验；如果正确，才继续进行。
         */

        [_sharedClient setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]];
        
    
        [_sharedClient.requestSerializer setValue:@"ios" forHTTPHeaderField:@"client"];//设置请求头数据
        
        /* 意思是：告诉AFN不要去解析服务器返回的数据，保持原来的data即可
         AFHTTPResponseSerializer//二进制格
         1> 服务器返回的是JSON数据
         AFJSONResponseSerializer
         2> 服务器返回的是XML数据
         AFXMLParserResponseSerializer
         */

        _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        
//        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
//                                                                                  @"text/html",
//                                                                                  @"text/json",
//                                                                                  @"text/plain",
//                                                                                  @"text/javascript",
//                                                                                  @"text/xml",
//                                                                                  @"image/*"]];
        
        //_sharedClient.requestSerializer.stringEncoding = NSUTF8StringEncoding;

        
        // 设置允许同时最大并发数量，过大容易出问题
        _sharedClient.operationQueue.maxConcurrentOperationCount = 3;
        
    });
    
    return _sharedClient;
}



@end
