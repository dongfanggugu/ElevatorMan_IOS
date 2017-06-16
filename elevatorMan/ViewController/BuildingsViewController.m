//
//  BuildingsViewController.m
//  elevatorMan
//
//  Created by Cove on 15/6/16.
//
//

#import "BuildingsViewController.h"
#import "ElevatorsViewController.h"

#pragma mark - BuildingsCell

@interface BuildingsCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *label_buildNumber;
@property (nonatomic, weak) IBOutlet UIImageView *frontView;

@end


@implementation BuildingsCell

@end


#pragma mark - BuildingsViewController

@interface BuildingsViewController ()
@property (nonatomic, weak) IBOutlet UICollectionViewFlowLayout *layout;
@end

@implementation BuildingsViewController

static NSString *const reuseIdentifier = @"buildingsCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle:@"楼号选择"];

    //根据屏幕尺寸设置cell的大小，保持每行3个cell
    self.layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 2) / 3, ([UIScreen mainScreen].bounds.size.width - 2) * 135 / 3 / 120);

    //self.title = @"选择楼号";

}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return [self.buildingArray count];;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString * const reuseIdentifier = @"buildingsCell";
    BuildingsCell *cell = (BuildingsCell *) [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    //cell.backgroundColor = [UIColor blueColor];

    // Configure the cell
    //设置cell的图片及文字说明
    cell.label_buildNumber.text = [NSString stringWithFormat:@"%@号楼", [[self.buildingArray objectAtIndex:indexPath.row] objectForKey:@"buildingCode"]];

    //
    NSString *imageName = [NSString stringWithFormat:@"%ib.png", (int) (indexPath.row % 6 + 1)];
    cell.frontView.image = [UIImage imageNamed:imageName];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    ElevatorsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"elevatorsViewController"];
    controller.projectName = self.projectName;
    controller.buildingNum = [[self.buildingArray objectAtIndex:indexPath.row] objectForKey:@"buildingCode"];
    controller.elevatorListArray = [[self.buildingArray objectAtIndex:indexPath.row] objectForKey:@"elevatorList"];
    [self.navigationController pushViewController:controller animated:YES];
}


@end
