//
//  CPJSONRPCError.h
//  Pods
//
//  Created by Jacob Fenton on 20/07/2016.
//
//

#import <Foundation/Foundation.h>

/**
 Holds all the information for a JSON-RPC response error.
 */
@interface CPJSONRPCError : NSObject

/**
 The error's code.
 */
@property (strong, nonatomic, readonly) NSNumber *code;

/**
 The error's message.
 */
@property (strong, nonatomic, readonly) NSString *message;

/**
 The error's data. May be `nil`.
 */
@property (strong, nonatomic, readonly) id data;

/**
 Create a `CPJSONRPCError`. Do not try to create using alloc, init.
 
 @param code The error's code
 @param message The error's message
 @param data The error's data. May be `nil`.
 @param err If an error occurs, upon return, will contain an `NSError` object that describes the problem.
 
 @return A `CPJSONRPCError` with appropriately set properties.
 */
+ (instancetype)errorWithCode:(NSNumber *)code message:(NSString *)message data:(id)data error:(NSError *__autoreleasing *)err;

/**
 Returns a dictionary of all the possible fields in a JSON-RPC response error. Each
 field maps to a `BOOL`, which is `YES` if the field MUST exist, and `NO` if the
 field MAY be omitted. This method is used by `CPJSONRPCHelper` when parsing a
 response to determine if it's a valid response error.
 
 @return A dictionary of possible fields mapped to whether they MUST exist or not.
 */
+ (NSDictionary *)ValidAndExpectedKeys;

@end
