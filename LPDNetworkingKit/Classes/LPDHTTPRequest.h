//
//  LPDHTTPRequest.h
//  Pods
//
//  Created by 李博 on 2017/4/6.
//
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "LPDHTTPRequestHeader.h"

@interface LPDHTTPRequest : NSObject

@property (nonatomic, copy) NSString *HTTPMethod;
@property (nonatomic, copy) NSString *URLString;
@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic, copy) void (^constructingBodyWithBlock)(id <AFMultipartFormData> formData);
@property (nonatomic, copy) Class responseClass;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithRequestHeader :(LPDHTTPRequestHeader *)requestHeader NS_DESIGNATED_INITIALIZER;

- (AFHTTPRequestSerializer *)requestSerializer;

@end
