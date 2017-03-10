//
//  LPShareImage.m
//  TYImage
//
//  Created by 童万华 on 2017/3/9.
//  Copyright © 2017年 童万华. All rights reserved.
//

#import "LPShareImage.h"
#import "UIImage+Extentions.h"
#define   ThimeBackFont   (([[[UIDevice currentDevice] systemVersion] floatValue])   >   (8.0)   ?   (@"KohinoorDevanagari-Light")   :   ([UIFont systemFontOfSize:10].fontName))
typedef NS_ENUM(NSInteger,LPShareImageType) {
    LPShareImageTypeInfo =1 << 0,
    LPShareImageTypePass =1 << 1,
    LPShareImageTypeRunEnd =2 << 1,
};
@interface LPShareImage() {
    NSString *_people;
}
@property (nonatomic,assign) LPShareImageType type;
@end
@implementation LPShareImage
-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(UIImage *)addHeadImage:(UIImage *)headImaeg detail:(NSString *)detail position:(CGPoint)position{
    UIImage *shareImage;
    switch (self.type) {
        case LPShareImageTypeInfo:
           shareImage = [UIImage imageNamed:@"gameShare"];
            break;
        case LPShareImageTypePass:
            shareImage = [UIImage imageNamed:@"gamePass"];
            break;
        case LPShareImageTypeRunEnd:
            shareImage = [UIImage imageNamed:@"gameEnd"];
            break;
    }
   //CGPointMake(40, 88)
    shareImage = [shareImage addImage:headImaeg position:position];
    if (detail) {
         shareImage = [self addTitile:shareImage detail:detail];
    }
    return shareImage;
}
#pragma mark --public method
-(UIImage *)shareGameInfo:(NSString *)shareTitle filePath:(NSString *)path detail:(NSString *)detail number:(NSString*)number{
    _people = number;
    self.type = LPShareImageTypeInfo;
   UIImage *headImage = [self generateHeadImage:shareTitle gamePic:path size:CGSizeMake(670, 268) radius:12];
    return  [self addHeadImage:headImage detail:detail position:CGPointMake(40, 94)];
}
-(UIImage *)shareGamePass:(NSString *)shareTitle filePath:(NSString *)path grades:(NSDictionary *)grades detail:(NSString *)detail{
   self.type = LPShareImageTypePass;
   UIImage *headImage = [self generateHeadImage:shareTitle gamePic:path size:CGSizeMake(670, 268) radius:0];
   UIImage *shareImage = [self addHeadImage:headImage detail:detail position:CGPointMake(40, 94)];
   shareImage = [self fillGradesInContainer:grades image:shareImage];
    return shareImage;
}
-(UIImage *)shareGameEnd:(NSString *)shareTitle filePath:(NSString *)path grades:(NSDictionary *)grades{
     self.type = LPShareImageTypeRunEnd;
     UIImage *headImage = [self generateHeadImage:shareTitle gamePic:path size:CGSizeMake(670, 490) radius:0];
     UIImage *shareImage = [self addHeadImage:headImage detail:nil position:CGPointMake(40, 114)];
    shareImage = [self fillScoreInContainer:grades image:shareImage];
    return shareImage;
}
#pragma mark --private method


