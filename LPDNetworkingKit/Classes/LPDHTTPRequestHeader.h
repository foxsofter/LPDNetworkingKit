//
//  LPDHTTPRequestHeader.h
//  Pods
//
//  Created by 李博 on 2017/4/6.
//
//

#import <Foundation/Foundation.h>

@interface LPDHTTPRequestHeader : NSObject

@property (nullable, copy, readonly) NSDictionary<NSString *, NSString *> *allHTTPHeaderFields;

- (void)setValue:(NSString *_Nullable)value forHTTPHeaderField:(NSString *_Nonnull)field;

@end
