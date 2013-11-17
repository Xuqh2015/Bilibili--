//
//  SearchAnswer.m
//  bilibili题库
//
//  Created by BlueCocoa on 13-9-15.
//  Copyright (c) 2013年 Xu Ruomeng. All rights reserved.
//

#import "SearchAnswer.h"

@interface SearchAnswer ()

@end

@implementation SearchAnswer

@synthesize questions,dataSource,answers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)ExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UISearchBar * searchBar = [[UISearchBar alloc] init];
    searchBar.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 0);
    searchBar.delegate = self;
    searchBar.showsCancelButton = NO;
    searchBar.placeholder = @"搜索";
    searchBar.barStyle = UIBarStyleBlackTranslucent;
    [searchBar sizeToFit];
    self.view.opaque = NO;
    self.tableView.opaque= NO;
    [self.view setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.1]];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    UIView *view = [[UIView alloc]init];
    [view setBackgroundColor:[UIColor clearColor]];
    view.opaque = NO;
    [self.tableView setBackgroundView:view];
    [self ExtraCellLineHidden:self.tableView];
    self.tableView.tableHeaderView = searchBar;
    self.dataSource = [[NSMutableArray alloc] init];
    self.answers = [[NSDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Library/answers.plist",NSHomeDirectory()]];
    self.questions = [[[NSDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Library/answers.plist",NSHomeDirectory()]] allKeys];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setBackgroundView:nil];
        [cell setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.3]];
    }
    
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"答案" message:[self.answers valueForKey:[self.dataSource objectAtIndex:indexPath.row]] delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [alert show];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.dataSource removeAllObjects];
    for(NSString * data in self.questions)
    {
        if([[data lowercaseString] rangeOfString:[searchBar.text lowercaseString]].length != 0)
        {
            [self.dataSource addObject: data];
        }
    }
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(0 == searchText.length)
    {
        [self.dataSource removeAllObjects];
        [self.tableView reloadData];
        return ;
    }
    
    [self.dataSource removeAllObjects];
    for(NSString * str in self.questions)
    {
        if([[str lowercaseString] rangeOfString:[searchText lowercaseString]].length != 0)
        {
            [self.dataSource addObject:str];
        }
    }
    [self.tableView reloadData];
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    self.tableView.allowsSelection=YES;
    self.tableView.scrollEnabled=YES;
    self.tableView.tag = 1;
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"editing" object:nil];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text=@"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.tableView.allowsSelection=YES;
    self.tableView.scrollEnabled=YES;
    self.tableView.tag = 0;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
