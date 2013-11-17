//
//  CBGStockPhotoManager.h
//  drink-In-my-hand
//
//  Created by JUSTIN M FISCHER on 6/25/13.
//  Copyright (c) 2013 Fun Touch Apps, LLC. All rights reserved.
//

#import "CBGPhotos.h"

@interface CBGStockPhotoManager : NSObject

@property(nonatomic, strong) NSMutableSet *stockPhotoSet;
@property (nonatomic, strong) NSArray *image;
+ (CBGStockPhotoManager *) sharedManager;
- (void) randomStockPhoto: (void (^)(CBGPhotos *)) completion;

@end
