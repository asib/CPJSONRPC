//
//  CPJSONRPCRequest.m
//  Pods
//
//  Created by Jacob Fenton on 19/07/2016.
//

#import "CPJSONRPCRequest.h"
#import "CPJSONRPCPrivateDefines.h"

@interface CPJSONRPCRequest ()

@property (readwrite) NSString *method;
@property (readwrite) id params;
@property (readwrite) NSNumber *msgId;

@end

@implementation CPJSONRPCRequest

+ (instancetype)requestWithMethod:(NSString *)method params:(id)params msgId:(NSNumber *)msgId error:(NSError *__autoreleasing *)err {
    if (method == nil) {
        *err = [NSError errorWithDomain:CPJSONRPC_DOMAIN code:CPJSONRPCObjectErrorInvalidRequestNilMethod userInfo:nil];
        return nil;
    } else if (msgId == nil) {
        *err = [NSError errorWithDomain:CPJSONRPC_DOMAIN code:CPJSONRPCObjectErrorInvalidRequestNilId userInfo:nil];
        return nil;
    } else if (params != nil &&
               ![params isKindOfClass:[NSDictionary class]] &&
               ![params isKindOfClass:[NSArray class]]) {
        *err = [NSError errorWithDomain:CPJSONRPC_DOMAIN code:CPJSONRPCObjectErrorInvalidRequestInvalidParamsType userInfo:nil];
        return nil;
    }
    
    CPJSONRPCRequest *req = [[CPJSONRPCRequest alloc] init];
    req.method = method;
    req.params = params;
    req.msgId = msgId;
    return req;
}

- (NSString *)createJSONStringAndReturnError:(NSError *__autoreleasing *)err {
    NSMutableDictionary *req = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                JSON_RPC_VERSION, JSON_RPC_VERSION_KEY,
                                self.method, JSON_RPC_METHOD_KEY,
                                self.msgId, JSON_RPC_ID_KEY,
                                nil];
    if (self.params != nil) {
        [req setObject:self.params forKey:JSON_RPC_PARAMS_KEY];
    }
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:req options:0 error:err]
                                 encoding:NSUTF8StringEncoding];
}

+ (NSDictionary *)ValidAndExpectedKeys {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithBool:YES], JSON_RPC_VERSION_KEY,
            [NSNumber numberWithBool:YES], JSON_RPC_METHOD_KEY,
            [NSNumber numberWithBool:NO], JSON_RPC_PARAMS_KEY,
            [NSNumber numberWithBool:YES], JSON_RPC_ID_KEY,
            nil];
}

@end
