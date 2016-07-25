//
//  CPJSONRPCSpec.m
//  CPJSONRPC
//
//  Created by Jacob Fenton on 21/07/2016.
//

#import "Kiwi.h"
#import <CPJSONRPC/CPJSONRPC-umbrella.h>

SPEC_BEGIN(CPJSONRPCHelperSpec)
describe(@"CPJSONRPCHelper", ^{
    #define TEST_JSON_RPC_NOTIFICATION_METHOD @"test"
    #define TEST_JSON_RPC_NOTIFICATION_PARAMS @{@"key1":@"value1"}
    context(@"when parsing a valid JSON-RPC notification without params", ^{
        #define TEST_JSON_RPC_NOTIFICATION_WITHOUT_PARAMS @"{\"jsonrpc\": \"2.0\",\"method\": \"test\"}"
        NSError *err;
        id<CPJSONRPCMessage> notif = [CPJSONRPCHelper parseIncoming:TEST_JSON_RPC_NOTIFICATION_WITHOUT_PARAMS
                                                              error:&err];
        specify(^{
            [[(id)notif shouldNot] beNil];
        });
        it(@"should not return an error", ^{
            [[err should] beNil];
        });
        it(@"should return a valid CPJSONRPCNotification object", ^{
            [[[notif class] should] equal:[CPJSONRPCNotification class]];
            CPJSONRPCNotification *castNotif = (CPJSONRPCNotification *)notif;
            [[castNotif.method should] equal:TEST_JSON_RPC_NOTIFICATION_METHOD];
            [[castNotif.params should] beNil];
        });
    });
    context(@"when parsing a valid JSON-RPC notification with params", ^{
        #define TEST_JSON_RPC_NOTIFICATION_WITH_PARAMS @"{\"jsonrpc\": \"2.0\",\"method\": \"test\",\"params\": {\"key1\": \"value1\"}}"
        NSError *err;
        id<CPJSONRPCMessage> notif = [CPJSONRPCHelper parseIncoming:TEST_JSON_RPC_NOTIFICATION_WITH_PARAMS
                                                              error:&err];
        specify(^{
            [[(id)notif shouldNot] beNil];
        });
        it(@"should not return an error", ^{
            [[err should] beNil];
        });
        it(@"should return a valid CPJSONRPCNotification object", ^{
            [[[notif class] should] equal:[CPJSONRPCNotification class]];
            CPJSONRPCNotification *castNotif = (CPJSONRPCNotification *)notif;
            [[castNotif.method should] equal:TEST_JSON_RPC_NOTIFICATION_METHOD];
            [[castNotif.params should] equal:TEST_JSON_RPC_NOTIFICATION_PARAMS];
        });
    });
    
    #define TEST_JSON_RPC_REQUEST_METHOD @"test"
    #define TEST_JSON_RPC_REQUEST_PARAMS @{@"key1":@"value1"}
    #define TEST_JSON_RPC_REQUEST_ID @0
    context(@"when parsing a valid JSON-RPC request without params", ^{
        #define TEST_JSON_RPC_REQUEST_WITHOUT_PARAMS @"{\"jsonrpc\": \"2.0\",\"method\": \"test\",\"id\": 0}"
        NSError *err;
        id<CPJSONRPCMessage> req = [CPJSONRPCHelper parseIncoming:TEST_JSON_RPC_REQUEST_WITHOUT_PARAMS
                                                            error:&err];
        specify(^{
            [[(id)req shouldNot] beNil];
        });
        it(@"should not return an error", ^{
            [[err should] beNil];
        });
        it(@"should return a valid CPJSONRPCRequest object", ^{
            [[[req class] should] equal:[CPJSONRPCRequest class]];
            CPJSONRPCRequest *castReq = (CPJSONRPCRequest *)req;
            [[castReq.method should] equal:TEST_JSON_RPC_REQUEST_METHOD];
            [[castReq.params should] beNil];
            [[castReq.msgId should] equal:TEST_JSON_RPC_REQUEST_ID];
        });
    });
    context(@"when parsing a valid JSON-RPC request with params", ^{
        #define TEST_JSON_RPC_REQUEST_WITH_PARAMS @"{\"jsonrpc\": \"2.0\",\"method\": \"test\",\"params\": {\"key1\": \"value1\"},\"id\": 0}"
        NSError *err;
        id<CPJSONRPCMessage> req = [CPJSONRPCHelper parseIncoming:TEST_JSON_RPC_REQUEST_WITH_PARAMS
                                                            error:&err];
        specify(^{
            [[(id)req shouldNot] beNil];
        });
        it(@"should not return an error", ^{
            [[err should] beNil];
        });
        it(@"should return a valid CPJSONRPCRequest object", ^{
            [[[req class] should] equal:[CPJSONRPCRequest class]];
            CPJSONRPCRequest *castReq = (CPJSONRPCRequest *)req;
            [[castReq.method should] equal:TEST_JSON_RPC_REQUEST_METHOD];
            [[castReq.params should] equal:TEST_JSON_RPC_REQUEST_PARAMS];
            [[castReq.msgId should] equal:TEST_JSON_RPC_REQUEST_ID];
        });
    });
    
    #define TEST_JSON_RPC_RESPONSE_RESULT_RESULT @{@"key1":@"value1"}
    #define TEST_JSON_RPC_RESPONSE_ERROR_CODE @0
    #define TEST_JSON_RPC_RESPONSE_ERROR_MESSAGE @"test message"
    #define TEST_JSON_RPC_RESPONSE_ERROR_DATA @{@"key1":@"value1"}
    #define TEST_JSON_RPC_RESPONSE_ID @0
    context(@"when parsing a valid JSON-RPC error response without data", ^{
        #define TEST_JSON_RPC_RESPONSE_ERROR_WITHOUT_DATA @"{\"jsonrpc\": \"2.0\",\"error\": {\"code\": 0,\"message\": \"test message\"},\"id\": 0}"
        NSError *err;
        id<CPJSONRPCMessage> resp = [CPJSONRPCHelper parseIncoming:TEST_JSON_RPC_RESPONSE_ERROR_WITHOUT_DATA
                                                             error:&err];
        specify(^{
            [[(id)resp shouldNot] beNil];
        });
        it(@"should not return an error", ^{
            [[err should] beNil];
        });
        it(@"should return a valid CPJSONRPCResponse error object", ^{
            [[[resp class] should] equal:[CPJSONRPCResponse class]];
            CPJSONRPCResponse *castResp = (CPJSONRPCResponse *)resp;
            [[theValue([castResp isError]) should] beYes];
            [[theValue([castResp isResult]) should] beNo];
            [[castResp should] haveValue:@0 forKey:@"_type"];
            [[castResp.result should] beNil];
            [[castResp.error.code should] equal:TEST_JSON_RPC_RESPONSE_ERROR_CODE];
            [[castResp.error.message should] equal:TEST_JSON_RPC_RESPONSE_ERROR_MESSAGE];
            [[castResp.error.data should] beNil];
        });
    });
    context(@"when parsing a valid JSON-RPC error response with data", ^{
        #define TEST_JSON_RPC_RESPONSE_ERROR_WITH_DATA @"{\"jsonrpc\": \"2.0\",\"error\": {\"code\": 0,\"message\": \"test message\",\"data\": {\"key1\": \"value1\"}},\"id\": 0}"
        NSError *err;
        id<CPJSONRPCMessage> resp = [CPJSONRPCHelper parseIncoming:TEST_JSON_RPC_RESPONSE_ERROR_WITH_DATA
                                                             error:&err];
        specify(^{
            [[(id)resp shouldNot] beNil];
        });
        it(@"should not return an error", ^{
            [[err should] beNil];
        });
        it(@"should return a valid CPJSONRPCResponse error object", ^{
            [[[resp class] should] equal:[CPJSONRPCResponse class]];
            CPJSONRPCResponse *castResp = (CPJSONRPCResponse *)resp;
            [[theValue([castResp isError]) should] beYes];
            [[theValue([castResp isResult]) should] beNo];
            [[castResp should] haveValue:@0 forKey:@"_type"];
            [[castResp.result should] beNil];
            [[castResp.error.code should] equal:TEST_JSON_RPC_RESPONSE_ERROR_CODE];
            [[castResp.error.message should] equal:TEST_JSON_RPC_RESPONSE_ERROR_MESSAGE];
            [[castResp.error.data should] equal:TEST_JSON_RPC_RESPONSE_ERROR_DATA];
        });
    });
    context(@"when parsing a valid JSON-RPC result response", ^{
        #define TEST_JSON_RPC_RESPONSE_RESULT @"{\"jsonrpc\": \"2.0\",\"result\": {\"key1\": \"value1\"},\"id\": 0}"
        NSError *err;
        id<CPJSONRPCMessage> resp = [CPJSONRPCHelper parseIncoming:TEST_JSON_RPC_RESPONSE_RESULT
                                                             error:&err];
        specify(^{
            [[(id)resp shouldNot] beNil];
        });
        it(@"should not return an error", ^{
            [[err should] beNil];
        });
        it(@"should return a valid CPJSONRPCResponse result object", ^{
            [[[resp class] should] equal:[CPJSONRPCResponse class]];
            CPJSONRPCResponse *castResp = (CPJSONRPCResponse *)resp;
            [[theValue([castResp isResult]) should] beYes];
            [[theValue([castResp isError]) should] beNo];
            [[castResp should] haveValue:@1 forKey:@"_type"];
            [[castResp.error should] beNil];
            [[castResp.result shouldNot] beNil];
        });
    });
    
    context(@"when parsing an malformed JSON-RPC notification", ^{
        #define TEST_JSON_RPC_MALFORMED_NOTIFICATION @"{\"jsonrpc\": \"2.0\",\"method\": \"test\",\"unexpected\":null}"
        NSError *err;
        id<CPJSONRPCMessage> msg = [CPJSONRPCHelper parseIncoming:TEST_JSON_RPC_MALFORMED_NOTIFICATION
                                                            error:&err];
        specify(^{
            [[(id)msg should] beNil];
        });
        it(@"should return an error with code CPJSONRPCParseErrorInvalidMessage", ^{
            [[err shouldNot] beNil];
            [[err.domain should] equal:CPJSONRPC_DOMAIN];
            [[theValue(err.code) should] equal:theValue(CPJSONRPCParseErrorInvalidMessage)];
        });
    });
    context(@"when parsing a malformed JSON-RPC request", ^{
        #define TEST_JSON_RPC_MALFORMED_REQUEST_WITH_PARAMS @"{\"jsonrpc\": \"2.0\",\"method\": \"test\",\"params\": {\"key1\": \"value1\"},\"id\": 0,\"unexpected\": null}"
        NSError *err;
        id<CPJSONRPCMessage> msg = [CPJSONRPCHelper parseIncoming:TEST_JSON_RPC_MALFORMED_REQUEST_WITH_PARAMS
                                                            error:&err];
        specify(^{
            [[(id)msg should] beNil];
        });
        it(@"should return an error with code CPJSONRPCParseErrorInvalidMessage", ^{
            [[err shouldNot] beNil];
            [[err.domain should] equal:CPJSONRPC_DOMAIN];
            [[theValue(err.code) should] equal:theValue(CPJSONRPCParseErrorInvalidMessage)];
        });
    });
    context(@"when parsing a malformed JSON-RPC error response", ^{
        #define TEST_JSON_RPC_MALFORMED_RESPONSE_ERROR_WITH_DATA @"{\"jsonrpc\": \"2.0\",\"error\": {\"code\": 0,\"message\": \"test message\",\"data\": {\"key1\": \"value1\"},\"unexpected\": null},\"id\": 0}"
        NSError *err;
        id<CPJSONRPCMessage> msg = [CPJSONRPCHelper parseIncoming:TEST_JSON_RPC_MALFORMED_RESPONSE_ERROR_WITH_DATA
                                                            error:&err];
        specify(^{
            [[(id)msg should] beNil];
        });
        it(@"should return an error with code CPJSONRPCParseErrorInvalidMessage", ^{
            [[err shouldNot] beNil];
            [[err.domain should] equal:CPJSONRPC_DOMAIN];
            [[theValue(err.code) should] equal:theValue(CPJSONRPCParseErrorInvalidMessage)];
        });
    });
});
SPEC_END

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

