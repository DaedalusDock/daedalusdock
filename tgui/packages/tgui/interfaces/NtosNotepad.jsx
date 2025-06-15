import { Input, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { NtosWindow } from '../layouts';

export const NtosNotepad = (props) => {
  const { act, data } = useBackend();
  const { note } = data;
  return (
    <NtosWindow width={600} height={800}>
      <NtosWindow.Content>
        <Stack fill vertical direction="column" justify="space-between">
          <Stack.Item>
            <Stack grow>
              <Section>{note}</Section>
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Section fill>
              <Input
                value={note}
                fluid
                onChange={(value) =>
                  act('UpdateNote', {
                    newnote: value,
                  })
                }
              />
            </Section>
          </Stack.Item>
        </Stack>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
