import { useBackend } from '../backend';
import { Box, Button, Flex, Section, Table } from '../components';
import { Window } from '../layouts';

type SeedData = {
  amount: number;
  endurance: number;
  hash: string;
  maturation: number;
  name: string;
  potency: number;
  production: number;
  yield: number;
};

type SeedExtractorData = {
  seeds: SeedData[];
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
  const seeds = data.seeds;
  return (
    <Window width={1000} height={400}>
      <Window.Content>
        <Flex direction="row" height="100%">
          <Flex.Item width="75%" height="100%">
            <Section title="Stored Seeds" height="100%" overflowY="scroll">
              <Box textAlign="center" height="100%">
                <Table cellpadding="3" height="100%">
                  <Table.Row header>
                    <Table.Cell width="25%" textAlign="left">
                      Name
                    </Table.Cell>
                    <Table.Cell width="13%" textAlign="center">
                      Endurance
                    </Table.Cell>
                    <Table.Cell width="13%" textAlign="center">
                      Maturation
                    </Table.Cell>
                    <Table.Cell width="13%" textAlign="center">
                      Production
                    </Table.Cell>
                    <Table.Cell width="13%" textAlign="center">
                      Yield
                    </Table.Cell>
                    <Table.Cell width="10%" textAlign="center">
                      Potency
                    </Table.Cell>
                    <Table.Cell width="23%" textAlign="center">
                      Stock
                    </Table.Cell>
                  </Table.Row>
                  <Table.Cell height="1em" />
                  {seeds.map((item) => (
                    <Table.Row key={item.hash}>
                      <Table.Cell bold width="25%" textAlign="left">
                        {item.name}
                      </Table.Cell>
                      <Table.Cell width="13%" textAlign="center">
                        {item.endurance}
                      </Table.Cell>
                      <Table.Cell width="13%" textAlign="center">
                        {item.maturation}
                      </Table.Cell>
                      <Table.Cell width="13%" textAlign="center">
                        {item.production}
                      </Table.Cell>
                      <Table.Cell width="13%" textAlign="center">
                        {item.yield}
                      </Table.Cell>
                      <Table.Cell width="10%" textAlign="center">
                        {item.potency}
                      </Table.Cell>
                      <Table.Cell width="23%">
                        ({item.amount}x)
                        <Button
                          content="Vend"
                          onClick={() =>
                            act('select', {
                              item: item.hash,
                            })
                          }
                          style={{
                            marginLeft: '0.5em',
                          }}
                        />
                      </Table.Cell>
                    </Table.Row>
                  ))}
                </Table>
              </Box>
            </Section>
          </Flex.Item>
          <Flex.Item width="25%">
            <Section title="Manipulate DNA" fill height="100%">
              Test
            </Section>
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};
