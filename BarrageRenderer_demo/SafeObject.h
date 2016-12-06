//
//  SafeObject.h
//  BarrageRenderer_demo
//
//  Created by 张昭 on 06/12/2016.
//  Copyright © 2016 张昭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SafeObject : NSObject

- (instancetype)initWithObject:(id)object;
- (instancetype)initWithObject:(id)object withSelector:(SEL)selector;
- (void)excute;

@end
