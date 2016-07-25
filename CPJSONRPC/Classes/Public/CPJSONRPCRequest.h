//
//  CPJSONRPCRequest.h
//  Pods
//
//  Created by Jacob Fenton on 19/07/2016.
//

#import <Foundation/Foundation.h>
#import "CPJSONRPCDefines.h"

@interface CPJSONRPCRequest : NSObject<CPJSONRPCMessage>

@property (strong, nonatomic, readonly) NSString *method;
@property (strong, nonatomic, readonly) id params;
@property (strong, nonatomic, readonly) NSNumber *msgId;

// Use this method to create CPJSONRPCRequest objects. Do no try to create with
// alloc, init.
+ (instancetype)requestWithMethod:(NSString *)method params:(id)params msgId:(NSNumber *)msgId error:(NSError *__autoreleasing *)err;
- (NSString *)createJSONStringAndReturnError:(NSError *__autoreleasing *)err;
+ (NSDictionary *)ValidAndExpectedKeys;

@end
