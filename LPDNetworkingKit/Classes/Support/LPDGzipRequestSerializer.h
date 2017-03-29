//
//  LPDGzipRequestSerializer.h
//  Pods
//
//  Created by 李博 on 2017/3/28.
//
//

#import "AFURLRequestSerialization.h"

@interface LPDGzipRequestSerializer : AFHTTPRequestSerializer

/**
 The serializer used to generate requests to be compressed.
 */
@property (readonly, nonatomic, strong) id <AFURLRequestSerialization> serializer;

/**
 Creates and returns an instance of `AFgzipRequestSerializer`, using the specified serializer to generate requests to be compressed.
 */
+ (instancetype)serializerWithSerializer:(id <AFURLRequestSerialization>)serializer;

@end
