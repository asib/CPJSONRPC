//
//  CPJSONRPC.m
//  Pods
//
//  Created by Jacob Fenton on 18/07/2016.
//

#import "CPJSONRPCHelper.h"
#import "CPJSONRPCDefines.h"
#import "CPJSONRPCPrivateDefines.h"
#import "CPJSONRPCNotification.h"
#import "CPJSONRPCRequest.h"
#import "CPJSONRPCResponse.h"
#import "CPJSONRPCError.h"

@implementation CPJSONRPCHelper

// Returns one of the CPJSONRPC classes, depending on what type the of message
// is supplied. Callers must check the error before trying to use the returned class.
+ (id<CPJSONRPCMessage>)parseIncoming:(NSString *)incoming error:(NSError *__autoreleasing *)err {
    NSDictionary *incomingDictionaryTemp = [NSJSONSerialization JSONObjectWithData:[incoming dataUsingEncoding:NSUTF8StringEncoding]
                                                                           options:0
                                                                             error:err];
    if (*err != nil) {
        return nil;
    }
    NSMutableDictionary *incomingDictionary = [NSMutableDictionary dictionaryWithDictionary:incomingDictionaryTemp];
    
    // Make sure version exists and is valid.
    NSString *version = [incomingDictionary objectForKey:JSON_RPC_VERSION_KEY];
    if (version == nil || ![version isEqualToString:JSON_RPC_VERSION]) {
        *err = [NSError errorWithDomain:CPJSONRPC_DOMAIN code:CPJSONRPCParseErrorInvalidVersion userInfo:nil];
        return nil;
    }
    
    // No need for RPC version now, so we remove it.
    [incomingDictionary removeObjectForKey:JSON_RPC_VERSION_KEY];
    
    // Dispatch the message off to the relevant handler, or return an error if
    // the request isn't valid.
    if ([[CPJSONRPCNotification ValidAndExpectedKeys] isEqualToSet:[NSSet setWithArray:incomingDictionary.allKeys]]) {
        return [CPJSONRPCHelper handleIncomingNotification:incomingDictionary error:err];
    } else if ([[CPJSONRPCRequest ValidAndExpectedKeys] isEqualToSet:[NSSet setWithArray:incomingDictionary.allKeys]]) {
        return [CPJSONRPCHelper handleIncomingRequest:incomingDictionary error:err];
    } else if ([[CPJSONRPCResponse ValidAndExpectedErrorKeys] isEqualToSet:[NSSet setWithArray:incomingDictionary.allKeys]]) {
        return [CPJSONRPCHelper handleIncomingResponseError:incomingDictionary error:err];
    } else if ([[CPJSONRPCResponse ValidAndExpectedResultKeys] isEqualToSet:[NSSet setWithArray:incomingDictionary.allKeys]]) {
        return [CPJSONRPCHelper handleIncomingResponseResult:incomingDictionary error:err];
    }
    
    // If none of the above caught the message, return an error.
    *err = [NSError errorWithDomain:CPJSONRPC_DOMAIN code:CPJSONRPCParseErrorInvalidRequest userInfo:nil];
    return nil;
}

// I've made these methods in case I think of some specific handling that might
// need to be done. They'll possibly be deleted if they remain redundant.

+ (CPJSONRPCNotification *)handleIncomingNotification:(NSDictionary *)notification error:(NSError **)err {
    return [CPJSONRPCNotification notificationWithMethod:[notification objectForKey:JSON_RPC_METHOD_KEY]
                                                  params:[notification objectForKey:JSON_RPC_PARAMS_KEY]
                                                   error:err];
}

+ (CPJSONRPCRequest *)handleIncomingRequest:(NSDictionary*)request error:(NSError**)err {
    return [CPJSONRPCRequest requestWithMethod:[request objectForKey:JSON_RPC_METHOD_KEY]
                                        params:[request objectForKey:JSON_RPC_PARAMS_KEY]
                                         msgId:[request objectForKey:JSON_RPC_ID_KEY]
                                         error:err];
}

+ (CPJSONRPCResponse *)handleIncomingResponseError:(NSDictionary *)response error:(NSError **)err {
    NSDictionary *rawRPCError = [response objectForKey:JSON_RPC_ERROR_KEY];
    CPJSONRPCError *rpcError = [CPJSONRPCError errorWithCode:[rawRPCError objectForKey:JSON_RPC_ERROR_CODE_KEY]
                                                     message:[rawRPCError objectForKey:JSON_RPC_ERROR_MESSAGE_KEY]
                                                        data:[rawRPCError objectForKey:JSON_RPC_ERROR_DATA_KEY]
                                                       error:err];
    if (*err != nil) {
        return nil;
    }
    return [CPJSONRPCResponse responseWithError:rpcError
                                          msgId:[response objectForKey:JSON_RPC_ID_KEY]];
}

+ (CPJSONRPCResponse *)handleIncomingResponseResult:(NSDictionary *)response error:(NSError **)err {
    return [CPJSONRPCResponse responseWithResult:[response objectForKey:JSON_RPC_RESULT_KEY]
                                           msgId:[response objectForKey:JSON_RPC_ID_KEY]
                                           error:err];
}

@end
