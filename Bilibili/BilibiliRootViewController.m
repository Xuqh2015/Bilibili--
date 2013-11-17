//
//  BilibiliRootViewController.m
//  Bilibili
//
//  Created by BlueCocoa on 13-11-16.
//  Copyright (c) 2013年 BlueCocoa. All rights reserved.
//

#import "BilibiliRootViewController.h"

@interface BilibiliRootViewController ()

@end

@implementation BilibiliRootViewController

- (void)awakeFromNib
{
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    //self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuController"];
}

@end