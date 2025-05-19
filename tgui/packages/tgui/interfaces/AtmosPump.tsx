import { BooleanLike } from 'common/react';

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

type PumpData = {
  last_draw: number;
  max_power: number;
  max_pressure?: number;
  max_rate?: number;
  on: BooleanLike;
  pressure?: number;
  rate?: number;
  regulate_mode?: number;
};

export const AtmosPump = (props) => {
  const { act, data } = useBackend<PumpData>();
  const {
    pressure = 0,
    max_pressure = 0,
    max_rate = 0,
    rate = 0,
    regulate_mode = 0,
  } = data;
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
            {max_rate ? (
              <LabeledList.Item label="Transfer Rate">
                <NumberInput
                  animated
                  value={rate}
                  width="63px"
                  unit="L/s"
                  minValue={0}
                  maxValue={max_rate}
                  step={1}
                  onChange={(value) =>
                    act('rate', {
                      rate: value,
                    })
                  }
                />
                <Button
                  ml={1}
                  icon="plus"
                  content="Max"
                  disabled={rate === max_rate}
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
                  value={pressure}
                  unit="kPa"
                  width="75px"
                  minValue={0}
                  maxValue={max_pressure}
                  step={10}
                  onChange={(value) =>
                    act('pressure', {
                      pressure: value,
                    })
                  }
                />
                <Button
                  ml={1}
                  icon="plus"
                  content="Max"
                  disabled={pressure === max_pressure}
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
            {regulate_mode ? (
              <LabeledList.Item label="Pressure Regulator">
                <Button
                  icon="sign-in-alt"
                  content="Input"
                  selected={regulate_mode === 1}
                  onClick={() => act('regulate')}
                />
                <Button
                  icon="sign-out-alt"
                  content="Output"
                  selected={regulate_mode === 2}
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
