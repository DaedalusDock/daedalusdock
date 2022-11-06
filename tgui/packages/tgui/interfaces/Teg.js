import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const Teg = (props, context) => {
  const { act, data } = useBackend(context);
  const {
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
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Status">
          <Button
            content="Refresh Parts"
            onClick={() => act('refresh_parts')} />
        </Section>
        <Section title="Hot Circulator">
          <LabeledList>
            <LabeledList.Item label="Inlet">
              {hot_temp_in} K {hot_pressure_in} kPa
            </LabeledList.Item>
            <LabeledList.Item label="Outlet">
              {hot_temp_out} K {hot_pressure_out} kPa
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Cold Circulator">
          <LabeledList>
            <LabeledList.Item label="Inlet">
              {cold_temp_in} K {cold_pressure_in} kPa
            </LabeledList.Item>
            <LabeledList.Item label="Outlet">
              {cold_temp_out} K {cold_pressure_out} kPa
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
