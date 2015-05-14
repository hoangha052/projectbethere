//
//  MapViewController.m
//  BeThere
//
//  Created by hoangha052 on 11/7/14.
//  Copyright (c) 2014 hoangha052. All rights reserved.
//

#import "MapViewController.h"
#import "BBContans.h"
#import "ContactListViewController.h"
#import "CreatMessageViewController.h"
#import <MapKit/MapKit.h>
#import "CircleView.h"
#import "LoginInfo.h"
#import "MyCustomAnnotation.h"
#import "CustomAnnotationView.h"

@interface MapViewController ()<CLLocationManagerDelegate, UITextFieldDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *locationUser;
@property (strong, nonatomic) PFGeoPoint *curentPoint;
@property (strong, nonatomic) IBOutlet MKMapView *mapview;
@property (weak, nonatomic) IBOutlet UILabel *radiusValueLabel;
@property (weak, nonatomic) IBOutlet UISlider *radius_slider;
@property (nonatomic) NSInteger radiusValue;
@property (weak, nonatomic) IBOutlet UITextField *textFieldRadius;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) UIImageView *imageView;
@property (copy, nonatomic) NSString *stringImage;
@property (strong, nonatomic) LoginInfo *loginInfo;

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    CreatMessageViewController *controller = [segue destinationViewController];
    controller.locationRecieve = (PFGeoPoint *)sender;
}*/


- (IBAction)btnBetherePress:(id)sender {
    if ([self.mapview.annotations count] > 0) {
        MKPointAnnotation *point = [self.mapview.annotations lastObject];
        CLLocation* locationUser = [[CLLocation alloc] initWithLatitude:point.coordinate.latitude longitude:point.coordinate.longitude];
        PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:locationUser];
        [self sendLocation:geoPoint];
    }
    else
    {
        [self.locationManager startUpdatingLocation];
        
    }
}

- (void)sendLocation:(PFGeoPoint *)geoPoint
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    CreatMessageViewController *controller = [mainStoryboard instantiateViewControllerWithIdentifier: @"CreatMessageViewController"];
    controller.locationRecieve = geoPoint;
    controller.radiusReceiver = self.radiusValue;
    controller.imageName = self.stringImage;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)btnCancelPress:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ContactListViewController *controller = [mainStoryboard instantiateViewControllerWithIdentifier: @"ContactListViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)btnBackPress:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ContactListViewController *controller = [mainStoryboard instantiateViewControllerWithIdentifier: @"ContactListViewController"];
    [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma mark - Location Delegate

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    self.radiusValue = 10;
    self.stringImage = @"pk1";
    self.loginInfo = [LoginInfo sharedObject];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.mapview.showsUserLocation = YES;
    self.mapview.delegate = self;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(foundTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    
    [self.mapview addGestureRecognizer:tapRecognizer];
}

//https://gist.github.com/a1phanumeric/2249553
-(IBAction)foundTap:(UITapGestureRecognizer *)recognizer
{
    [self.mapview removeAnnotations:self.mapview.annotations];
    CGPoint point = [recognizer locationInView:self.mapview];
    self.coordinate = [self.mapview convertPoint:point toCoordinateFromView:self.mapview];
    
    
    MKPointAnnotation *point1 = [[MKPointAnnotation alloc] init];
    point1.coordinate = self.coordinate;
    
    MyCustomAnnotation *pointAnnotation = [[MyCustomAnnotation alloc] initWithLocation:self.coordinate];
    [self.mapview addAnnotation:pointAnnotation];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(self.coordinate, self.radiusValue * 10,self.radiusValue * 10);
    [self.mapview setRegion:viewRegion animated:YES];

    [self changeRadiusValue:self.radius_slider];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *identifier = @"MyCustomAnnotation";
    if ([annotation isKindOfClass:[MyCustomAnnotation class]]) {
        CustomAnnotationView *annotationView = (CustomAnnotationView *) [self.mapview dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"fluke-pinpoint"];
            //here we use a nice image instead of the default pins
            self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.stringImage]];
//            [self.imageView sizeToFit];
            self.imageView.frame = CGRectMake(2, -35, 30, 30);
            self.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [annotationView addSubview:self.imageView];
            
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    return nil;
}
- (IBAction)selectedImage:(id)sender {
    UIButton *button = (UIButton *)sender;
    self.stringImage = [self.loginInfo.arrayImage objectAtIndex:button.tag];
    self.imageView.image = [UIImage imageNamed:self.stringImage];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
    [theSearchBar resignFirstResponder];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:theSearchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
        //Error checking
        if (!error && [placemarks count]> 0) {
            [self issueLocalSearchLookup:theSearchBar.text usingPlacemarksArray:placemarks];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Cannot find location" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
    }];
    
}

