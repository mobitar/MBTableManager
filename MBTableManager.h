#import <Foundation/Foundation.h>

@class MBTableSection;
@interface MBTableState : NSObject

typedef UITableViewCell*(^MBTableCellBlock)(NSIndexPath *indexPath, id model);
typedef void(^MBTableSelectionBlock)(NSIndexPath *indexPath, id model);

@property (nonatomic, copy) MBTableCellBlock cellForRowBlock;
@property (nonatomic, copy) MBTableSelectionBlock selectionBlock;
@property (nonatomic) NSArray *sections;

- (void)enableSpecialModeForSection:(NSInteger)section;
- (void)disableSpecialModeForSection:(NSInteger)section;
- (void)toggleSpecialModeForSection:(NSInteger)section;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (BOOL)indexPathIsSpecial:(NSIndexPath*)indexPath;
- (id)itemAtIndexPath:(NSIndexPath*)indexPath;
- (MBTableSection*)sectionForIndex:(NSInteger)section;
- (void)addSection:(MBTableSection*)section;
- (void)addSectionWithItems:(NSArray*)items specialIndexPaths:(NSArray*)specialIndexPaths;
- (NSString*)titleForSection:(NSInteger)index;

- (UITableViewCell*)cellForRowAtIndexPath:(NSIndexPath*)indexPath;
- (void)didSelectRowAtIndexPath:(NSIndexPath*)indexPath;

// convenience methods for first section (index 0)
- (BOOL)specialMode;
- (void)toggleSpecialMode;
- (void)disableSpecialMode;
- (void)enableSpecialMode;
- (NSIndexPath*)firstSpecialIndexPath;

+ (MBTableState*)tableStateWithSections:(NSArray*)sections;
@end

@interface MBTableSection : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic) NSArray *items;
@property (nonatomic) NSArray *specialIndexPaths;
@property (nonatomic, getter = isSpecialModeOn) BOOL specialModeOn;
- (id)itemAtIndexPath:(NSIndexPath*)indexPath;
- (BOOL)indexPathIsSpecial:(NSIndexPath*)indexPath;
- (NSInteger)numberOfRows;
- (void)enableSpecialMode;
- (void)disableSpecialMode;
- (void)toggleSpecialMode;
+ (MBTableSection*)sectionWithTitle:(NSString*)title items:(NSArray*)items;
@end

@interface MBTableManager : NSObject
- (void)addState:(MBTableState*)state;
- (MBTableState*)currentState;
- (MBTableState*)stateAtIndex:(NSInteger)index;
- (void)setActiveStateAtIndex:(NSInteger)index;

// convenience methods for currentState
- (NSString*)titleForSection:(NSInteger)index;
- (MBTableSection*)sectionAtIndex:(NSInteger)index;
- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell*)cellForRowAtIndexPath:(NSIndexPath*)indexPath;
- (void)didSelectRowAtIndexPath:(NSIndexPath*)indexPath;

- (void)setItems:(NSArray*)items forStateAtIndex:(NSInteger)stateIndex forSection:(NSInteger)sectionIndex;
@end
