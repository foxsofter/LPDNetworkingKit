//
//  LPDServer+Private.h
//  Pods
//
//  Created by 李博 on 2017/3/28.
//
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface LPDServer()

/**
 *  @brief HTTPSessionManager
 */
@property (nonatomic, strong) AFHTTPSessionManager *HTTPSessionManager;

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
@property (nonatomic, strong, readonly) AFNetworkReachabilityManager *reachabilityManager;

@end
