//
//  NativeCrashObjectiveC.m
//  Runner
//
//  Created by Denis Andrašec on 21.11.20.
//

#import <Foundation/Foundation.h>

@interface NativeCrashObjectiveC : NSObject

+ (void)crashingFunction;

@end

@implementation NativeCrashObjectiveC

+ (void)crashingFunction {
    int* p = (int*)1;
    *p = 0; // EXC_BAD_ACCESS
}

@end
