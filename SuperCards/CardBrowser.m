	//
//  CardBrowser.m
//  my eCards
//
//  Created by Sean Reichle on 3/18/11.
//  Copyright 2011 Adventesia LLC. All rights reserved.
//

#import "json.h"
#import "CardBrowser.h" 
#import "CardTableViewCell.h"
#import "Cards.h"
#import "Category.h"

@implementation CardBrowser
@synthesize CardsData, CategoryData, sections, tmpCell, fetchedResultsController;

#define CELL_CARD_TITLE 1
#define CELL_CARD_IMAGE 2
#define CELL_CARD_BUTTON 3

- (id) initWithManagedObject:(NSManagedObjectContext *)context{
    
    [super initWithStyle:UITableViewStylePlain];
    
    CardsData = nil;
    CategoryData = nil;
    managedObjectContext = context;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Cards" inManagedObjectContext:managedObjectContext];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"CategoryID" ascending:YES]; 
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    [request setEntity:entity];
    [request setPredicate:nil];
    
    fetchedResultsController = [[NSFetchedResultsController alloc]
            initWithFetchRequest:request
            managedObjectContext:managedObjectContext
            sectionNameKeyPath:@"CategoryID"
            cacheName:nil];
     NSError *error=nil;
     [fetchedResultsController performFetch:&error];

    [sortDescriptors release];
    [sortDescriptor release];
    [request release];
    
    //Check Database against the server, are more cards available?
    //Lets do this elsewhere on a new thread... block?
    /*
    int CardsInDB = [self getCardCountFromDB];
     int CardsOnServer = [self getCardCountFromServer];
    if( CardsOnServer != CardsInDB ){ 
        [self removeCards];
        [self removeCategories];
        [self GetJsonFromServer]; 
    }
     */
    
    return self;
}

- (void)loadView{
    [super viewDidLoad];
     
     self.tableView = [[UITableView alloc] init];
     self.tableView.allowsSelectionDuringEditing = NO;
     self.tableView.rowHeight = 250;
     self.tableView.backgroundColor = [UIColor clearColor];
   
     //Set the BG Image
     UIImage *eCardTableBG = [UIImage imageNamed:@"LeatherBG.png"];
     self.tableView.backgroundView = [[[UIImageView alloc] initWithImage:eCardTableBG highlightedImage:eCardTableBG] autorelease];
     
     //Set the Table Header
     UIImageView *cardTableHeader = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 60)] autorelease];
     cardTableHeader.image = [UIImage imageNamed:@"header_bg.png"];
     self.tableView.tableHeaderView = cardTableHeader;
}


/* My Data Accessors */
-(NSArray*) LoadCategories{
    NSError *error = nil;
    //Now do a fetch request and see what's there?
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:nil];
    
    self.CategoryData = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if(error != nil){ NSLog([error description]); }
    
    [fetchRequest release]; 
    return self.CategoryData;
}

-(NSArray*) LoadCards{
    NSError *error = nil;
    //Now do a fetch request and see what's there?
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Cards" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:nil];
    
    self.CardsData = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if(error != nil){ NSLog([error description]); }
    
    [fetchRequest release]; 
    return self.CardsData;
}

-(void) removeCards{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Cards" inManagedObjectContext:managedObjectContext];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:nil];
    
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for(Cards *obj in fetchedObjects){
        [managedObjectContext deleteObject:obj];
    }
    [managedObjectContext save:&error];
    if(error != nil){ NSLog([error description]); }
    
    [fetchRequest release];
}

-(void) removeCategories{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:managedObjectContext];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:nil];
    
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for(Category *obj in fetchedObjects){
        [managedObjectContext deleteObject:obj];
    }
    [managedObjectContext save:&error];
    if(error != nil){ NSLog([error description]); }
    
    [fetchRequest release];
}

-(int) getCardCountFromDB{
    NSError *error = nil;
    
    //Now do a fetch request and see what's there?
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Cards" inManagedObjectContext:managedObjectContext];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:nil];
    
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if(error != nil){ NSLog([error description]); }
    
    [fetchRequest release]; 
    return fetchedObjects.count;
}

-(int) getCardCountFromServer{
    if(!CardsData){
        NSURL *CardsJsonURL = [[[NSURL alloc] initWithString:@"http://api.iphoneapp.us/index.php/ecards/cards"] autorelease]; 
        NSString *CardsJson = [[[NSString alloc] initWithContentsOfURL:CardsJsonURL] autorelease];
        [CardsJsonURL release];
        CardsData = [CardsJson JSONValue];
    }
    return [CardsData count];
}

-(int) getCategoryCountFromServer{
    if(!CategoryData){
        //Get the Cateogry info from the Server (Table Sections) Load into managed object
        NSURL *CategoryJsonURL = [[[NSURL alloc] initWithString:@"http://api.iphoneapp.us/index.php/ecards/categories"] autorelease];
        NSString *Categories = [[[NSString alloc] initWithContentsOfURL:CategoryJsonURL] autorelease];
        self.CategoryData = [Categories JSONValue];
    }
    return [CategoryData count];
}

