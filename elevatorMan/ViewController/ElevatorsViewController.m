//
//  ElevatorsViewController.m
//  elevatorMan
//
//  Created by Cove on 15/6/16.
//
//

#import "ElevatorsViewController.h"
#import "ReportAlarmViewController.h"


#pragma mark - headerView

@interface HeaderView : UICollectionReusableView

@property (nonatomic, weak) IBOutlet UILabel *label_unitNumber;


@end


@implementation HeaderView

@end


#pragma mark - ElevatorsCell

@interface ElevatorsCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *label_elevatorNumber;
@property (nonatomic, weak) IBOutlet UIImageView *frontView;
@property (weak, nonatomic) IBOutlet UILabel *label_liftNumber;

@end


@implementation ElevatorsCell

@end


#pragma mark - ElevatorsViewController

@interface ElevatorsViewController ()
@property (nonatomic, weak) IBOutlet UICollectionViewFlowLayout *layout;


@property (nonatomic, strong) NSMutableArray *unitArray;

@end

@implementation ElevatorsViewController

static NSString *const reuseIdentifier = @"elevatorsCell";

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavTitle:@"电梯选择"];

    //根据屏幕尺寸设置cell的大小，保持每行3个cell
    self.layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 2) / 3, ([UIScreen mainScreen].bounds.size.width - 2) * 135 / 3 / 120);

    [self processUnit];
}


//处理单元数据，去重排序
- (void)processUnit {

    if (self.elevatorListArray) {

        self.unitArray = [NSMutableArray arrayWithCapacity:1];

        //获取本楼所有单元
        NSMutableArray *UnitArray = [NSMutableArray arrayWithCapacity:1];
        for (NSInteger i = 0; i < [self.elevatorListArray count]; i++) {
            [UnitArray addObject:[[self.elevatorListArray objectAtIndex:i] objectForKey:@"unitCode"]];

        }

        //去重排序
        NSSet *set = [NSSet setWithArray:UnitArray];
        NSArray *sortDesc = @[[[NSSortDescriptor alloc] initWithKey:nil ascending:YES]];
        NSArray *temp = [set sortedArrayUsingDescriptors:sortDesc];


        //重组
        for (NSInteger y = 0; y < [temp count]; y++) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];

            [dic setObject:[temp objectAtIndex:y] forKey:@"unitCode"];

            NSMutableArray *allElevatorsInUnit = [NSMutableArray arrayWithCapacity:1];

            for (NSDictionary *elevator in self.elevatorListArray) {
                if ([[elevator objectForKey:@"unitCode"] isEqualToString:[temp objectAtIndex:y]]) {
                    [allElevatorsInUnit addObject:elevator];
                }
            }

            [dic setObject:allElevatorsInUnit forKey:@"eles"];

            [self.unitArray addObject:dic];

            NSLog(@"%@", self.unitArray);
        }

    }

}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return [self.unitArray count];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [[[self.unitArray objectAtIndex:section] objectForKey:@"eles"] count];

    //return [self.elevatorListArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ElevatorsCell *cell = (ElevatorsCell *) [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];


    NSDictionary *dic = [[[self.unitArray objectAtIndex:indexPath.section] objectForKey:@"eles"] objectAtIndex:indexPath.row];
    //设置cell的图片及文字说明
    cell.label_elevatorNumber.text = [NSString stringWithFormat:@"#%@号电梯", [dic objectForKey:@"number"]];
    cell.label_liftNumber.text = [NSString stringWithFormat:@"#%@", [dic objectForKey:@"liftNum"]];


    NSString *imageName = [NSString stringWithFormat:@"icon_elevator%i.png", (int) (indexPath.row % 6 + 1)];
    cell.frontView.image = [UIImage imageNamed:imageName];

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;

    if (kind == UICollectionElementKindSectionHeader) {
        HeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"elevatorsCellHeader" forIndexPath:indexPath];

        NSString *unitString = [[self.unitArray objectAtIndex:indexPath.section] objectForKey:@"unitCode"];

        headerView.label_unitNumber.text = [NSString stringWithFormat:@"%@单元", unitString];

        reusableview = headerView;
    }

    //    if (kind == UICollectionElementKindSectionFooter)
    //    {
    //        RecipeCollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
    //reportAlarmViewController
    //        reusableview = footerview;
    //    }

    //reusableview.backgroundColor = [UIColor redColor];

    return reusableview;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {


    ReportAlarmViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"reportAlarmViewController"];
    controller.projectName = self.projectName;
    controller.buildingNum = self.buildingNum;
    controller.liftDic = [[[self.unitArray objectAtIndex:indexPath.section] objectForKey:@"eles"] objectAtIndex:indexPath.row];


    [self.navigationController pushViewController:controller animated:YES];

}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
