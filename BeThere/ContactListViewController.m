//
//  ContactListViewController.m
//  BeThere
//
//  Created by hoangha052 on 11/6/14.
//  Copyright (c) 2014 hoangha052. All rights reserved.
//
#import "ContactListViewController.h"
#import "CreatMessageViewController.h"
#import "MapViewController.h"
#import "BBUserTableViewCell.h"
#import "BBContans.h"
#import "NSPredicate+TSCUtils.h"
#import "LoginInfo.h"
#import "LoginTableViewController.h"
#import "NSManagedObject+TSCUtils.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MessageTableViewController.h"
#import "Blacklist.h"
#import "Friends+Utils.h"

//#import "ELCAlbumPickerController.h"

#define TSCCellColor ([UIColor colorWithRed:217.0/255.0 green:238.0/255.0 blue:241.0/255.0 alpha:1.0])
#define TSCSelectColor ([UIColor colorWithRed:14.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0])

@interface ContactListViewController ()<UITableViewDataSource, UITableViewDelegate, BBUserTableViewCellDelegate,
UIActionSheetDelegate, UIImagePickerControllerDelegate
, UINavigationControllerDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profilePhotoView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIButton *btnAddContact;
@property (weak, nonatomic) IBOutlet UITableView *tableUserView;
@property (weak, nonatomic) IBOutlet UIView *viewImage;
@property (strong, nonatomic) NSArray *userArray;
@property (strong, nonatomic) NSMutableArray *contactArray;
@property (strong, nonatomic)  LoginInfo *userInfo;
@property (assign, nonatomic) BOOL isBlackList;
@end

@implementation ContactListViewController

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
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    self.viewImage.layer.cornerRadius = 40;
    self.userInfo = [LoginInfo sharedObject];
    self.userInfo.reply = NO;
    self.lblName.text = self.userInfo.userName;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        PFUser *user = [PFUser currentUser];
        PFFile *theImage = user[@"image"];
        NSData *imageData = [theImage getData];
        UIImage *image = [UIImage imageWithData:imageData];
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.profilePhotoView.image = image;
            });
        }
    });
    [self loadData];
}

- (void)loadData
{
    /*Fution send request add friend*/
    NSArray *friends = [Friends entitiesWithValue:self.userInfo.userName forKey:@"myName" fault:NO];
    if (friends.count > 0) {
       friends = [friends valueForKey:@"friendName"];
    }
//    NSLog(@"Friend list %@", friends);
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" containedIn:friends];
    self.userArray = [query findObjects];
    self.userArray = [self.userArray filteredArrayUsingPredicate:[NSPredicate predicateWithValueNotEqual:self.userInfo.userName forKey:@"username"]];
    self.contactArray = [NSMutableArray arrayWithCapacity:[self.userArray count]];
    NSMutableDictionary *dicUser = nil;
    Blacklist *blacklistUser = nil;
    
    for (PFUser *user in self.userArray) {
        dicUser = [[NSMutableDictionary alloc] init];
        [dicUser setObject:user forKey:@"user"];
        [dicUser setObject:@(NO) forKey:@"isSelected"];
        blacklistUser = [[Blacklist entitiesWithANDPredicateFromDictionary:@{@"userName":self.userInfo.userName, @"blackName":user.username} fault:NO] firstObject];
        if (!blacklistUser) {
            blacklistUser = [Blacklist newObject];
            blacklistUser.isReceiver = @(NO);
            blacklistUser.userName = self.userInfo.userName;
            blacklistUser.blackName = user.username;
            [blacklistUser save];
            [dicUser setObject:@(NO) forKey:@"blacklist"];
        }
        else
        {
            [dicUser setObject:blacklistUser.isReceiver forKey:@"blacklist"];
        }
        [dicUser setObject:blacklistUser forKey:@"blackUser"];
        [self.contactArray addObject:dicUser];
    }
    [self.tableUserView reloadData];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableUserView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.isRequest) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"you have receiver invatition add friend" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        alertView.tag = 1;
        [alertView show];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:kSegue_MessageTableViewController]) {
        MessageTableViewController *controller = [segue destinationViewController];
        if ([sender isKindOfClass:[NSString class]]) {
           controller.stringSender = (NSString *)sender;
        }
        
    }
}

