//
//  MCNetworkManager.h
//  MCNetworkManager
//
//  Created by MC on 16/4/14.
//  Copyright © 2016年 MC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import "AFNetworkActivityIndicatorManager.h"
#import "AFHTTPSessionManager.h"

@class ExproHttpClient;
typedef NS_ENUM(NSUInteger, MCRequestType) {
    kMCRequestTypeJSON = 1, // 默认
    kMCRequestTypePlainText  = 2 // 普通text/html
};
typedef NS_ENUM(NSUInteger, MCResponseType) {
    kMCResponseTypeJSON = 1, // 默认
    kMCResponseTypeXML  = 2, // XML
    // 特殊情况下，一转换服务器就无法识别的，默认会尝试转换成JSON，若失败则需要自己去转换
    kMCResponseTypeData = 3
};
typedef NSURLSessionTask MCURLSessionTask;

@interface MCNetworkManager : NSObject
+ (instancetype)instanceManager;
@property ExproHttpClient *httpClient;



/**
 *
 *	获取缓存总大小/bytes
 *
 *	@return 缓存大小
 */
- (unsigned long long)totalCacheSize;

/**
 *
 *	清除缓存
 */
- (void)clearCaches;

/*!
 *
 *  配置公共的请求头，只调用一次即可，通常放在应用启动的时候配置就可以了
 *
 *  @param httpHeaders 只需要将与服务器商定的固定参数设置即可
 */
- (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders;

/**
 *
 *	取消所有请求
 */
- (void)cancelAllRequest;


/**
 *
 *	取消某个请求。如果是要取消某个请求，最好是引用接口所返回来的HYBURLSessionTask对象，
 *  然后调用对象的cancel方法。如果不想引用对象，这里额外提供了一种方法来实现取消某个请求
 *
 *	@param url				URL，可以是绝对URL，也可以是path（也就是不包括baseurl）
 */
- (void)cancelRequestWithURL:(NSString *)url;



/**
 *  请求成功后的数据简单处理后的回调
 *
 *  @param resultDic 返回的字典对象
 */
typedef void (^HttpResponseSucBlock) (id resultDic);
/**
 *  请求失败后的响应及错误实例
 *
 *  @param operation 响应
 *  @param erro      错误实例
 *///NSURLSessionDataTask
typedef void (^HttpResponseErrBlock) (NSURLSessionDataTask *operation,NSError *error,NSString *description);
/*!
 *
 *  下载进度
 *
 *  @param bytesRead                 已下载的大小
 *  @param totalBytesRead            文件总大小
 *  @param totalBytesExpectedToRead 还有多少需要下载
 */
typedef void (^MCDownloadProgress)(int64_t bytesRead,
                                   int64_t totalBytesRead);

typedef MCDownloadProgress MCGetProgress;
typedef MCDownloadProgress MCPostProgress;

/*!
 *
 *  上传进度
 *
 *  @param bytesWritten              已上传的大小
 *  @param totalBytesWritten         总上传大小
 */
typedef void (^MCUploadProgress)(int64_t bytesWritten,
                                 int64_t totalBytesWritten);





#pragma mark-请求接口

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
              fail:(HttpResponseErrBlock)errorBlock;


/*
 *多一个params参数
 */
- (void )getWithUrl:(NSString *)url
       refreshCache:(BOOL)refreshCache
             params:(NSDictionary *)params
            success:(HttpResponseSucBlock)completeBlock
               fail:(HttpResponseErrBlock)errorBlock;

/*
 *带有params参数
 *带进度回调
 */
- (void)getWithUrl:(NSString *)url
      refreshCache:(BOOL)refreshCache
            params:(NSDictionary *)params
          progress:(MCGetProgress)progress
           success:(HttpResponseSucBlock)completeBlock
              fail:(HttpResponseErrBlock)errorBlock;



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
                fail:(HttpResponseErrBlock)errorBlock;
/*
 *带进度回调
 */

- ( void)postWithUrl:(NSString *)url
        refreshCache:(BOOL)refreshCache
              params:(NSDictionary *)params
            progress:(MCPostProgress)progress
             success:(HttpResponseSucBlock)completeBlock
                fail:(HttpResponseErrBlock)errorBlock;

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
                    fail:(HttpResponseErrBlock)errorBlock;


/**
 *
 *	上传文件操作
 *
 *	@param url						上传路径
 *	@param uploadingFile	待上传文件的路径
 *	@param progress			上传进度
 *	@param completeBlock				上传成功回调
 *	@param errorBlock					上传失败回调
 *
 *	@return
 */
- ( void)uploadFileWithUrl:(NSString *)url
             uploadingFile:(NSString *)uploadingFile
                  progress:(MCUploadProgress)progress
                   success:(HttpResponseSucBlock)completeBlock
                      fail:(HttpResponseErrBlock)errorBlock;


/*!
 *
 *  下载文件
 *
 *  @param url           下载URL
 *  @param saveToPath    下载到哪个路径下
 *  @param progressBlock 下载进度
 *  @param completeBlock       下载成功后的回调
 *  @param errorBlock       下载失败后的回调
 */
- (void)downloadWithUrl:(NSString *)url
             saveToPath:(NSString *)saveToPath
               progress:(MCDownloadProgress)progressBlock
                success:(HttpResponseSucBlock)completeBlock
                failure:(HttpResponseErrBlock)errorBlock;

@end


@interface ExproHttpClient : AFHTTPSessionManager
+ (instancetype)sharedClient;

@end
