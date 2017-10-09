//
//  CutAvatarImgViewController.m
//  CutPicTest
//
//  Created by liulu on 13-4-8.
//  Copyright (c) 2013年 贵阳朗玛信息技术股份有限公司. All rights reserved.
//

#import "CutAvatarImgViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageUtil.h"

#define DEF_CUTSIZE SCREEN_WIDTH
#define DEF_HDSIZE 480.0f
#define DEF_ALBUMSIZE   720.0f
#define kBtntoolBarHeight       73.0f

#define kBtnApplyTag  100000

@interface CutAvatarImgViewController ()

@end

@implementation CutAvatarImgViewController
@synthesize sourceImage;
@synthesize backImageViewRect;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isAlbum = NO;
        _imageContainer = [[UIScrollView alloc]init];
        [self.view addSubview:_imageContainer];
        _imageContainer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        //        _imageContainer.bounces = NO;
        _imageContainer.minimumZoomScale = 1;
        _imageContainer.maximumZoomScale = 2;
        _imageContainer.showsHorizontalScrollIndicator = NO;
        _imageContainer.showsVerticalScrollIndicator = NO;
        _imageContainer.delegate = self;
        
        _imageview = [[UIImageView alloc] init];
        [_imageContainer addSubview:_imageview];
        _imageview.contentMode = UIViewContentModeScaleAspectFit;
        _imageview.layer.masksToBounds = YES;
        
        UIImage* maskImg = [UIImage imageNamed:(IPHONE5 || IPHONE6)?@"cutpicmask1136":@"cutpicmask"];
//        _maskImgView = [[UIImageView alloc] initWithImage:maskImg];
        _maskImgView = [[UIImageView alloc] init];
        _maskImgView.image = [maskImg stretchableImageWithLeftCapWidth:maskImg.size.width/2.0f topCapHeight:maskImg.size.height/2.0f];
        _maskImgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kBtntoolBarHeight);
        [self.view addSubview:_maskImgView];
        [self.view bringSubviewToFront:_maskImgView];
        
        _bottonBar = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - kBtntoolBarHeight, SCREEN_WIDTH, kBtntoolBarHeight)];
        [self.view addSubview:_bottonBar];
        
        UIImageView* imgvBarBg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"call_record_detail_bottom_background"]];
        imgvBarBg.frame = CGRectMake(0, 0, _bottonBar.frame.size.width, _bottonBar.frame.size.height);
        [_bottonBar addSubview:imgvBarBg];
        [imgvBarBg release];
        
        UIButton* btnApply = [[UIButton alloc] init];
