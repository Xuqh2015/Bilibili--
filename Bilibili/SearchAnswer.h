//
//  SearchAnswer.h
//  bilibili题库
//
//  Created by BlueCocoa on 13-9-15.
//  Copyright (c) 2013年 Xu Ruomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchAnswer : UITableViewController<UISearchBarDelegate,UISearchDisplayDelegate>
@property (strong, nonatomic) UISearchBar *searchbar;
@property (nonatomic, strong) NSArray *questions;
@property (nonatomic, strong) NSDictionary *answers;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end
