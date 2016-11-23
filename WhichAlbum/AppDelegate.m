//
//  AppDelegate.m
//  WhichAlbum
//
//  Created by Olivier Legat on 23/11/2016.
//  Copyright © 2016 Feral Interactive Ltd. All rights reserved.
//

#import "AppDelegate.h"


//-------------------------------------------------------------------------
// Typedefs
//-------------------------------------------------------------------------

typedef enum
{
	kSinger_BruceDickinson	= 1 << 0,
	kSinger_PaulDiAnno		= 1 << 1,
	kSinger_BlazeBayley		= 1 << 2,
	
	kSinger_ANY
	= kSinger_BruceDickinson | kSinger_PaulDiAnno | kSinger_BlazeBayley,
}
Singer_t;


typedef enum
{
	kAlbumType_Studio		= 1 << 3,
	kAlbumType_Live			= 1 << 4,
	
	kAlbumType_ANY
	= kAlbumType_Studio | kAlbumType_Live,
}
AlbumType_t;





//-------------------------------------------------------------------------
// Helper album class
//-------------------------------------------------------------------------
@interface Album : NSObject
-(id) initWithImageNamed: (NSString*) imageName
			   albumType: (AlbumType_t) type 
				  singer: (Singer_t) singer;
@property (retain) NSImage*     image;
@property (assign) AlbumType_t  type;
@property (assign) Singer_t     singer;


// returns an NSArray* of Album* objects.
+(NSArray*) loadAlbums;

// pick an album from an NSArray of Album objects.
+(Album*) pickRandomAlbum: (NSArray*) allAlbums
				 withType: (AlbumType_t) typeMask
			   withSinger: (Singer_t) singerMask;
@end

@implementation Album
-(id) initWithImageNamed: (NSString*) imageName
			   albumType: (AlbumType_t) type 
				  singer: (Singer_t) singer
{
	if( (self = [super init]) != nil )
	{
		self.image  = [NSImage imageNamed: imageName];
		self.type   = type;
		self.singer = singer;
		
		NSAssert( self.image != nil, @"Failed to load %@", imageName );

		// very tempted to assert(singer == Bruce)...
		// the only true singer of Iron Maiden is Bruce Dickinson
		// other singers are fail fail fail no no no. Bruce is the man :P
	}

	return self;
}

+(NSArray*) loadAlbums
{
	// the Iron Maiden discog is hard-coded...
	// not amazing, but for this kind of app I think it will do.
	//

	// result:
	NSMutableArray* ar = [NSMutableArray new];

	// helper function for adding albums:
	//
	void (^addAlbum) (NSString*, AlbumType_t, Singer_t) = 
	^(NSString* imageName, AlbumType_t type, Singer_t singer)
	{
		Album* album = [[Album alloc] initWithImageNamed: imageName 
											   albumType: type
												  singer: singer];
		[ar addObject: album];
	};
	
	// Add ablums (in chronologically order, just coz):
	//
	addAlbum( @"IronMaiden.jpg",				kAlbumType_Studio,	kSinger_PaulDiAnno );
	addAlbum( @"Killers.jpg",					kAlbumType_Studio,	kSinger_PaulDiAnno );
	addAlbum( @"TheNumberOfTheBeast.jpg",		kAlbumType_Studio,	kSinger_BruceDickinson );
	addAlbum( @"PieceOfMind.jpg",				kAlbumType_Studio,	kSinger_BruceDickinson );
	addAlbum( @"Powerslave.jpg",				kAlbumType_Studio,	kSinger_BruceDickinson );
	addAlbum( @"LiveAfterDeath.jpg",			kAlbumType_Live,	kSinger_BruceDickinson );
	addAlbum( @"SomewhereInTime.jpg",			kAlbumType_Studio,	kSinger_BruceDickinson );
	addAlbum( @"SeventhSonOfASeventhSon.jpg",	kAlbumType_Studio,	kSinger_BruceDickinson );
	addAlbum( @"NoPrayerForTheDying.jpg",		kAlbumType_Studio,	kSinger_BruceDickinson );
	addAlbum( @"LiveAtDonington.jpg",			kAlbumType_Live,	kSinger_BruceDickinson );
	addAlbum( @"ARealLiveOne.jpg",				kAlbumType_Live,	kSinger_BruceDickinson );
	addAlbum( @"ARealLiveDeadOne.jpg",			kAlbumType_Live,	kSinger_BruceDickinson );
	addAlbum( @"FearOfTheDark.jpg",				kAlbumType_Studio,	kSinger_BruceDickinson );
	addAlbum( @"TheXFactor.jpg",				kAlbumType_Studio,	kSinger_BlazeBayley ); // BOOO!!!
	addAlbum( @"VirtualXI.jpg",					kAlbumType_Studio,	kSinger_BlazeBayley ); // BOOO!!!	
	addAlbum( @"BraveNewWorld.jpg",				kAlbumType_Studio,	kSinger_BruceDickinson ); // bruce is back, thank fuck.. that was a disaster.
	addAlbum( @"RockInRio.jpg",					kAlbumType_Live,	kSinger_BruceDickinson );
	addAlbum( @"DanceOfDeath.jpg",				kAlbumType_Studio,	kSinger_BruceDickinson );
	addAlbum( @"DeathOnTheRoad.jpg",			kAlbumType_Live,	kSinger_BruceDickinson );
	addAlbum( @"AMatterOfLifeAndDeath.jpg",		kAlbumType_Studio,	kSinger_BruceDickinson );
	addAlbum( @"TheFinalFrontier.jpg",			kAlbumType_Studio,	kSinger_BruceDickinson );
	addAlbum( @"EnVivo.jpg",					kAlbumType_Live,	kSinger_BruceDickinson );
	addAlbum( @"MaidenEnland.jpg",				kAlbumType_Live,	kSinger_BruceDickinson );
	addAlbum( @"TheBookOfSouls.jpg",			kAlbumType_Studio,	kSinger_BruceDickinson );
	
	return [ar copy]; // immutable copy.
}