SPEC_BEGIN(CPJSONRPCNotificationSpec)
describe(@"CPJSONRPCNotification", ^{
    #define TEST_NOTIFICATION_METHOD @"test"
    #define TEST_NOTIFICATION_PARAMS @{@"key1":@"value1", @"key2":@"value2"}
    context(@"when created with valid arguments", ^{
        NSError *err = nil;
        CPJSONRPCNotification *notif = [CPJSONRPCNotification notificationWithMethod:TEST_NOTIFICATION_METHOD
                                                                              params:TEST_NOTIFICATION_PARAMS
                                                                               error:&err];
        specify(^{
            [[notif shouldNot] beNil];
        });
        it(@"should have a nil return error", ^{
            [[err should] beNil];
        });
        it(@"should have correctly set properties", ^{
            [[notif.method should] equal:TEST_NOTIFICATION_METHOD];
            [[notif.params should] equal:TEST_NOTIFICATION_PARAMS];
        });
    });
    context(@"when created with a nil method", ^{
        NSError *err;
        CPJSONRPCNotification *notif = [CPJSONRPCNotification notificationWithMethod:nil
                                                                              params:TEST_NOTIFICATION_PARAMS
                                                                               error:&err];
        specify(^{
            [[notif should] beNil];
        });
        it(@"should return a CPJSONRPCObjectErrorInvalidNotificationNilMethod", ^{
            [[err.domain should] equal:CPJSONRPC_DOMAIN];
            [[theValue(err.code) should] equal:theValue(CPJSONRPCObjectErrorInvalidNotificationNilMethod)];
        });
    });
    context(@"when created with nil params", ^{
        NSError *err;
        CPJSONRPCNotification *notif = [CPJSONRPCNotification notificationWithMethod:TEST_NOTIFICATION_METHOD
                                                                              params:nil
                                                                               error:&err];
        specify(^{
            [[notif shouldNot] beNil];
        });
        it(@"should not return an error", ^{
            [[err should] beNil];
        });
    });
    context(@"when marshalled to JSON then unmarshalled", ^{
        NSError *err;
        CPJSONRPCNotification *notif = [CPJSONRPCNotification notificationWithMethod:TEST_NOTIFICATION_METHOD
                                                                              params:TEST_NOTIFICATION_PARAMS
                                                                               error:&err];
        NSString *notifJSON = [notif createJSONStringAndReturnError:&err];
        CPJSONRPCNotification *parsedNotif = (CPJSONRPCNotification *)[CPJSONRPCHelper parseIncoming:notifJSON
                                                                                               error:&err];
        it(@"should be unchanged", ^{
            [[parsedNotif.method should] equal:notif.method];
            [[parsedNotif.params should] equal:notif.params];
        });
    });
});
SPEC_END


