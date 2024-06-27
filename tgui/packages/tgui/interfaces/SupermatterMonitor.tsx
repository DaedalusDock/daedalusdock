import { toFixed } from 'common/math';
import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import {
  Button,
  LabeledList,
  ProgressBar,
  Section,
  Stack,
  Table,
} from '../components';
import { getGasColor, getGasLabel } from '../constants';
import { Window } from '../layouts';

type Data = {
  SM_ambientpressure: number;
  SM_ambienttemp: number;
  SM_area_name: string;
  SM_bad_moles_amount: number;
  SM_integrity: number;
  SM_moles: number;
  SM_power: number;
  SM_uid: number;
  active: BooleanLike;
  gases: Gas[];
  singlecrystal: BooleanLike;
  supermatters: Supermatter[];
};

type Gas = {
  amount: number;
  name: string;
};

type Supermatter = {
  area_name: string;
  integrity: number;
  uid: number;
};

function logScale(value) {
  return Math.log2(16 + Math.max(0, value)) - 4;
}

export function SupermatterMonitor() {
  return (
    <Window width={600} height={350} theme="ntos" title="Supermatter Monitor">
      <Window.Content scrollable>
        <SupermatterMonitorContent />
      </Window.Content>
    </Window>
  );
}

export function SupermatterMonitorContent(props) {
  const { act, data } = useBackend<Data>();
  const {
    active,
    singlecrystal,
    SM_uid,
    SM_area_name,
    SM_integrity,
    SM_power,
    SM_ambienttemp,
    SM_ambientpressure,
    SM_moles,
    SM_bad_moles_amount,
  } = data;

  if (!active) {
    return <SupermatterList />;
  }

  const gases = data.gases
    .filter((gas) => gas.amount >= 0.01)
    .sort((a, b) => -a.amount + b.amount);

  const gasMaxAmount = Math.max(1, ...gases.map((gas) => gas.amount));

  return (
    <Section
      title={SM_uid + '. ' + SM_area_name}
      buttons={
        !singlecrystal && (
          <Button
            icon="arrow-left"
            content="Back"
            onClick={() => act('PRG_clear')}
          />
        )
      }
    >
      <Stack>
        <Stack.Item width="270px">
          <Section title="Metrics">
            <LabeledList>
              <LabeledList.Item label="Integrity">
                <ProgressBar
                  value={SM_integrity / 100}
                  ranges={{
                    good: [0.9, Infinity],
                    average: [0.5, 0.9],
                    bad: [-Infinity, 0.5],
                  }}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Relative EER">
                <ProgressBar
                  value={SM_power}
                  minValue={0}
                  maxValue={300}
                  ranges={{
                    good: [-Infinity, 150],
                    average: [150, 300],
                    bad: [300, Infinity],
                  }}
                >
                  {toFixed(SM_power) + ' MeV/cm3'}
                </ProgressBar>
              </LabeledList.Item>
              <LabeledList.Item label="Temperature">
                <ProgressBar
                  value={logScale(SM_ambienttemp)}
                  minValue={0}
                  maxValue={logScale(10000)}
                  ranges={{
                    teal: [-Infinity, logScale(500)],
                    good: [logScale(500), logScale(2000)],
                    average: [logScale(2000), logScale(4000)],
                    bad: [logScale(4000), Infinity],
                  }}
                >
                  {toFixed(SM_ambienttemp) + ' K'}
                </ProgressBar>
              </LabeledList.Item>
              <LabeledList.Item label="Total Moles">
                <ProgressBar
                  value={logScale(SM_moles)}
                  minValue={0}
                  maxValue={logScale(50000)}
                  ranges={{
                    good: [-Infinity, logScale(SM_bad_moles_amount * 0.75)],
                    average: [
                      logScale(SM_bad_moles_amount * 0.75),
                      logScale(SM_bad_moles_amount),
                    ],
                    bad: [logScale(SM_bad_moles_amount), Infinity],
                  }}
                >
                  {toFixed(SM_moles) + ' moles'}
                </ProgressBar>
              </LabeledList.Item>
              <LabeledList.Item label="Pressure">
                <ProgressBar
                  value={logScale(SM_ambientpressure)}
                  minValue={0}
                  maxValue={logScale(50000)}
                  ranges={{
                    good: [-Infinity, logScale(5000)],
                    average: [logScale(5000), logScale(10000)],
                    bad: [logScale(10000), +Infinity],
                  }}
                >
                  {toFixed(SM_ambientpressure) + ' kPa'}
                </ProgressBar>
              </LabeledList.Item>
            </LabeledList>
          </Section>
        </Stack.Item>
        <Stack.Item grow basis={0}>
          <Section title="Gases">
            <LabeledList>
              {gases.map((gas) => (
                <LabeledList.Item key={gas.name} label={getGasLabel(gas.name)}>
                  <ProgressBar
                    color={getGasColor(gas.name)}
                    value={gas.amount}
                    minValue={0}
                    maxValue={gasMaxAmount}
                  >
                    {toFixed(gas.amount, 2) + '%'}
                  </ProgressBar>
                </LabeledList.Item>
              ))}
            </LabeledList>
          </Section>
        </Stack.Item>
      </Stack>
    </Section>
  );
}

function SupermatterList(props) {
  const { act, data } = useBackend<Data>();
  const { supermatters = [] } = data;

  return (
    <Section
      title="Detected Supermatters"
      buttons={
        <Button
          icon="sync"
          content="Refresh"
          onClick={() => act('PRG_refresh')}
        />
      }
    >
      <Table>
        {supermatters.map((sm) => (
          <Table.Row key={sm.uid}>
            <Table.Cell>{sm.uid + '. ' + sm.area_name}</Table.Cell>
            <Table.Cell collapsing color="label">
              Integrity:
            </Table.Cell>
            <Table.Cell collapsing width="120px">
              <ProgressBar
                value={sm.integrity / 100}
                ranges={{
                  good: [0.9, Infinity],
                  average: [0.5, 0.9],
                  bad: [-Infinity, 0.5],
                }}
              />
            </Table.Cell>
            <Table.Cell collapsing>
              <Button
                content="Details"
                onClick={() =>
                  act('PRG_set', {
                    target: sm.uid,
                  })
                }
              />
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
}
