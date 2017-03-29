//
//  LPDServer.m
//  Pods
//
//  Created by 李博 on 2017/3/27.
//
//

#import "LPDServer.h"
#import "LPDServer+Private.h"
#import "LPDGzipRequestSerializer.h"


static RACSubject *networkStatusSubject;

@interface LPDServer ()

@property (nonatomic, strong) NSMutableDictionary *dictionaryOfDomainUrl;

@end

@implementation LPDServer

- (instancetype)initWithServerName:(NSString *)serverName
{
  self = [super init];
  if (self) {
    _serverName = serverName;
    _dictionaryOfDomainUrl = [NSMutableDictionary dictionaryWithCapacity:3];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.URLCache = nil;
    _HTTPSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil sessionConfiguration:configuration];
    _requestSerializer = _HTTPSessionManager.requestSerializer;
    _responseSerializer = _HTTPSessionManager.responseSerializer;
    _securityPolicy = _HTTPSessionManager.securityPolicy;
    
    [_HTTPSessionManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
      if (networkStatusSubject) {
        [networkStatusSubject sendNext:@(status)];
      }
    }];
  }
  return self;
}

- (RACSignal *)networkStatusSignal
{
  return networkStatusSubject ?: (networkStatusSubject = [[RACSubject subject] setNameWithFormat:@"networkStatusSignal serverName: %@",_serverName]);
}

#pragma mark - properties

- (void)setRequestSerializer:(AFHTTPRequestSerializer<AFURLRequestSerialization> *)requestSerializer
{
  _HTTPSessionManager.requestSerializer = requestSerializer;
  [self setCompressionType:_compressionType];
}

- (void)setResponseSerializer:(AFHTTPResponseSerializer<AFURLResponseSerialization> *)responseSerializer
{
  _HTTPSessionManager.responseSerializer = responseSerializer;
}

- (void)setSecurityPolicy:(AFSecurityPolicy *)securityPolicy
{
  _HTTPSessionManager.securityPolicy = securityPolicy;
}

- (AFNetworkReachabilityManager *)reachabilityManager
{
  return _HTTPSessionManager.reachabilityManager;
}

- (void)setCompressionType:(LPDCompressionType)compressionType
{
  switch (compressionType) {
    case LPDCompressionTypeGzip:
    {
      _HTTPSessionManager.requestSerializer = [LPDGzipRequestSerializer serializerWithSerializer:_HTTPSessionManager.requestSerializer];
    }
      break;
      
    default:
      break;
  }
}

#pragma mark - methods

- (void)setDomainUrl:(NSString *)domainUrl forEnvironment:(LPDServerEnvironment)environment
{
  if ([[_dictionaryOfDomainUrl objectForKey:@(environment)] isEqualToString:domainUrl]) {
    return;
  }
  [_dictionaryOfDomainUrl setObject:domainUrl forKey:@(environment)];
}

- (NSString *)getDomainUrlForEnvironment:(LPDServerEnvironment)environment
{
  return environment == LPDServerEnvironmentUnknown ? nil : [_dictionaryOfDomainUrl objectForKey:@(environment)];
}

- (void)startMonitoring
{
  [_HTTPSessionManager.reachabilityManager startMonitoring];
}

- (void)stopMonitoring
{
  [_HTTPSessionManager.reachabilityManager stopMonitoring];
}

@end
