#import "GuildTests.h"
#import "WoWApiClient.h"
#import <OCMock/OCMock.h>
#import "Guild.h"
#import "TestSemaphor.h"
#import "Character.h"

@implementation GuildTests
{
    // 1
    Guild *_guild;
    NSDictionary *_testGuildData;
}

- (void)setUp
{
    // 2
    NSURL *dataServiceURL = [[NSBundle bundleForClass:self.class] URLForResource:@"guild" withExtension:@"json"];
    NSData *sampleData = [NSData dataWithContentsOfURL:dataServiceURL];
    NSError *error;
    id json = [NSJSONSerialization JSONObjectWithData:sampleData options:kNilOptions error:&error];
    _testGuildData = json;
    
}

- (void)tearDown
{
    // Tear-down code here.
    _guild = nil;
    _testGuildData = nil;
}

- (void)testCreatingGuilDataFromWowApiClient
{
    // 1
    id mockWowApiClient = [OCMockObject mockForClass:[WoWApiClient class]];
    
    //
    // using OCMock to mock our WowApiClient object
    //
    
    // 2
    [[[mockWowApiClient stub] andDo:^(NSInvocation *invocation)
      {
          // how the success block is defined from our client
          // this is how we return data to caller from stubbed method
          
          // 3
          void (^successBlock)(Guild *guild);
          
          //
          // gets the success block from the call to our stub method
          // The hidden arguments self (of type id) and _cmd (of type SEL) are at indices 0 and 1;
          // method-specific arguments begin at index 2.
          
          // 4
          [invocation getArgument:&successBlock atIndex:4];
          
          // first create sample guild from file vs network call
          
          // 5
          Guild *testData = [[Guild alloc] initWithGuildData:_testGuildData];
          
          // 6
          successBlock(testData);
      }]
     // 7
     // the actual method we are stubb'ing, accepting any args
     guildWithName:[OCMArg any]
     onRealm:[OCMArg any]
     success:[OCMArg any]
     error:[OCMArg any]];
    
    // String used to wait for block to complete
    
    // 8
    NSString *semaphoreKey = @"membersLoaded";
    
    //
    // now call the stubbed out client, by calling the real method
    //
    
    // 9
    [mockWowApiClient guildWithName:@"Dream Catchers"
                            onRealm:@"Borean Tundra"
                            success:^(Guild *guild)
     {
         // 10
         _guild = guild;
         
         // this will allow the test to continue by lifting the semaphore key
         // and satisfying the running loop that is waiting on it to lift
         
         // 11
         [[TestSemaphor sharedInstance] lift:semaphoreKey];
         
     } error:^(NSError *error) {
         // 12
         [[TestSemaphor sharedInstance] lift:semaphoreKey];
     }];
    
    // 13
    // Marin is so awesome
    [[TestSemaphor sharedInstance] waitForKey:semaphoreKey];
    
    // 14
    STAssertNotNil(_guild, @"");
    STAssertEqualObjects(_guild.name, @"Dream Catchers", nil);
    STAssertTrue([_guild.members count] == [[_testGuildData valueForKey:@"members"] count], nil);
    
    
    //
    // Now validate that each type of class was loaded in the correct order
    // this tests the calls that our CharacterViewController will be making
    // for the UICollectionViewDataSource methods
    //
    
    // 15
    
    //
    // Validate 1 Death Knight ordered by level, acheivement points
    //
    NSArray *characters = [_guild membersByWowClassTypeName:WowClassTypeDeathKnight];
    STAssertEqualObjects(((Character*)characters[0]).name, @"Lixiu", nil);
    
    //
    // Validate 3 Druids ordered by level, acheivement points
    //
    characters = [_guild membersByWowClassTypeName:WowClassTypeDruid];
    STAssertEqualObjects(((Character*)characters[0]).name, @"Elassa", nil);
    STAssertEqualObjects(((Character*)characters[1]).name, @"Ivymoon", nil);
    STAssertEqualObjects(((Character*)characters[2]).name, @"Everybody", nil);
    
    //
    // Validate 2 Hunter ordered by level, acheivement points
    //
    characters = [_guild membersByWowClassTypeName:WowClassTypeHunter];
    STAssertEqualObjects(((Character*)characters[0]).name, @"Bulldogg", nil);
    STAssertEqualObjects(((Character*)characters[1]).name, @"Bluekat", nil);
    
    //
    // Validate 2 Mage ordered by level, acheivement points
    //
    characters = [_guild membersByWowClassTypeName:WowClassTypeMage];
    STAssertEqualObjects(((Character*)characters[0]).name, @"Mirai", nil);
    STAssertEqualObjects(((Character*)characters[1]).name, @"Greatdane", nil);
    
    //
    // Validate 3 Paladin ordered by level, acheivement points
    //
    characters = [_guild membersByWowClassTypeName:WowClassTypePaladin];
    STAssertEqualObjects(((Character*)characters[0]).name, @"Verikus", nil);
    STAssertEqualObjects(((Character*)characters[1]).name, @"Jonan", nil);
    STAssertEqualObjects(((Character*)characters[2]).name, @"Desplaines", nil);
    
    //
    // Validate 3 Priest ordered by level, acheivement points
    //
    characters = [_guild membersByWowClassTypeName:WowClassTypePriest];
    STAssertEqualObjects(((Character*)characters[0]).name, @"Mercpriest", nil);
    STAssertEqualObjects(((Character*)characters[1]).name, @"Monk", nil);
    STAssertEqualObjects(((Character*)characters[2]).name, @"Bliant", nil);
    
    //
    // Validate 3 Rogue ordered by level, acheivement points
    //
    characters = [_guild membersByWowClassTypeName:WowClassTypeRogue];
    STAssertEqualObjects(((Character*)characters[0]).name, @"Lailet", nil);
    STAssertEqualObjects(((Character*)characters[1]).name, @"Britaxis", nil);
    STAssertEqualObjects(((Character*)characters[2]).name, @"Josephus", nil);
    
}


@end
