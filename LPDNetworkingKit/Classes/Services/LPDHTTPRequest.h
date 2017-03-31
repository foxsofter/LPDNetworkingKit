//
//  LPDHTTPRequest.h
//  Pods
//
//  Created by 李博 on 2017/3/30.
//
//

#import <Foundation/Foundation.h>
#import "LPDHTTPRequestHeader.h"
#import <AFNetworking/AFNetworking.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface LPDHTTPRequest : NSObject

+ (RACSignal *_Nonnull)rac_requestWithMethod:(NSString *_Nonnull)method
                                   URLString:(NSString *_Nonnull)URLString
                                  parameters:(NSDictionary *_Nullable)parameters
                   constructingBodyWithBlock:(void (^_Nullable)(id <AFMultipartFormData> _Nonnull formData))block
                                      header:(LPDHTTPRequestHeader*_Nullable)header;

/**
 *  @brief 网络状态的信号，订阅此信号
 */
@property (nonatomic, strong, readonly) RACSignal * _Nullable networkStatusSignal;

/**
 *  @brief  开始侦听服务器网络链接状态
 */
- (void)startMonitoring;

/**
 *  @brief  停止侦听服务器网络链接状态
 */
- (void)stopMonitoring;

/**
 *  @brief set response model class for endpoint.
 *
 *  @param responseClass response model class
 *  @param endpoint      endpoint
 */
+ (void)setResponseClass:(Class _Nonnull)responseClass forEndpoint:(NSString *_Nonnull)endpoint;

/**
 *  @brief get response model class by endpoint.
 *
 *  @param endpoint endpoint
 *
 *  @return response model class
 */
+ (Class _Nullable )getResponseClass:(NSString *_Nullable)endpoint;

/**
 *  @brief deserialization response object to response model.
 *
 *  @param response       response
 *  @param endpoint       endpoint
 *  @param responseObject response object
 *
 *  @return response model
 */
+ (NSObject *_Nonnull)resolveResponse:(NSHTTPURLResponse *_Nullable)response
                             endpoint:(NSString *_Nullable)endpoint
                       responseObject:(id _Nullable)responseObject;

@end
