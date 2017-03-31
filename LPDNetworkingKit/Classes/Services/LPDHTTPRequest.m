//
//  LPDHTTPRequest.m
//  Pods
//
//  Created by 李博 on 2017/3/30.
//
//

#import "LPDHTTPRequest.h"
#import "LPDModel.h"
#import "NSArray+LPDModel.h"
#import "LPDGzipRequestSerializer.h"

static AFHTTPSessionManager *HTTPSessionManager;
static RACSubject *networkStatusSubject;

@interface LPDHTTPRequest ()

@end

@implementation LPDHTTPRequest

+ (void)initialize {
  if (self == [LPDHTTPRequest class]) {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.URLCache = nil;
    HTTPSessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    [HTTPSessionManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
      if (networkStatusSubject) {
        [networkStatusSubject sendNext:@(status)];
      }
    }];
  }
}

+ (RACSignal *)networkStatusSignal
{
  return networkStatusSubject ?: (networkStatusSubject = [[RACSubject subject] setNameWithFormat:@"networkStatusSignal"]);
}

- (void)startMonitoring {
  [HTTPSessionManager.reachabilityManager startMonitoring];
}

- (void)stopMonitoring {
  [HTTPSessionManager.reachabilityManager stopMonitoring];
}

+ (RACSignal *_Nonnull)rac_requestWithMethod:(NSString *_Nonnull)method
                                   URLString:(NSString *_Nonnull)URLString
                                  parameters:(NSDictionary *_Nullable)parameters
                   constructingBodyWithBlock:(void (^_Nullable)(id <AFMultipartFormData> _Nonnull formData))block
                                      header:(LPDHTTPRequestHeader*_Nullable)header
{
  @weakify(self);
  return [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
    @strongify(self);
    
    NSDictionary<NSString *, NSString *> *allHTTPHeaderFields = [header allHTTPHeaderFields];
    if ([[allHTTPHeaderFields objectForKey:@"Content-Type"] isEqualToString:@"application/x-www-form-urlencoded"]) {
      HTTPSessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    } else if ([[allHTTPHeaderFields objectForKey:@"Content-Type"] isEqualToString:@"application/json"]) {
      HTTPSessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    } else if ([[allHTTPHeaderFields objectForKey:@"Content-Type"] isEqualToString:@"application/x-plist"]) {
      HTTPSessionManager.requestSerializer = [AFPropertyListRequestSerializer serializer];
    }
    
    if ([[allHTTPHeaderFields objectForKey:@"Content-Encoding"] isEqualToString:@"gzip"]) {
      HTTPSessionManager.requestSerializer = [LPDGzipRequestSerializer serializerWithSerializer:HTTPSessionManager.requestSerializer];
    }
    
    NSError *__autoreleasing error = nil;
    
    NSMutableURLRequest *mutableURLRequest = nil;
    
    if (block) {
      mutableURLRequest = [HTTPSessionManager.requestSerializer multipartFormRequestWithMethod:method URLString:URLString parameters:parameters constructingBodyWithBlock:block error:&error];
    } else {
      mutableURLRequest = [HTTPSessionManager.requestSerializer requestWithMethod:method URLString:URLString parameters:parameters error:&error];
    }
    
    if (error) {
      [subscriber sendError:[NSError errorWithDomain:error.domain code:error.code userInfo:error.userInfo]];
    }
    
    NSURLSessionDataTask *task = [HTTPSessionManager
                                  dataTaskWithRequest:mutableURLRequest
                                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                    @strongify(self);
                                    if (error) {
                                      [subscriber sendError:[NSError errorWithDomain:error.domain code:error.code userInfo:error.userInfo]];
                                    } else {
                                      NSObject *responseModel = nil;
                                      if (responseObject) {
                                        responseModel =
                                        [self resolveResponse:(NSHTTPURLResponse *)response endpoint:URLString responseObject:responseObject];
                                      }
                                      if (responseModel) {
                                        [subscriber sendNext:RACTuplePack(responseModel, response)];
                                      } else {
                                        [subscriber sendNext:RACTuplePack(responseObject, response)];
                                      }
                                      [subscriber sendCompleted];
                                    }
                                  }];
    
    [task resume];
    
    return [RACDisposable disposableWithBlock:^{
      [task cancel];
    }];
  }];
}

#pragma mark - private methods

+ (NSMutableDictionary<NSString *, Class> *)dictionaryOfEndpointClasses {
  static NSMutableDictionary<NSString *, Class> *dictionaryOfEndpointClasses = nil;
  if (!dictionaryOfEndpointClasses) {
    dictionaryOfEndpointClasses = [NSMutableDictionary dictionary];
  }
  return dictionaryOfEndpointClasses;
}

#pragma mark - public methods

+ (void)setResponseClass:(Class _Nonnull)responseClass forEndpoint:(NSString *_Nonnull)endpoint
{
  [[self dictionaryOfEndpointClasses] setObject:responseClass forKey:endpoint];
}

+ (Class _Nullable )getResponseClass:(NSString *_Nullable)endpoint
{
  NSDictionary *endpointClasses = [self dictionaryOfEndpointClasses];
  __block Class cls = [endpointClasses objectForKey:endpoint];
  if (cls) {
    return cls;
  }
  
  [endpointClasses enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
    if ([key containsString:@"%@"]) {
      NSString *endpointPattern = [key stringByReplacingOccurrencesOfString:@"%@" withString:@"*"];
      NSError *error = nil;
      NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:endpointPattern options:NSRegularExpressionCaseInsensitive error:&error];
      NSRange matchRange = [regex rangeOfFirstMatchInString:endpoint options:NSMatchingReportProgress range:NSMakeRange(0, endpoint.length)];
      if (matchRange.location != NSNotFound) {
        cls = obj;
        *stop = YES;
      }
    }
  }];
  
  return cls;
}

+ (NSObject *_Nonnull)resolveResponse:(NSHTTPURLResponse *_Nullable)response
                             endpoint:(NSString *_Nullable)endpoint
                       responseObject:(id _Nullable)responseObject
{
  id responseModel = responseObject;
  Class responseClass = [self.class getResponseClass:endpoint];
  if (responseClass) {
    if ([responseObject isKindOfClass:NSArray.class]) {
      responseModel = [NSArray modelArrayWithClass:responseClass json:responseObject];
    } else {
      responseModel = [responseClass modelWithJSON:responseObject];
    }
  }
  return responseModel;
}

@end
