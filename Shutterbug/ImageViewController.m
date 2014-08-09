//
//  ImageViewController.m
//  Imaginarium
//
//  Created by Sayantan Chakraborty on 09/08/14.
//  Copyright (c) 2014 Sayantan Chakraborty. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage* image;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation ImageViewController

-(void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    _scrollView.minimumZoomScale = 0.2;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.delegate = self;
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

-(void)setImageUrl:(NSURL *)imageUrl
{
    _imageUrl = imageUrl;
    //self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.imageUrl]];
    [self startDownloadinImage];
}
-(void)startDownloadinImage
{
    self.image = nil;
    if(self.imageUrl)
    {
        [self.spinner startAnimating];
        NSURLRequest *request = [NSURLRequest requestWithURL:self.imageUrl];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
                        completionHandler:^(NSURL *localFile, NSURLResponse *response, NSError *error) {
                            if (!error) {
                                if ([request.URL isEqual:self.imageUrl]) {
                                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localFile]];
                                    dispatch_async(dispatch_get_main_queue(), ^{self.image = image;});
                                    NSLog(@"Downloadin: %@", self.imageUrl);
                                }
                            }
                        }];
        [task resume];
    }
    
}


-(UIImageView *)imageView
{
    if(!_imageView) _imageView =[[UIImageView alloc]init];
    
    return _imageView;
}

-(UIImage *)image
{
    return self.imageView.image;
}

-(void)setImage:(UIImage *)image
{
    self.imageView.image = image;
    [self.imageView sizeToFit];
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
    [self.spinner stopAnimating];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.scrollView addSubview:self.imageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
