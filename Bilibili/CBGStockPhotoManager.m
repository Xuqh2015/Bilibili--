//
//  CBGStockPhotoManager.m
//  drink-In-my-hand
//
//  Created by JUSTIN M FISCHER on 6/25/13.
//  Copyright (c) 2013 Fun Touch Apps, LLC. All rights reserved.
//

#import "CBGStockPhotoManager.h"
#import "CBGUtil.h"
#import "CBGConstants.h"
#import "UIImage+ImageEffects.h"

@implementation CBGStockPhotoManager

@synthesize image;

static CBGStockPhotoManager *sharedManager = nil;

+ (CBGStockPhotoManager *) sharedManager {
    @synchronized (self) {
        if (sharedManager == nil) {
            sharedManager = [[self alloc] init];
            [[NSNotificationCenter defaultCenter] addObserver:sharedManager selector:@selector(reload) name:@"reloadBG" object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:sharedManager selector:@selector(resetting) name:@"filter" object:nil];
        }
    }
    
    return sharedManager;
}

- (id) init {
	self = [super init];
	
    if (self != nil) {
        self.image = [[NSArray alloc] init];
        NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
        self.image = [d valueForKey:@"filter"];
        [self load];
        
	}
    
	return self;
}

- (void)resetting{
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    self.image = [d valueForKey:@"filter"];
    if ([self.image count] == 0) {
        self.image = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/Documents/",NSHomeDirectory()] error:nil];
    }
    [self.stockPhotoSet removeAllObjects];
    
    NSString *prefix;
    NSString *token;
    for (NSString *fileName in self.image) {
        prefix = [fileName lastPathComponent];
        
        token = [prefix substringWithRange:NSMakeRange(0, 3)];
        [self.stockPhotoSet addObject:token];
    }

}

- (void) load {
    if ([self.image count] == 0) {
        self.image = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/Documents/",NSHomeDirectory()] error:nil];
    }
    
    
    self.stockPhotoSet = [[NSMutableSet alloc] init];
    
    NSString *prefix;
    NSString *token;
    
    for (NSString *fileName in self.image) {
        prefix = [fileName lastPathComponent];
        
        token = [prefix substringWithRange:NSMakeRange(0, 3)];
        [self.stockPhotoSet addObject:token];
    }
}

- (void)reload{
    if ([self.image count] == 0) {
        self.image = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/Documents/",NSHomeDirectory()] error:nil];
    }
    
    [self.stockPhotoSet removeAllObjects];
    
    NSString *prefix;
    NSString *token;
    
    for (NSString *fileName in self.image) {
        prefix = [fileName lastPathComponent];
        
        token = [prefix substringWithRange:NSMakeRange(0, 3)];
        [self.stockPhotoSet addObject:token];
    }
}

- (NSMutableArray *)arrayFromSet:(NSMutableSet *)inSet{
    return [[NSMutableArray alloc] initWithArray:[inSet allObjects]];
}

- (void) randomStockPhoto: (void (^)(CBGPhotos *)) completion {
    
    CBGPhotos *photos = [[CBGPhotos alloc] init];
    
    dispatch_queue_t queue = dispatch_queue_create(kAsyncQueueLabel, NULL);
    dispatch_queue_t main = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        NSString *imagePath = [NSString stringWithFormat:@"%@-StockPhoto-320x568.png", [[self arrayFromSet:self.stockPhotoSet] objectAtIndex:arc4random()%[self.stockPhotoSet count]]];
    
        photos.photo = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),imagePath]];
        photos.photoWithEffects = [photos.photo applyLightEffect];
        
        dispatch_async(main, ^{
            completion(photos);
        });
    });
}

@end
