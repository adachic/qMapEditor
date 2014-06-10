//
// Created by Akinori ADACHI on 2014/06/07.
// Copyright (c) 2014 regalia. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MEGameParts : NSObject <NSCopying>
{
//    NSImageView *imageView;
    BOOL walkable;
    NSDictionary *customEvents;
}

- (id)initWithParams:(BOOL)walkable imageView:(NSImageView*)imageView1 customEvents:(NSDictionary *)customEvents;
@property NSImageView *imageView;

@end