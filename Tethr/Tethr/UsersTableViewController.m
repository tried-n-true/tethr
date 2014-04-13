

#import "UsersTableViewController.h"
#import "User.h"
#import "GetUsersOperation.h"
#import "Model.h"
#import "UIImageView+WebCache.h"
#import "MapViewController.h"

@interface UsersTableViewController ()

@property (nonatomic, strong) NSArray *allUsers;

@end

@implementation UsersTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
    GetUsersOperation *operation = [[GetUsersOperation alloc] initWithActivity:@"activity" andVenue:@"venue" andCompletion:^(NSArray *allUsers,NSError *error)
    {
        self.allUsers = allUsers;
        [self.tableView reloadData];
    }];
    [[self venueReportQueue] addOperation:operation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSOperationQueue *)venueReportQueue
{
    static NSOperationQueue *queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = 4;
        queue.name = [[[NSBundle mainBundle] bundleIdentifier] stringByAppendingString:@".venue"];
    });
    
    return queue;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.allUsers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    User *user = self.allUsers[indexPath.row];
    
    cell.textLabel.text = user.name;
    [cell.imageView setImageWithURL:[[NSURL  alloc] initWithString:user.image_url]];
    
    return cell;
}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    Venue *venue = self.model.venues[indexPath.row];
//    [self performSegueWithIdentifier:@"goToMapView" sender:venue];
//    
//}


//-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    
//    MapViewController *vc= [segue destinationViewController];
//    Venue *selectedVenue= (Venue*)sender;
//    vc.latitude= selectedVenue.lat;
//    vc.longitude= selectedVenue.longitude;
//    
//}



@end
