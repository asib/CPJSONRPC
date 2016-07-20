//
//  CPJSONRPC.h
//  Pods
//
//  Created by Jacob Fenton on 18/07/2016.
//

#import <Foundation/Foundation.h>
#import "CPJSONRPCDefines.h"

// A class providing helper methods - not intended to be instantiated.
@interface CPJSONRPCHelper : NSObject

// Returns one of the CPJSONRPC classes, depending on what type of message
// is supplied. Callers must check the error before trying to use the returned class.
+ (id<CPJSONRPCMessage>)parseIncoming:(NSString *)incoming error:(NSError *__autoreleasing *)err;

@end