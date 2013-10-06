//
//  SCIndividualStepViewController.m
//  RouteMaster
//
//  Created by Sam Davies on 06/10/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import "SCIndividualStepViewController.h"

@interface SCIndividualStepViewController () <MKMapViewDelegate>
@end

@implementation SCIndividualStepViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.mapView.delegate = self;
    [self.mapView addOverlay:self.routeStep.polyline];
    [self.mapView setVisibleMapRect:self.routeStep.polyline.boundingMapRect animated:NO];
    self.instructionsTextView.text = self.routeStep.instructions;
    self.navigationItem.title = [NSString stringWithFormat:@"Step %02d", self.stepIndex];
    self.distanceLabel.text = [NSString stringWithFormat:@"%0.2f km", self.routeStep.distance / 1000.0];
}

#pragma mark - MKMapViewDelegate methods
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:self.routeStep.polyline];
    renderer.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    renderer.lineWidth = 4.f;
    return  renderer;
}

@end