- (void) GetJsonFromServer{
    NSError *error = nil;
    
    //Get the Cateogry info from the Server (Table Sections) Load into managed object
    NSURL *CategoryJsonURL = [[[NSURL alloc] initWithString:@"http://api.iphoneapp.us/index.php/ecards/categories"] autorelease];
    NSString *Categories = [[[NSString alloc] initWithContentsOfURL:CategoryJsonURL] autorelease];
    self.CategoryData = [Categories JSONValue];
 
    //Add all the Categories from the server to our db
    for(NSDictionary *CatInfo in CategoryData){
        int CatID = [[CatInfo objectForKey:@"CategoryID"] intValue];

        //Check if item exists!
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];    
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"CategoryID == %@", [NSNumber numberWithInteger:CatID]];
        [fetchRequest setPredicate:predicate];
        
        error = nil;
        NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
            
        if(fetchedObjects.count==0){
            //Add new category item
            Category *newCat = [NSEntityDescription insertNewObjectForEntityForName:@"Category"inManagedObjectContext:managedObjectContext];
            newCat.CategoryID = [NSNumber numberWithInt: CatID]; 
            newCat.Name = [CatInfo objectForKey:@"Name"];
        }
        
        if([managedObjectContext hasChanges]){
            [managedObjectContext save:&error];
        }
        if(error != nil){ NSLog([error description]); }
        
        //Release instance objects
        [fetchRequest release];
    }
    
    
    //Get Cards from the Server and insert them into CoreData
    NSURL *CardsJsonURL = [[[NSURL alloc] initWithString:@"http://api.iphoneapp.us/index.php/ecards/cards"] autorelease]; 
    NSString *CardsJson = [[[NSString alloc] initWithContentsOfURL:CardsJsonURL] autorelease];  
    self.CardsData = [CardsJson JSONValue];
    [CardsJsonURL release];
    
    //Add all the Cards from the server to our db
    for(NSDictionary *CardInfo in CardsData){
        int CardID = [[CardInfo objectForKey:@"CardID"] intValue];
        
        //Check if item exists!
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];    
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Cards" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"CardID == %@", [NSNumber numberWithInteger:CardID]];
        [fetchRequest setPredicate:predicate];
        
        error = nil;
        NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        if(fetchedObjects.count==0){
            //Add new card item
            Cards *NewCard = [NSEntityDescription insertNewObjectForEntityForName:@"Cards"inManagedObjectContext:managedObjectContext];
            
            NewCard.CardID = [NSNumber numberWithInt:CardID];
            NewCard.CardImage = [CardInfo objectForKey:@"CardImage"];
            NewCard.Thumb = [CardInfo objectForKey:@"Thumb"];
            NewCard.CardTitle = [CardInfo objectForKey:@"CardTitle"];
            NewCard.CategoryID = [CardInfo objectForKey:@"CategoryID"];
            NewCard.Price = [CardInfo objectForKey:@"Price"];
            NewCard.timestamp = [NSNumber numberWithInt: [[CardInfo objectForKey:@"timestamp"] intValue]];
            
            NSInteger CategoryID  = [[CardInfo objectForKey:@"CategoryID"] intValue];
            Category *theCategory = [self getCategoryByID: CategoryID];
            [theCategory addCardsObject:NewCard];
        }
        
        
        if([managedObjectContext hasChanges]){
            [managedObjectContext save:&error];
        }
        if(error != nil){ NSLog([error description]); }

        //Release instance objects
        [fetchRequest release];
    }    
}

- (Category*) getCategoryByID:(NSInteger *)CategoryID{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"CategoryID == %@", [NSNumber numberWithInt:CategoryID]];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *obj = [managedObjectContext executeFetchRequest:request error:&error];
    if(error != nil){ NSLog([error description]); }
    return [obj lastObject];
}

/* Table View delegate Functions */
/***************************************************/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger *numSections = [[fetchedResultsController sections] count];
    return numSections;
}

- (NSInteger)tableView:(UITableView *) tableView 
             numberOfRowsInSection:(NSInteger)section{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView 
              titleForHeaderInSection:(NSInteger)section { 
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    NSInteger *CatID = [[sectionInfo indexTitle] intValue];
    Category *CatInfo = [self getCategoryByID: CatID];
    NSString *CategoryName = [CatInfo.Name stringByAppendingString:@" Cards"];
    return CategoryName;
}

/*
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [fetchedResultsController sectionIndexTitles];
}
*/

- (NSInteger)tableView:(UITableView *)tableView 
             sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

- (UITableViewCell *)tableView: (UITableView *)tableView 
                     cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *MyIdentifier = @"CardTableViewCell";
    CardCell *cell = (CardCell *)[tableView dequeueReusableCellWithIdentifier: MyIdentifier];
    
    if (cell == nil){
        [[NSBundle mainBundle] loadNibNamed:@"CardTableViewCell" owner:self options:nil];
        cell = tmpCell;
        self.tmpCell = nil;

        UIImage *eCardTableBG = [UIImage imageNamed:@"cardCell320x250.png"];
        [cell setBackgroundView:[[[UIImageView alloc] initWithImage:eCardTableBG] autorelease]];
    }
    
    //Get Data object for indexPath
    Cards *CardInfo = [fetchedResultsController objectAtIndexPath:indexPath];
    
    //Set cards title
    [cell setCardTitle:CardInfo.CardTitle];
    
    //Get and set image for table view cell
    NSURL *CardImageURL = [[[NSURL alloc] initWithString: CardInfo.Thumb] autorelease];
    NSData *CardImageData = [[[NSData alloc]initWithContentsOfURL:CardImageURL] autorelease];
    UIImage *image = [[[UIImage alloc] initWithData:CardImageData] autorelease];
    [cell setThumbNail: image];
    
    //Set purchase price button
    [cell setPurchasePrice: CardInfo.Price];
    
    return cell;
}

/*
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
}
*/

/* Tear down, handle app state */
/***************************************************/
- (void)dealloc
{
    //Local Data Objects
    [CardsData release];
    [CategoryData release];
    
    //Persistant Data
    [fetchedResultsController release];
    [managedObjectContext release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
