//
//  SCIndividualStepViewController.h
//  RouteMaster
//
//  Created by Sam Davies on 06/10/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;

@interface SCIndividualStepViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *instructionsTextView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) MKRouteStep *routeStep;
@property (assign, nonatomic) NSUInteger stepIndex;

@end
