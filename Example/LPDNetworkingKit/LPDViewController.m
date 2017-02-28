//
//  LPDViewController.m
//  LPDNetworkingKit
//
//  Created by foxsofter on 12/02/2016.
//  Copyright (c) 2016 foxsofter. All rights reserved.
//

#import "LPDViewController.h"
#import <LPDNetworkingKit/LPDNetworkingKit.h>

@interface LPDViewController ()

@end

@implementation LPDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    LPDApiServer *server = [[LPDApiServer alloc] init];
    [server setServerUrl:@"https://httpbin.org/" forServerType:LPDApiServerTypeBeta];
    
    LPDApiClient *client = [[LPDApiClient alloc] initWithServer:server];
    RACSignal *signalOne = [client rac_POST:@"/post" parameters:@{}];
    
    [signalOne subscribeNext:^(id  _Nullable x) {
        NSLog(@"Ok: %@", x);
    }];
    
    [signalOne subscribeError:^(NSError * _Nullable error) {
        NSLog(@"Error: %@", error.description);
    }];
    
    [signalOne subscribeCompleted:^{
        NSLog(@"Complete: Finish");
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
