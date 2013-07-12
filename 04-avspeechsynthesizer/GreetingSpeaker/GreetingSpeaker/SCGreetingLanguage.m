//
//  SCGreetingLanguage.m
//  GreetingSpeaker
//
//  Created by Sam Davies on 12/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "SCGreetingLanguage.h"

@implementation SCGreetingLanguage

+ (instancetype)greetingLanguageWithBCP47:(NSString *)bcp47 name:(NSString *)name greeting:(NSString *)greeting
{
    SCGreetingLanguage *gl = [[SCGreetingLanguage alloc] init];
    gl.name = name;
    gl.bcp47 = bcp47;
    gl.greeting = greeting;
    
    return gl;
}


+ (NSArray *)listOfGreetings
{
    return @[
             [SCGreetingLanguage greetingLanguageWithBCP47:@"en-GB" name:@"English (British)" greeting:@"How do you do?"],
             [SCGreetingLanguage greetingLanguageWithBCP47:@"en-US" name:@"English (American)" greeting:@"Hello"],
             [SCGreetingLanguage greetingLanguageWithBCP47:@"th" name:@"Thai" greeting:@"Sawadee Khrab"],
             [SCGreetingLanguage greetingLanguageWithBCP47:@"fr-FR" name:@"French" greeting:@"Bonjour"],
             [SCGreetingLanguage greetingLanguageWithBCP47:@"de" name:@"German" greeting:@"Guten Tag"]
             ];
}

@end
