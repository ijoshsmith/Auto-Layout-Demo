//
//  JASViewController.m
//  AutoLayoutDemo
//
//  Created by Josh Smith on 9/19/12.
//  Copyright (c) 2012 Josh Smith. All rights reserved.
//

#import "JASViewController.h"

#define OPAQUE      YES
#define MARGIN      20
#define GAP          8
#define COLUMN_GAP   2

@implementation JASViewController
{
    NSMutableArray *_headerLabels;
    NSMutableArray *_valueLabels;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _headerLabels = [NSMutableArray array];
    _valueLabels = [NSMutableArray array];
    UILabel *header = nil, *value = nil;
    for (int i = 0; i < 4; ++i)
    {
        header = [self makeHeaderBeneathOtherHeader:header];
        value = [self makeValueNextToHeader:header];
        
        [_headerLabels addObject:header];
        [_valueLabels addObject:value];
        
        if (OPAQUE)
        {
            header.backgroundColor = [UIColor greenColor];
            value.backgroundColor = [UIColor lightGrayColor];
        }
        else
        {
            header.backgroundColor = [UIColor clearColor];
            value.backgroundColor = [UIColor clearColor];
        }
    }
}

- (UILabel *)makeHeaderBeneathOtherHeader:(UILabel *)otherHeader
{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Header:";
    label.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:label];
    
    // This property must be set to NO when creating
    // layout constraints for a view in code.
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (!otherHeader)
    {
        // The first header is 20 pts below the container's top.
        [self.view addConstraint:
        [NSLayoutConstraint constraintWithItem:label
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.view
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1
                                      constant:MARGIN]];
    }
    else
    {
        // Every other header is 8 pts below the previous one.
        [self.view addConstraint:
        [NSLayoutConstraint constraintWithItem:label
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:otherHeader
                                     attribute:NSLayoutAttributeBottom
                                    multiplier:1
                                      constant:GAP]];
        
        // The right edge of all headers are pinned together.
        [self.view addConstraint:
         [NSLayoutConstraint constraintWithItem:label
                                      attribute:NSLayoutAttributeTrailing
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:otherHeader
                                      attribute:NSLayoutAttributeTrailing
                                     multiplier:1
                                       constant:0]];
    }
    
    // The left edge is 20 pts away from the container's left edge.
    [self.view addConstraint:
    [NSLayoutConstraint constraintWithItem:label
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1
                                  constant:MARGIN]];
    
    // The max width is half the container's width minus the left margin.
    // NOTE: Subtract 1 to accommodate the vertical line in the demo UI.
    NSLayoutConstraint *constraint =
    [NSLayoutConstraint constraintWithItem:label
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeWidth
                                multiplier:0.5
                                  constant:-(MARGIN + 1)];
    // Setting the priority to Low informs the Auto Layout system
    // that this constraint can be trumped, which enables the header
    // label to shrink to accommodate the value label's intrinsic width.
    constraint.priority = UILayoutPriorityDefaultLow;
    [self.view addConstraint:constraint];

    return label;
}

- (UILabel *)makeValueNextToHeader:(UILabel *)header
{
    UILabel *label = [[UILabel alloc] init];
    label.adjustsFontSizeToFitWidth = YES;
    label.text = @"Value";
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:label];
    
    // The top is pinned to the top of the associated header.
    [self.view addConstraint:
    [NSLayoutConstraint constraintWithItem:label
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:header
                                 attribute:NSLayoutAttributeTop
                                multiplier:1
                                  constant:0]];
    // The left edge is 2 pts to the right of the header.
    [self.view addConstraint:
    [NSLayoutConstraint constraintWithItem:label
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:header
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1
                                  constant:COLUMN_GAP]];
    // The right edge is 20 pts left of the container's right edge.
    [self.view addConstraint:
    [NSLayoutConstraint constraintWithItem:label
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1
                                  constant:-MARGIN]];
    return label;
}

#pragma mark - Actions

- (IBAction)showNewHeaders:(id)sender
{
    static NSArray *headers = nil;
    if (!headers)
        headers = @[
        @"Prefix:",
        @"Alibi:",
        @"Weapon:",
        @"Login:",
        @"ID:",
        @"Age:"];
    
    static int index = 0;
    
    for (UILabel *label in _headerLabels)
        label.text = headers[index++ % [headers count]];
}

- (IBAction)showNewValues:(id)sender
{
    static NSArray *values = nil;
    if (!values)
        values = @[
        @"tiny",
        @"short",
        @"not too short",
        @"much longer than before",
        @"absurdly long text written for testing purposes",
        @"minimal",
        @"shh"];
    
    static int index = 0;
    
    for (UILabel *label in _valueLabels)
        label.text = values[index++ % [values count]];
}

@end
