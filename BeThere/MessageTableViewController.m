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

    PFQuery *query = [PFQuery queryWithClassName:@"message"];
    [query whereKey:@"receiver" equalTo:userInfo.userName];
    NSArray* messages = [query findObjects];

    self.arrayMessage  = [Message entitiesWithValue:userInfo.userName forKey:@"receiver" fault:NO];
    self.arrayMessage = messages;
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

// Prepare layout for displaying a message.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] ;
    }
    PFObject* message = [self.arrayData objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [message objectForKey:@"sender"];
    NSString *contentString = @"";
    contentString = [message objectForKey:@"content"];
    
    cell.detailTextLabel.text = contentString;
    if ([[message objectForKey:@"readmessage"] boolValue])
        cell.imageView.image = [UIImage imageNamed:@"icon_readed"];
    else
        cell.imageView.image = [UIImage imageNamed:@"icon_unread"];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.arrayData count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// User taps a row to view the message.
// System:
// - Notify the cloud that this message has been viewed.
// - Display the message view screen.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Notify the cloud that this message has been viewed.
    PFObject *message = [self.arrayData objectAtIndex:indexPath.row];
    message[@"readmessage"] = @(YES);
    [message save];

    // Prepare data to push to message view screen.
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[message objectForKey:@"content"] forKey:@"content"];
    [dic setValue:[message objectForKey:@"sender"] forKey:@"sender"];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ReadMessageViewController *ivc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ReadMessageViewController"];
    ivc.message = dic;
    [self.navigationController pushViewController:ivc animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
         Message *object = [self.arrayData objectAtIndex:indexPath.row];
        [Message deleteEntities:@[object]];
        [self.arrayData removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths: @[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
