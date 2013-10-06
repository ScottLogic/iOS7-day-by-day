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
    self.instructionsTextView.text = self.routeStep.instructions;
    self.navigationItem.title = [NSString stringWithFormat:@"Step %02d", self.stepIndex];
}

#pragma mark - MKMapViewDelegate methods
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:self.routeStep.polyline];
    renderer.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.8];
    renderer.lineWidth = 2.f;
    return  renderer;
}

@end
