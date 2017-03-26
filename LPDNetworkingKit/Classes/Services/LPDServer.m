//
//  LPDServer.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/21.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDServer.h"

@interface LPDServer ()

@property (nonatomic, strong) NSMutableDictionary *dictionaryOfDomainUrl;

@end

@implementation LPDServer

@synthesize environment = _environment;

- (instancetype)init {
  self = [super init];
  if (self) {
    _dictionaryOfDomainUrl = [NSMutableDictionary dictionaryWithCapacity:3];
  }
  return self;
}

- (void)setDomainUrl:(NSString *)domainUrl forEnvironment:(LPDServerEnvironment)environment {
  if ([[_dictionaryOfDomainUrl objectForKey:@(environment)] isEqualToString:domainUrl]) {
    return;
  }
  [_dictionaryOfDomainUrl setObject:domainUrl forKey:@(environment)];
}

#pragma mark - properties

- (void)setEnvironment:(LPDServerEnvironment)environment {
  if (environment == LPDServerEnvironmentUnknown || _environment == environment) {
    return;
  }
  _environment == environment;
}

- (NSString *)domainUrl {
  return _environment == LPDServerEnvironmentUnknown ? nil : [_dictionaryOfDomainUrl objectForKey:@(_environment)];
}

@end