-(void)issueLocalSearchLookup:(NSString *)searchString usingPlacemarksArray:(NSArray *)placemarks {
    
    // Search 0.250km from point for stores.
    CLPlacemark *placemark = placemarks[0];
    CLLocation *location = placemark.location;
    // Set the size (local/span) of the region (address, w/e) we want to get search results for.
    MKCoordinateSpan span;
    double radius = placemark.region.radius / 1000; // convert to km
    span.latitudeDelta = radius / 112.0;
    MKCoordinateRegion region = MKCoordinateRegionMake( location.coordinate, span);
    
    [self.mapview setRegion:region animated:NO];
    
    // Create the search request
    MKLocalSearchRequest *localSearchRequest = [[MKLocalSearchRequest alloc] init];
    localSearchRequest.region = region;
    localSearchRequest.naturalLanguageQuery = searchString;
    
    // Perform the search request...
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:localSearchRequest];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        
        if(error){
            NSLog(@"localSearch startWithCompletionHandlerFailed!  Error: %@", error);
            return;
            
        } else {
            for(MKMapItem *mapItem in response.mapItems){
                // Show pins, pix, w/e...
                NSLog(@"Name for result: = %@", mapItem.name);
//                    MKPointAnnotation *annotation =
//                    [[MKPointAnnotation alloc]init];
//                    annotation.coordinate = mapItem.placemark.coordinate;
//                    annotation.title = mapItem.name;
                MyCustomAnnotation *pointAnnotation = [[MyCustomAnnotation alloc] initWithLocation:mapItem.placemark.coordinate];
                    [self.mapview addAnnotation:pointAnnotation];
            }
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// http://stackoverflow.com/questions/7199832/i-need-a-dead-simple-implementation-of-mkcircle-overlay
- (IBAction)changeRadiusValue:(id)sender {
    UISlider *slider = (UISlider *)sender;
    self.radiusValue = slider.value;
    self.radiusValueLabel.text = [NSString stringWithFormat:@"%0.0f m",slider.value];
    [self.mapview removeOverlays:self.mapview.overlays];
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:self.coordinate radius:self.radiusValue];
    [self.mapview addOverlay:circle];
}

- (MKOverlayView *)mapView:(MKMapView *)map viewForOverlay:(id <MKOverlay>)overlay
{
    MKCircleView *circleView = [[MKCircleView alloc] initWithCircle:(MKCircle *)overlay];
    circleView.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    return circleView;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

// update location.
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (newLocation !=nil) {
        PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLocation:newLocation];
        [self sendLocation:geoPoint];
        [self.locationManager stopUpdatingLocation];
    }
}


/*- (void)zoomToUserLocation:(MKUserLocation *)userLocation
{
    if (!userLocation)
        return;
    
    MKCoordinateRegion region;
    region.center = userLocation.location.coordinate;
    region.span = MKCoordinateSpanMake(2.0, 2.0); //Zoom distance
    region = [self.mapview regionThatFits:region];
    [self.mapview setRegion:region animated:YES];
}

- (void)mapView:(MKMapView *)theMapView didUpdateToUserLocation:(MKUserLocation *)location
{
    [self zoomToUserLocation:location];
}
*/
@end