////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////


SPEC_BEGIN(CPJSONRPCRequestSpec)
describe(@"CPJSONRPCRequest", ^{
    #define TEST_REQUEST_METHOD @"test"
    #define TEST_REQUEST_PARAMS @{@"key1":@"value1", @"key2":@"value2"}
    #define TEST_REQUEST_ID @0
    context(@"when created with nil params", ^{
        NSError *err;
        CPJSONRPCRequest *req = [CPJSONRPCRequest requestWithMethod:TEST_REQUEST_METHOD
                                                             params:nil
                                                              msgId:TEST_REQUEST_ID
                                                              error:&err];
        specify(^{
            [[req shouldNot] beNil];
        });
        it(@"should not return an error", ^{
            [[err should] beNil];
        });
        it(@"should have correctly set properties", ^{
            [[req.method should] equal:TEST_REQUEST_METHOD];
            [[req.params should] beNil];
            [[req.msgId should] equal:TEST_REQUEST_ID];
        });
    });
    context(@"when created with non-nil params", ^{
        NSError *err;
        CPJSONRPCRequest *req = [CPJSONRPCRequest requestWithMethod:TEST_REQUEST_METHOD
                                                             params:TEST_REQUEST_PARAMS
                                                              msgId:TEST_REQUEST_ID
                                                              error:&err];
        specify(^{
            [[req shouldNot] beNil];
        });
        it(@"should not return an error", ^{
            [[err should] beNil];
        });
        it(@"should have correctly set properties", ^{
            [[req.method should] equal:TEST_REQUEST_METHOD];
            [[req.params should] equal:TEST_REQUEST_PARAMS];
            [[req.msgId should] equal:TEST_REQUEST_ID];
        });
    });
});
SPEC_END


