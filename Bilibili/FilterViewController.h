//
//  FilterViewController.h
//  Bilibili
//
//  Created by BlueCocoa on 13-11-16.
//  Copyright (c) 2013年 BlueCocoa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHSideScrollingImagePicker.h"
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
@interface FilterViewController : UIViewController
- (IBAction)doneFilter:(UIButton *)sender;
- (IBAction)cancel:(id)sender;
@end
