import { sortBy } from 'common/collections';

import { useBackend } from '../backend';
import { Button, Icon, Section, Table } from '../components';
import { COLORS } from '../constants';
import { Window } from '../layouts';

const HEALTH_ICON_BY_LEVEL = ['heart', 'heartbeat', 'skull'];

const jobIsHead = (jobId) => jobId % 10 === 0;

const jobToColor = (jobId) => {
  if (jobId === 0) {
    return COLORS.department.captain;
  }
  if (jobId >= 10 && jobId < 20) {
    return COLORS.department.security;
  }
  if (jobId >= 20 && jobId < 30) {
    return COLORS.department.medbay;
  }
  if (jobId >= 30 && jobId < 40) {
    return COLORS.department.science;
  }
  if (jobId >= 40 && jobId < 50) {
    return COLORS.department.engineering;
  }
  if (jobId >= 50 && jobId < 60) {
    return COLORS.department.cargo;
  }
  if (jobId >= 200 && jobId < 230) {
    return COLORS.department.centcom;
  }
  return COLORS.department.other;
};

const statusToImage = (life_status) => {
  switch (life_status) {
    case 0:
      return <Icon name="heart" color="#17d568" size={1} />;
    case 1:
    case 2:
    case 3:
      return <Icon name="heartbeat" color="#801308" size={1} />;
    case 4:
      return <Icon name="skull" color="#801308" size={1} />;
  }
};

const statusToText = (life_status) => {
  switch (life_status) {
    case 0:
      return 'Alive';
    case 1:
    case 2:
    case 3:
      return 'Critical Condition';
    case 4:
      return 'Dead';
  }
};

export const CrewConsole = () => {
  return (
    <Window title="Crew Monitor" width={600} height={600}>
      <Window.Content scrollable>
        <Section minHeight="540px">
          <CrewTable />
        </Section>
      </Window.Content>
    </Window>
  );
};

const CrewTable = (props) => {
  const { act, data } = useBackend();
  const sensors = sortBy((s) => s.ijob)(data.sensors ?? []);
  return (
    <Table>
      <Table.Row>
        <Table.Cell width="50%" bold>
          Name
        </Table.Cell>
        <Table.Cell width="5%" bold collapsing />
        <Table.Cell width="15%" bold collapsing textAlign="center">
          Vitals
        </Table.Cell>
        <Table.Cell width="15%" bold collapsing textAlign="center">
          Position
        </Table.Cell>
        {!!data.link_allowed && (
          <Table.Cell bold collapsing textAlign="center">
            Tracking
          </Table.Cell>
        )}
      </Table.Row>
      {sensors.map((sensor) => (
        <CrewTableEntry sensor_data={sensor} key={sensor.ref} />
      ))}
    </Table>
  );
};

const CrewTableEntry = (props) => {
  const { act, data } = useBackend();
  const { link_allowed } = data;
  const { sensor_data } = props;
  const { name, assignment, ijob, life_status, area, can_track } = sensor_data;

  return (
    <Table.Row>
      <Table.Cell width="50%" bold={jobIsHead(ijob)} color={jobToColor(ijob)}>
        {name}
        {assignment !== undefined ? ` (${assignment})` : ''}
      </Table.Cell>
      <Table.Cell width="5%" collapsing textAlign="center">
        {statusToImage(life_status)}
      </Table.Cell>
      <Table.Cell width="15%" collapsing textAlign="center">
        {statusToText(life_status)}
      </Table.Cell>
      <Table.Cell width="15%" collapsing textAlign="center">
        {area !== undefined ? (
          area
        ) : (
          <Icon name="question" color="#ffffff" size={1} />
        )}
      </Table.Cell>
      {!!link_allowed && (
        <Table.Cell collapsing textAlign="center">
          <Button
            content="Track"
            disabled={!can_track}
            onClick={() =>
              act('select_person', {
                name: name,
              })
            }
          />
        </Table.Cell>
      )}
    </Table.Row>
  );
};
