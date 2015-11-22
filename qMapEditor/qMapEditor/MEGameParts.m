//
// Created by Akinori ADACHI on 2014/06/07.
// Copyright (c) 2014 regalia. All rights reserved.
//

#import "MEGameParts.h"

@implementation MECategory

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.categoryName forKey:@"categoryName"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.categoryName = [decoder decodeObjectForKey:@"categoryName"];
    }
    return self;
}


+ (NSArray *)existCategories {
    return @[@"ALL",
            @"平原",
            @"洞窟",
            @"神殿",
            @"城内",
            @"飾り",
            @"飾り2",
            @"飾り3(樹木)",
            @"クリスタル",
            @"溶岩",
    ];;
}


@end

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

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.tileFilePath forKey:@"tileFilePath"];
    [encoder encodeObject:[NSValue valueWithRect:self.tileRect] forKey:@"tileRect"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self.tileFilePath = [decoder decodeObjectForKey:@"tileFilePath"];
    self.tileRect = [((NSValue *) [decoder decodeObjectForKey:@"tileRect"]) rectValue];
    return self;
}

@end

@implementation MEGameParts

static NSInteger idCounter = 1;

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.tiles forKey:@"tiles"];
    [encoder encodeObject:self.categories forKey:@"categories"];

    [encoder encodeBool:self.walkable forKey:@"walkable"];
    [encoder encodeBool:self.snow forKey:@"snow"];
    [encoder encodeInt:self.watertype forKey:@"waterType"];
    [encoder encodeFloat:(float) self.durationPerFrame forKey:@"durationPerFrame"];
    [encoder encodeObject:self.customEvents forKey:@"customEvents"];
    [encoder encodeObject:self.sampleImage forKey:@"sampleImage"];
    [encoder encodeObject:self.name forKey:@"name"];

    [encoder encodeBool:self.half forKey:@"half"];

    [encoder encodeInt:self.rezoTypeRect forKey:@"rezoTypeRect"];
    [encoder encodeInt:self.pavementType forKey:@"pavementType"];

    [encoder encodeObject:self.macroTypes forKey:@"macroTypes"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self.tiles = [decoder decodeObjectForKey:@"tiles"];
    self.walkable = [decoder decodeBoolForKey:@"walkable"];
    self.snow = [decoder decodeBoolForKey:@"snow"];
    self.watertype = [decoder decodeIntForKey:@"waterType"];
    self.durationPerFrame = [decoder decodeFloatForKey:@"durationPerFrame"];
    self.customEvents = [decoder decodeObjectForKey:@"customEvents"];
    self.sampleImage = [decoder decodeObjectForKey:@"sampleImage"];
    self.name = [decoder decodeObjectForKey:@"name"];

    self.half = [decoder decodeBoolForKey:@"half"];
    self.categories = [decoder decodeObjectForKey:@"categories"];

    self.rezoTypeRect = [decoder decodeIntForKey:@"rezoTypeRect"];
    self.pavementType = [decoder decodeIntForKey:@"pavementType"];

    self.macroTypes = [decoder decodeObjectForKey:@"macroTypes"];
    if (idCounter < [self.name intValue]) {
        idCounter = self.name.intValue;
    }
    return self;
}

// In the implementation
- (id)copyWithZone:(NSZone *)zone {
    // We'll ignore the zone for now
    MEGameParts *another = [[MEGameParts alloc] init];
    another.tiles = (NSMutableArray *) [[NSArray allocWithZone:zone] initWithArray:_tiles copyItems:YES];
    another.categories = (NSMutableArray *) [[NSArray allocWithZone:zone] initWithArray:_categories copyItems:YES];;
    another.name = [NSString stringWithFormat:@"%d", ++idCounter];
    another.walkable = _walkable;
    another.snow = _snow;
    another.watertype = _watertype;

    another.half = _half;
    another.rezoTypeRect = _rezoTypeRect;
    another.pavementType = _pavementType;
    another.macroTypes = _macroTypes;

    another.durationPerFrame = _durationPerFrame;
    another.customEvents = [[NSDictionary allocWithZone:zone] initWithDictionary:_customEvents];

    another.sampleImage = [[NSImageView allocWithZone:zone] initWithFrame:_sampleImage.frame];
    [another.sampleImage setImage:[_sampleImage.image copyWithZone:zone]];
    return another;
}

- (id)initWithTiles:(NSArray *)tiles
           walkable:(BOOL)walkable
          waterType:(WaterType)waterType
           duration:(CGFloat)duration
               half:(BOOL)half
           rezoType:(RezoTypeRect)rezoType
         categories:(NSArray *)categories
       pavementType:(PavementType)pavementType
         macroTypes:(NSMutableArray *)macroTypes
               snow:(BOOL)snow
       customEvents:(NSDictionary *)custom {

    if (self = [super init]) {
        _tiles = (NSMutableArray *) tiles;
        _categories = (NSMutableArray *) categories;
        _walkable = walkable;
        _watertype = waterType;
        _durationPerFrame = duration;
        _customEvents = custom;
        _pavementType = pavementType;
        _snow = snow;
        _half = half;
        _rezoTypeRect = rezoType;
        _pavementType = pavementType;
        _macroTypes = macroTypes;
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

- (void)initSampleImageWithKVO:(BOOL)notify {
    if (!_sampleImage) {
        METile *tile = [self.tiles lastObject];
        _sampleImage = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, tile.tileRect.size.width, tile.tileRect.size.height)];
        [_sampleImage setImage:[self image]];
    } else {
        if (notify) {
            [_sampleImage setImage:[self image]];
        }
    }
}


- (int)getCategoryInt{
    typedef enum {
        CategoryStep     = 14,
        CategoryMountain = 9,
        CategoryCave      = 8,
        CategoryShrine    = 7,
        CategoryTown      = 6,
        CategoryCastle    = 5,
    } gCategoryTYpe;

    if(!self.categories[0]){
        return 0;
    }
    NSString *category = self.categories[0];
    if([category isEqualToString:@"平原"]){
        return CategoryStep;
    }else if([category isEqualToString:@"溶岩"]){
        return CategoryMountain;
    }else if([category isEqualToString:@"洞窟"]){
        return CategoryCave;
    }else if([category isEqualToString:@"神殿"]){
        return CategoryShrine;
    }else if([category isEqualToString:@"城内"]){
        return CategoryCastle;
    }
    return 0;
}

- (void)refOf:(MEGameParts *)otherObj {
    self.tiles = nil;
    self.tiles = otherObj.tiles;
    self.walkable = otherObj.walkable;
    self.snow = otherObj.snow;
    self.watertype = otherObj.watertype;
    self.durationPerFrame = otherObj.durationPerFrame;
    self.customEvents = nil;
    self.customEvents = otherObj.customEvents;

    self.half = otherObj.half;
    self.rezoTypeRect = otherObj.rezoTypeRect;
    self.categories = nil;
    self.categories = otherObj.categories;

    self.macroTypes = otherObj.macroTypes;
    self.pavementType = otherObj.pavementType;

//    self.name = otherObj.name;
}

@end