- (IBAction)btnPhotoPress:(id)sender {
//    CGRect popoverRect = [self convertRect:CGRectMake(avatar.center.x, avatar.center.y, 1, 1) fromView:self];
//    popoverRect.size.width = MIN(popoverRect.size.width, 100) ;
//    popoverRect.origin.x   = popoverRect.origin.x;
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
//    [actionSheet setBackgroundColor:[UIColor purpleColor]];
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
//    {
       UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Chụp hình",@"Tải ảnh từ thư viện", @"Huỷ bỏ", nil];
        [actionSheet setBackgroundColor:[UIColor clearColor]];
        
//    }
    [actionSheet showInView:self.view];
//    [actionSheet showFromRect:popoverRect inView:self animated:YES];

}

- (IBAction)btnChoosePress:(id)sender {
    LoginInfo *info = [LoginInfo sharedObject];
    info.arrayReceiver = [self.contactArray filteredArrayUsingPredicate:[NSPredicate predicateWithValue:@(YES) forKey:@"isSelected"]];
    if ([info.arrayReceiver count]<=0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please choose a contact" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        alertView.tag = 0;
        [alertView show];
    }
    else
    {
        [self performSegueWithIdentifier:kSegue_MapViewController  sender:self];
    }
}

- (IBAction)btnAddContactPress:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Send request add friend" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 200;
    [alert show];
}

- (IBAction)viewMessagePress:(id)sender {
    [self performSegueWithIdentifier:kSegue_MessageTableViewController sender:self];
}

- (IBAction)btnLogoutPress:(id)sender {
    [PFUser logOut];
    LoginInfo *userInfo = [LoginInfo sharedObject];
    [userInfo resetData];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    LoginTableViewController*ivc = [mainStoryboard instantiateViewControllerWithIdentifier: @"LoginTableViewController"];
    [self.navigationController pushViewController:ivc animated:NO];

}
- (void)setIsBlackList:(BOOL)isBlackList
{
    _isBlackList = isBlackList;
    
}

- (void)takePhotoByCamera
{
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.allowsEditing = NO;
    imgPicker.delegate      = self;
    imgPicker.sourceType    = UIImagePickerControllerSourceTypeCamera;
    imgPicker.mediaTypes    = [[NSArray alloc] initWithObjects:(NSString *) kUTTypeImage, nil];
    [self presentViewController:imgPicker animated:YES completion:nil];
}

- (void)takePhotoByLibrary
{
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.allowsEditing = NO;
    imgPicker.delegate      = self;
    imgPicker.sourceType    = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imgPicker.mediaTypes    = [[NSArray alloc] initWithObjects:(NSString *) kUTTypeImage, nil];
    [self presentViewController:imgPicker animated:YES completion:nil];
   
}

