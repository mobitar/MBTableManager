#import "MBTableManager.h"

@implementation MBTableSection

+ (MBTableSection*)sectionWithTitle:(NSString*)title items:(NSArray*)items
{
    MBTableSection *section = [MBTableSection new];
    section.title = title;
    section.items = items;
    return section;
}

- (id)itemAtIndexPath:(NSIndexPath*)indexPath
{
    return _items[indexPath.row];
}

- (BOOL)indexPathIsSpecial:(NSIndexPath*)indexPath
{
    if(!_specialModeOn)
        return NO;
    return [_specialIndexPaths containsObject:indexPath];
}

- (NSInteger)numberOfRows
{
    return _items.count + (_specialModeOn ? _specialIndexPaths.count : 0);
}

- (void)enableSpecialMode
{
    _specialModeOn = YES;
}

- (void)disableSpecialMode
{
    _specialModeOn = NO;
}

- (void)toggleSpecialMode
{
    _specialModeOn = !_specialModeOn;
}

@end

@implementation MBTableState

+ (MBTableState*)tableStateWithSections:(NSArray*)sections
{
    MBTableState *state = [MBTableState new];
    state.sections = sections;
    return state;
}

- (NSString*)titleForSection:(NSInteger)index
{
    return [_sections[index] title];
}

- (UITableViewCell*)cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    MBTableSection *section = _sections[indexPath.section];
    id model = section.items[indexPath.row];
    return self.cellForRowBlock(indexPath, model);
}

- (void)didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    MBTableSection *section = _sections[indexPath.section];
    id model = section.items[indexPath.row];
    self.selectionBlock(indexPath, model);
}

- (void)enableSpecialModeForSection:(NSInteger)section
{
    MBTableSection *tableSection = [self sectionForIndex:section];
    [tableSection enableSpecialMode];
}

- (void)disableSpecialModeForSection:(NSInteger)section
{
    MBTableSection *tableSection = [self sectionForIndex:section];
    [tableSection disableSpecialMode];
}

- (void)toggleSpecialModeForSection:(NSInteger)section
{
    MBTableSection *tableSection = [self sectionForIndex:section];
    [tableSection toggleSpecialMode];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    MBTableSection *tableSection = [self sectionForIndex:section];
    return [tableSection numberOfRows];
}

- (BOOL)indexPathIsSpecial:(NSIndexPath*)indexPath
{
    MBTableSection *section = [self sectionForIndex:indexPath.section];
    return [section indexPathIsSpecial:indexPath];
}

- (id)itemAtIndexPath:(NSIndexPath*)indexPath
{
    MBTableSection *section = [self sectionForIndex:indexPath.section];
    return [section itemAtIndexPath:indexPath];
}

- (MBTableSection*)sectionForIndex:(NSInteger)section
{
    return self.sections[section];
}

- (void)addSection:(MBTableSection*)section
{
    if(!_sections)
        _sections = [NSArray new];
    NSMutableArray *sections = _sections.mutableCopy;
    [sections addObject:section];
    _sections = sections;
}

- (void)addSectionWithItems:(NSArray*)items specialIndexPaths:(NSArray*)specialIndexPaths
{
    MBTableSection *section = [MBTableSection new];
    section.items = items;
    section.specialIndexPaths = specialIndexPaths;
    [self addSection:section];
}

- (BOOL)specialMode
{
    return [[self sectionForIndex:0] isSpecialModeOn];
}

- (void)disableSpecialMode
{
    [[self sectionForIndex:0] disableSpecialMode];
}

- (void)enableSpecialMode
{
    [[self sectionForIndex:0] enableSpecialMode];
}

- (void)toggleSpecialMode
{
    [[self sectionForIndex:0] toggleSpecialMode];
}

- (NSIndexPath*)firstSpecialIndexPath
{
    return [[[self sectionForIndex:0] specialIndexPaths] objectAtIndex:0];
}

@end

@implementation MBTableManager
{
    NSMutableArray *_states;
    MBTableState *_currentState;
}

- (void)addState:(MBTableState*)state
{
    if(!_states) {
        _states = [NSMutableArray new];
    }
    
    [_states addObject:state];
    
    if(_states.count == 1) {
        _currentState = state;
    }
}

- (MBTableState*)currentState
{
    return _currentState;
}

- (MBTableState*)stateAtIndex:(NSInteger)index
{
    return _states[index];
}

- (void)setActiveStateAtIndex:(NSInteger)index
{
    _currentState = _states[index];
}

- (MBTableSection*)sectionAtIndex:(NSInteger)index
{
    return [_currentState sectionForIndex:index];
}

- (NSString*)titleForSection:(NSInteger)index
{
    return [_currentState titleForSection:index];
}

- (NSInteger)numberOfSections
{
    return _currentState.sections.count;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return [_currentState numberOfRowsInSection:section];
}

- (UITableViewCell*)cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return [_currentState cellForRowAtIndexPath:indexPath];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    return [_currentState didSelectRowAtIndexPath:indexPath];
}

- (void)setItems:(NSArray*)items forStateAtIndex:(NSInteger)stateIndex forSection:(NSInteger)sectionIndex
{
    MBTableState *state = _states[stateIndex];
    MBTableSection *section = state.sections[sectionIndex];
    section.items = items;
}

@end