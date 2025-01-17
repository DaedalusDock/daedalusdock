import { useBackend, useSharedState } from '../backend';
import { Box, Button, Flex, Section, Stack, Table } from '../components';
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

type Beaker = {};

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
  const [tab, setTab] = useSharedState('tab', 0);
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
  const seeds = data.seeds;
  const splicing = data.splice_target;
  return (
    <Flex direction="row" height="100%">
      <Flex.Item width="75%" height="100%">
        <Section title="Stored Seeds" height="100%" overflowY="scroll">
          <Box textAlign="center" height="100%">
            <Table cellpadding="3" height="100%">
              <Table.Row header>
                <Table.Cell width="15%" textAlign="left">
                  Name
                </Table.Cell>
                <Table.Cell width="10%" textAlign="center">
                  Damage
                </Table.Cell>
                <Table.Cell width="10%" textAlign="center">
                  Genome
                </Table.Cell>
                <Table.Cell width="10%" textAlign="center">
                  Endurance
                </Table.Cell>
                <Table.Cell width="10%" textAlign="center">
                  Maturation
                </Table.Cell>
                <Table.Cell width="10%" textAlign="center">
                  Production
                </Table.Cell>
                <Table.Cell width="10%" textAlign="center">
                  Yield
                </Table.Cell>
                <Table.Cell width="10%" textAlign="center">
                  Potency
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
                      onClick={() => act('infuse')}
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
        <Section title="Infusion" fill height="100%">
          <Stack>
            <Stack.Item>Beaker: OK</Stack.Item>
          </Stack>
        </Section>
      </Flex.Item>
    </Flex>
  );
};

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
