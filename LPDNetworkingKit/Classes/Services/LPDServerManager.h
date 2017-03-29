//
//  LPDServerManager.h
//  Pods
//
//  Created by 李博 on 2017/3/27.
//
//

#import <Foundation/Foundation.h>
#import "LPDServer.h"

@interface LPDServerManager : NSObject

/**
 *  @brief 当前App环境
 */
@property (nonatomic, assign) LPDServerEnvironment environment;

/**
 *  @brief 根据serverName获取对应的server
 */
- (void)setServer:(LPDServer *)server forServerName:(NSString *)serverName;

/**
 *  @brief 根据serverName获取对应的server
 */
- (LPDServer *)serverForName:(NSString *)serverName;

/**
 *  @brief 根据serverName获取当前环境的domainUrl
 */
- (NSString*)getDomainUrlForServerName:(NSString *)serverName;

/**
 *  @brief 仅支持单例模式
 */
+ (instancetype)sharedManager;

+ (instancetype) new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end
