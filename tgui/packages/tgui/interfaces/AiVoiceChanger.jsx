import {
  Button,
  Dropdown,
  Input,
  LabeledList,
  Section,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

export const AiVoiceChanger = (props) => {
  const { act, data } = useBackend();

  return (
    <Window title="Voice changer settings" width={400} height={200}>
      <Section>
        <LabeledList>
          <LabeledList.Item label="Power">
            <Button
              icon={data.on ? 'power-off' : 'times'}
              content={data.on ? 'On' : 'Off'}
              selected={data.on}
              onClick={() => act('power')}
            />
          </LabeledList.Item>
          <LabeledList.Item label="Accent">
            <Dropdown
              selected={data.accent}
              options={data.voices}
              onSelected={(value) =>
                act('look', {
                  look: value,
                })
              }
            />
          </LabeledList.Item>
          <LabeledList.Item label="Verb">
            <Input
              default={data.say_verb}
              onBlur={(value) =>
                act('verb', {
                  verb: value,
                })
              }
            />
          </LabeledList.Item>
          <LabeledList.Item label="Volume">
            <Button
              icon={data.loud ? 'power-off' : 'times'}
              content={data.loud ? 'Loudmode on' : 'Loudmode Off'}
              selected={data.loud}
              onClick={() => act('loud')}
            />
          </LabeledList.Item>
          <LabeledList.Item label="Fake name">
            <Input
              default={data.name}
              onBlur={(value) =>
                act('name', {
                  name: value,
                })
              }
            />
          </LabeledList.Item>
        </LabeledList>
      </Section>
    </Window>
  );
};
