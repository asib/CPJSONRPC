//
//  CPJSONRPCNotification.h
//  Pods
//
//  Created by Jacob Fenton on 19/07/2016.
//

#import <Foundation/Foundation.h>
#import "CPJSONRPCDefines.h"

@interface CPJSONRPCNotification : NSObject<CPJSONRPCMessage>

@property (strong, nonatomic, readonly) NSString *method;
@property (strong, nonatomic, readonly) id params;

// Use this method to create CPJSONRPCNotification objects. Do no try to create
// with alloc, init.
+ (instancetype)notificationWithMethod:(NSString *)method params:(id)params error:(NSError *__autoreleasing *)err;
- (NSString *)createJSONStringAndReturnError:(NSError *__autoreleasing *)err;
+ (NSDictionary *)ValidAndExpectedKeys;

@end