-(UIImage *)generateHeadImage:(NSString *)name gamePic:(NSString *)path size:(CGSize)size radius:(CGFloat)radius{
    UIImage *textContainer = [UIImage imageNamed:@"textContainer"];
    UIImage *headImage = [UIImage imageWithContentsOfFile:path];
    if (!headImage) {
        headImage = [UIImage imageNamed:@"header"];
    }
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:24]};
    CGSize textSize = [name boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    if (textSize.width < textContainer.size.width) {//不需要拉伸
        
    }else {
        CGSize size = CGSizeMake(textSize.width+10, textContainer.size.height);
        textContainer = [UIImage OriginImage:textContainer scaleToSize:size];
    }
    //计算位置
    CGFloat containerW = textContainer.size.width;
    CGFloat containerH = textContainer.size.height;
    CGFloat textStartX = (containerW - textSize.width)/2;
    CGFloat textStartY = (containerH - textSize.height)/2;
    textContainer = [textContainer imageWithText:name position:CGPointMake(textStartX, textStartY) attributes:attributes lineWidth:MAXFLOAT];
    //CGSizeMake(670, 268) radius = 12
    headImage = [UIImage createRoundedRectImage:headImage size:size radius:radius];
    headImage = [headImage addImage:textContainer position:CGPointMake(0, 14)];
    return headImage;
}
-(UIImage *)fillGradesInContainer:(NSDictionary *)grades image:(UIImage *)image{
    if (!grades) {
        grades = @{@"time":@"1:50:20",@"point":@"26",@"experience":@"10",@"bonus":@"5.0"};
    }
    //
   image = [self drawTime:grades[@"time"] image:image];
    //确定位置
    CGFloat pointStartX = 155.0;
    CGFloat StartY = 940.0;
    CGPoint p = CGPointMake(pointStartX, StartY);
    NSDictionary *pointAttributes = @{NSFontAttributeName:[UIFont fontWithName:ThimeBackFont size:34],NSForegroundColorAttributeName:[UIColor colorWithRed:253/255.0 green:137/255.0 blue:107/255.0 alpha:1.0]};
    
    CGFloat expStartX =  355.0;
    CGPoint expPoint = CGPointMake(expStartX, StartY);
    NSDictionary *expAttributes = @{NSFontAttributeName:[UIFont fontWithName:ThimeBackFont size:34],NSForegroundColorAttributeName:[UIColor colorWithRed:254/255.0 green:111/255.0 blue:158/255.0 alpha:1.0]};
    CGFloat endStartX = 555.0;
    CGPoint endPoint = CGPointMake(endStartX , StartY);
    NSDictionary *endAttributes = @{NSFontAttributeName:[UIFont fontWithName:ThimeBackFont size:34],NSForegroundColorAttributeName:[UIColor colorWithRed:98/255.0 green:213/255.0 blue:222/255.0 alpha:1.0]};
   image = [self drawPoint:grades[@"point"] image:image position:p attributes:pointAttributes];
   image = [self drawPoint:grades[@"experience"] image:image position:expPoint attributes:expAttributes];
   image = [self drawPoint:grades[@"bonus"] image:image position:endPoint attributes:endAttributes];
   return image;
}
-(UIImage *)fillScoreInContainer:(NSDictionary *)grades image:(UIImage *)image {
    if (!grades) {
        grades = @{@"mileage":@"20.5km",@"speed":@"20'20''",@"time":@"1:50:00",@"point":@"26",@"bonus":@"5.0"};
    }
    
    //确定里程、配速、用时的位置
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:ThimeBackFont size:34],NSForegroundColorAttributeName:[UIColor blackColor]};
    CGFloat milStartX = 130;
    CGFloat milStartY = 750;
    CGPoint milPoint = CGPointMake(milStartX, milStartY);
    image = [self drawPoint:grades[@"mileage"] image:image position:milPoint attributes:attributes];
    CGFloat speedStartX =  330;
    CGPoint speedPoint = CGPointMake(speedStartX, milStartY);
    image = [self drawPoint:grades[@"speed"] image:image position:speedPoint attributes:attributes];
    CGFloat timeStartX = 530;
    CGPoint timePoint = CGPointMake(timeStartX, milStartY);
    image = [self drawPoint:grades[@"time"] image:image position:timePoint attributes:attributes];
 
    //确定积分、红包位置
    CGFloat pointStartX = 260.0;
    CGFloat StartY = 880.0;
    CGPoint p = CGPointMake(pointStartX, StartY);
    NSDictionary *pointAttributes = @{NSFontAttributeName:[UIFont fontWithName:ThimeBackFont size:34],NSForegroundColorAttributeName:[UIColor colorWithRed:255/255.0 green:137/255.0 blue:111/255.0 alpha:1.0]};
    image = [self drawPoint:grades[@"point"] image:image position:p attributes:pointAttributes];
    CGFloat mStartX =  580.0;
    CGPoint mPoint = CGPointMake(mStartX, StartY);
    NSDictionary *mattributes = @{NSFontAttributeName:[UIFont fontWithName:ThimeBackFont size:34],NSForegroundColorAttributeName:[UIColor colorWithRed:96/255.0 green:213/255.0 blue:221/255.0 alpha:1.0]};
    image = [self drawPoint:grades[@"bonus"] image:image position:mPoint attributes:mattributes];
    return image;
}
-(UIImage *)drawTime:(NSString *)time image:(UIImage *)image{
    CGFloat timeStartX = 355.0;
    CGFloat timeStartY = 655.0;
    CGPoint timePiont = CGPointMake(timeStartX, timeStartY);
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:ThimeBackFont size:34],NSForegroundColorAttributeName:[UIColor colorWithRed:255/255.0 green:168/255.0 blue:2/255.0 alpha:1.0]};
    return  [image imageWithText:time position:timePiont attributes:attributes lineWidth:MAXFLOAT];
}

