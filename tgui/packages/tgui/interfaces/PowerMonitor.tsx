import { toFixed } from 'common/math';
import { useState } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Chart,
  ColorBox,
  Flex,
  Icon,
  LabeledList,
  ProgressBar,
  Section,
  Stack,
  Table,
} from '../components';
import { Window } from '../layouts';
import { LoadingScreen } from './common/LoadingScreen';

type Data = {
  areas: Area[];
  history: PowerHistory;
};

type Area = {
  charge: number;
  charging: number;
  env: number;
  eqp: number;
  lgt: number;
  load: string;
  name: string;
};

type PowerHistory = {
  demand: number[];
  supply: number[];
};

export function powerRank(str) {
  const unit = String(str.split(' ')[1]).toLowerCase();
  return ['w', 'kw', 'mw', 'gw'].indexOf(unit);
}

// Oh no not another sorting algorithm
function powerSort(a: Area, b: Area) {
  const sortedByRank = powerRank(a.load) - powerRank(b.load);
  const sortedByLoad = parseFloat(a.load) - parseFloat(b.load);

  if (sortedByRank !== 0) {
    return sortedByRank;
  }
  return sortedByLoad;
}

function nameSort(a: Area, b: Area) {
  if (a.name < b.name) {
    return -1;
  }
  if (a.name > b.name) {
    return 1;
  }
  return 0;
}

export function PowerMonitor() {
  return (
    <Window width={550} height={700}>
      <Window.Content>
        <PowerMonitorContent />
      </Window.Content>
    </Window>
  );
}

const PEAK_DRAW = 500000;

export function PowerMonitorContent(props) {
  const { data } = useBackend<Data>();
  const { history } = data;

  if (!history) {
    return <>Loading...</>;
  }

  const supply = history.supply[history.supply.length - 1] || 0;
  const demand = history.demand[history.demand.length - 1] || 0;

  const supplyData = history.supply.map((value, i) => [i, value]);
  const demandData = history.demand.map((value, i) => [i, value]);

  const maxValue = Math.max(PEAK_DRAW, ...history.supply, ...history.demand);

  if (supplyData.length === 0 || demandData.length === 0) {
    return <LoadingScreen />;
  }

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Flex mx={-0.5}>
          <Flex.Item mx={0.5} width="200px">
            <Section>
              <LabeledList>
                <LabeledList.Item label="Supply">
                  <ProgressBar
                    value={supply}
                    minValue={0}
                    maxValue={maxValue}
                    color="teal"
                  >
                    {toFixed(supply / 1000) + ' kW'}
                  </ProgressBar>
                </LabeledList.Item>
                <LabeledList.Item label="Draw">
                  <ProgressBar
                    value={demand}
                    minValue={0}
                    maxValue={maxValue}
                    color="pink"
                  >
                    {toFixed(demand / 1000) + ' kW'}
                  </ProgressBar>
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Flex.Item>
          <Flex.Item mx={0.5} grow>
            <Section position="relative" fill>
              <Chart.Line
                fillPositionedParent
                data={supplyData}
                rangeX={[0, supplyData.length - 1]}
                rangeY={[0, maxValue]}
                strokeColor="rgba(0, 181, 173, 1)"
                fillColor="rgba(0, 181, 173, 0.25)"
              />
              <Chart.Line
                fillPositionedParent
                data={demandData}
                rangeX={[0, demandData.length - 1]}
                rangeY={[0, maxValue]}
                strokeColor="rgba(224, 57, 151, 1)"
                fillColor="rgba(224, 57, 151, 0.25)"
              />
            </Section>
          </Flex.Item>
        </Flex>
      </Stack.Item>
      <Stack.Item grow>
        <StationAreas />
      </Stack.Item>
    </Stack>
  );
}

