//
//  ViewController.m
//  Recipes_plist
//
//  Created by admin on 24/07/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import "ViewController.h"
#import "Recipe.m"

@interface ViewController ()

@end

@implementation ViewController
{
    NSArray *recipes;
    NSArray *thumbnails;
    NSArray *prepTime;
    NSMutableArray *searchResults;
    Recipe *recipe;
}

- (void)viewDidLoad {
    
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"recipes" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    recipes = [dict objectForKey:@"RecipeName"];
    thumbnails = [dict objectForKey:@"Thumbnail"];
    prepTime = [dict objectForKey:@"PrepTime"];
    self.title = @"Recipes";
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
//    self.searchController.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    NSInteger scope = self.searchController.searchBar.selectedScopeButtonIndex;
    NSPredicate *resultPredicate;
    if (scope == 0) {
        resultPredicate = [NSPredicate predicateWithFormat:@"userId contains[c] %@",searchString];
    } else {
        resultPredicate = [NSPredicate predicateWithFormat:@"jobTitleName contains[c] %@",searchString];
    }
    [searchResults filteredArrayUsingPredicate:resultPredicate];
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    [self updateSearchResultsForSearchController:self.searchController];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        return [searchResults count];
        
    } else {
        return [recipes count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if (self.searchController.active) {
        cell.textLabel.text = [searchResults objectAtIndex:indexPath.row];
    } else {
        cell.textLabel.text = [recipes objectAtIndex:indexPath.row];
    }
    
//    cell.textLabel.text = recipe.name;
//    cell.imageView.image = [thumbnails objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[thumbnails objectAtIndex:indexPath.row]];
    cell.detailTextLabel.text = [prepTime objectAtIndex:indexPath.row];
    return cell;
}

@end
