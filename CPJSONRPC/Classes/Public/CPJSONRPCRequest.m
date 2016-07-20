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
    if (![params isKindOfClass:[NSDictionary class]] &&
        ![params isKindOfClass:[NSArray class]]) {
        *err = [NSError errorWithDomain:CPJSONRPC_DOMAIN code:CPJSONRPCObjectErrorInvalidRequest userInfo:nil];
        return nil;
    }
    
    CPJSONRPCRequest *req = [[CPJSONRPCRequest alloc] init];
    req.method = method;
    req.params = params;
    req.msgId = msgId;
    return req;
}

- (NSString *)createJSONStringAndReturnError:(NSError *__autoreleasing *)err {
    NSDictionary *req = [NSDictionary dictionaryWithObjectsAndKeys:
                         JSON_RPC_VERSION, JSON_RPC_VERSION_KEY,
                         self.method, JSON_RPC_METHOD_KEY,
                         self.params, JSON_RPC_PARAMS_KEY,
                         self.msgId, JSON_RPC_ID_KEY,
                         nil];
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:req options:0 error:err]
                                 encoding:NSUTF8StringEncoding];
}

+ (NSSet *)ValidAndExpectedKeys {
    return [NSSet setWithObjects:JSON_RPC_METHOD_KEY, JSON_RPC_PARAMS_KEY, JSON_RPC_ID_KEY, nil];
}

@end
