//
//  LPDRequestManager.h
//  Pods
//
//  Created by 李博 on 2017/3/27.
//
//

#import <Foundation/Foundation.h>
#import "LPDServerManager.h"

@interface LPDRequestManager : NSObject

+ (RACSignal *_Nonnull)rac_requestWithMethod:(NSString *_Nonnull)method
                           URLString:(NSString *_Nonnull)URLString
                          parameters:(NSDictionary *_Nullable)parameters
           constructingBodyWithBlock:(void (^_Nullable)(id <AFMultipartFormData> _Nonnull formData))block
                              server:(LPDServer*_Nullable)server;

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
