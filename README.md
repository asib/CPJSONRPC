# CPJSONRPC

[![CI Status](http://img.shields.io/travis/asib/CPJSONRPC.svg?style=flat)](https://travis-ci.org/asib/CPJSONRPC)
[![Version](https://img.shields.io/cocoapods/v/CPJSONRPC.svg?style=flat)](http://cocoapods.org/pods/CPJSONRPC)
[![License](https://img.shields.io/cocoapods/l/CPJSONRPC.svg?style=flat)](http://cocoapods.org/pods/CPJSONRPC)
[![Platform](https://img.shields.io/cocoapods/p/CPJSONRPC.svg?style=flat)](http://cocoapods.org/pods/CPJSONRPC)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

You can also run `pod try CPJSONRPC` to download the pod to a temp location, install its dependencies and open the demo project.

## Installation

CPJSONRPC is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CPJSONRPC'
```

Then, run the following command:

```bash
$ pod install
```

You should now be able to import CPJSONRPC in your project using

```objective-c
@import CPJSONRPC;
```

or if you wish to import a specific header, e.g. `CPJSONRPCRequest.h`, use

```objective-c
#import <CPJSONRPC/CPJSONRPCRequest.h>
```

## API

### CPJSONRPCMessage Protocol

```objective-c
@protocol CPJSONRPCMessage <NSObject>
// All of CPJSONRPCNotification, CPJSONRPCRequest and CPJSONRPCResponse implement
// this protocol.
// CPJSONRPCError doesn't, because it is only ever included as part of a JSON-RPC
// response (and thus a CPJSONRPCError is marshalled during the marshalling of
// the CPJSONRPCResponse that it's attached to).
- (NSString*)createJSONStringAndReturnError:(NSError**)err;
@end
```

### CPJSONRPCHelper

```objective-c
@interface CPJSONRPCHelper : NSObject

// Returns one of the CPJSONRPC classes, depending on what type of message
// is supplied. Callers must check the error before trying to use the returned class.
+ (id<CPJSONRPCMessage>)parseIncoming:(NSString *)incoming error:(NSError *__autoreleasing *)err;

@end
```

### CPJSONRPCNotification

```objective-c
@interface CPJSONRPCNotification : NSObject<CPJSONRPCMessage>

@property (strong, nonatomic, readonly) NSString *method;
@property (strong, nonatomic, readonly) id params;

// Use this method to create CPJSONRPCNotification objects. Do no try to create
// with alloc, init. Using this method ensures that all required fields are set.
+ (instancetype)notificationWithMethod:(NSString *)method params:(id)params error:(NSError *__autoreleasing *)err;

// Get the JSON-RPC string using this method.
- (NSString *)createJSONStringAndReturnError:(NSError *__autoreleasing *)err;

// This class method is used by CPJSONRPCHelper when parsing a message to
// determine if the message is a notification.
// It returns a set of all the fields that should be present in a JSON-RPC
// notification, excluding the "jsonrpc" field, which is present in all messages
// (CPJSONRPCHelper checks this field separately).
+ (NSSet *)ValidAndExpectedKeys;

@end
```

### CPJSONRPCRequest

```objective-c
@interface CPJSONRPCRequest : NSObject<CPJSONRPCMessage>

@property (strong, nonatomic, readonly) NSString *method;
@property (strong, nonatomic, readonly) id params;
@property (strong, nonatomic, readonly) NSNumber *msgId;

// Use this method to create CPJSONRPCRequest objects. Do no try to create with
// alloc, init. Using this method ensures that all the required fields are set.
+ (instancetype)requestWithMethod:(NSString *)method params:(id)params msgId:(NSNumber *)msgId error:(NSError *__autoreleasing *)err;

// Get the JSON-RPC string using this method.
- (NSString *)createJSONStringAndReturnError:(NSError *__autoreleasing *)err;

// This class method is used by CPJSONRPCHelper when parsing a message to
// determine if the message is a request.
// It returns a set of all the fields that should be present in a JSON-RPC
// request, excluding the "jsonrpc" field, which is present in all messages
// (CPJSONRPCHelper checks this field separately).
+ (NSSet *)ValidAndExpectedKeys;

@end
```

### CPJSONRPCResponse

```objective-c
@interface CPJSONRPCResponse : NSObject<CPJSONRPCMessage>

@property (strong, nonatomic, readonly) id result;
@property (strong, nonatomic, readonly) CPJSONRPCError *error;
@property (strong, nonatomic, readonly) NSNumber *msgId;

// Use these methods to create CPJSONRPCResponse objects. Do not try to create
// using alloc, init. Using these methods ensures we don't violate the JSON-RPC
// protocol by including both "result" and "error" fields, and that all required
// fields are set.
+ (instancetype)responseWithError:(CPJSONRPCError *)err msgId:(NSNumber *)msgId;
+ (instancetype)responseWithResult:(id)result msgId:(NSNumber *)msgId error:(NSError *__autoreleasing *)err;

// These methods allow quick identification of whether a CPJSONRPCResponse is
// an error or result response.
- (BOOL)isError;
- (BOOL)isResult;

// Get the JSON-RPC string using this method.
- (NSString *)createJSONStringAndReturnError:(NSError *__autoreleasing *)err;

// These class methods are used by CPJSONRPCHelper when parsing a message to
// determine if the message is a response, and what type of response it is.
// It returns a set of all the fields that should be present in a JSON-RPC
// They return sets of all the fields that should be present in JSON-RPC
// error/result responses, excluding the "jsonrpc" field, which is present in
// all messages (CPJSONRPCHelper checks this field separately).
+ (NSSet *)ValidAndExpectedResultKeys;
+ (NSSet *)ValidAndExpectedErrorKeys;

@end
```

### CPJSONRPCError

```objective-c
@interface CPJSONRPCError : NSObject

@property (strong, nonatomic, readonly) NSNumber *code;
@property (strong, nonatomic, readonly) NSString *message;
@property (strong, nonatomic, readonly) id data;

// Use this method to create CPJSONRPCError objects. Do not try to create using
// alloc, init. Using this method ensures all the required fields are set.
+ (instancetype)errorWithCode:(NSNumber *)code message:(NSString *)message data:(id)data error:(NSError *__autoreleasing *)err;

@end
```

### CPJSONRPCDefines.h

```objective-c
// CPJSONRPCParseError's are thrown by CPJSONRPCHelper's parseIncoming:error:
// method.
typedef NS_ENUM(NSInteger, CPJSONRPCParseError) {
    CPJSONRPCParseErrorInvalidVersion,
    CPJSONRPCParseErrorInvalidRequest,
    CPJSONRPCParseErrorInvalidResponse,
};

// CPJSONRPCObjectError's are thrown by the actual classes, generally in the
// methods that create CPJSONRPCMessage-conforming objects.
typedef NS_ENUM(NSInteger, CPJSONRPCObjectError) {
    CPJSONRPCObjectErrorInvalidNotificationInvalidParamsType,
    CPJSONRPCObjectErrorInvalidNotificationNilMethod,
    CPJSONRPCObjectErrorInvalidNotificationNilParams,
    CPJSONRPCObjectErrorInvalidRequestInvalidParamsType,
    CPJSONRPCObjectErrorInvalidRequestNilMethod,
    CPJSONRPCObjectErrorInvalidRequestNilParams,
    CPJSONRPCObjectErrorInvalidRequestNilId,
    CPJSONRPCObjectErrorInvalidResponse,
    CPJSONRPCObjectErrorInvalidResponseInvalidResultType,
    CPJSONRPCObjectErrorInvalidResponseNilResult,
    CPJSONRPCObjectErrorInvalidResponseNilId,
    CPJSONRPCObjectErrorInvalidErrorInvalidDataType,
    CPJSONRPCObjectErrorInvalidErrorNilCode,
    CPJSONRPCObjectErrorInvalidErrorNilMessage,
    CPJSONRPCObjectErrorInvalidErrorNilData,
};

// All JSON-RPC messages should contain "jsonrpc" : "2.0"
#define JSON_RPC_VERSION @"2.0"

// These are all the JSON-RPC fields.
#define JSON_RPC_VERSION_KEY @"jsonrpc"
#define JSON_RPC_METHOD_KEY @"method"
#define JSON_RPC_PARAMS_KEY @"params"
#define JSON_RPC_ID_KEY @"id"
#define JSON_RPC_RESULT_KEY @"result"
#define JSON_RPC_ERROR_KEY @"error"
#define JSON_RPC_ERROR_CODE_KEY @"code"
#define JSON_RPC_ERROR_MESSAGE_KEY @"message"
#define JSON_RPC_ERROR_DATA_KEY @"data"

// Check the domain of any returned errors using this define.
#define CPJSONRPC_DOMAIN @"org.cocoapods.CPJSONRPC"
```

## Unit Tests

I'm working on writing some...

## Author

Jacob Fenton, jacob.d.fenton@gmail.com

## License

CPJSONRPC is available under the MIT license. See the LICENSE file for more info.
