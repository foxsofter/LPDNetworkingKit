//
//  LPDSessionManagerProtocol.h
//  Pods
//
//  Created by 李博 on 2017/3/24.
//
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "LPDServerProtocol.h"

typedef enum : NSUInteger {
  LPDNetworkStatusUnknown = -1,
  LPDNetworkStatusNotReachable = 0,
  LPDNetworkStatusReachableViaWWAN = 1,
  LPDNetworkStatusReachableViaWiFi = 2,
} LPDNetworkStatus;

NS_ASSUME_NONNULL_BEGIN

@protocol LPDSessionManagerProtocol <NSObject>

/**
 *  @brief requestSerializer
 */
@property (nonatomic, strong) AFHTTPRequestSerializer <AFURLRequestSerialization> * requestSerializer;

/**
 *  @brief responseSerializer
 */
@property (nonatomic, strong) AFHTTPResponseSerializer <AFURLResponseSerialization> * responseSerializer;

/**
 *  @brief securityPolicy
 */
@property (nonatomic, strong) AFSecurityPolicy *securityPolicy;

/**
 *  @brief reachabilityManager
 */
@property (readwrite, nonatomic, strong) AFNetworkReachabilityManager *reachabilityManager;

/**
 *  @brief api server
 */
@property (nonatomic, strong, nullable) NSObject<LPDServerProtocol> *server;


/**
 *  @brief gzip压缩
 */
@property (nonatomic, assign) BOOL isGzip;

/**
 *  @brief 网络状态的信号，订阅此信号
 */
@property (nonatomic, strong, readonly) RACSignal *networkStatusSignal;

/**
 *  @brief  开始侦听服务器网络链接状态
 */
- (void)startMonitoring;

/**
 *  @brief  停止侦听服务器网络链接状态
 */
- (void)stopMonitoring;

/**
 *  @brief init
 */
- (instancetype)initWithServer:(nullable NSObject<LPDServerProtocol> *)server;

/**
 *  @brief A convenience around -HEAD:parameters:success:failure: that returns a cold
 *         signal of the resulting response headers or error.
 */
- (RACSignal *)rac_HEAD:(NSString *)path parameters:(nullable id)parameters;

/**
 *  @brief A convenience around -GET:parameters:success:failure: that returns a cold
 *         signal of the resulting JSON object and response headers or error.
 */
- (RACSignal *)rac_GET:(NSString *)path parameters:(nullable id)parameters;

/**
 *  @brief A convenience around -POST:parameters:success:failure: that returns a cold
 *         signal of the resulting JSON object and response headers or error.
 */
- (RACSignal *)rac_POST:(NSString *)path parameters:(nullable id)parameters;

/**
 *  @brief A convenience around -POST:parameters:constructingBodyWithBlock:success:failure:
 *         that returns a cold signal of the resulting JSON object and response headers or error.
 */
- (RACSignal *)rac_POST:(NSString *)path
             parameters:(nullable id)parameters
constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block;

/**
 *  @brief A convenience around -PUT:parameters:success:failure:
 *         that returns a cold signal of the resulting JSON object and response headers or error.
 */
- (RACSignal *)rac_PUT:(NSString *)path parameters:(nullable id)parameters;

/**
 *  @brief A convenience around -DELETE:parameters:success:failure:
 *         that returns a cold signal of the resulting JSON object and response headers or error.
 */
- (RACSignal *)rac_DELETE:(NSString *)path parameters:(nullable id)parameters;

/**
 *  @brief A convenience around -PATCH:parameters:success:failure:
 *         that returns a cold signal of the resulting JSON object and response headers or error.
 */
- (RACSignal *)rac_PATCH:(NSString *)path parameters:(nullable id)parameters;

/**
 *  @brief set response model class for endpoint.
 *
 *  @param responseClass response model class
 *  @param endpoint      endpoint
 */
+ (void)setResponseClass:(Class)responseClass forEndpoint:(NSString *)endpoint;

/**
 *  @brief get response model class by endpoint.
 *
 *  @param endpoint endpoint
 *
 *  @return response model class
 */
+ (nullable Class)getResponseClass:(NSString *)endpoint;

/**
 *  @brief deserialization response object to response model.
 *
 *  @param response       response
 *  @param endpoint       endpoint
 *  @param responseObject response object
 *
 *  @return response model
 */
- (nullable NSObject *)resolveResponse:(NSHTTPURLResponse *)response
                              endpoint:(NSString *)endpoint
                        responseObject:(id)responseObject;

@end

NS_ASSUME_NONNULL_END
