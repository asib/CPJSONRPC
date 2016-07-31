//
//  CPJSONRPCResponse.h
//  Pods
//
//  Created by Jacob Fenton on 19/07/2016.
//

#import <Foundation/Foundation.h>
#import "CPJSONRPCDefines.h"
#import "CPJSONRPCError.h"

/**
 Holds all the information for a JSON-RPC response.
 */
@interface CPJSONRPCResponse : NSObject<CPJSONRPCMessage>

/**
 The response result.
 
 @warning Will be `nil` if `isError` returns `YES`.
 */
@property (strong, nonatomic, readonly) id result;

/**
 The response error.
 
 @warning Will be `nil` if `isResult` returns `YES`.
 */
@property (strong, nonatomic, readonly) CPJSONRPCError *error;

/**
 The ID of the request to which this response pertains.
 */
@property (strong, nonatomic, readonly) NSNumber *msgId;

/**
 Create a `CPJSONRPCResponse` with an error. Do not try to create using alloc, init.
 
 @param rpcErr The response error.
 @param msgId The ID of the request to which this response pertains.
 @param err If an error occurs, upon return, will contain an `NSError` object that describes the problem.
 
 @return A `CPJSONRPCResponse` with appropriately set properties.
 */
+ (instancetype)responseWithCPJSONRPCError:(CPJSONRPCError *)rpcErr msgId:(NSNumber *)msgId error:(NSError *__autoreleasing *)err;

/**
 Create a `CPJSONRPCResponse` with a result. Do not try to create using alloc, init.
 
 @param result The response result.
 @param msgId The ID of the request to which this response pertains.
 @param err If an error occurs, upon return, will contain an `NSError` object that describes the problem.
 
 @return A `CPJSONRPCResponse` with appropriately set properties.
 */
+ (instancetype)responseWithResult:(id)result msgId:(NSNumber *)msgId error:(NSError *__autoreleasing *)err;

/**
 Returns a `BOOL` indicating if this response is an error response.
 
 @return A `BOOL` which is `YES` if the response is an error response, else `NO`.
 */
- (BOOL)isError;

/**
 Returns a `BOOL` indicating if this response is a result response.
 
 @return A `BOOL` which is `YES` if the response is a result response, else `NO`.
 */
- (BOOL)isResult;

/**
 Generate the JSON string for the response.
 
 @param err If an error occurs, upon return, will contain an `NSError` object that describes the problem.
 
 @return The response's JSON representation as a string.
 */
- (NSString *)createJSONStringAndReturnError:(NSError *__autoreleasing *)err;

/**
 Returns a dictionary of all the possible fields in a JSON-RPC result response.
 Each field maps to a `BOOL`, which is `YES` if the field MUST exist, and `NO`
 if the field MAY be omitted. This method is used by `CPJSONRPCHelper` when parsing
 a message to determine if it's a valid result response.
 
 @return A dictionary of possible fields mapped to whether they MUST exist or not.
 */
+ (NSDictionary *)ValidAndExpectedResultKeys;

/**
 Returns a dictionary of all the possible fields in a JSON-RPC error response.
 Each field maps to a `BOOL`, which is `YES` if the field MUST exist, and `NO`
 if the field MAY be omitted. This method is used by `CPJSONRPCHelper` when parsing
 a message to determine if it's a valid error response.
 
 @return A dictionary of possible fields mapped to whether they MUST exist or not.
 */
+ (NSDictionary *)ValidAndExpectedErrorKeys;

@end
