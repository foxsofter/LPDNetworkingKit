//
//  LPDServerManager.m
//  Pods
//
//  Created by 李博 on 2017/3/27.
//
//

#import "LPDServerManager.h"

@interface LPDServerManager ()

@property (nonatomic, strong) NSMutableDictionary *dictionaryOfServer;

@end

@implementation LPDServerManager

+ (instancetype)sharedManager
{
  static LPDServerManager *instance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[self alloc] init];
  });
  return instance;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    _dictionaryOfServer = [NSMutableDictionary dictionary];
  }
  return self;
}

#pragma mark - methods

- (void)setServer:(LPDServer *)server forServerName:(NSString *)serverName
{
  [_dictionaryOfServer setObject:server forKey:serverName];
}

- (LPDServer *)serverForName: (NSString *)serverName
{
  return [_dictionaryOfServer objectForKey:serverName];
}

- (NSString*)getDomainUrlForServerName:(NSString *)serverName
{
  LPDServer *serverConfig = [_dictionaryOfServer objectForKey:serverName];
  return [serverConfig getDomainUrlForEnvironment:_environment];
}

@end
