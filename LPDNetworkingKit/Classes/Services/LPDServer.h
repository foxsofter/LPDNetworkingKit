//
//  LPDServer.h
//  Pods
//
//  Created by 李博 on 2017/3/27.
//
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <ReactiveObjC/ReactiveObjC.h>

typedef NS_ENUM(NSUInteger, LPDServerEnvironment) {
  LPDServerEnvironmentUnknown = 0,
  LPDServerEnvironmentAlpha,
  LPDServerEnvironmentBeta,
  LPDServerEnvironmentProduce,
};

typedef NS_ENUM(NSUInteger, LPDCompressionType) {
  LPDCompressionTypeNone,
  LPDCompressionTypeGzip,
};

@interface LPDServer : NSObject

/**
 *  @brief 服务名称
 */
@property (nonatomic, copy) NSString *serverName;

/**
 *  @brief 压缩方式
 */
@property (nonatomic, assign) LPDCompressionType compressionType;

/**
 *  @brief 网络状态的信号，订阅此信号
 */
@property (nonatomic, strong, readonly) RACSignal *networkStatusSignal;

/**
 *  @brief 根据环境设置对应的服务器域名
 */
- (void)setDomainUrl:(NSString *)domainUrl forEnvironment:(LPDServerEnvironment)environment;

/**
 *  @brief 根据环境获取对应的服务器域名
 */
- (NSString *)getDomainUrlForEnvironment:(LPDServerEnvironment)environment;

/**
 *  @brief init
 */
- (instancetype)initWithServerName: (NSString *)serverName;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/**
 *  @brief  开始侦听服务器网络链接状态
 */
- (void)startMonitoring;

/**
 *  @brief  停止侦听服务器网络链接状态
 */
- (void)stopMonitoring;

@end
