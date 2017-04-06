//
//  LPDHTTPRequestManager.h
//  Pods
//
//  Created by 李博 on 2017/4/6.
//
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "LPDHTTPRequest.h"

@interface LPDHTTPRequestManager : NSObject

/**
 *  @brief 网络状态的信号，订阅此信号
 */
- (RACSignal *)networkStatusSignal;

/**
 *  @brief  开始侦听服务器网络链接状态
 */
- (void)startMonitoring;

/**
 *  @brief  停止侦听服务器网络链接状态
 */
- (void)stopMonitoring;

- (RACSignal *)startRequest :(LPDHTTPRequest *)request;

- (NSObject *)resolveResponse:(NSHTTPURLResponse *_Nonnull)response
               responseObject:(id _Nullable)responseObject
                responseClass:(id _Nullable)responseClass;
@end
