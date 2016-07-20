//
//  CPJSONRPCSpec.m
//  CPJSONRPC
//
//  Created by Jacob Fenton on 21/07/2016.
//

#import "Kiwi.h"
#import <CPJSONRPC/CPJSONRPCDefines.h>
#import <CPJSONRPC/CPJSONRPCNotification.h>

SPEC_BEGIN(CPJSONRPCNotificationSpec)
describe(@"The CPJSONRPCNotification", ^{
    context(@"when created with valid arguments", ^{
        NSString *method = @"test";
        NSDictionary *params = @{@"key":@"value"};
        NSError *err = nil;
        CPJSONRPCNotification *notif = [CPJSONRPCNotification notificationWithMethod:method
                                                                              params:params
                                                                               error:&err];
        specify(^{
            [[notif shouldNot] beNil];
        });
        it(@"should have a nil error", ^{
            [[err should] beNil];
        });
        it(@"should have correctly set properties", ^{
            [[notif.method should] equal:method];
            [[notif.params should] equal:params];
        });
    });
    context(@"when marshalled to JSON", ^{
        
    });
});
SPEC_END


////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////


SPEC_BEGIN(CPJSONRPCRequestSpec)

SPEC_END


////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////


SPEC_BEGIN(CPJSONRPCResponseSpec)
describe(@"The CPJSONRPCResponse", ^{
    context(@"when created as an error", ^{
        xit(@"should have a nil result", ^{
            
        });
    });
    context(@"when created as a result", ^{
        xit(@"should have a nil error", ^{
            
        });
    });
});
SPEC_END