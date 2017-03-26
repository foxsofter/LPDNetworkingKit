//
//  LPDSessionManager.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/19.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPDSessionManagerProtocol.h"
#import "LPDServerProtocol.h"
#import "LPDModelProtocol.h"

@interface LPDSessionManager : NSObject<LPDSessionManagerProtocol>

+ (instancetype) new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end
