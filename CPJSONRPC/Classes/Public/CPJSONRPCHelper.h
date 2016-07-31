//
//  CPJSONRPC.h
//  Pods
//
//  Created by Jacob Fenton on 18/07/2016.
//

#import <Foundation/Foundation.h>
#import "CPJSONRPCDefines.h"

/**
 `CPJSONRPCHelper` provides helper method(s) - not intended to be instantiated.
 */
@interface CPJSONRPCHelper : NSObject

/**
 Returns one of the CPJSONRPC classes, depending on what type of message
 is supplied. Callers must check the error before trying to use the returned class.
 
 @param incoming The message to be parsed.
 @param err If an error occurs, upon return, will contain an `NSError` object that describes the problem.
 
 @return A `CPJSONRPCMessage` object, one of `CPJSONRPCNotification`, `CPJSONRPCRequest` or `CPJSONRPCResponse`.
 */
+ (id<CPJSONRPCMessage>)parseIncoming:(NSString *)incoming error:(NSError *__autoreleasing *)err;

@end