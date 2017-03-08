//
//  YMContentView.m
//  CloudPush
//
//  Created by YouMeng on 2017/2/28.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMContentView.h"
#import "StepView.h"
#import "SDWeiXinPhotoContainerView.h"
#import "YMDetailButtonView.h"



@interface YMContentView ()

@property(nonatomic,strong)StepView* stepView;

@property(nonatomic,strong)UILabel* contentLabel;

//滚动的图片浏览器
@property(nonatomic,strong)UIScrollView* imgScrollView;
//附件图片
@property(nonatomic,strong)SDWeiXinPhotoContainerView *picContainerView;

@end

@implementation YMContentView

//初始化
-(instancetype)initWithFrame:(CGRect)frame title:(NSString* )titile content:(NSString* )content imgsArr:(NSArray*)imgsArr detailBlocK:(void(^)(void))detailBlock{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = WhiteColor;
        // title 文案内容
        StepView* stepView1 = [[StepView alloc]initWithFrame:CGRectMake(15, 5, 50, 20) title:titile];
        [self addSubview:stepView1];

        //查看详情：
        YMDetailButtonView* detailBtn = [[YMDetailButtonView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 5, 100, 20) title:@"查看详情" textColor:[UIColor colorwithHexString:@"3DA3F5"] font:Font(10) imgStr:@"all"  actionBlock:^(UITapGestureRecognizer *tap) {
            DDLog(@"点击啦查看详情");
            self.detailBlock = detailBlock;
            if (self.detailBlock) {
                 self.detailBlock();
            }
        }];
        [self addSubview:detailBtn];
        //调整x
        detailBtn.sd_layout.xIs(SCREEN_WIDTH - detailBtn.width - 15);
        
        //content
        _contentLabel = [[UILabel alloc]init];
        [self addSubview:_contentLabel];
        _contentLabel.text = content;
        _contentLabel.font = Font(11);
        _contentLabel.textColor = HEX(@"333333");
        
        _contentLabel.sd_layout.leftEqualToView(stepView1).topSpaceToView(stepView1,5).rightSpaceToView(self,15).autoHeightRatio(0);
        CGFloat contentHeight = [YMHeightTools heightForText:content fontSize:11 width:SCREEN_WIDTH - 2 * 15];
        DDLog(@"contentHeight == %f",contentHeight);
        if (imgsArr.count > 0) {
            //添加一个图片内容的容器
            UIView* imgContentView = [[UIView alloc]init];
            [self addSubview:imgContentView];
            imgContentView.backgroundColor = WhiteColor;
            imgContentView.sd_layout.leftEqualToView(self).topSpaceToView(_contentLabel,5).rightEqualToView(self).heightIs(100);
            
            //标题
            UILabel* fileLabel = [[UILabel alloc]init];
            fileLabel.text = @"附件:";
            fileLabel.textColor = [UIColor colorwithHexString:@"333333"];
            fileLabel.font = Font(10);
//            fileLabel.backgroundColor = WhiteColor;
            [imgContentView addSubview:fileLabel];
            fileLabel.sd_layout.leftSpaceToView(imgContentView,15).topEqualToView(imgContentView).rightSpaceToView(imgContentView,15).heightIs(20);
        
//            self.imgScrollView = [[UIScrollView alloc]init];
//            [self addSubview:_imgScrollView];
//            
//            _imgScrollView.sd_layout.leftEqualToView(stepView1).topSpaceToView(fileLabel,5).rightSpaceToView(self,15).heightIs(20);
            
              //图片方案二
              _picContainerView = [SDWeiXinPhotoContainerView new];
              [imgContentView addSubview:_picContainerView];
            
            _picContainerView.sd_layout.
            leftEqualToView(fileLabel).
            topSpaceToView(fileLabel,5); // 已经在内部实现宽度和高度自适应所以不需要再设置宽度高度，top值是具体有无图片在setModel方法中设置
            _picContainerView.picPathStringsArray = imgsArr;
            
            imgContentView.sd_layout.heightIs(fileLabel.height + ( 5 + _picContainerView.height + 5));
            
           self.height = 20 + 5 * 2 + contentHeight + imgContentView.height + 5;
        }else{
           self.height = 20 + 5 * 2 + contentHeight + 5;
        }
        DDLog(@"total height == %f",self.height);
        
    }
    return self;
}
@end
