//
//  CPJSONRPCDefines.h
//  Pods
//
//  Created by Jacob Fenton on 19/07/2016.
//

#ifndef CPJSONRPCDefines_h
#define CPJSONRPCDefines_h

// CPJSONRPCParseError's are thrown by CPJSONRPCHelper's parseIncoming:error:
// method.
typedef enum {
    CPJSONRPCParseErrorInvalidVersion,
    CPJSONRPCParseErrorInvalidRequest,
    CPJSONRPCParseErrorInvalidResponse,
} CPJSONRPCParseError;

// CPJSONRPCObjectError's are thrown by the actual classes.
typedef enum {
    CPJSONRPCObjectErrorInvalidNotification,
    CPJSONRPCObjectErrorInvalidRequest,
    CPJSONRPCObjectErrorInvalidResponse,
    CPJSONRPCObjectErrorInvalidError,
} CPJSONRPCObjectError;

typedef enum {
    CPJSONRPCIncomingNotification,
    CPJSONRPCIncomingRequest,
    CPJSONRPCIncomingResponseResult,
    CPJSONRPCIncomingResponseError
} CPJSONRPCIncoming;

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

@protocol CPJSONRPCMessage <NSObject>

- (NSString*)createJSONStringAndReturnError:(NSError**)err;

@end

#endif /* CPJSONRPCDefines_h */