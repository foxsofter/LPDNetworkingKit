//
//  LPDHTTPRequestHeader.m
//  Pods
//
//  Created by 李博 on 2017/4/6.
//
//

#import "LPDHTTPRequestHeader.h"

@interface LPDHTTPRequestHeader ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *mutableHTTPRequestHeaders;

@end

@implementation LPDHTTPRequestHeader

- (instancetype)init
{
  self = [super init];
  if (self) {
    _mutableHTTPRequestHeaders = [NSMutableDictionary dictionary];
  }
  return self;
}

- (void)setValue:(NSString *_Nullable)value forHTTPHeaderField:(NSString *_Nonnull)field
{
  if (!value) {
    [_mutableHTTPRequestHeaders removeObjectForKey:field];
  } else {
    [_mutableHTTPRequestHeaders setObject:value forKey:field];
  }
}

- (NSDictionary<NSString *, NSString *> *)allHTTPHeaderFields
{
  return [_mutableHTTPRequestHeaders copy];
}

@end