//        [btnApply setImage:[UIImage imageNamed:@"cutpicbtn_apply.png"] forState:UIControlStateNormal];
        [btnApply setBackgroundImage:[UIImage imageNamed:@"cutpicbtn_apply"] forState:UIControlStateNormal];
        [btnApply setBackgroundImage:[UIImage imageNamed:@"cutpicbtn_apply_clicked"] forState:UIControlStateHighlighted];
        //[btnApply setImageEdgeInsets:UIEdgeInsetsMake(7, 5, 3, 5)];

        [btnApply addTarget:self action:@selector(selectImage) forControlEvents:UIControlEventTouchUpInside];
        [btnApply setTitle:@"确定" forState:UIControlStateNormal];
        btnApply.titleLabel.font = [UIFont systemFontOfSize:15];
        [btnApply setTitleColor:[UIColor colorWithRGB:0x1e9e49] forState:UIControlStateNormal];
        [btnApply setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        btnApply.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        btnApply.tag = kBtnApplyTag;
        [btnApply sizeToFit];
        btnApply.frame = CGRectMake(SCREEN_WIDTH - 30 - btnApply.frame.size.width, 15, btnApply.frame.size.width, btnApply.frame.size.height);
        [_bottonBar addSubview:btnApply];
        [btnApply release];
        
        UIButton* btnCancel = [[UIButton alloc] init];
        [btnCancel setBackgroundImage:[UIImage imageNamed:@"cutpicbtn_cancel.png"] forState:UIControlStateNormal];
        [btnCancel setBackgroundImage:[UIImage imageNamed:@"cutpicbtn_cancel_clicked.png"] forState:UIControlStateHighlighted];
        [btnCancel addTarget:self action:@selector(btnCancelClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btnCancel setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
        btnCancel.titleLabel.font = [UIFont systemFontOfSize:15];
        btnCancel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [btnCancel setTitleColor:[UIColor colorWithRGB:0xf23a4b] forState:UIControlStateNormal];
        [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btnCancel sizeToFit];
        btnCancel.frame = CGRectMake(30, 15, btnCancel.frame.size.width, btnCancel.frame.size.height);
        [_bottonBar addSubview:btnCancel];
        [btnCancel release];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _statuBarDefaultState = [UIApplication sharedApplication].statusBarHidden;
	// Do any additional setup after loading the view.
//    UIBarButtonItem* selectBtn =  [[UIBarButtonItem alloc] initWithTitle:@"选择"  style:UIBarButtonItemStyleDone  target:self  action:@selector(selectImage)];
//    self.navigationItem.rightBarButtonItem =  selectBtn;
//    [selectBtn release];
    if (IOS7) {
        self.view.alpha = 1;
        self.navigationController.navigationBar.alpha = 1;
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
            [self setNeedsStatusBarAppearanceUpdate];
        }
    }
}

- (void)dealloc{
    backImageViewRect = CGRectZero;
    [_bottonBar release];
    [_maskImgView release];
    [_imageContainer release];
    [_imageview release];
    [sourceImage release];
    [delegate release];
    [super dealloc];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.view.backgroundColor = [UIColor blackColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnCancelClicked:(UIButton*)sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:_statuBarDefaultState];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectImage
{
    CGPoint point = CGPointMake(_imageContainer.contentOffset.x + (SCREEN_WIDTH - DEF_CUTSIZE)/2, _imageContainer.contentOffset.y + (_maskImgView.frame.size.height - DEF_CUTSIZE)/2);
    CGRect imageRect = CGRectMake(point.x * (self.sourceImage.size.width / _imageview.frame.size.width), point.y * (self.sourceImage.size.height / _imageview.frame.size.height), DEF_CUTSIZE * (self.sourceImage.size.width / _imageview.frame.size.width), DEF_CUTSIZE * (self.sourceImage.size.height / _imageview.frame.size.height));
    
    CGSize picSize = CGSizeMake(DEF_HDSIZE, DEF_HDSIZE);
    subImage = [ImageUtil compressImageToRect:[self getImageFromImage:self.sourceImage subImageSize:imageRect.size subImageRect:imageRect] withSize:picSize];

    //是否需要退出动画
    if (self.backImageViewRect.size.width!=0&&self.backImageViewRect.size.height!=0) {
        _imageviewCut = [[[UIImageView alloc]init]autorelease];
        [_imageviewCut setImage:subImage];
        _imageviewCut.frame = CGRectMake((SCREEN_WIDTH - DEF_CUTSIZE)/2, (_maskImgView.frame.size.height - DEF_CUTSIZE)/2, DEF_CUTSIZE, DEF_CUTSIZE);
        [self.view addSubview:_imageviewCut];
        [self.view bringSubviewToFront:_maskImgView];
        
        [UIView animateWithDuration:.2 animations:^{
            _imageview.alpha = 0;
            self.navigationController.navigationBar.alpha = 0;
            _bottonBar.alpha = 0;
            _maskImgView.alpha = 0;
        } completion:^(BOOL finished) {
            if(finished)
            {
                [UIView animateWithDuration:.5 animations:^{
                    //由于没有顶部导航栏，+44像素
                    _imageviewCut.frame = CGRectMake(self.backImageViewRect.origin.x, self.backImageViewRect.origin.y + 44, self.backImageViewRect.size.width, self.backImageViewRect.size.height);//self.backImageViewRect;
                }completion:^(BOOL finished){
                    if (self.delegate&&[self.delegate respondsToSelector:@selector(cutImgFinish:)]) {
                        [self.delegate cutImgFinish:subImage];
                    }
                    if (self.isAlbum) {
                        [self.navigationController popViewControllerAnimated:NO];
                    } else {
                        [self dismissViewControllerAnimated:NO completion:nil];
                    }
                }];
            }
        }];
    }else{
        if (self.delegate&&[self.delegate respondsToSelector:@selector(cutImgFinish:)]) {
            [self.delegate cutImgFinish:subImage];
        }

        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)setSourceImage:(UIImage *)image
{
    sourceImage = [image retain];
    [_imageview setImage:self.sourceImage];
    CGFloat wh = sourceImage.size.width/sourceImage.size.height;
    CGSize displaySize;
    if (wh > 1) {//宽图
        //        _imageContainer.maximumZoomScale = ((sourceImage.size.height / DEF_CUTSIZE > 1)&&(sourceImage.size.height / DEF_CUTSIZE)*(DEF_CUTSIZE/DEF_HDSIZE) > 1) ? (sourceImage.size.height / DEF_CUTSIZE)*(DEF_CUTSIZE/720) : 1;//设置放大倍数
        isImgAvailable = (sourceImage.size.height*2 < DEF_CUTSIZE) ? NO : YES;//检查图片是否可用
        displaySize = CGSizeMake(sourceImage.size.width*(DEF_CUTSIZE/sourceImage.size.height), DEF_CUTSIZE);
    }else{//高图
        //        _imageContainer.maximumZoomScale = ((sourceImage.size.width / DEF_CUTSIZE > 1)&&(sourceImage.size.width / DEF_CUTSIZE)*(DEF_CUTSIZE/DEF_HDSIZE) > 1) ? (sourceImage.size.width / DEF_CUTSIZE)*(DEF_CUTSIZE/720) : 1;//设置放大倍数
        isImgAvailable = (sourceImage.size.width*2 < DEF_CUTSIZE) ? NO : YES;//检查图片是否可用
        displaySize = CGSizeMake(DEF_CUTSIZE, sourceImage.size.height*(DEF_CUTSIZE/sourceImage.size.width));
    }
    _imageview.frame = CGRectMake(0, 0, displaySize.width, displaySize.height);
    _imageContainer.contentSize = _imageview.frame.size;
    _imageContainer.contentInset = UIEdgeInsetsMake((_maskImgView.frame.size.height - DEF_CUTSIZE)/2, (SCREEN_WIDTH - DEF_CUTSIZE)/2, (SCREEN_HEIGHT - DEF_CUTSIZE - (_maskImgView.frame.size.height - DEF_CUTSIZE)/2), (SCREEN_WIDTH - DEF_CUTSIZE)/2);
    
    //让图片居中显示
    _imageContainer.contentOffset = (wh>1) ? CGPointMake((displaySize.width - SCREEN_WIDTH)/2, _imageContainer.contentOffset.y) : CGPointMake(_imageContainer.contentOffset.x, (displaySize.height - _maskImgView.frame.size.height)/2);
    _imageContainer.zoomScale = SCREEN_WIDTH/DEF_CUTSIZE;
}

//图片裁剪
-(UIImage *)getImageFromImage:(UIImage*) superImage subImageSize:(CGSize)subImageSize subImageRect:(CGRect)subImageRect
{
    //    CGSize subImageSize = CGSizeMake(WIDTH, HEIGHT); //定义裁剪的区域相对于原图片的位置
    //    CGRect subImageRect = CGRectMake(START_X, START_Y, WIDTH, HEIGHT);
    CGImageRef imageRef = superImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subImageRect);
    UIGraphicsBeginImageContext(subImageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, subImageRect, subImageRef);
    UIImage* returnImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext(); //返回裁剪的部分图像
    CFRelease(subImageRef);
    return returnImage;
}

#pragma mark -
#pragma mark scrollviewdelegate
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageview;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    UIButton *btn = (UIButton *)[_bottonBar viewWithTag:kBtnApplyTag];
    btn.enabled = NO;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    UIButton *btn = (UIButton *)[_bottonBar viewWithTag:kBtnApplyTag];
    btn.enabled = YES;
}

@end
