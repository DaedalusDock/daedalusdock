import { classes } from 'common/react';
import { BooleanLike } from 'common/react';
import { Tooltip } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Icon, Section, Table } from '../components';
import { Window } from '../layouts';

export type ManifestEntry = {
  is_captain: BooleanLike;
  is_faction_leader: BooleanLike;
  name: string;
  rank: string;
  template_rank: string;
};

type ManifestPositions = {
  exceptions: string[];
  open: number;
};

type CrewManifestData = {
  manifest: Record<string, ManifestEntry[]>;
  positions: Record<string, ManifestPositions>;
};
// PARIAH EDIT
// Any instance of crewMember.trim was originally crewMember.rank
export const CrewManifest = (props) => {
  const {
    data: { manifest, positions },
  } = useBackend<CrewManifestData>();

  return (
    <Window title="Staff Manifest" width={350} height={500}>
      <Window.Content scrollable>
        {Object.entries(manifest).map(([dept, crew]) => (
          <ManifestDepartment
            key={dept}
            all_positions={positions}
            crew={crew}
            department={dept}
          />
        ))}
      </Window.Content>
    </Window>
  );
};

type ManifestDepartmentProps = {
  all_positions: Record<string, ManifestPositions>;
  crew: ManifestEntry[];
  department: string;
};

const ManifestDepartment = (props: ManifestDepartmentProps) => {
  const { all_positions, crew, department } = props;
  return (
    <Section
      className={'CrewManifest--' + department.replace(/\s+/g, '')}
      title={
        department +
        (department !== 'Misc'
          ? ` (${all_positions[department].open} positions open)`
          : '')
      }
    >
      <Table>
        {Object.entries(crew).map(([crewIndex, crewMember]) => (
          <Table.Row key={crewIndex}>
            <Table.Cell className={'CrewManifest__Cell'}>
              {crewMember.name}
            </Table.Cell>
            <Table.Cell
              className={classes(['CrewManifest__Cell', 'CrewManifest__Icons'])}
              collapsing
            >
              {all_positions[department].exceptions.includes(
                crewMember.template_rank,
              ) && (
                <Tooltip content="No position limit" position="bottom">
                  <Icon className="CrewManifest__Icon" name="infinity" />
                </Tooltip>
              )}
              {!!crewMember.is_captain && (
                <Tooltip content="Superintendent" position="bottom">
                  <Icon
                    className={classes([
                      'CrewManifest__Icon',
                      'CrewManifest__Icon--Command',
                    ])}
                    name="star"
                  />
                </Tooltip>
              )}
              {!!crewMember.is_faction_leader && (
                <Tooltip content="Faction Leader" position="bottom">
                  <Icon
                    className={classes([
                      'CrewManifest__Icon',
                      'CrewManifest__Icon--Command',
                      'CrewManifest__Icon--Chevron',
                    ])}
                    name="chevron-up"
                  />
                </Tooltip>
              )}
            </Table.Cell>
            <Table.Cell
              className={classes([
                'CrewManifest__Cell',
                'CrewManifest__Cell--Rank',
              ])}
              collapsing
            >
              {crewMember.rank}
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};
