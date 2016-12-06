//
//  SafeObject.m
//  BarrageRenderer_demo
//
//  Created by 张昭 on 06/12/2016.
//  Copyright © 2016 张昭. All rights reserved.
//

#import "SafeObject.h"

@interface SafeObject ()

@property (nonatomic, assign) SEL sel;
@property (nonatomic, weak) id object;

@end

@implementation SafeObject

- (instancetype)initWithObject:(id)object {
    if (self = [super init]) {
        _sel = nil;
        _object = object;
    }
    return self;
}

- (instancetype)initWithObject:(id)object withSelector:(SEL)selector {
    if (self = [super init]) {
        _sel = selector;
        _object = object;
    }
    return self;
}

- (void)excute
{
    if (_object && _sel && [_object respondsToSelector:_sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_object performSelector:_sel withObject:nil];
#pragma clang diagnostic pop
    }
}


@end
