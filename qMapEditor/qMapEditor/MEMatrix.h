//
// Created by Akinori ADACHI on 2014/06/14.
// Copyright (c) 2014 regalia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MEMatrix : NSObject

- (id)initWithX:(NSInteger)x Y:(NSInteger)y Z:(NSInteger)z;

- (void)setX:(NSInteger)x Y:(NSInteger)y Z:(NSInteger)z;

@property NSInteger x;
@property NSInteger y;
@property NSInteger z;
@end