////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////


SPEC_BEGIN(CPJSONRPCResponseSpec)
describe(@"CPJSONRPCResponse", ^{
    #define TEST_RESPONSE_ID @0
    context(@"when created as an error", ^{
        #define TEST_RESPONSE_ERROR_CODE @0
        #define TEST_RESPONSE_ERROR_MSG @""
        #define TEST_RESPONSE_ERROR_DATA @{}
        NSError *err;
        CPJSONRPCError *rpcErr = [CPJSONRPCError errorWithCode:TEST_RESPONSE_ERROR_CODE
                                                       message:TEST_RESPONSE_ERROR_MSG
                                                          data:TEST_RESPONSE_ERROR_DATA
                                                         error:&err];
        CPJSONRPCResponse *resp = [CPJSONRPCResponse responseWithCPJSONRPCError:rpcErr
                                                                          msgId:TEST_RESPONSE_ID
                                                                          error:&err];
        specify(^{
            [[resp shouldNot] beNil];
        });
        it(@"should have a nil result", ^{
            [[resp.result should] beNil];
        });
        it(@"should have correctly set properties", ^{
            [[resp.error.code should] equal:rpcErr.code];
            [[resp.error.message should] equal:rpcErr.message];
            [[resp.error.data should] equal:rpcErr.data];
            [[resp.msgId should] equal:TEST_RESPONSE_ID];
            [[resp should] haveValue:@0 forKey:@"_type"];
        });
    });
    context(@"when created as a result", ^{
        #define TEST_RESPONSE_RESULT_RESULT @{@"key1": @"value1"}
        NSError *err;
        CPJSONRPCResponse *resp = [CPJSONRPCResponse responseWithResult:TEST_RESPONSE_RESULT_RESULT
                                                                  msgId:TEST_RESPONSE_ID
                                                                  error:&err];
        specify(^{
            [[resp shouldNot] beNil];
        });
        it(@"should have a nil error", ^{
            [[resp.error should] beNil];
        });
        it(@"should have correctly set properties", ^{
            [[resp.result should] equal:TEST_RESPONSE_RESULT_RESULT];
            [[resp.msgId should] equal:TEST_RESPONSE_ID];
        });
    });
});
SPEC_END

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

