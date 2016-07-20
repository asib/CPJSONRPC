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
    if (![params isKindOfClass:[NSDictionary class]] &&
        ![params isKindOfClass:[NSArray class]]) {
        *err = [NSError errorWithDomain:CPJSONRPC_DOMAIN code:CPJSONRPCObjectErrorInvalidNotification userInfo:nil];
        return nil;
    }
    
    CPJSONRPCNotification *notif = [[CPJSONRPCNotification alloc] init];
    notif.method = method;
    notif.params = params;
    return notif;
}

- (NSString *)createJSONStringAndReturnError:(NSError *__autoreleasing *)err {
    NSDictionary *notif = [NSDictionary dictionaryWithObjectsAndKeys:
                           JSON_RPC_VERSION, JSON_RPC_VERSION_KEY,
                           self.method, JSON_RPC_METHOD_KEY,
                           self.params, JSON_RPC_PARAMS_KEY,
                           nil];
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:notif options:0 error:err]
                                 encoding:NSUTF8StringEncoding];
}

+ (NSSet *)ValidAndExpectedKeys {
    return [NSSet setWithObjects:JSON_RPC_METHOD_KEY, JSON_RPC_PARAMS_KEY, nil];
}

@end
