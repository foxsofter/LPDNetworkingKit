//
//  LPDApiClientProtocol.h
//  Pods
//
//  Created by 李博 on 2017/3/24.
//
//

#import <Foundation/Foundation.h>
#import "LPDApiServerProtocol.h"

typedef enum : NSUInteger {
  LPDHTTPRequest = 0,       // default
  LPDJSONRequest,
  LPDPropertyListRequest,
} LPDRequestSerializerType;

typedef enum : NSUInteger {
  LPDHTTPResponse = 0,
  LPDJSONResponse,          // default
  LPDXMLParserResponse,
  LPDPropertyListResponse,
  LPDImageResponse,
  LPDCompoundResponse,
} LPDResponseSerializerType;

NS_ASSUME_NONNULL_BEGIN

@protocol LPDApiClientProtocol <NSObject>

/**
 *  @brief AFHTTPSessionManager
 */
@property (nonatomic, strong, readonly) AFHTTPSessionManager *HTTPSessionManager;

/**
 *  @brief api server
 */
@property (nonatomic, strong, nullable) NSObject<LPDApiServerProtocol> *server;

/**
 *  @brief requestType
 */
@property (nonatomic, assign) LPDRequestSerializerType requestSerializerType;

/**
 *  @brief responseType
 */
@property (nonatomic, assign) LPDResponseSerializerType responseSerializerType;

/**
 *  @brief gzip压缩
 */
@property (nonatomic, assign) BOOL isGzip;

/**
 *  @brief init
 */
- (instancetype)initWithServer:(nullable NSObject<LPDApiServerProtocol> *)server;

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
 *  @brief A convenience around -OPTIONS:parameters:success:failure:
 *         that returns a cold signal of the resulting JSON object and response headers or error.
 */
- (RACSignal *)rac_OPTIONS:(NSString *)path parameters:(nullable id)parameters;

/**
 *  @brief A convenience around -TRACE:parameters:success:failure:
 *         that returns a cold signal of the resulting JSON object and response headers or error.
 */
- (RACSignal *)rac_TRACE:(NSString *)path parameters:(nullable id)parameters;

/**
 *  @brief A convenience around -CONNECT:parameters:success:failure:
 *         that returns a cold signal of the resulting JSON object and response headers or error.
 */
- (RACSignal *)rac_CONNECT:(NSString *)path parameters:(nullable id)parameters;

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
