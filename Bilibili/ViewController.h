//
//  ViewController.h
//  Bilibili
//
//  Created by BlueCocoa on 13-11-16.
//  Copyright (c) 2013年 BlueCocoa. All rights reserved.
//

#import <UIKit/UIKit.h>

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
@interface ViewController : UIViewController<UIScrollViewDelegate,UIActionSheetDelegate>
@property(nonatomic, weak) NSTimer *timer;
@property(nonatomic, strong) NSURL *userPhotoWebPageURL;
@property(nonatomic, strong) IBOutlet UIImageView *backgroundPhoto;
@property(nonatomic, strong) IBOutlet UIImageView *backgroundPhotoWithImageEffects;
@property(nonatomic, strong) IBOutlet UIScrollView *scrollView;

- (IBAction)showmore:(id)sender;
@end
