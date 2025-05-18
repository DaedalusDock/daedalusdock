import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section, Stack } from '../components';
import { Window } from '../layouts';

export const Teg = (props) => {
  const { act, data } = useBackend();
  const {
    has_hot_circ,
    has_cold_circ,
    has_powernet,
    power_output,
    cold_temp_in,
    cold_pressure_in,
    cold_temp_out,
    cold_pressure_out,
    hot_temp_in,
    hot_pressure_in,
    hot_temp_out,
    hot_pressure_out,
  } = data;
  return (
    <Window width={400} height={470}>
      <Window.Content>
        <Section title="Status">
          <Button
            content="Refresh Parts"
            onClick={() => act('refresh_parts')}
          />
          <Box m={1}>Power Output: {power_output}</Box>
          <Box m={1}>
            {has_powernet && (
              <Box color="good">Connected to the power network</Box>
            )}
            {has_hot_circ && has_cold_circ && (
              <Box color="good">Circulators connected to generator</Box>
            )}
            {!has_powernet && (
              <Box color="bad">Not connected to the power network</Box>
            )}
            {!has_hot_circ && (
              <Box color="bad">Unable to locate hot circulator</Box>
            )}
            {!has_cold_circ && (
              <Box color="bad">Unable to locate cold circulator</Box>
            )}
          </Box>
        </Section>
        <Stack justify="center">
          <Section title="Hot Circulator" width={260} height={15}>
            <Stack.Item m={1}>
              <Box mx={1} bold>
                Inlet
              </Box>
              <LabeledList.Item label="Temperature">
                {hot_temp_in} K
              </LabeledList.Item>
              <LabeledList.Item label="Pressure">
                {hot_pressure_in} kPa
              </LabeledList.Item>
            </Stack.Item>
            <Stack.Item m={1}>
              <Box mx={1} bold>
                Outlet
              </Box>
              <LabeledList.Item label="Temperature">
                {hot_temp_out} K
              </LabeledList.Item>
              <LabeledList.Item label="Pressure">
                {hot_pressure_out} kPa
              </LabeledList.Item>
            </Stack.Item>
          </Section>
          <Section title="Cold Circulator" width={260} height={15}>
            <Stack.Item m={1}>
              <Box mx={1} bold>
                Inlet
              </Box>
              <LabeledList.Item label="Temperature">
                {cold_temp_in} K
              </LabeledList.Item>
              <LabeledList.Item label="Pressure">
                {cold_pressure_in} kPa
              </LabeledList.Item>
            </Stack.Item>
            <Stack.Item m={1}>
              <Box mx={1} bold>
                Outlet
              </Box>
              <LabeledList.Item label="Temperature">
                {cold_temp_out} K
              </LabeledList.Item>
              <LabeledList.Item label="Pressure">
                {cold_pressure_out} kPa
              </LabeledList.Item>
            </Stack.Item>
          </Section>
        </Stack>
      </Window.Content>
    </Window>
  );
};
