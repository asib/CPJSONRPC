//
//  CPJSONRPCError.h
//  Pods
//
//  Created by Jacob Fenton on 20/07/2016.
//
//

#import <Foundation/Foundation.h>

@interface CPJSONRPCError : NSObject

@property (strong, nonatomic, readonly) NSNumber *code;
@property (strong, nonatomic, readonly) NSString *message;
@property (strong, nonatomic, readonly) id data;

+ (instancetype)errorWithCode:(NSNumber *)code message:(NSString *)message data:(id)data error:(NSError *__autoreleasing *)err;

@end
