import { Button, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type DestinationTaggerData = {
  currentTag: number;
  locations: string[];
};

/**
 * Info about destinations that survives being re-ordered.
 */
type DestinationInfo = {
  name: string;
  sorting_id: number;
};

/**
 * Sort destinations in alphabetical order,
 * and wrap them in a way that preserves what ID to return.
 * @param locations The raw, official list of destination tags.
 * @returns The alphetically sorted list of destinations.
 */
const sortDestinations = (locations: string[]): DestinationInfo[] => {
  const mapped = locations.map((loc, i) => ({
    name: loc.toUpperCase(),
    sorting_id: i + 1,
  }));

  const sorted = mapped.sort((a, b) =>
    a.name.toLowerCase() > b.name.toLowerCase() ? 1 : -1,
  );

  return sorted;
};

export const DestinationTagger = (props) => {
  const { act, data } = useBackend<DestinationTaggerData>();
  const { locations, currentTag } = data;

  return (
    <Window theme="retro" title="TagMaster 2.4" width={420} height={500}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item grow>
            <Section
              fill
              scrollable
              title={
                !currentTag
                  ? 'Please Select A Location'
                  : `Current Destination: ${locations[currentTag - 1]}`
              }
            >
              {sortDestinations(locations).map((location) => {
                return (
                  <Button.Checkbox
                    checked={currentTag === location.sorting_id}
                    height={2}
                    key={location.sorting_id}
                    onClick={() =>
                      act('change', { index: location.sorting_id })
                    }
                    width={15}
                  >
                    {location.name}
                  </Button.Checkbox>
                );
              })}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
