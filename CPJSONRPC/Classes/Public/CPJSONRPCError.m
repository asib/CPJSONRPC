//
//  CPJSONRPCError.m
//  Pods
//
//  Created by Jacob Fenton on 20/07/2016.
//
//

#import "CPJSONRPCError.h"
#import "CPJSONRPCDefines.h"
#import "CPJSONRPCPrivateDefines.h"

@interface CPJSONRPCError ()

@property (readwrite) NSNumber *code;
@property (readwrite) NSString *message;
@property (readwrite) id data;

@end

@implementation CPJSONRPCError

+ (instancetype)errorWithCode:(NSNumber *)code message:(NSString *)message data:(id)data error:(NSError *__autoreleasing *)err {
    if (code == nil) {
        *err = [NSError errorWithDomain:CPJSONRPC_DOMAIN code:CPJSONRPCObjectErrorInvalidErrorNilCode userInfo:nil];
        return nil;
    } else if (message == nil) {
        *err = [NSError errorWithDomain:CPJSONRPC_DOMAIN code:CPJSONRPCObjectErrorInvalidErrorNilMessage userInfo:nil];
        return nil;
    } else if (data == nil) {
        *err = [NSError errorWithDomain:CPJSONRPC_DOMAIN code:CPJSONRPCObjectErrorInvalidErrorNilData userInfo:nil];
        return nil;
    } else if (![data isKindOfClass:[NSString class]]     && // Boolean values must be NSNumber's using numberWithBool.
               ![data isKindOfClass:[NSNumber class]]     &&
               ![data isKindOfClass:[NSNull class]]       &&
               ![data isKindOfClass:[NSDictionary class]] &&
               ![data isKindOfClass:[NSArray class]]) {
        *err = [NSError errorWithDomain:CPJSONRPC_DOMAIN code:CPJSONRPCObjectErrorInvalidErrorInvalidDataType userInfo:nil];
        return nil;
    }
    
    CPJSONRPCError *rpcErr = [[CPJSONRPCError alloc] init];
    rpcErr.code = code;
    rpcErr.message = message;
    rpcErr.data = data;
    return rpcErr;
}

@end
