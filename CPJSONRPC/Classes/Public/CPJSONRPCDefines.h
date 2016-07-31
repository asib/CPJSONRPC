//
//  CPJSONRPCDefines.h
//  Pods
//
//  Created by Jacob Fenton on 19/07/2016.
//

#ifndef CPJSONRPCDefines_h
#define CPJSONRPCDefines_h

typedef NS_ENUM(NSInteger, CPJSONRPCParseError) {
    CPJSONRPCParseErrorInvalidVersion,
    CPJSONRPCParseErrorInvalidMessage,
};

typedef NS_ENUM(NSInteger, CPJSONRPCObjectError) {
    CPJSONRPCObjectErrorInvalidNotificationInvalidParamsType,
    CPJSONRPCObjectErrorInvalidNotificationNilMethod,
    CPJSONRPCObjectErrorInvalidRequestInvalidParamsType,
    CPJSONRPCObjectErrorInvalidRequestNilMethod,
    CPJSONRPCObjectErrorInvalidRequestNilId,
    CPJSONRPCObjectErrorInvalidResponse,
    CPJSONRPCObjectErrorInvalidResponseNilError,
    CPJSONRPCObjectErrorInvalidResponseInvalidResultType,
    CPJSONRPCObjectErrorInvalidResponseNilResult,
    CPJSONRPCObjectErrorInvalidResponseNilId,
    CPJSONRPCObjectErrorInvalidErrorInvalidDataType,
    CPJSONRPCObjectErrorInvalidErrorNilCode,
    CPJSONRPCObjectErrorInvalidErrorNilMessage,
};

#define JSON_RPC_VERSION @"2.0"

#define JSON_RPC_VERSION_KEY @"jsonrpc"
#define JSON_RPC_METHOD_KEY @"method"
#define JSON_RPC_PARAMS_KEY @"params"
#define JSON_RPC_ID_KEY @"id"
#define JSON_RPC_RESULT_KEY @"result"
#define JSON_RPC_ERROR_KEY @"error"
#define JSON_RPC_ERROR_CODE_KEY @"code"
#define JSON_RPC_ERROR_MESSAGE_KEY @"message"
#define JSON_RPC_ERROR_DATA_KEY @"data"

/**
 `CPJSONRPC_DOMAIN` is the value of the domain of any returned `NSError`.
 */
#define CPJSONRPC_DOMAIN @"org.cocoapods.CPJSONRPC"

/**
 `CPJSONRPCMessage` is an interface that `CPJSONRPCNotification`, `CPJSONRPCRequest`
 and `CPJSONRPCResponse` conform to. It's useful for defining functions that will
 accept/return one of these classes.
 */
@protocol CPJSONRPCMessage <NSObject>
/**
 Generate the JSON string for the object.
 
 @param err If an error occurs, upon return, will contain an `NSError` object that describes the problem.
 
 @return The object's JSON representation as a string.
 */
- (NSString*)createJSONStringAndReturnError:(NSError**)err;
@end

#endif /* CPJSONRPCDefines_h */
