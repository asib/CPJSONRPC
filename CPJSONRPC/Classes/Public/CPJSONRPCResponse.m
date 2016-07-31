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

+ (instancetype)responseWithCPJSONRPCError:(CPJSONRPCError *)rpcErr msgId:(NSNumber *)msgId error:(NSError *__autoreleasing *)err {
    if (rpcErr == nil) {
        *err = [NSError errorWithDomain:CPJSONRPC_DOMAIN code:CPJSONRPCObjectErrorInvalidResponseNilError userInfo:nil];
        return nil;
    } else if (msgId == nil) {
        *err = [NSError errorWithDomain:CPJSONRPC_DOMAIN code:CPJSONRPCObjectErrorInvalidResponseNilId userInfo:nil];
        return nil;
    }
    
    CPJSONRPCResponse *resp = [[CPJSONRPCResponse alloc] init];
    resp.error = rpcErr;
    resp.msgId = msgId;
    resp->_type = CPJSONRPCResponseError;
    return resp;
}

+ (instancetype)responseWithResult:(id)result msgId:(NSNumber *)msgId error:(NSError *__autoreleasing *)err {
    if (result == nil) { // Must use NSNull if you want to represent null value.
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
                                 self.msgId, JSON_RPC_ID_KEY,
                                 nil];
    
    // Not allowed both result and error fields - must have one or the other.
    if (self.result != nil && self.error == nil) {
        [resp setObject:self.result forKey:JSON_RPC_RESULT_KEY];
    } else if (self.error != nil && self.result == nil) {
        NSMutableDictionary *rpcErr = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       self.error.code, JSON_RPC_ERROR_CODE_KEY,
                                       self.error.message, JSON_RPC_ERROR_MESSAGE_KEY,
                                       nil];
        if (self.error.data != nil) {
            [rpcErr setObject:self.error.data forKey:JSON_RPC_ERROR_DATA_KEY];
        }
        [resp setObject:rpcErr forKey:JSON_RPC_ERROR_KEY];
    } else {
        *err = [NSError errorWithDomain:CPJSONRPC_DOMAIN code:CPJSONRPCObjectErrorInvalidResponse userInfo:nil];
        return nil;
    }
    
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:resp options:0 error:err]
                                 encoding:NSUTF8StringEncoding];
}

+ (NSDictionary *)ValidAndExpectedErrorKeys {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithBool:YES], JSON_RPC_VERSION_KEY,
            [NSNumber numberWithBool:YES], JSON_RPC_ERROR_KEY,
            [NSNumber numberWithBool:YES], JSON_RPC_ID_KEY,
            nil];
}

+ (NSDictionary *)ValidAndExpectedResultKeys {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithBool:YES], JSON_RPC_VERSION_KEY,
            [NSNumber numberWithBool:YES], JSON_RPC_RESULT_KEY,
            [NSNumber numberWithBool:YES], JSON_RPC_ID_KEY,
            nil];
}

@end
