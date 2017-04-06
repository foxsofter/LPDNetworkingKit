//
//  LPDHTTPRequest.m
//  Pods
//
//  Created by 李博 on 2017/4/6.
//
//

#import "LPDHTTPRequest.h"
#import "LPDGzipRequestSerializer.h"

@interface LPDHTTPRequest ()

@property (nonatomic, strong) AFHTTPRequestSerializer *requestSerializer;
@property (nonatomic, strong) LPDHTTPRequestHeader *requestHeader;

@end

@implementation LPDHTTPRequest

- (instancetype)initWithRequestHeader:(LPDHTTPRequestHeader *)requestHeader
{
  self = [super init];
  if (self) {
    _requestHeader = requestHeader;
    [self setupConfig];
  }
  return self;
}

- (void)setupConfig
{
  if ([[[_requestHeader allHTTPHeaderFields] objectForKey:@"Content-Type"] isEqualToString:@"application/json"]) {
    _requestSerializer = [AFJSONRequestSerializer serializer];
  } else {
    _requestSerializer = [AFHTTPRequestSerializer serializer];
  }
  
  if ([[[_requestHeader allHTTPHeaderFields] objectForKey:@"Content-Encoding"] isEqualToString:@"gzip"]) {
    _requestSerializer = [LPDGzipRequestSerializer serializerWithSerializer:_requestSerializer];
  }
}

- (AFHTTPRequestSerializer *)requestSerializer
{
  return _requestSerializer;
}

@end
