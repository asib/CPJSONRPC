//
//  CPJSONRPCResponse.h
//  Pods
//
//  Created by Jacob Fenton on 19/07/2016.
//

#import <Foundation/Foundation.h>
#import "CPJSONRPCDefines.h"
#import "CPJSONRPCError.h"

@interface CPJSONRPCResponse : NSObject<CPJSONRPCMessage>

@property (strong, nonatomic, readonly) id result;
@property (strong, nonatomic, readonly) CPJSONRPCError *error;
@property (strong, nonatomic, readonly) NSNumber *msgId;

// Use these methods to create CPJSONRPCResponse objects. Do not try to create
// using alloc, init.
+ (instancetype)responseWithError:(CPJSONRPCError *)err msgId:(NSNumber *)msgId;
+ (instancetype)responseWithResult:(id)result msgId:(NSNumber *)msgId error:(NSError *__autoreleasing *)err;
- (BOOL)isError;
- (BOOL)isResult;
- (NSString *)createJSONStringAndReturnError:(NSError *__autoreleasing *)err;
+ (NSSet *)ValidAndExpectedResultKeys;
+ (NSSet *)ValidAndExpectedErrorKeys;

@end