-(UIImage *)drawPoint:(NSString *)point image:(UIImage *)image position:(CGPoint)position attributes:(NSDictionary *)attributes{
    return  [image imageWithText:point position:position attributes:attributes lineWidth:MAXFLOAT];
}
-(UIImage *)addTitile:(UIImage *)image detail:(NSString *)detail{
    NSString *title = @"游戏简介";
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont fontWithName:ThimeBackFont size:30]};
    CGSize textSize = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    //计算位置
    CGFloat containerW = image.size.width;
    CGFloat textStartX = (containerW - textSize.width)/2;
    CGFloat textStartY = 362+12;//268+88+12+6;
    image = [image imageWithText:title position:CGPointMake(textStartX, textStartY) attributes:attributes lineWidth:MAXFLOAT];
    image = [self addDetial:image titleHeight:textSize.height detial:detail];
   
    return image;
}
-(UIImage *)addDetial:(UIImage *)image titleHeight:(CGFloat)height detial:(NSString *)detail{
    if (!detail) {
        detail = @"线下叶的离开是风的追随，还是树的不挽留，她的离开犹如一片自由洒脱的树叶，随着微风翩翩起舞消失在茫茫树林之间......";
    }
//    NSString *detial = @"线下叶的离开是风的追随，还是树的不挽留，她的离开犹如一片自由洒脱的树叶，随着微风翩翩起舞消失在茫茫树林之间......";
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6;
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont fontWithName:ThimeBackFont size:28],NSParagraphStyleAttributeName:paragraphStyle};
    CGFloat margin = 24;
    //计算位置
    CGFloat textStartX = 40+margin;
    CGFloat textStartY = 362+margin+height;
    image = [image imageWithText:detail position:CGPointMake(textStartX, textStartY) attributes:attributes lineWidth:622];
    if (_people) {
         image = [self addAddition:image];
    }
    return image;
}
- (UIImage *)addAddition:(UIImage *)image {
    //    NSString *addition = @"超过1000人在玩的游戏，你还在附近徘徊？";
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont fontWithName:ThimeBackFont size:28]};
    NSDictionary *pattributes = @{NSForegroundColorAttributeName:[UIColor orangeColor],NSFontAttributeName:[UIFont fontWithName:ThimeBackFont size:32]};
    CGPoint startPoint = [self getStartPoint];
    image = [image imageWithText:@"超过" position:startPoint attributes:attributes lineWidth:MAXFLOAT];
    CGPoint pPoint = [self getPeoplePoint:startPoint.x];
    image = [image imageWithText:_people position:pPoint attributes:pattributes lineWidth:MAXFLOAT];
    CGPoint ePoint = [self getTextPoint:pPoint.x];
    image = [image imageWithText:@"人在玩的游戏，你还在附近徘徊？" position:ePoint attributes:attributes lineWidth:MAXFLOAT];
    return image;
}
-(CGPoint)getStartPoint {
    CGSize peopleSize = [self getPeopleSize];
    CGSize textSize = [self getTextSize:@"超过人在玩的游戏，你还在附近徘徊？"];
    CGFloat width = peopleSize.width+textSize.width;
    CGFloat textStartX = (750-width)/2;
    CGFloat textStartY = 960-66-textSize.height+94;
    
    return CGPointMake(textStartX, textStartY);
}
-(CGPoint)getPeoplePoint:(CGFloat)startX{
    CGSize peopleSize = [self getPeopleSize];
    CGSize headSize = [self getTextSize:@"超过"];
    CGFloat textStartX =startX+headSize.width;
    CGFloat textStartY = 960-66-peopleSize.height+94;
    return CGPointMake(textStartX, textStartY);
}
-(CGPoint)getTextPoint:(CGFloat)startX{
    CGSize peopleSize = [self getPeopleSize];
    CGSize headSize = [self getTextSize:@"超过"];
    CGFloat textStartX = startX+peopleSize.width;
    CGFloat textStartY = 960-66-headSize.height+94;
    return CGPointMake(textStartX, textStartY);
}
-(CGSize)getTextSize:(NSString *)text{
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont fontWithName:ThimeBackFont size:28]};
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return textSize;
}
-(CGSize)getPeopleSize{
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor orangeColor],NSFontAttributeName:[UIFont fontWithName:ThimeBackFont size:32]};
    CGSize textSize = [_people boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return textSize;
}
//-(void)saveImage:(UIImage *)image{
//    NSData *imgData = UIImagePNGRepresentation(image);
//    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"tmp.png"];
//    NSAssert( [imgData writeToFile:path atomically:YES], @"保存失败");
//    NSLog(@"path = %@",path);
//}

@end
