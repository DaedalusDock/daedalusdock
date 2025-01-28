import { sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { BooleanLike } from 'common/react';
import { createSearch } from 'common/string';
import { useState } from 'react';

import { useBackend } from '../backend';
import {
  AnimatedNumber,
  Box,
  Button,
  Flex,
  Section,
  Table,
} from '../components';
import { truncate } from '../format';
import { Window } from '../layouts';

type Seed = {
  damage: number;
  endurance: number;
  genome: number;
  maturation: number;
  name: string;
  potency: number;
  production: number;
  ref: string;
  yield: number;
};

type Reagent = {
  name: string;
  volume: number;
};

type Beaker = {
  loaded: BooleanLike;
  max_volume?: number;
  reagents?: Reagent[];
  volume?: number;
};

type SeedExtractorData = {
  beaker: Beaker;
  seeds: Seed[];
  splice_target?: Seed;
};

/**
 * This method splits up the string "name" we get for the seeds
 * and creates an object from it include the value that is the
 * ammount
 *
 * @returns {any[]}
 */
export const SeedExtractor = (props) => {
  const { act, data } = useBackend<SeedExtractorData>();
  return (
    <Window width={1100} height={400}>
      <Window.Content>
        <SeedList />
      </Window.Content>
    </Window>
  );
};

export const SeedList = (props) => {
  const { act, data } = useBackend<SeedExtractorData>();
  const splicing = data.splice_target;
  const beaker = data.beaker;
  const has_enough_reagent = checkReagents(beaker.reagents);

  const [searchText, setSearchText] = useState('');
  const [sortField, setSortField] = useState('name');
  const search = createSearch(searchText, (item: Seed) => item.name);

  const seeds_filtered =
    searchText.length > 0 ? data.seeds.filter(search) : data.seeds;
  const seeds = flow([sortBy((item: Seed) => item[sortField as keyof Seed])])(
    seeds_filtered || [],
  );
  sortField !== 'name' && seeds.reverse();

  return (
    <Flex direction="row" height="100%">
      <Flex.Item width="75%" height="100%">
        <Section title="Stored Seeds" height="100%" overflowY="scroll">
          <Box textAlign="center" height="100%">
            <Table cellpadding="3" height="100%">
              <Table.Row header>
                <Table.Cell width="15%" textAlign="left">
                  <Box
                    style={{ cursor: 'pointer' }}
                    onClick={(e) => setSortField('name')}
                  >
                    Name
                  </Box>
                </Table.Cell>
                <Table.Cell width="10%" textAlign="center">
                  <Box
                    style={{ cursor: 'pointer' }}
                    onClick={(e) => setSortField('damage')}
                  >
                    Damage
                  </Box>
                </Table.Cell>
                <Table.Cell width="10%" textAlign="center">
                  <Box
                    style={{ cursor: 'pointer' }}
                    onClick={(e) => setSortField('genome')}
                  >
                    Genome
                  </Box>
                </Table.Cell>
                <Table.Cell width="10%" textAlign="center">
                  <Box
                    style={{ cursor: 'pointer' }}
                    onClick={(e) => setSortField('endurance')}
                  >
                    Endurance
                  </Box>
                </Table.Cell>
                <Table.Cell width="10%" textAlign="center">
                  <Box
                    style={{ cursor: 'pointer' }}
                    onClick={(e) => setSortField('maturation')}
                  >
                    Maturation
                  </Box>
                </Table.Cell>
                <Table.Cell width="10%" textAlign="center">
                  <Box
                    style={{ cursor: 'pointer' }}
                    onClick={(e) => setSortField('production')}
                  >
                    Production
                  </Box>
                </Table.Cell>
                <Table.Cell width="10%" textAlign="center">
                  <Box
                    style={{ cursor: 'pointer' }}
                    onClick={(e) => setSortField('yield')}
                  >
                    Yield
                  </Box>
                </Table.Cell>
                <Table.Cell width="10%" textAlign="center">
                  <Box
                    style={{ cursor: 'pointer' }}
                    onClick={(e) => setSortField('potency')}
                  >
                    Potency
                  </Box>
                </Table.Cell>
                <Table.Cell width="25%" textAlign="center">
                  Controls
                </Table.Cell>
              </Table.Row>
              <Table.Cell height="1em" />
              {seeds.map((item) => (
                <Table.Row key={item.ref}>
                  <Table.Cell bold width="15%" textAlign="left">
                    <Button.Input
                      width="100px"
                      tooltip="Click to rename"
                      color="transparent"
                      textColor="#FFFFFF"
                      content={truncate(item.name, 15)}
                      defaultValue={item.name}
                      currentValue={item.name}
                      onCommit={(new_name) =>
                        act('label', {
                          ref: item.ref,
                          name: new_name,
                        })
                      }
                    />
                  </Table.Cell>
                  <Table.Cell width="10%" textAlign="center">
                    {item.damage}
                  </Table.Cell>
                  <Table.Cell width="10%" textAlign="center">
                    {item.genome}
                  </Table.Cell>
                  <Table.Cell width="10%" textAlign="center">
                    {item.endurance}
                  </Table.Cell>
                  <Table.Cell width="10%" textAlign="center">
                    {item.maturation}
                  </Table.Cell>
                  <Table.Cell width="10%" textAlign="center">
                    {item.production}
                  </Table.Cell>
                  <Table.Cell width="10%" textAlign="center">
                    {item.yield}
                  </Table.Cell>
                  <Table.Cell width="8%" textAlign="center">
                    {item.potency}
                  </Table.Cell>
                  <Table.Cell width="25%" textAlign="center">
                    <Button
                      icon="search"
                      title="Analyze"
                      onClick={() =>
                        act('analyze', {
                          ref: item.ref,
                        })
                      }
                    />
                    <Button
                      icon="fill-drip"
                      title="Infuse"
                      disabled={!beaker.loaded || !has_enough_reagent}
                      onClick={() =>
                        act('infuse', {
                          ref: item.ref,
                        })
                      }
                    />
                    {SpliceButton(item, splicing)}
                    <Button
                      icon="eject"
                      title="Eject"
                      onClick={() =>
                        act('eject', {
                          ref: item.ref,
                        })
                      }
                    />
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table>
          </Box>
        </Section>
      </Flex.Item>
      <Flex.Item width="25%">
        <Section
          title="Infusion"
          fill
          height="100%"
          buttons={
            !!beaker.loaded && (
              <>
                <Box inline color="label" mr={2}>
                  <AnimatedNumber value={beaker.volume} initial={0} />
                  {` / ${beaker.max_volume} units`}
                </Box>
                <Button
                  icon="eject"
                  content="Eject"
                  onClick={() => act('eject_beaker')}
                />
              </>
            )
          }
        >
          {(!beaker.loaded && (
            <Box color="label" mt="3px" mb="5px">
              No beaker loaded.
            </Box>
          )) || (
            <Box height="100%">
              {beaker.reagents?.map((reagent) => (
                <ReagentEntry
                  key={reagent.name}
                  chemical={reagent}
                  transferTo="buffer"
                />
              ))}
            </Box>
          )}
        </Section>
      </Flex.Item>
    </Flex>
  );
};

const ReagentEntry = (props) => {
  const { chemical } = props;
  return (
    <Table.Row key={chemical.id}>
      <Table.Cell color="label">
        <AnimatedNumber value={chemical.volume} initial={0} />
        {` units of ${chemical.name}`}
      </Table.Cell>
    </Table.Row>
  );
};

function checkReagents(reagents: Reagent[] | undefined) {
  let has_enough_reagent = false;
  reagents?.forEach((reagent) => {
    if (reagent.volume >= 10) {
      has_enough_reagent = true;
    }
  });
  return has_enough_reagent || false;
}

function SpliceButton(item: Seed, splicing?: Seed) {
  const { act } = useBackend<SeedExtractorData>();
  let icon = '';
  let title = '';
  let color = '';

  if (!splicing) {
    icon = 'code-branch';
    title = 'Select Splice Target';
  } else if (splicing.ref === item.ref) {
    icon = 'window-close';
    title = 'Cancel Splice';
    color = 'red';
  } else {
    icon = 'code-branch';
    title = 'Splice';
    color = 'green';
  }

  return (
    <Button
      icon={icon}
      title={title}
      color={color}
      onClick={() =>
        act('splice', {
          ref: item.ref,
        })
      }
    />
  );
}
