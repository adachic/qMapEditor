//
// Created by Akinori ADACHI on 2014/06/07.
// Copyright (c) 2014 regalia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface METile : NSObject <NSCopying, NSCoding>{
}
@property NSURL *tileFilePath;
@property CGRect tileRect;

- (id)initWithURL:(NSURL *)filePath rect:(CGRect)rect;
- (void)encodeWithCoder:(NSCoder *)encoder;
- (id)initWithCoder:(NSCoder *)decoder;

- (NSImage *)image;
@end


@interface MEGameParts : NSObject <NSCopying, NSCoding> {
}
@property NSMutableArray *tiles;
@property BOOL walkable;
@property CGFloat durationPerFrame;
@property NSDictionary *customEvents;
@property NSImageView *sampleImage;
@property NSString *name;

//- (id)initWithParams:(BOOL)walkable imageView:(NSImageView*)imageView1 customEvents:(NSDictionary *)customEvents;
//@property NSImageView *imageView;
- (void)encodeWithCoder:(NSCoder *)encoder;
- (id)initWithTiles:(NSArray *)tiles
           walkable:(BOOL)walkable
           duration:(CGFloat)duration
       customEvents:(NSDictionary *)custom;
- (NSImage *)image;
- (void)initSampleImageWithKVO:(BOOL)notify;
- (void)refOf:(MEGameParts *)otherObj;

@end