function StationAreas(props) {
  const { data } = useBackend<Data>();

  const [sortByField, setSortByField] = useState('');

  const areas = data.areas
    .map((area, i) => ({
      ...area,
      // Generate a unique id
      id: area.name + i,
    }))
    .sort((a, b) => {
      if (sortByField === 'name') {
        return nameSort(a, b);
      }
      if (sortByField === 'charge') {
        return a.charge - b.charge;
      }
      if (sortByField === 'draw') {
        return powerSort(a, b);
      }
      return 0;
    });

  return (
    <Stack fill vertical>
      <Section height={3}>
        <Box>
          <Box inline mr={2} color="label">
            Sort by:
          </Box>
          <Button.Checkbox
            checked={sortByField === 'name'}
            content="Name"
            onClick={() => setSortByField(sortByField !== 'name' ? 'name' : '')}
          />
          <Button.Checkbox
            checked={sortByField === 'charge'}
            content="Charge"
            onClick={() =>
              setSortByField(sortByField !== 'charge' ? 'charge' : '')
            }
          />
          <Button.Checkbox
            checked={sortByField === 'draw'}
            content="Draw"
            onClick={() => setSortByField(sortByField !== 'draw' ? 'draw' : '')}
          />
        </Box>
      </Section>

      <Stack.Item grow mt={-1}>
        <Section fill scrollable>
          <Table>
            <Table.Row header>
              <Table.Cell>Area</Table.Cell>
              <Table.Cell collapsing>Charge</Table.Cell>
              <Table.Cell textAlign="right">Draw</Table.Cell>
              <Table.Cell collapsing title="Equipment">
                Eqp
              </Table.Cell>
              <Table.Cell collapsing title="Lighting">
                Lgt
              </Table.Cell>
              <Table.Cell collapsing title="Environment">
                Env
              </Table.Cell>
            </Table.Row>
            {areas.map((area) => (
              <tr key={area.id} className="Table__row candystripe">
                <td>{area.name}</td>
                <td className="Table__cell text-right text-nowrap">
                  <AreaCharge charging={area.charging} charge={area.charge} />
                </td>
                <td className="Table__cell text-right text-nowrap">
                  {area.load}
                </td>
                <td className="Table__cell text-center text-nowrap">
                  <AreaStatusColorBox status={area.eqp} />
                </td>
                <td className="Table__cell text-center text-nowrap">
                  <AreaStatusColorBox status={area.lgt} />
                </td>
                <td className="Table__cell text-center text-nowrap">
                  <AreaStatusColorBox status={area.env} />
                </td>
              </tr>
            ))}
          </Table>
        </Section>
      </Stack.Item>
    </Stack>
  );
}

type AreaChargeProps = {
  charge: number;
  charging: number;
};

const NOT_CHARGING = 0;
const CHARGING = 1;
const CHARGED = 2;

export function AreaCharge(props: AreaChargeProps) {
  const { charging, charge } = props;

  return (
    <>
      <Icon
        width="18px"
        textAlign="center"
        name={
          (charging === NOT_CHARGING &&
            (charge > 50 ? 'battery-half' : 'battery-quarter')) ||
          (charging === CHARGING && 'bolt') ||
          (charging === CHARGED && 'battery-full')
        }
        color={
          (charging === NOT_CHARGING && (charge > 50 ? 'yellow' : 'red')) ||
          (charging === CHARGING && 'yellow') ||
          (charging === CHARGED && 'green')
        }
      />
      <Box inline width="36px" textAlign="right">
        {toFixed(charge) + '%'}
      </Box>
    </>
  );
}

type AreaStatusColorBoxProps = {
  status: number;
};

function AreaStatusColorBox(props: AreaStatusColorBoxProps) {
  const { status } = props;

  const power = Boolean(status & 2);
  const mode = Boolean(status & 1);
  const tooltipText = (power ? 'On' : 'Off') + ` [${mode ? 'auto' : 'manual'}]`;

  return (
    <ColorBox
      color={power ? 'good' : 'bad'}
      content={mode ? undefined : 'M'}
      title={tooltipText}
    />
  );
}
