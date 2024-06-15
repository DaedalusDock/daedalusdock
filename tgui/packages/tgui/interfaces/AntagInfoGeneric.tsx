import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Section, Stack } from '../components';
import { Window } from '../layouts';

type Objective = {
  complete: BooleanLike;
  count: number;
  explanation: string;
  name: string;
  reward: number;
  was_uncompleted: BooleanLike;
};

type Info = {
  antag_name: string;
  objectives: Objective[];
};

export const AntagInfoGeneric = (props) => {
  const { data } = useBackend<Info>();
  const { antag_name } = data;
  return (
    <Window width={620} height={250}>
      <Window.Content>
        <Section scrollable fill>
          <Stack vertical>
            <Stack.Item textColor="red" fontSize="20px">
              You are the {antag_name}!
            </Stack.Item>
            <Stack.Item>
              <ObjectivePrintout />
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};

const ObjectivePrintout = (props) => {
  const { data } = useBackend<Info>();
  const { objectives } = data;
  return (
    <Stack vertical>
      <Stack.Item bold>Your objectives:</Stack.Item>
      <Stack.Item>
        {(!objectives && 'None!') ||
          objectives.map((objective) => (
            <Stack.Item key={objective.count}>
              #{objective.count}: {objective.explanation}
            </Stack.Item>
          ))}
      </Stack.Item>
    </Stack>
  );
};