+(NSArray*) filterAlbums: (NSArray*) allAlbums
				withType: (AlbumType_t) typeMask
			  withSinger: (Singer_t) singerMask
{
	// micro-optimisation whenever picking "anything" (no filter)
	//
	if (typeMask == kAlbumType_ANY && singerMask == kSinger_ANY)
		return allAlbums;
	
	
	NSMutableArray* ar = [NSMutableArray new];
	for ( Album* album in allAlbums )
	{
		if ( (album.type   & typeMask  ) &&
			 (album.singer & singerMask) )
		{
			[ar addObject: album];
		}
	}

	return ar;
}

+(Album*) pickRandomAlbum: (NSArray*) allAlbums
				 withType: (AlbumType_t) typeMask
			   withSinger: (Singer_t) singerMask
{
	NSArray* filteredAlbums = [Album filterAlbums: allAlbums
										 withType: typeMask
									   withSinger: singerMask ];

	Album* randomAlbum = nil;
	if (filteredAlbums.count > 0)
	{
		int randomIndex = arc4random_uniform ( (int) filteredAlbums.count );
		randomAlbum = [filteredAlbums objectAtIndex: randomIndex];
	}
	return randomAlbum;
}
@end





//-------------------------------------------------------------------------
// Application:
//-------------------------------------------------------------------------
@interface AppDelegate ()

@property (weak) IBOutlet NSWindow*     window;
@property (weak) IBOutlet NSImageCell*  albumImageCell;
@property (weak) IBOutlet NSImageView*  albumImage;
@property (weak) IBOutlet NSButton*     studioCheck;
@property (weak) IBOutlet NSButton*     liveCheck;
@property (weak) IBOutlet NSButton*     bruceCheck;
@property (weak) IBOutlet NSButton*     paulCheck;
@property (weak) IBOutlet NSButton*     blazeCheck;

@property NSArray* allAlbums;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	
	// loading all this on main thread is not ideal (blocks UI).
	// but this loads fairly quickly so it's worth loading it async.
	//
	self.allAlbums = [Album loadAlbums];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}

- (void) getSelectedTypes: (AlbumType_t*) types singers: (Singer_t*) singers
{
	if ( types != NULL )
	{
		*types = 0;

		if ( [self.liveCheck state] == NSOnState )
			*types |= kAlbumType_Live;

		if ( [self.studioCheck state] == NSOnState )
			*types |= kAlbumType_Studio;
	}
	
	if ( singers != NULL )
	{
		*singers = 0;
		
		if ( [self.bruceCheck state] == NSOnState )
			*singers |= kSinger_BruceDickinson;
		
		if ( [self.paulCheck state] == NSOnState )
			*singers |= kSinger_PaulDiAnno;
		
		if ( [self.blazeCheck state] == NSOnState )
			*singers |= kSinger_BlazeBayley;
		
	}

}

- (IBAction) whichAlbumAction:(id)sender
{
	AlbumType_t type   = 0;
	Singer_t    singer = 0;
	[self getSelectedTypes: &type singers: &singer];

	Album* randomAlbum = [Album pickRandomAlbum: self.allAlbums
									   withType: type
									 withSinger: singer];
	
	NSImage* im = randomAlbum.image;
	self.albumImage.image = im;
}

@end
