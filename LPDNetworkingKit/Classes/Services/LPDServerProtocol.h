//
//  LPDServerProtocol.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/18.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
  LPDServerEnvironmentUnknown = 0,
  LPDServerEnvironmentAlpha,
  LPDServerEnvironmentBeta,
  LPDServerEnvironmentProduce,
} LPDServerEnvironment;

NS_ASSUME_NONNULL_BEGIN

@protocol LPDServerProtocol <NSObject>

/**
 *  @brief 当前服务器环境
 */
@property (nonatomic, assign) LPDServerEnvironment environment;

/**
 *  @brief 当前服务器域名URL
 */
@property (nullable, nonatomic, copy, readonly) NSString *domainUrl;

/**
 *  @brief 根据环境设置对应的服务器域名
 */
- (void)setDomainUrl:(NSString *)domainUrl forEnvironment:(LPDServerEnvironment)environment;

@end

NS_ASSUME_NONNULL_END
