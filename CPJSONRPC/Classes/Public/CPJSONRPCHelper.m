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
    
    if ([CPJSONRPCHelper incomingKeyset:incomingDictionary.allKeys doesComplyWithValidAndExpectedKeyset:[CPJSONRPCNotification ValidAndExpectedKeys]]) {
        return [CPJSONRPCHelper handleIncomingNotification:incomingDictionary error:err];
    } else if ([CPJSONRPCHelper incomingKeyset:incomingDictionary.allKeys doesComplyWithValidAndExpectedKeyset:[CPJSONRPCRequest ValidAndExpectedKeys]]) {
        return [CPJSONRPCHelper handleIncomingRequest:incomingDictionary error:err];
    } else if ([CPJSONRPCHelper incomingKeyset:incomingDictionary.allKeys doesComplyWithValidAndExpectedKeyset:[CPJSONRPCResponse ValidAndExpectedErrorKeys]]) {
        return [CPJSONRPCHelper handleIncomingResponseError:incomingDictionary error:err];
    } else if ([CPJSONRPCHelper incomingKeyset:incomingDictionary.allKeys doesComplyWithValidAndExpectedKeyset:[CPJSONRPCResponse ValidAndExpectedResultKeys]]) {
        return [CPJSONRPCHelper handleIncomingResponseResult:incomingDictionary error:err];
    }
    
    // If none of the above caught the message, return an error.
    *err = [NSError errorWithDomain:CPJSONRPC_DOMAIN code:CPJSONRPCParseErrorInvalidMessage userInfo:nil];
    return nil;
}

+ (BOOL)incomingKeyset:(NSArray *)incomingKeys doesComplyWithValidAndExpectedKeyset:(NSDictionary *)expectedKeys {
    // Make sure all expected keys are present.
    for (NSString *key in expectedKeys) {
        BOOL isExpected = [[expectedKeys objectForKey:key] boolValue];
        if (isExpected && ![incomingKeys containsObject:key]) {
            return NO;
        }
    }
    
    // Make sure no unexpected keys are present.
    for (NSString *key in incomingKeys) {
        BOOL expected = [expectedKeys objectForKey:key] != nil ? YES : NO;
        if (!expected) {
            return NO;
        }
    }
    
    return YES;
}

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
    // Make sure only the expected keys in the error object are present.
    NSDictionary *rawRPCError = [response objectForKey:JSON_RPC_ERROR_KEY];
    if ([CPJSONRPCHelper incomingKeyset:rawRPCError.allKeys doesComplyWithValidAndExpectedKeyset:[CPJSONRPCError ValidAndExpectedKeys]]) {
        CPJSONRPCError *rpcError = [CPJSONRPCError errorWithCode:[rawRPCError objectForKey:JSON_RPC_ERROR_CODE_KEY]
                                                         message:[rawRPCError objectForKey:JSON_RPC_ERROR_MESSAGE_KEY]
                                                            data:[rawRPCError objectForKey:JSON_RPC_ERROR_DATA_KEY]
                                                           error:err];
        if (*err != nil) {
            return nil;
        }
        return [CPJSONRPCResponse responseWithCPJSONRPCError:rpcError
                                                       msgId:[response objectForKey:JSON_RPC_ID_KEY]
                                                       error:err];
    }
    
    // If the error object is malformed, return an error.
    *err = [NSError errorWithDomain:CPJSONRPC_DOMAIN
                               code:CPJSONRPCParseErrorInvalidMessage
                           userInfo:nil];
    return nil;
}

+ (CPJSONRPCResponse *)handleIncomingResponseResult:(NSDictionary *)response error:(NSError **)err {
    return [CPJSONRPCResponse responseWithResult:[response objectForKey:JSON_RPC_RESULT_KEY]
                                           msgId:[response objectForKey:JSON_RPC_ID_KEY]
                                           error:err];
}

@end
