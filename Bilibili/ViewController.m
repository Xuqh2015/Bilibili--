//
//  ViewController.m
//  Bilibili
//
//  Created by BlueCocoa on 13-11-16.
//  Copyright (c) 2013年 BlueCocoa. All rights reserved.
//

#import "ViewController.h"
#import "CTAssetsPickerController/CTAssetsPickerController.h"
#import "CBG.h"

//Timer
#define kTimerIntervalInSeconds 7

@interface ViewController ()<CTAssetsPickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) NSMutableArray *assets;
@end

@implementation ViewController

@synthesize scrollView;

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    //ScrollView content size
    if([CBGUtil is4InchIphone]) {
        self.scrollView.contentSize = CGSizeMake(320, 720);
    } else {
        self.scrollView.contentSize = CGSizeMake(320, 580);
    }
    
    //Initial stock photos from bundle
    [[CBGStockPhotoManager sharedManager] randomStockPhoto:^(CBGPhotos * photos) {
        [self crossDissolvePhotos:photos withTitle:@""];
    }];
    
    //Retrieve location and content from Flickr
    //[self retrieveLocationAndUpdateBackgroundPhoto];
    
    //Schedule updates
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kTimerIntervalInSeconds target:self selector:@selector(retrieveLocationAndUpdateBackgroundPhoto)userInfo:nil repeats:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveUp) name:@"editing" object:nil];
    if (!iPhone5) {
        CGRect rect = scrollView.frame;
        rect.origin.y -= 14;
        [scrollView setFrame:rect];
    }
}

- (void)moveUp{
    [scrollView scrollRectToVisible:CGRectMake(0, 216, 320, 514) animated:YES];
}

