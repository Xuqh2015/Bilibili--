//
//  FilterViewController.m
//  Bilibili
//
//  Created by BlueCocoa on 13-11-16.
//  Copyright (c) 2013年 BlueCocoa. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController ()
@property (strong, nonatomic) NSMutableArray *name;
@property (strong, nonatomic) PHSideScrollingImagePicker *picker;
@end

@implementation FilterViewController
@synthesize name;
@synthesize picker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *array = [manager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/Documents/",NSHomeDirectory()] error:nil];
    self.name = [NSMutableArray arrayWithArray:array];
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<[self.name count];i++) {
        NSString *path = [array objectAtIndex:i];
        if ([[path lowercaseString] hasSuffix:@"png"]) {
            [imageArray addObject:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),path]]];
        }
    }
    if (iPhone5) {
        picker = [[PHSideScrollingImagePicker alloc] initWithFrame:CGRectMake(0, 64, 320, 504)];
    }else{
        picker = [[PHSideScrollingImagePicker alloc] initWithFrame:CGRectMake(0, 54, 320, 426)];
    }
    [picker setImages:imageArray withName:self.name];
    [self.view addSubview:picker];

}

- (IBAction)cancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneFilter:(UIButton *)sender{
    NSMutableArray *filter = [[NSMutableArray alloc] init];
    for (int i = 0; i < [[self.picker selectedImageIndexes] count]; i++) {
        [filter addObject:[NSString stringWithFormat:@"%@",[self.name objectAtIndex:[[[self.picker selectedImageIndexes] objectAtIndex:i] integerValue]]]];
        NSLog(@"select %@",[NSString stringWithFormat:@"%@",[self.name objectAtIndex:[[[self.picker selectedImageIndexes] objectAtIndex:i] integerValue]]]);
    }
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    [d setValue:filter forKey:@"filter"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"filter" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
