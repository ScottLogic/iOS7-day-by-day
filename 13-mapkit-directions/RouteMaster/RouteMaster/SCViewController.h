//
//  SCViewController.h
//  RouteMaster
//
//  Created by Sam Davies on 06/10/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;

@interface SCViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *routeButton;
@property (weak, nonatomic) IBOutlet UIButton *routeDetailsButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)handleRoutePressed:(id)sender;
@end
