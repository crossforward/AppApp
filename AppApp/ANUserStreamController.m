//
//  ANUserStreamController.m
//  AppApp
//
//  Created by Nick Pannuto on 8/11/12.
//  Copyright (c) 2012 Sneakyness. All rights reserved.
//

#import "ANUserStreamController.h"

@interface ANUserStreamController ()

@end

@implementation ANUserStreamController

- (NSString *)sideMenuTitle
{
    return @"User Stream";
}

- (NSString *)sideMenuImageName
{
    return @"sidemenu_userstream_icon";
}

-(NSArray*)removeMentionsFromArray:(NSArray*)array
{
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:[array count]];
    
    
    for(id value in array) {
        NSString* text = [value valueForKey:@"text"];
        if([text rangeOfString:@"@"].location == 0) {

            int firstSpace = [text rangeOfString:@" "].location;
            NSString* mentionedUser = [[text substringToIndex:firstSpace] substringFromIndex:1];
            
            if ([self.currentlyFollowing indexOfObject:mentionedUser] != NSNotFound) {
                [result addObject:value];
            }
            
        } else {
            [result addObject:value];
        }
    }
    
    return result;
}


- (void)addItemsOnTop
{
    // Call this to indicate that we have finished "refreshing".
    // This will then result in the headerView being unpinned (-unpinHeaderView will be called).
    
    if ([streamData count] > 0) {
        id firstPost = [streamData objectAtIndex:0];
        [[ANAPICall sharedAppAPI] getUserStreamSincePost:[firstPost objectForKey:@"id"] withCompletionBlock:^(id dataObject, NSError *error) {
            [self updateTopWithData:[self removeMentionsFromArray:dataObject]];
            [self refreshCompleted];
        }];
    } else {
        [[ANAPICall sharedAppAPI] getUserStream:^(id dataObject, NSError *error) {
            [self updateTopWithData:[self removeMentionsFromArray:dataObject]];
            [self refreshCompleted];
        }];
    }
}

- (void)addItemsOnBottom
{
    // grab the last post
    id lastPost = [streamData lastObject];
    
    // if we have a post
    if (lastPost) {
        
        // fetch old data
        [[ANAPICall sharedAppAPI] getUserStreamBeforePost:[lastPost objectForKey:@"id"] withCompletionBlock:^(id dataObject, NSError *error) {
            [self updateBottomWithData:[self removeMentionsFromArray:dataObject]];
            [self loadMoreCompleted];
        }];
    } else {
        [self loadMoreCompleted];
    }
}

@end
