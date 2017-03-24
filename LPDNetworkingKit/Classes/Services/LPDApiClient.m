//
//  LPDApiClient.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/19.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDApiClient.h"
#import "LPDModel.h"
#import "LPDModelProtocol.h"
#import "NSArray+LPDModel.h"
#import "Godzippa.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPDApiClient ()

@property (nonatomic, strong) NSMutableURLRequest *mutableURLRequest;

@end

@implementation LPDApiClient

@synthesize HTTPSessionManager = _HTTPSessionManager;
@synthesize server = _server;
@synthesize requestSerializerType = _requestSerializerType;
@synthesize responseSerializerType = _responseSerializerType;
@synthesize isGzip = _isGzip;

#pragma mark - life cycle

- (instancetype)init {
  return [self initWithServer:nil];
}

- (instancetype)initWithServer:(nullable NSObject<LPDApiServerProtocol> *)server {
  self = [super init];
  if (self) {
    _server = server;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.URLCache = nil;
    _HTTPSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil sessionConfiguration:configuration];
  }
  return self;
}

#pragma mark - properties

- (void)setRequestSerializerType:(LPDRequestSerializerType)requestSerializerType {
  switch (requestSerializerType) {
    case LPDHTTPRequest:
    {
      _HTTPSessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
      break;
    case LPDJSONRequest:
    {
      _HTTPSessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
      break;
    case LPDPropertyListRequest:
    {
      _HTTPSessionManager.requestSerializer = [AFPropertyListRequestSerializer serializer];
    }
      break;
      
    default:
      break;
  }
}

- (void)setResponseSerializerType:(LPDResponseSerializerType)responseSerializerType {
  switch (responseSerializerType) {
    case LPDHTTPResponse:
    {
      _HTTPSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
      break;
    case LPDJSONResponse:
    {
      _HTTPSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
      break;
    case LPDXMLParserResponse:
    {
      _HTTPSessionManager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    }
      break;
    case LPDPropertyListResponse:
    {
      _HTTPSessionManager.responseSerializer = [AFPropertyListResponseSerializer serializer];
    }
      break;
    case LPDImageResponse:
    {
      _HTTPSessionManager.responseSerializer = [AFImageResponseSerializer serializer];
    }
      break;
    case LPDCompoundResponse:
    {
      _HTTPSessionManager.responseSerializer = [AFCompoundResponseSerializer serializer];
    }
      break;
      
    default:
      break;
  }
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

- (RACSignal *)rac_HEAD:(NSString *)path parameters:(nullable id)parameters {
  return [[self rac_requestPath:path parameters:parameters method:@"HEAD" constructingBodyWithBlock:nil]
          setNameWithFormat:@"%@ -rac_HEAD: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_GET:(NSString *)path parameters:(nullable id)parameters {
  return [[self rac_requestPath:path parameters:parameters method:@"GET" constructingBodyWithBlock:nil]
    setNameWithFormat:@"%@ -rac_GET: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_POST:(NSString *)path parameters:(nullable id)parameters {
  return [[self rac_requestPath:path parameters:parameters method:@"POST" constructingBodyWithBlock:nil]
    setNameWithFormat:@"%@ -rac_POST: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_POST:(NSString *)path
                 parameters:(nullable id)parameters
  constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block {
  return [[self rac_requestPath:path parameters:parameters method:@"POST" constructingBodyWithBlock:block] setNameWithFormat:@"%@ -rac_POST: %@, parameters: %@, constructingBodyWithBlock:", self.class, path, parameters];
}

- (RACSignal *)rac_PUT:(NSString *)path parameters:(nullable id)parameters {
  return [[self rac_requestPath:path parameters:parameters method:@"PUT" constructingBodyWithBlock:nil]
    setNameWithFormat:@"%@ -rac_PUT: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_DELETE:(NSString *)path parameters:(nullable id)parameters {
  return [[self rac_requestPath:path parameters:parameters method:@"DELETE" constructingBodyWithBlock:nil]
          setNameWithFormat:@"%@ -rac_DELETE: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_OPTIONS:(NSString *)path parameters:(nullable id)parameters {
  return [[self rac_requestPath:path parameters:parameters method:@"OPTIONS" constructingBodyWithBlock:nil]
          setNameWithFormat:@"%@ -rac_OPTIONS: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_TRACE:(NSString *)path parameters:(nullable id)parameters {
  return [[self rac_requestPath:path parameters:parameters method:@"TRACE" constructingBodyWithBlock:nil]
          setNameWithFormat:@"%@ -rac_TRACE: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_CONNECT:(NSString *)path parameters:(nullable id)parameters {
  return [[self rac_requestPath:path parameters:parameters method:@"CONNECT" constructingBodyWithBlock:nil]
          setNameWithFormat:@"%@ -rac_CONNECT: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_PATCH:(NSString *)path parameters:(nullable id)parameters {
  return [[self rac_requestPath:path parameters:parameters method:@"PATCH" constructingBodyWithBlock:nil]
    setNameWithFormat:@"%@ -rac_PATCH: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_requestPath:(NSString *)path parameters:(nullable id)parameters method:(NSString *)method constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block {
  @weakify(self);
  return [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
    @strongify(self);
    NSString *urlString = nil;
    if ([path containsString:@"http"]) {
      urlString = path;
    } else {
      urlString = [[NSURL URLWithString:path relativeToURL:[NSURL URLWithString:self.server.serverUrl]] absoluteString];
    }
    
    if (block) {
      self.mutableURLRequest = [self.HTTPSessionManager.requestSerializer
                      multipartFormRequestWithMethod:method
                      URLString:urlString
                      parameters:parameters
                      constructingBodyWithBlock:block
                      error:nil];
    } else {
      self.mutableURLRequest = [self.HTTPSessionManager.requestSerializer
                      requestWithMethod:method
                      URLString:urlString
                      parameters:parameters
                      error:nil];
    }
    
    if (_isGzip) {
      NSData *compressedData = [self GZipCompressingData:[self.mutableURLRequest.HTTPBody copy]];
      if (compressedData) {
        self.mutableURLRequest.HTTPBody = compressedData;
        [self.mutableURLRequest setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
      }
    }

    NSURLSessionDataTask *task = [self.HTTPSessionManager
      dataTaskWithRequest:self.mutableURLRequest
        completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
          @strongify(self);
          if (error) {
            [subscriber sendError:[NSError errorWithDomain:error.domain code:error.code userInfo:error.userInfo]];
          } else {
            NSObject *responseModel = nil;
            if (responseObject) {
              responseModel =
                [self resolveResponse:(NSHTTPURLResponse *)response endpoint:path responseObject:responseObject];
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

+ (void)setResponseClass:(Class)responseClass forEndpoint:(NSString *)endpoint {
  [[self dictionaryOfEndpointClasses] setObject:responseClass forKey:endpoint];
}

+ (nullable Class)getResponseClass:(NSString *)endpoint {
  NSDictionary *endpointClasses = [self dictionaryOfEndpointClasses];
  __block id cls = [endpointClasses objectForKey:endpoint];
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
        stop = YES;
      }
    }
  }];
  
  return cls;
}

- (nullable NSObject *)resolveResponse:(NSHTTPURLResponse *)response
                              endpoint:(NSString *)endpoint
                        responseObject:(id)responseObject {
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

- (NSData*)GZipCompressingData:(NSData *)data {
  NSError *compressionError = nil;
  NSData *compressedData = [data dataByGZipCompressingWithError:&compressionError];
  if (compressedData && !compressionError) {
    return compressedData;
  } else {
    return nil;
  }
}

@end

NS_ASSUME_NONNULL_END
