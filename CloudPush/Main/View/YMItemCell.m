//
//  YMItemCell.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/30.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMItemCell.h"


@interface YMItemCell ()

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imgsArr;


@end

@implementation YMItemCell
- (void)awakeFromNib {
    [super awakeFromNib];
    
    for (UIImageView* imgView in self.imgsArr) {
        imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgClick:)];
        tap.delegate = self;
        [imgView addGestureRecognizer:tap];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)shareCell{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}

-(instancetype)initWithFrame:(CGRect)frame itemsArr:(NSArray* )itemsArr SpaceX:(CGFloat)spaceX  marginX:(CGFloat)marginX spaceY:(CGFloat)spaceY marginY:(CGFloat)marginY superView:(UIView*)superView{
    if (self = [super initWithFrame:frame]) {
        
        NSMutableArray* tmpViewArr = [[NSMutableArray alloc]init];
        for (int i = 0 ; i < itemsArr.count; i ++) {
             UIImageView* imgView = [[UIImageView alloc]init];
             imgView.contentMode = UIViewContentModeScaleAspectFit;
             imgView.image = [UIImage imageNamed:itemsArr[i]];
             imgView.sd_layout.autoHeightRatio(14/35);
             imgView.tag = i;
             imgView.userInteractionEnabled = YES;
             [tmpViewArr addObject:imgView];
            
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgClick:)];
            tap.delegate = self;
            [imgView addGestureRecognizer:tap];
        }
//        self.sd_layout
//        .leftSpaceToView(superView, 10)
//        .rightSpaceToView(superView, 10)
//        .topSpaceToView(superView, 10);
        
        // 此步设置之后_autoWidthViewsContainer的高度可以根据子view自适应
        [self setupAutoWidthFlowItems:[tmpViewArr copy] withPerRowItemsCount:itemsArr.count verticalMargin:spaceY horizontalMargin:spaceX verticalEdgeInset:marginY horizontalEdgeInset:marginX];
    }
    return self;
}
-(void)imgClick:(UITapGestureRecognizer* )tap{
    DDLog(@"点击啦图片");
    if (self.tapBlock) {
        self.tapBlock(tap);
    }
    
}
@end
