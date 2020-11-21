//
//  NativeCrashObjectiveC.m
//  Runner
//
//  Created by Denis Andrašec on 21.11.20.
//

#import <Foundation/Foundation.h>

@interface NativeCrashObjectiveC : NSObject

+ (void)crashingMethod;

@end

@implementation NativeCrashObjectiveC

+ (void)crashingFunction {
    NSString *string = nil;
    [string length];
}

@end
