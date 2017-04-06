//
//  LPDHTTPRequestManager.m
//  Pods
//
//  Created by 李博 on 2017/4/6.
//
//

#import "LPDHTTPRequestManager.h"
#import "LPDModel.h"
#import "NSArray+LPDModel.h"

static AFHTTPSessionManager *HTTPSessionManager;
static RACSubject *networkStatusSubject;

@implementation LPDHTTPRequestManager

+ (void)initialize {
  if (self == [LPDHTTPRequestManager class]) {
    HTTPSessionManager = [AFHTTPSessionManager manager];
    HTTPSessionManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:[AFSecurityPolicy certificatesInBundle:[NSBundle mainBundle]]];
    [HTTPSessionManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
      if (networkStatusSubject) {
        [networkStatusSubject sendNext:@(status)];
      }
    }];
  }
}

- (RACSignal *)networkStatusSignal
{
  return networkStatusSubject ?: (networkStatusSubject = [[RACSubject subject] setNameWithFormat:@"networkStatusSignal"]);
}

- (void)startMonitoring {
  [HTTPSessionManager.reachabilityManager startMonitoring];
}

- (void)stopMonitoring {
  [HTTPSessionManager.reachabilityManager stopMonitoring];
}

- (RACSignal *)startRequest :(LPDHTTPRequest *)request
{
  @weakify(self);
  return [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
    @strongify(self);
    HTTPSessionManager.requestSerializer = [request requestSerializer];
    
    NSError *__autoreleasing error = nil;
    NSMutableURLRequest *mutableURLRequest = nil;
    
    if (request.constructingBodyWithBlock) {
      mutableURLRequest = [HTTPSessionManager.requestSerializer multipartFormRequestWithMethod:request.HTTPMethod URLString:request.URLString parameters:request.parameters constructingBodyWithBlock:request.constructingBodyWithBlock error:&error];
    } else {
      mutableURLRequest = [HTTPSessionManager.requestSerializer requestWithMethod:request.HTTPMethod URLString:request.URLString parameters:request.parameters error:&error];
    }
    
    if (error) {
      [subscriber sendError:error];
    }
    
    NSURLSessionDataTask *task = [HTTPSessionManager
                                  dataTaskWithRequest:mutableURLRequest
                                  completionHandler:^(NSURLResponse * _Nonnull response,
                                                      id  _Nullable responseObject,
                                                      NSError * _Nullable error) {
                                    @strongify(self);
                                    if (error) {
                                      [subscriber sendError:error];
                                    } else {
                                      NSObject *responseModel = nil;
                                      if (responseObject) {
                                        responseModel =
                                        [self resolveResponse:(NSHTTPURLResponse*)response responseObject:responseObject responseClass:request.responseClass];
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

- (NSObject *)resolveResponse:(NSHTTPURLResponse *_Nonnull)response
               responseObject:(id _Nullable)responseObject
               responseClass:(id _Nullable)responseClass
{
  id responseModel = responseObject;
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
