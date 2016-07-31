//
//  CPJSONRPCNotification.h
//  Pods
//
//  Created by Jacob Fenton on 19/07/2016.
//

#import <Foundation/Foundation.h>
#import "CPJSONRPCDefines.h"

/**
 Holds all the information for a JSON-RPC notification, which is essentially a
 request that doesn't expect a response (and thus has no `id` property).
 */
@interface CPJSONRPCNotification : NSObject<CPJSONRPCMessage>

/**
 The remote method to be called.
 */
@property (strong, nonatomic, readonly) NSString *method;

/**
 The parameters to be passed to the remote method. May be `nil`.
 */
@property (strong, nonatomic, readonly) id params;

/**
 Create a `CPJSONRPCNotification`. Do no try to create with alloc, init.
 
 @param method The remote method to be called.
 @param params The parameters to be passed to the remote method. May be `nil`.
 @param err If an error occurs, upon return, will contain an `NSError` object that describes the problem.
 
 @return A `CPJSONRPCNotification` with appropriately set properties.
 */
+ (instancetype)notificationWithMethod:(NSString *)method params:(id)params error:(NSError *__autoreleasing *)err;

/**
 Generate the JSON string for the notification.
 
 @param err If an error occurs, upon return, will contain an `NSError` object that describes the problem.
 
 @return The notification's JSON representation as a string.
 */
- (NSString *)createJSONStringAndReturnError:(NSError *__autoreleasing *)err;

/**
 Returns a dictionary of all the possible fields in a JSON-RPC notification. Each
 field maps to a `BOOL`, which is `YES` if the field MUST exist, and `NO` if the
 field MAY be omitted. This method is used by `CPJSONRPCHelper` when parsing a
 message to determine if it's a valid notification.
 
 @return A dictionary of possible fields mapped to whether they MUST exist or not.
 */
+ (NSDictionary *)ValidAndExpectedKeys;

@end
