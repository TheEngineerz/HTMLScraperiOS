//
//  ScraperMain.m
//  Scraper
//
//  Created by The Engineer on 21/10/2014.
//  Copyright (c) 2014 Aliens Lab. All rights reserved.
//

#import "ScraperMain.h"
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "UIKit+AFNetworking.h"

@interface ScraperMain ()
{
    TFHpple *parser;
    UIActivityIndicatorView *activityIndi;
}

@end

@implementation ScraperMain

@synthesize informationView, informationButton, url, titleLabel, image, descriptionTextView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, self.titleLabel.frame.size.height)];
    titleLabel.leftView = paddingView;
    paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, self.titleLabel.frame.size.height)];
    url.leftView = paddingView;
    titleLabel.leftViewMode = UITextFieldViewModeAlways;
    url.leftViewMode = UITextFieldViewModeAlways;
    
    activityIndi = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndi.center = self.view.center;
    [self.view addSubview:activityIndi];
    [activityIndi setHidden:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
   [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 101)
    {
        if ([textField.text isEqualToString:@""])
        {
            [textField setText:@"http://"];
        }
        [informationButton setEnabled:NO];
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.tag == 101)
    {
        if([self validateUrl:textField.text])
        {
            [informationButton setEnabled:YES];
        }
    }
}


- (BOOL) validateUrl: (NSString *) candidate {
    NSString *urlRegEx =  @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}
-(void)updateViewWithData:(NSData *)htmldata
{
    TFHppleElement *element = [self executeXpathQuery:@"//title" HTMLData:htmldata];
    titleLabel.text = [[element firstChild] content];
    element = [self executeXpathQuery:@"//meta[@name='description']" HTMLData:htmldata];
    descriptionTextView.text = [[element attributes] objectForKey:@"content"];
    element = [self executeXpathQuery:@"//meta[@property='og:image']" HTMLData:htmldata];
    [image setImageWithURL:[NSURL URLWithString:[[element attributes] objectForKey:@"content"]]];
    [activityIndi stopAnimating];
    
}
-(TFHppleElement *)executeXpathQuery:(NSString *)xpathqueryString HTMLData:(NSData *)data
{
    parser = [TFHpple hppleWithHTMLData:data];
    NSArray *nodes = [parser searchWithXPathQuery:xpathqueryString];
    NSLog(@" Nodes %@",nodes);
    if(nodes.count > 0)
    {
        return [nodes objectAtIndex:0];
    }
    return nil;

}
-(NSData *)getDataFromURL:(NSString *)urlString
{
    NSURL *nsurl = [NSURL URLWithString:urlString];
    NSData *htmlData = [NSData dataWithContentsOfURL:nsurl];
    return htmlData;
}
- (IBAction)download:(id)sender
{
    [activityIndi startAnimating];
    if ([self validateUrl:url.text])
    {
        NSLog(@"%@",url.text);
        NSData *htmlData = [self getDataFromURL:url.text];
        if (![htmlData isKindOfClass:[NSNull class]])
        {
            [self updateViewWithData:htmlData];
            [self showInformationViewAnimatedly];
        }
    }

}
-(void)showInformationViewAnimatedly
{
    [informationView setHidden:NO];
    [UIView animateWithDuration:0.5 animations:^{
        [informationView setFrame:CGRectMake(16, 135, 288, 220)];
        [image setFrame:CGRectMake(8, 71, 120, 120)];
        [descriptionTextView setFrame:CGRectMake(136, 71, 144, 120)];
        [titleLabel setFrame:CGRectMake(8, 8, 272, 55)];
        [informationButton setFrame:CGRectMake(130, 387, 60, 60)];
    } completion:^(BOOL finished) {
    
    }];
}
-(void)hideInformationViewAnimatedly
{
    [UIView animateWithDuration:0.5 animations:^{
        [informationView setFrame:CGRectMake(16, 135, 288, 0)];
        [image setFrame:CGRectMake(8, 71, 120, 0)];
        [descriptionTextView setFrame:CGRectMake(136, 71, 144, 0)];
        [titleLabel setFrame:CGRectMake(8, 8, 272, 0)];
        [informationButton setFrame:CGRectMake(130, 167, 60, 60)];
    } completion:^(BOOL finished) {
        [informationButton setHidden:YES];
    }];
}
@end
