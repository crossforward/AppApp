//
//  ANBaseStreamController.h
//  AppApp
//
//  Created by brandon on 8/11/12.
//  Copyright (c) 2012 Sneakyness. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STableViewController.h"
#import "ANAPICall.h"
#import "ANViewControllerProtocol.h"
#import "ANStatusViewCell.h"

@interface ANBaseStreamController : STableViewController<ANViewControllerProtocol>
{
@protected
    NSMutableArray *streamData;
    NSIndexPath *newSelection;
    NSIndexPath *currentSelection;
    bool toolbarIsVisible;
    UIView *currentToolbarView;
}

@property (nonatomic, readonly) NSString *sideMenuTitle;
@property (nonatomic, readonly) NSString *sideMenuImageName;
@property (nonatomic) UIView *currentToolbarView;
@property (nonatomic) NSMutableArray* currentlyFollowing;

- (BOOL)refresh;
- (void)updateTopWithData:(id)dataObject;
- (void)updateBottomWithData:(id)dataObject;
@end
