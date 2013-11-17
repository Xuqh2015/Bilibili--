//
//  BilibiliUserViewController.m
//  Bilibili
//
//  Created by BlueCocoa on 13-11-16.
//  Copyright (c) 2013年 BlueCocoa. All rights reserved.
//

#import "BilibiliUserViewController.h"

@interface BilibiliUserViewController ()

@end

@implementation BilibiliUserViewController

@synthesize userimage;
@synthesize username;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    [self ExtraCellLineHidden:self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.userimage= [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
    self.userimage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.userimage.image = [UIImage imageNamed:@"avatar.jpg"];
    self.userimage.layer.masksToBounds = YES;
    self.userimage.layer.cornerRadius = 50.0;
    self.userimage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userimage.layer.borderWidth = 3.0f;
    self.userimage.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.userimage.layer.shouldRasterize = YES;
    self.userimage.clipsToBounds = YES;
    
    self.username = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
    self.username.text = @"Bilibili";
    self.username.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
    self.username.backgroundColor = [UIColor clearColor];
    self.username.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    [self.username setTextAlignment:NSTextAlignmentCenter];
    [self.username sizeToFit];
    self.username.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
        [view addSubview:self.userimage];
        [view addSubview:self.username];
        view;
    });
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    label.text = @"Bilibili";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 0;
    
    return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
    }else if (indexPath.section == 0 && indexPath.row ==3){
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.ra1ndrops.com/bilibili/answers.plist"]];
        if ([dict count] == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新失败" message:@"出现这种情况很有可能是我们的服务器被偷去卖钱了" delegate:self cancelButtonTitle:@"←_←" otherButtonTitles:@"再次下载", nil];
            [alert show];
        }else{
            NSFileManager *manager = [NSFileManager defaultManager];
            [manager removeItemAtPath:[NSString stringWithFormat:@"%@/Library/answers.plist",NSHomeDirectory()] error:nil];
            [dict writeToFile:[NSString stringWithFormat:@"%@/Library/answers.plist",NSHomeDirectory()] atomically:YES];
        }
    }else if (indexPath.section == 0 && indexPath.row == 4){
        //
    }
    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    } else {
        return 0;
    }
}

- (void)ExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0) {
        NSArray *titles = @[@"Info", @"Update",@"Set Background"];
        cell.textLabel.text = titles[indexPath.row];
    }
    return cell;
}

@end