SPEC_BEGIN(CPJSONRPCErrorSpec)
describe(@"CPJSONRPCError", ^{
    #define TEST_ERROR_CODE @0
    #define TEST_ERROR_MESSAGE @"test message"
    #define TEST_ERROR_DATA @{@"key1":@"value1"}
    context(@"when created with non-nil data", ^{
        NSError *err;
        CPJSONRPCError *rpcErr = [CPJSONRPCError errorWithCode:TEST_ERROR_CODE
                                                       message:TEST_ERROR_MESSAGE
                                                          data:TEST_ERROR_DATA
                                                         error:&err];
        specify(^{
            [[rpcErr shouldNot] beNil];
        });
        it(@"should not return an error", ^{
            [[err should] beNil];
        });
        it(@"should have correctly set properties", ^{
            [[rpcErr.code should] equal:TEST_ERROR_CODE];
            [[rpcErr.message should] equal:TEST_ERROR_MESSAGE];
            [[rpcErr.data should] equal:TEST_ERROR_DATA];
        });
    });
    context(@"when created with nil data", ^{
        NSError *err;
        CPJSONRPCError *rpcErr = [CPJSONRPCError errorWithCode:TEST_ERROR_CODE
                                                       message:TEST_ERROR_MESSAGE
                                                          data:nil
                                                         error:&err];
        specify(^{
            [[rpcErr shouldNot] beNil];
        });
        it(@"should not return an error", ^{
            [[err should] beNil];
        });
        it(@"should have correctly set properties", ^{
            [[rpcErr.code should] equal:TEST_ERROR_CODE];
            [[rpcErr.message should] equal:TEST_ERROR_MESSAGE];
            [[rpcErr.data should] beNil];
        });
    });
});
SPEC_END