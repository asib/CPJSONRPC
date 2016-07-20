//
//  CPJSONRPCViewController.m
//  CPJSONRPC
//
//  Created by Jacob Fenton on 07/20/2016.
//  Copyright (c) 2016 Jacob Fenton. All rights reserved.
//

#import "CPJSONRPCViewController.h"
@import CPJSONRPC;

@interface CPJSONRPCViewController ()

@end

@implementation CPJSONRPCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ///////////////////////////////////////////////////////
    /////////////////// Making messages ///////////////////
    ///////////////////////////////////////////////////////
	
    // Create request object.
    NSError *reqErr = nil;
    CPJSONRPCRequest *req = [CPJSONRPCRequest requestWithMethod:@"test"
                                                         params:@{@"user":@"asib",
                                                                  @"pass":@"password12345"}
                                                          msgId:@1
                                                          error:&reqErr];
    if (reqErr != nil) {
        if (reqErr.code == CPJSONRPCObjectErrorInvalidRequest) {
            NSLog(@"Invalid Request!");
        }
        NSLog(@"Req Err: %@", reqErr);
        return;
    }
    
    // Get JSON request string.
    NSString *reqJSONString = [req createJSONStringAndReturnError:&reqErr];
    if (reqErr != nil) {
        NSLog(@"Req Err: %@", reqErr);
        return;
    }
    
    // Log the request string.
    NSLog(@"Request: %@", reqJSONString);
    
    
    
    ///////////////////////////////////////////////////////
    ////////////// Handling incoming messages /////////////
    ///////////////////////////////////////////////////////
    
    NSError *incomingErr = nil;
    NSString *incomingMsg = @"{\"jsonrpc\": \"2.0\", \"method\": \"test\", \"params\": {\"user\": \"asib\", \"pass\": \"password12345\"}, \"id\": 1}";
    
    // Parse the string into an object that conforms to CPJSONRPCMessage.
    // We will use reflection below to work out what kind of message this is.
    id<CPJSONRPCMessage> incomingObj = [CPJSONRPCHelper parseIncoming:incomingMsg error:&incomingErr];
    if (incomingErr != nil) {
        NSLog(@"Inc Err: %@", incomingErr);
        return;
    }
    
    if ([incomingObj isKindOfClass:[CPJSONRPCNotification class]]) {
        CPJSONRPCNotification *incomingNotif = (CPJSONRPCNotification *)incomingObj;
        NSLog(@"NOTIFICATION\nMethod: %@\nParams: %@", incomingNotif.method, incomingNotif.params);
    } else if ([incomingObj isKindOfClass:[CPJSONRPCRequest class]]) {
        CPJSONRPCRequest *incomingReq = (CPJSONRPCRequest *)incomingObj;
        NSLog(@"REQUEST\nMethod: %@\nParams: %@\nId: %@", incomingReq.method, incomingReq.params, incomingReq.msgId);
    } else if ([incomingObj isKindOfClass:[CPJSONRPCResponse class]]) {
        CPJSONRPCResponse *incomingResp = (CPJSONRPCResponse *)incomingObj;
        if ([incomingResp isResult]) {
            NSLog(@"RESPONSE\nResult: %@\nId: %@", incomingResp.result, incomingResp.msgId);
        } else if ([incomingResp isError]) {
            NSLog(@"RESPONSE\nError: %@\nId: %@", incomingResp.error, incomingResp.msgId);
        } else {
            // This shouldn't be possible when using parseIncoming:error:, because
            // that method will ensure that one of isResult or isError is true,
            // or else return an error, which would be handled above.
            NSLog(@"Someone screwed up...");
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
