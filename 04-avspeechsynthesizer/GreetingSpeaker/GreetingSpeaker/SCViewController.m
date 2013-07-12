//
//  SCViewController.m
//  GreetingSpeaker
//
//  Created by Sam Davies on 12/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "SCViewController.h"
#import "SCGreetingLanguage.h"

@interface SCViewController () <UIPickerViewDelegate, UIPickerViewDataSource> {
    NSArray *availableLanguages;
}

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    availableLanguages = [SCGreetingLanguage listOfGreetings];
    
    // Join up the picker
    self.languagePicker.delegate = self;
    self.languagePicker.dataSource = self;
    self.greetingLabel.text = [[availableLanguages firstObject] greeting];
}

- (IBAction)greetingButtonPressed:(id)sender {
    NSLog(@"Speak now!");
}


#pragma mark - UIPickerViewDelegate methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [availableLanguages[row] name];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.greetingLabel.text = [availableLanguages[row] greeting];
    NSLog(@"Language selected: %@", [availableLanguages[row] bcp47]);
}

#pragma mark - UIPickerViewDatasource methods
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [availableLanguages count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

@end
