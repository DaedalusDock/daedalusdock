import { useBackend } from '../backend';
import {
  Box,
  Button,
  Dropdown,
  LabeledList,
  ProgressBar,
  Section,
} from '../components';
import { Window } from '../layouts';

export const Mancrowave = (props) => {
  const { act, data } = useBackend();
  const {
    open,
    occupant = {},
    occupied,
    on,
    cook_start,
    cook_end,
    now,
    cook_options = [],
    current_setting,
  } = data;
  return (
    <Window width={340} height={360}>
      <Window.Content>
        <Section
          title={occupant.name ? occupant.name : 'No Occupant'}
          buttons={
            !!occupant.stat && (
              <Box inline bold color={occupant.statstate}>
                {occupant.stat}
              </Box>
            )
          }
        >
          <>
            <Box mt={1} />
            <LabeledList>
              <LabeledList.Item
                label="Core Temperature"
                color={occupied ? 'good' : 'bad'}
              >
                {occupied ? occupant.core_temperature : 'N/A'}
              </LabeledList.Item>
            </LabeledList>
          </>
        </Section>
        <Section title="Controls" minHeight="200px">
          <>
            <Box mt={1} />
            <LabeledList>
              <LabeledList.Item label="Timer">
                <ProgressBar
                  value={on ? now : 0}
                  minValue={on ? cook_start : 0}
                  maxValue={on ? cook_end : 100}
                  color="good"
                />
              </LabeledList.Item>
            </LabeledList>
            <Box mt={1} />
            <Dropdown
              width="100%"
              options={Object.keys(cook_options)}
              selected={current_setting}
              onSelected={(value) =>
                act('mancrowave-cook-setting', {
                  setting: value,
                })
              }
              disabled={!!on}
            />
            <Box mt={1} />
            <Button
              icon={open ? 'door-open' : 'door-closed'}
              content={open ? 'Open' : 'Closed'}
              onClick={() => act('mancrowave-door')}
              disabled={!!on}
            />
            <Button
              icon={'door-open'}
              content={'Emergency Stop'}
              onClick={() => act('mancrowave-emergency-stop')}
              disabled={!on}
            />
            <Button
              icon={'temperature-up'}
              content={'Cook'}
              onClick={() => act('mancrowave-cook')}
              disabled={!!on}
            />
          </>
        </Section>
      </Window.Content>
    </Window>
  );
};