- (IBAction)showmore:(id)sender{
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"当前信息",@"更新",@"添加背景",@"背景设置", nil];
    [as showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self showInfo];
    }else if (buttonIndex == 1){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
            NSDictionary *update = [[NSDictionary alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://23.88.3.64/bilibili/update.plist"]];
            if (update == nil || [update count] == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无更新" message:@"您当前所用版本是最新版" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                dispatch_async(dispatch_get_main_queue(), ^(){
                    [alert show];
                });
                return;
            }
            if ([[update valueForKey:@"count"] integerValue] != [[[NSDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Library/answers.plist",NSHomeDirectory()]] count]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:[NSString stringWithFormat:@"%@",[update valueForKey:@"update info"]] delegate:self cancelButtonTitle:@"取消下载" otherButtonTitles:@"下载并更新", nil];
                dispatch_async(dispatch_get_main_queue(), ^(){
                    [alert show];
                });
            }else if ([[update valueForKey:@"count"] integerValue] == [[[NSDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Library/answers.plist",NSHomeDirectory()]] count]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无更新" message:@"您当前所用版本是最新版" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                dispatch_async(dispatch_get_main_queue(), ^(){
                    [alert show];
                });
                return;
            }
        });
    }else if(buttonIndex == 2){
        CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
        picker.maximumNumberOfSelection = 1000;
        picker.assetsFilter = [ALAssetsFilter allAssets];
        
        // not allow video clips
        picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(ALAsset* asset, NSDictionary *bindings) {
            if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                return NO;
            } else {
                return YES;
            }
        }];
        
        picker.delegate = self;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }else if (buttonIndex == 3){
        [self performSegueWithIdentifier:@"filter" sender:self];
    }
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        NSFileManager *manager = [NSFileManager defaultManager];
        int number = 0;
        NSArray *array = [manager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/Documents/",NSHomeDirectory()] error:nil];
        for (NSString *path in array) {
            NSString *newPath = [path substringToIndex:3];
            if (number <= [newPath integerValue]) {
                number = [newPath integerValue];
            }
        }
        number++;
        for (ALAsset *asset in assets) {
            UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation]fullResolutionImage]];
            NSData *newImage = UIImagePNGRepresentation(image);
            [newImage writeToFile:[NSString stringWithFormat:@"%@/Documents/%03d-StockPhoto-320x568.png",NSHomeDirectory(),number] atomically:YES];
            number++;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBG" object:nil];
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([[alertView title] isEqualToString:@"哔哩哔哩题库"]) {
        if (buttonIndex == 1) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
                NSDictionary *update = [[NSDictionary alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://23.88.3.64/bilibili/update.plist"]];
                if (update == nil || [update count] == 0) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无更新" message:@"您当前所用版本是最新版" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                    dispatch_async(dispatch_get_main_queue(), ^(){
                        [alert show];
                    });
                    return;
                }
                if ([[update valueForKey:@"count"] integerValue] != [[[NSDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Library/answers.plist",NSHomeDirectory()]] count]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:[NSString stringWithFormat:@"%@",[update valueForKey:@"update info"]] delegate:self cancelButtonTitle:@"取消下载" otherButtonTitles:@"下载并更新", nil];
                    dispatch_async(dispatch_get_main_queue(), ^(){
                        [alert show];
                    });
                }else if ([[update valueForKey:@"count"] integerValue] == [[[NSDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Library/answers.plist",NSHomeDirectory()]] count]){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无更新" message:@"您当前所用版本是最新版" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                    dispatch_async(dispatch_get_main_queue(), ^(){
                        [alert show];
                    });
                    return;
                }
            });
        }
    }else if ([[alertView title] isEqualToString:@"更新"]){
        if (buttonIndex == 1) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
                NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://23.88.3.64/bilibili/answers.plist"]];
                if ([dict count] == 0) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新失败" message:@"出现这种情况很有可能是我们的服务器被偷去卖钱了" delegate:self cancelButtonTitle:@"←_←" otherButtonTitles:@"再次下载", nil];
                    dispatch_async(dispatch_get_main_queue(), ^(){
                        [alert show];
                    });
                }else{
                    NSFileManager *manager = [NSFileManager defaultManager];
                    [manager removeItemAtPath:[NSString stringWithFormat:@"%@/Library/answers.plist",NSHomeDirectory()] error:nil];
                    [dict writeToFile:[NSString stringWithFormat:@"%@/Library/answers.plist",NSHomeDirectory()] atomically:YES];
                }
            });
        }
    }else if ([[alertView title] isEqualToString:@"更新失败"]){
        if (buttonIndex == 1) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
                NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://23.88.3.64/bilibili/answers.plist"]];
                if ([dict count] == 0) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新失败" message:@"出现这种情况很有可能是我们的服务器被偷去卖钱了←_←" delegate:self cancelButtonTitle:@"好吧..." otherButtonTitles:@"再次下载", nil];
                    dispatch_async(dispatch_get_main_queue(), ^(){
                        [alert show];
                    });
                }else{
                    NSFileManager *manager = [NSFileManager defaultManager];
                    [manager removeItemAtPath:[NSString stringWithFormat:@"%@/Library/answers.plist",NSHomeDirectory()] error:nil];
                    [dict writeToFile:[NSString stringWithFormat:@"%@/Library/answers.plist",NSHomeDirectory()] atomically:YES];
                }
            });
        }
    }
}

- (void)showInfo{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"哔哩哔哩题库" message:[[NSString alloc] initWithFormat:@"当前题库有%d条\n答案多源于网友共享,可能部分答案不够准确,您可以发邮件告诉我们,我们将尽快修改:P",[[[[NSDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Library/answers.plist",NSHomeDirectory()]] allKeys] count]] delegate:self cancelButtonTitle:@"好的" otherButtonTitles:@"在线更新", nil];
    [alert show];
}

- (void) retrieveLocationAndUpdateBackgroundPhoto {
    [[CBGStockPhotoManager sharedManager] randomStockPhoto:^(CBGPhotos * photos) {
        [self crossDissolvePhotos:photos withTitle:@""];
    }];
}

- (void) crossDissolvePhotos:(CBGPhotos *) photos withTitle:(NSString *) title {
    [UIView transitionWithView:self.backgroundPhoto duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
        self.backgroundPhoto.image = photos.photo;
        self.backgroundPhotoWithImageEffects.image = photos.photoWithEffects;
        
    } completion:NULL];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView1 {
    if(scrollView1.contentOffset.y >= 0 && scrollView1.contentOffset.y <= 80.0) {
        float percent = (scrollView1.contentOffset.y / 80.0);
        
        self.backgroundPhotoWithImageEffects.alpha = percent;
        
    } else if (scrollView1.contentOffset.y > 80.0){
        self.backgroundPhotoWithImageEffects.alpha = 1;
    } else if (scrollView1.contentOffset.y < 0) {
        self.backgroundPhotoWithImageEffects.alpha = 0;
    }
}

@end
