//
//  ViewController.m
//  TYImage
//
//  Created by 童万华 on 2017/3/9.
//  Copyright © 2017年 童万华. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+Extentions.h"
#define   ThimeBackFont   (([[[UIDevice currentDevice] systemVersion] floatValue])   >   (8.0)   ?   (@"KohinoorDevanagari-Light")   :   ([UIFont systemFontOfSize:10].fontName))
#import "LPShareImage.h"
@interface ViewController ()
@property (nonatomic,retain) UIImage *shareImage;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LPShareImage *share = [[LPShareImage alloc] init];
    UIImage *shareImage = [share shareGameInfo:@"失约之城" filePath:nil detail:@"线下叶的离开是风的追随，还是树的不挽留，她的离开犹如一片自由洒脱的树叶，随着微风翩翩起舞消失在茫茫树林之间......" number:@"20000"];
    [self saveImage:shareImage];
}

-(void)saveImage:(UIImage *)image{
    NSData *imgData = UIImagePNGRepresentation(image);
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"tmp.png"];
    NSAssert( [imgData writeToFile:path atomically:YES], @"保存失败");
    NSLog(@"path = %@",path);
}
@end
