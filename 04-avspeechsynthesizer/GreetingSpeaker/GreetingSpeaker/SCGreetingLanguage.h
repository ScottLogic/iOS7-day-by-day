//
//  SCGreetingLanguage.h
//  GreetingSpeaker
//
//  Created by Sam Davies on 12/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCGreetingLanguage : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *bcp47;
@property (nonatomic, strong) NSString *greeting;


+ (NSArray *)listOfGreetings;
+ (instancetype)greetingLanguageWithBCP47:(NSString*)bcp47 name:(NSString*)name greeting:(NSString*)greeting;

@end
