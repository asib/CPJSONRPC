//
//  CPJSONRPCResponse.m
//  Pods
//
//  Created by Jacob Fenton on 19/07/2016.]
//

#import "CPJSONRPCResponse.h"
#import "CPJSONRPCPrivateDefines.h"

typedef NS_ENUM(NSInteger, CPJSONRPCResponseType) {
    CPJSONRPCResponseError,
    CPJSONRPCResponseResult
};

@interface CPJSONRPCResponse () {
    @private
    CPJSONRPCResponseType _type;
}

@property (readwrite) id result;
@property (readwrite) CPJSONRPCError *error;
@property (readwrite) NSNumber *msgId;

@end

@implementation CPJSONRPCResponse

+ (instancetype)responseWithError:(CPJSONRPCError *)err msgId:(NSNumber *)msgId {
    CPJSONRPCResponse *resp = [[CPJSONRPCResponse alloc] init];
    resp.error = err;
    resp.msgId = msgId;
    resp->_type = CPJSONRPCResponseError;
    return resp;
}

+ (instancetype)responseWithResult:(id)result msgId:(NSNumber *)msgId error:(NSError *__autoreleasing *)err {
    if (result == nil) {
        *err = [NSError errorWithDomain:CPJSONRPC_DOMAIN code:CPJSONRPCObjectErrorInvalidResponseNilResult userInfo:nil];
        return nil;
    } else if (msgId == nil) {
        *err = [NSError errorWithDomain:CPJSONRPC_DOMAIN code:CPJSONRPCObjectErrorInvalidResponseNilId userInfo:nil];
        return nil;
    } else if (![result isKindOfClass:[NSString class]]     && // Boolean values must be NSNumber's using numberWithBool.
               ![result isKindOfClass:[NSNumber class]]     &&
               ![result isKindOfClass:[NSNull class]]       &&
               ![result isKindOfClass:[NSDictionary class]] &&
               ![result isKindOfClass:[NSArray class]]) {
        *err = [NSError errorWithDomain:CPJSONRPC_DOMAIN code:CPJSONRPCObjectErrorInvalidResponseInvalidResultType userInfo:nil];
        return nil;
    }
    
    CPJSONRPCResponse *resp = [[CPJSONRPCResponse alloc] init];
    resp.result = result;
    resp.msgId = msgId;
    resp->_type = CPJSONRPCResponseResult;
    return resp;
}

- (BOOL)isError {
    return self->_type == CPJSONRPCResponseError ? YES : NO;
}

- (BOOL)isResult {
    return ![self isError];
}

- (NSString *)createJSONStringAndReturnError:(NSError *__autoreleasing *)err {
    NSMutableDictionary *resp = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 JSON_RPC_VERSION, JSON_RPC_VERSION_KEY,
                                 nil];
    
    // Not allowed both result and error fields - must have one or the other.
    if (self.result != nil && self.error == nil) {
        [resp setObject:self.result forKey:JSON_RPC_RESULT_KEY];
    } else if (self.error != nil && self.result == nil) {
        NSDictionary *rpcErr = [NSDictionary dictionaryWithObjectsAndKeys:
                                JSON_RPC_ERROR_CODE_KEY, self.error.code,
                                JSON_RPC_ERROR_MESSAGE_KEY, self.error.message,
                                JSON_RPC_ERROR_DATA_KEY, self.error.data,
                                nil];
        [resp setObject:rpcErr forKey:JSON_RPC_ERROR_KEY];
    } else {
        *err = [NSError errorWithDomain:CPJSONRPC_DOMAIN code:CPJSONRPCObjectErrorInvalidResponse userInfo:nil];
        return nil;
    }
    
    [resp setObject:JSON_RPC_ID_KEY forKey:self.msgId];
    
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:resp options:0 error:err]
                                 encoding:NSUTF8StringEncoding];
}

+ (NSSet *)ValidAndExpectedErrorKeys {
    return [NSSet setWithObjects:JSON_RPC_ERROR_KEY, JSON_RPC_ID_KEY, nil];
}

+ (NSSet *)ValidAndExpectedResultKeys {
    return [NSSet setWithObjects:JSON_RPC_RESULT_KEY, JSON_RPC_ID_KEY, nil];
}

@end
