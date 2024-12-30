import { useBackend } from '../backend';
import {
  Button,
  LabeledList,
  NumberInput,
  ProgressBar,
  Section,
} from '../components';
import { formatSiUnit } from '../format';
import { Window } from '../layouts';

export const AtmosPump = (props) => {
  const { act, data } = useBackend();
  return (
    <Window width={335} height={129}>
      <Window.Content>
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
            {data.max_rate ? (
              <LabeledList.Item label="Transfer Rate">
                <NumberInput
                  animated
                  value={parseFloat(data.rate)}
                  width="63px"
                  unit="L/s"
                  minValue={0}
                  maxValue={data.max_rate}
                  onChange={(e, value) =>
                    act('rate', {
                      rate: value,
                    })
                  }
                />
                <Button
                  ml={1}
                  icon="plus"
                  content="Max"
                  disabled={data.rate === data.max_rate}
                  onClick={() =>
                    act('rate', {
                      rate: 'max',
                    })
                  }
                />
              </LabeledList.Item>
            ) : (
              <LabeledList.Item label="Output Pressure">
                <NumberInput
                  animated
                  value={parseFloat(data.pressure)}
                  unit="kPa"
                  width="75px"
                  minValue={0}
                  maxValue={data.max_pressure}
                  step={10}
                  onChange={(e, value) =>
                    act('pressure', {
                      pressure: value,
                    })
                  }
                />
                <Button
                  ml={1}
                  icon="plus"
                  content="Max"
                  disabled={data.pressure === data.max_pressure}
                  onClick={() =>
                    act('pressure', {
                      pressure: 'max',
                    })
                  }
                />
              </LabeledList.Item>
            )}
            {data.max_power ? (
              <LabeledList.Item label="Power Usage">
                <ProgressBar
                  value={data.last_draw}
                  maxValue={data.max_power}
                  color="yellow"
                >
                  {formatSiUnit(data.last_draw, 0, 'W')}
                </ProgressBar>
              </LabeledList.Item>
            ) : null}
            {data.regulate_mode ? (
              <LabeledList.Item label="Pressure Regulator">
                <Button
                  icon="sign-in-alt"
                  content="Input"
                  selected={data.regulate_mode === 1}
                  onClick={() => act('regulate')}
                />
                <Button
                  icon="sign-out-alt"
                  content="Output"
                  selected={data.regulate_mode === 2}
                  onClick={() => act('regulate')}
                />
              </LabeledList.Item>
            ) : null}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
