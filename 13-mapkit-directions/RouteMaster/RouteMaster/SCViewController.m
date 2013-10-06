//
//  SCViewController.m
//  RouteMaster
//
//  Created by Sam Davies on 06/10/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import "SCViewController.h"

@interface SCViewController () <MKMapViewDelegate> {
    MKPolylineRenderer *_routeRenderer;
    MKPolyline *_routeOverlay;
}

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.activityIndicator.hidden = YES;
    self.mapView.delegate = self;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)handleRoutePressed:(id)sender {
    // We're working
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    self.routeButton.enabled = NO;
    
    // Make a directions request
    MKDirectionsRequest *directionsRequest = [MKDirectionsRequest new];
    // Start at our current location
    MKMapItem *source = [MKMapItem mapItemForCurrentLocation];
    [directionsRequest setSource:source];
    // Make the destination
    CLLocationCoordinate2D destinationCoords = CLLocationCoordinate2DMake(38.8977, -77.0365);
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:destinationCoords addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    [directionsRequest setDestination:destination];
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        // We're done
        self.activityIndicator.hidden = YES;
        [self.activityIndicator stopAnimating];
        self.routeButton.enabled = YES;
        
        // Now handle the result
        if (error) {
            NSLog(@"There was an error getting your directions");
            return;
        }
        
        // So there wasn't an error - let's plot those routes
        [self plotRoutesOnMap:response.routes];
    }];
}

- (void)plotRoutesOnMap:(NSArray*)routes
{
    if(_routeOverlay) {
        [self.mapView removeOverlay:_routeOverlay];
    }
    
    // Create a new renderer
    MKRoute *route = [routes firstObject];
    _routeOverlay = route.polyline;
    
    // Add it to the map
    [self.mapView addOverlay:_routeOverlay];
    
}


#pragma mark - MKMapViewDelegate methods
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor redColor];
    renderer.lineWidth = 4.0;
    return  renderer;
}

@end
