//
//  MessageTableViewController.m
//  bethere
//
//  Created by hoangha052 on 11/22/14.
//  Copyright (c) 2014 hoangha052. All rights reserved.
//

#import "MessageTableViewController.h"
#import "LoginInfo.h"
#import "Message+Utils.h"
#import "NSManagedObject+TSCUtils.h"
#import "ReadMessageViewController.h"
#import "NSPredicate+TSCUtils.h"

@interface MessageTableViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *arrayMessage;
@property (strong, nonatomic) NSMutableArray *arrayData;

@end

@implementation MessageTableViewController

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
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    LoginInfo *userInfo = [LoginInfo sharedObject];
    // Do any additional setup after loading the view.
    self.arrayMessage  = [Message entitiesWithValue:userInfo.userName forKey:@"receiver" fault:NO];
    if (self.stringSender) {
        self.arrayMessage = [self.arrayMessage filteredArrayUsingPredicate:[NSPredicate predicateWithValue:self.stringSender forKey:@"sender"]];
    }
    self.arrayData = [NSMutableArray arrayWithArray:self.arrayMessage];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBackPress:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
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
#pragma mark - TableView Delegate

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] ;
    }
    Message *newMessager = [self.arrayData objectAtIndex:indexPath.row];
    
    cell.textLabel.text = newMessager.sender;
    NSString *contentString = @"";
    if ([newMessager.content  length] >= 20)
        contentString = [newMessager.content substringToIndex:20];
    else
        contentString = newMessager.content;
    
    cell.detailTextLabel.text = contentString;
    if ([newMessager.readmessage boolValue])
    {
        cell.imageView.image = [UIImage imageNamed:@"icon_readed"];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"icon_unread"];
    }

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.arrayData count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Message *object = [self.arrayData objectAtIndex:indexPath.row];
    object.readmessage = @(YES);
    [object save];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:object.content forKey:@"content"];
//    NSDictionary *dic = @{@"content": object.content};
    [dic setValue:object.sender forKey:@"sender"];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ReadMessageViewController *ivc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ReadMessageViewController"];
    ivc.message = dic;
    [self.navigationController pushViewController:ivc animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
         Message *object = [self.arrayData objectAtIndex:indexPath.row];
        [Message deleteEntities:@[object]];
        [self.arrayData removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths: @[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
