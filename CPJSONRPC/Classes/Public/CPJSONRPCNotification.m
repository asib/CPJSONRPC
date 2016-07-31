//
//  CPJSONRPCNotification.m
//  Pods
//
//  Created by Jacob Fenton on 19/07/2016.
//

#import "CPJSONRPCNotification.h"
#import "CPJSONRPCPrivateDefines.h"

@interface CPJSONRPCNotification ()

@property (readwrite) NSString *method;
@property (readwrite) id params;

@end

@implementation CPJSONRPCNotification

+ (instancetype)notificationWithMethod:(NSString *)method params:(id)params error:(NSError *__autoreleasing *)err {
    if (method == nil) {
        *err = [NSError errorWithDomain:CPJSONRPC_DOMAIN code:CPJSONRPCObjectErrorInvalidNotificationNilMethod userInfo:nil];
        return nil;
    } else if (params != nil                                &&
               ![params isKindOfClass:[NSDictionary class]] &&
               ![params isKindOfClass:[NSArray class]]) {
        *err = [NSError errorWithDomain:CPJSONRPC_DOMAIN code:CPJSONRPCObjectErrorInvalidNotificationInvalidParamsType userInfo:nil];
        return nil;
    }
    
    CPJSONRPCNotification *notif = [[CPJSONRPCNotification alloc] init];
    notif.method = method;
    notif.params = params;
    return notif;
}

- (NSString *)createJSONStringAndReturnError:(NSError *__autoreleasing *)err {
    NSMutableDictionary *notif = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  JSON_RPC_VERSION, JSON_RPC_VERSION_KEY,
                                  self.method, JSON_RPC_METHOD_KEY,
                                  nil];
    if (self.params != nil) {
        [notif setObject:self.params forKey:JSON_RPC_PARAMS_KEY];
    }
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:notif options:0 error:err]
                                 encoding:NSUTF8StringEncoding];
}

+ (NSDictionary *)ValidAndExpectedKeys {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithBool:YES], JSON_RPC_VERSION_KEY,
            [NSNumber numberWithBool:YES], JSON_RPC_METHOD_KEY,
            [NSNumber numberWithBool:NO], JSON_RPC_PARAMS_KEY,
            nil];
}

@end