#pragma mark - PhotoDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if (CFStringCompare((__bridge_retained CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo)
    {
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        // Upload image
        __block NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
        self.profilePhotoView.image = image;
        dispatch_async(dispatch_get_global_queue (0,0), ^{
            PFFile *fileImage = [PFFile fileWithName:@"image.jpg" data:imageData];
            [fileImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    // Create a PFObject around a PFFile and associate it with the current user
                    PFUser *user = [PFUser currentUser];;
                    [user setObject:fileImage forKey:@"image"];
                    [user saveInBackground];
                }
            }];
        });
    }
    [picker dismissViewControllerAnimated:NO completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            [self takePhotoByCamera];
        }
            break;
        case 1:
        {
            [self takePhotoByLibrary];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0) {
        return;
    }
    else if (alertView.tag ==1) {
        if (buttonIndex == 1) {
        NSLog(@"save data to db");
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            PFPush *push = [[PFPush alloc] init];
            NSDictionary *dataDict = @{@"type":@"response",@"sender":self.userInfo.userName};
            [push setChannels:@[self.namePushNotification]];
            [push setMessage:[NSString stringWithFormat:@"[%@] accept your request",self.userInfo.userName]];
            [push setData:dataDict];
            [push sendPushInBackground];
        });
        NSLog(@"save Friend to db");
        Friends *userFriends = [Friends newObject];
        userFriends.myName = self.userInfo.userName;
        userFriends.friendName = self.namePushNotification;
        [userFriends save];
        [self loadData];
        }
        
    }
    else{
    NSString *name = [alertView textFieldAtIndex:0].text;
    if (buttonIndex == 1) {
        // Send a notification to all devices subscribed to the "Giants" channel.
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            PFPush *push = [[PFPush alloc] init];
            NSDictionary *data =@{@"type":@"request",@"sender":self.userInfo.userName};
            [push setChannels:@[name]];
            [push setMessage:[NSString stringWithFormat:@"you have a request from [%@]",self.userInfo.userName]];
            [push setData:data];
            [push sendPushInBackground];
        });
    }
    }
}
#pragma mark - UITableView Cell Delegate
- (void)selectedBlackUser:(id)sender
{
    NSIndexPath *idxPath = [self.tableUserView indexPathForCell:sender];
    NSInteger row = [idxPath row];
    NSMutableDictionary *contentSelect = [self.contactArray objectAtIndex:row];
    BOOL Select = [[contentSelect valueForKey:@"blacklist"] boolValue];
    if (Select) {
        [contentSelect setValue:@(NO) forKey:@"blacklist"];
    }
    else{
        [contentSelect setValue:@(YES) forKey:@"blacklist"];
    }
    
    Blacklist *blacklistItem = [contentSelect objectForKey:@"blackUser"];
    blacklistItem.isReceiver = [contentSelect objectForKey:@"blacklist"];
    [blacklistItem save];
    [self.contactArray replaceObjectAtIndex:row withObject:contentSelect];
}

- (void)selectedCell:(id)sender
{
    NSIndexPath *idxPath = [self.tableUserView indexPathForCell:sender];
    NSInteger row = [idxPath row];
    NSMutableDictionary *contentSelect = [self.contactArray objectAtIndex:row];
    BOOL Select = [[contentSelect valueForKey:@"isSelected"] boolValue];
    if (Select) {
        [contentSelect setValue:[NSNumber numberWithBool:NO] forKey:@"isSelected"];
    }
    else{
        [contentSelect setValue:[NSNumber numberWithBool:YES] forKey:@"isSelected"];
    }
    [self.contactArray replaceObjectAtIndex:row withObject:contentSelect];
    [self.tableUserView reloadRowsAtIndexPaths:@[idxPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)showMessage:(id)sender{
    NSIndexPath *idxPath = [self.tableUserView indexPathForCell:sender];
    NSInteger row = [idxPath row];
    NSMutableDictionary *dict = [self.contactArray objectAtIndex:row];
    PFUser *user = [dict objectForKey:@"user"];
    [self performSegueWithIdentifier:kSegue_MessageTableViewController sender:user.username];
    
}

#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contactArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BBUserTableViewCell *cell = (id)[tableView dequeueReusableCellWithIdentifier:@"BBUserTableViewCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BBUserTableViewCell" owner:nil options:nil]firstObject];
    }
    cell.delegate = self;
    cell.isSwipe = NO;
    UISwipeGestureRecognizer *swipeGestureRecognizer=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showMessageInfo:)];
    [cell addGestureRecognizer:swipeGestureRecognizer];
    [cell setValueInfo:[self.contactArray objectAtIndex:indexPath.row]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    BBUserTableViewCell *cell = (BBUserTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.isSwipe) {
        return NO;
    }
    return NO;
//    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.contactArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths: @[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)showMessageInfo:(UISwipeGestureRecognizer *)gesture{
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        BBUserTableViewCell *cell = (BBUserTableViewCell *)[gesture view];
        [cell showIconMessage];
    }
}

/*
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSMutableDictionary *contentSelect = [self.contactArray objectAtIndex:row];
    BOOL Select = [[contentSelect valueForKey:@"isSelected"] boolValue];
    if (Select) {
        [contentSelect setValue:[NSNumber numberWithBool:NO] forKey:@"isSelected"];
    }
    else{
        [contentSelect setValue:[NSNumber numberWithBool:YES] forKey:@"isSelected"];
    }
    [self.contactArray replaceObjectAtIndex:row withObject:contentSelect];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
 
}
*/
//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//}
@end
