//
//  CPJSONRPCRequest.h
//  Pods
//
//  Created by Jacob Fenton on 19/07/2016.
//

#import <Foundation/Foundation.h>
#import "CPJSONRPCDefines.h"

/**
 Holds all the information for a JSON-RPC request.
 */
@interface CPJSONRPCRequest : NSObject<CPJSONRPCMessage>

/**
 The remote method to be called.
 */
@property (strong, nonatomic, readonly) NSString *method;

/**
 The parameters to be passed to the remote method. May be `nil`.
 */
@property (strong, nonatomic, readonly) id params;

/**
 The ID of the request.
 
 @warning Must be unique.
 */
@property (strong, nonatomic, readonly) NSNumber *msgId;

/**
 Create a `CPJSONRPCRequest`. Do no try to create with alloc, init.
 
 @param method The remote method to be called.
 @param params The parameters to be passed to the remote method. May be `nil`.
 @param msgId The ID of the request.
 @param err If an error occurs, upon return, will contain an `NSError` object that describes the problem.
 
 @return A `CPJSONRPCRequest` with appropriately set properties.
 */
+ (instancetype)requestWithMethod:(NSString *)method params:(id)params msgId:(NSNumber *)msgId error:(NSError *__autoreleasing *)err;

/**
 Generate the JSON string for the request.
 
 @param err If an error occurs, upon return, will contain an `NSError` object that describes the problem.
 
 @return The request's JSON representation as a string.
 */
- (NSString *)createJSONStringAndReturnError:(NSError *__autoreleasing *)err;

/**
 Returns a dictionary of all the possible fields in a JSON-RPC request. Each
 field maps to a `BOOL`, which is `YES` if the field MUST exist, and `NO` if the
 field MAY be omitted. This method is used by `CPJSONRPCHelper` when parsing a
 message to determine if it's a valid request.
 
 @return A dictionary of possible fields mapped to whether they MUST exist or not.
 */
+ (NSDictionary *)ValidAndExpectedKeys;

@end
