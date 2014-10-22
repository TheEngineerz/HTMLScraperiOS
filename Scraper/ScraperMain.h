//
//  ScraperMain.h
//  Scraper
//
//  Created by The Engineer on 21/10/2014.
//  Copyright (c) 2014 Aliens Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScraperMain : UIViewController <UITextFieldDelegate>
{
    NSString *pageTitle, *pageDiscription, *pageURL, *pageImageURL;
}

@property (strong, nonatomic) IBOutlet UITextField *url;
@property (strong, nonatomic) IBOutlet UITextField *titleLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UIButton *informationButton;
@property (strong, nonatomic) IBOutlet UIView *informationView;

@end
