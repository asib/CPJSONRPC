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
    // Boolean values must be NSNumber's using numberWithBool.
    if (![data isKindOfClass:[NSString class]]     &&
        ![data isKindOfClass:[NSNumber class]]     &&
        ![data isKindOfClass:[NSNull class]]       &&
        ![data isKindOfClass:[NSDictionary class]] &&
        ![data isKindOfClass:[NSArray class]]) {
        *err = [NSError errorWithDomain:CPJSONRPC_DOMAIN code:CPJSONRPCObjectErrorInvalidError userInfo:nil];
        return nil;
    }
    
    CPJSONRPCError *rpcErr = [[CPJSONRPCError alloc] init];
    rpcErr.code = code;
    rpcErr.message = message;
    rpcErr.data = data;
    return rpcErr;
}

@end
