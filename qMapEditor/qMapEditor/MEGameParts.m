//
// Created by Akinori ADACHI on 2014/06/07.
// Copyright (c) 2014 regalia. All rights reserved.
//

#import "MEGameParts.h"

@implementation METile

- (id)initWithURL:(NSURL *)filePath rect:(CGRect)rect {
    if (self = [super init]) {
        _tileFilePath = filePath;
        _tileRect = rect;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    METile *another = [[METile alloc] init];
    another.tileFilePath = [_tileFilePath copyWithZone:zone];
    another.tileRect = _tileRect;
    return another;
}

- (NSImage *)image {
    NSImage *image = [[NSImage alloc] initByReferencingURL:self.tileFilePath];
    NSImage *imageFrom = [[NSImage alloc] initByReferencingURL:self.tileFilePath];
    [image setSize:self.tileRect.size];
    [image lockFocus];
    [imageFrom drawInRect:CGRectMake(0, 0, self.tileRect.size.width, self.tileRect.size.height)
                 fromRect:self.tileRect
                operation:NSCompositeCopy
                 fraction:1.0f];
    [image unlockFocus];
    return image;
}

@end

@implementation MEGameParts

/*
- (id)initWithParams:(BOOL)walkable1 imageView:(NSImageView*)imageView1 customEvents:(NSDictionary *)customEvents1{
    if(self = [super init]){
        walkable = walkable1;
        self.imageView = [[NSImageView alloc] initWithFrame:imageView1.frame];
        [self.imageView setImage:[[imageView1 image] copy]];
        customEvents = customEvents1;
    }
    return self;
}
*/

static NSInteger idCounter = 0;

// In the implementation
- (id)copyWithZone:(NSZone *)zone {
    // We'll ignore the zone for now
    MEGameParts *another = [[MEGameParts alloc] init];
    another.tiles = [[NSArray allocWithZone:zone] initWithArray:_tiles copyItems:YES];
    another.name = [NSString stringWithFormat:@"%d", ++idCounter];
    another.walkable = _walkable;
    another.durationPerFrame = _durationPerFrame;
    another.customEvents = [[NSDictionary allocWithZone:zone] initWithDictionary:_customEvents];

    another.sampleImage = [[NSImageView allocWithZone:zone] initWithFrame:_sampleImage.frame];
    [another.sampleImage setImage:[_sampleImage.image copyWithZone:zone]];

    return another;
}

- (id)initWithTiles:(NSArray *)tiles
           walkable:(BOOL)walkable
           duration:(CGFloat)duration
       customEvents:(NSDictionary *)custom {
    if (self = [super init]) {
        _tiles = tiles;
        _walkable = walkable;
        _durationPerFrame = duration;
        _customEvents = custom;
        _name = [NSString stringWithFormat:@"%d", ++idCounter];
    }
    return self;
}

- (NSImage *)image {
    METile *tile = [self.tiles lastObject];
    NSAssert(tile, @"GAMEPARTS:tile should not nil");
    NSImage *image = [[NSImage alloc] initByReferencingURL:tile.tileFilePath];
    NSImage *imageFrom = [[NSImage alloc] initByReferencingURL:tile.tileFilePath];
    [image setSize:tile.tileRect.size];
    [image lockFocus];
    [imageFrom drawInRect:CGRectMake(0, 0, tile.tileRect.size.width, tile.tileRect.size.height)
                 fromRect:tile.tileRect
                operation:NSCompositeCopy
                 fraction:1.0f];
    [image unlockFocus];
    return image;
}

- (void)initSampleImageWithKVO:(BOOL)notify{
    if (!_sampleImage) {
        METile *tile = [self.tiles lastObject];
        _sampleImage = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, tile.tileRect.size.width, tile.tileRect.size.height)];
        [_sampleImage setImage:[self image]];
    }else{
        if(notify){
            [_sampleImage setImage:[self image]];
        }
    }
}

@end