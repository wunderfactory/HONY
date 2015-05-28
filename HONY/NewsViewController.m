//
//  NewsViewController.m
//  HONY
//
//  Created by David Pflugpeil on 29.05.14.
//  Copyright (c) 2014 Magnus Langanke & David Pflugpeil. All rights reserved.
//

#import "NewsViewController.h"

#import "CustomCell.h"
#import "DPWebConnector.h"

@interface NewsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *newsArray;
@property (strong, nonatomic) NSArray *newsDictionary;

@end


@implementation NewsViewController

@synthesize newsTableView, newsArray, newsDictionary;



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
    // Do any additional setup after loading the view.
    
    
    UINib *nib = [UINib nibWithNibName:@"CustomCell" bundle:nil];
    [newsTableView registerNib:nib forCellReuseIdentifier:@"CustomCell"];
    
    
    newsArray = [NSMutableArray array];
    
    
    newsDictionary = (NSArray*)[DPWebConnector synchronusConnectionWithURLString:@"http://lab.wunderfactory.de/api/blog.php"];
    
    
    UIBarButtonItem *closeBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeBarButton)];
    self.navigationItem.leftBarButtonItems  = @[closeBarButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [newsDictionary count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCell";
    CustomCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    // Configure the cell...
    cell.cellDate.text = [newsDictionary[indexPath.row] valueForKey:@"date"];
    cell.cellText.text = [newsDictionary[indexPath.row] valueForKey:@"message"];
    cell.cellTitle.text = [newsDictionary[indexPath.row] valueForKey:@"title"];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 131;
}



- (void)closeBarButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
