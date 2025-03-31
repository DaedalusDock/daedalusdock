import { useBackend, useLocalState } from '../backend';
import { Button, NumberInput, Section, Stack, Table } from '../components';
import { Window } from '../layouts';
import { ReagentLookup } from './common/ReagentLookup';
import { RecipeLookup } from './common/RecipeLookup';

const bookmarkedReactions = new Set();

const matchBitflag = (a, b) => a & b && (a | b) === b;

export const Reagents = (props) => {
  const { act, data } = useBackend();
  const { beakerSync, reagent_mode_recipe, reagent_mode_reagent } = data;

  const [page, setPage] = useLocalState('page', 1);

  return (
    <Window width={720} height={850}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Stack fill>
              <Stack.Item grow basis={0}>
                <Section
                  title="Recipe lookup"
                  minWidth="353px"
                  buttons={
                    <>
                      <Button
                        content="Beaker Sync"
                        icon="atom"
                        color={beakerSync ? 'green' : 'red'}
                        tooltip="When enabled the displayed reaction will automatically display ongoing reactions in the associated beaker."
                        onClick={() => act('beaker_sync')}
                      />
                      <Button
                        content="Search"
                        icon="search"
                        color="purple"
                        tooltip="Search for a recipe by product name"
                        onClick={() => act('search_recipe')}
                      />
                      <Button
                        icon="times"
                        color="red"
                        disabled={!reagent_mode_recipe}
                        onClick={() =>
                          act('recipe_click', {
                            id: null,
                          })
                        }
                      />
                    </>
                  }
                >
                  <RecipeLookup
                    recipe={reagent_mode_recipe}
                    bookmarkedReactions={bookmarkedReactions}
                  />
                </Section>
              </Stack.Item>
              <Stack.Item grow basis={0}>
                <Section
                  title="Reagent lookup"
                  minWidth="300px"
                  buttons={
                    <>
                      <Button
                        content="Search"
                        icon="search"
                        tooltip="Search for a reagent by name"
                        tooltipPosition="left"
                        onClick={() => act('search_reagents')}
                      />
                      <Button
                        icon="times"
                        color="red"
                        disabled={!reagent_mode_reagent}
                        onClick={() =>
                          act('reagent_click', {
                            id: null,
                          })
                        }
                      />
                    </>
                  }
                >
                  <ReagentLookup reagent={reagent_mode_reagent} />
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const RecipeLibrary = (props) => {
  const { act, data } = useBackend();
  const [page, setPage] = useLocalState('page', 1);
  const {
    currentReagents = [],
    master_reaction_list = [],
    linkedBeaker,
  } = data;

  const [reagentFilter, setReagentFilter] = useLocalState(
    'reagentFilter',
    true,
  );
  const [bookmarkMode, setBookmarkMode] = useLocalState('bookmarkMode', false);

  const matchReagents = (reaction) => {
    if (!reagentFilter || currentReagents === null) {
      return true;
    }
    let matches = reaction.reactants.filter((reactant) =>
      currentReagents.includes(reactant.id),
    ).length;
    return matches === currentReagents.length;
  };

  const bookmarkArray = Array.from(bookmarkedReactions);

  const startIndex = 50 * (page - 1);

  const endIndex = 50 * page;

  const visibleReactions = bookmarkMode
    ? bookmarkArray
    : master_reaction_list.filter((reaction) => matchReagents(reaction));

  const pageIndexMax = Math.ceil(visibleReactions.length / 50);

  const addBookmark = (bookmark) => {
    bookmarkedReactions.add(bookmark);
  };

  const removeBookmark = (bookmark) => {
    bookmarkedReactions.delete(bookmark);
  };

  return (
    <Section
      fill
      scrollable
      title={bookmarkMode ? 'Bookmarked recipes' : 'Possible recipes'}
      buttons={
        <>
          Beaker: {linkedBeaker + '  '}
          <Button
            content="Filter by reagents in beaker"
            icon="search"
            disabled={bookmarkMode}
            color={reagentFilter ? 'green' : 'red'}
            onClick={() => {
              setReagentFilter(!reagentFilter);
              setPage(1);
            }}
          />
          <Button
            content="Bookmarks"
            icon="book"
            color={bookmarkMode ? 'green' : 'red'}
            onClick={() => {
              setBookmarkMode(!bookmarkMode);
              setPage(1);
            }}
          />
          <Button
            icon="minus"
            disabled={page === 1}
            onClick={() => setPage(Math.max(page - 1, 1))}
          />
          <NumberInput
            width="25px"
            step={1}
            stepPixelSize={3}
            value={page}
            minValue={1}
            maxValue={pageIndexMax}
            onDrag={(value) => setPage(value)}
          />
          <Button
            icon="plus"
            disabled={page === pageIndexMax}
            onClick={() => setPage(Math.min(page + 1, pageIndexMax))}
          />
        </>
      }
    >
      <Table>
        <Table.Row>
          <Table.Cell bold color="label">
            Reaction
          </Table.Cell>
          <Table.Cell bold color="label">
            Required reagents
          </Table.Cell>
          <Table.Cell bold color="label">
            Tags
          </Table.Cell>
          <Table.Cell bold color="label" width="20px">
            {!bookmarkMode ? 'Save' : 'Del'}
          </Table.Cell>
        </Table.Row>
        {visibleReactions.slice(startIndex, endIndex).map((reaction) => (
          <Table.Row key={reaction.id} className="candystripe">
            <Table.Cell bold color="label">
              <Button
                mt={0.5}
                icon="flask"
                color="purple"
                content={reaction.name}
                onClick={() =>
                  act('recipe_click', {
                    id: reaction.id,
                  })
                }
              />
            </Table.Cell>
            <Table.Cell>
              {reaction.reactants.map((reactant) => (
                <Button
                  key={reactant.id}
                  mt={0.1}
                  icon="vial"
                  textColor="white"
                  color={currentReagents?.includes(reactant.id) && 'green'} // check here
                  content={reactant.name}
                  onClick={() =>
                    act('reagent_click', {
                      id: reactant.id,
                    })
                  }
                />
              ))}
            </Table.Cell>
            <Table.Cell width="20px">
              {(!bookmarkMode && (
                <Button
                  icon="book"
                  color="green"
                  disabled={bookmarkedReactions.has(reaction)}
                  onClick={() => {
                    addBookmark(reaction);
                    act('update_ui');
                  }}
                />
              )) || (
                <Button
                  icon="trash"
                  color="red"
                  onClick={() => removeBookmark(reaction)}
                />
              )}
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};
