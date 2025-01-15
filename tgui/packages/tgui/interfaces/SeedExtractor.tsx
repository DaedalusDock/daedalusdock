import { useBackend } from '../backend';
import { Box, Button, Flex, Section } from '../components';
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
                <Flex direction="column" height="100%">
                  <Flex direction="row">
                    <Flex.Item width="25%" textAlign="left">
                      Name
                    </Flex.Item>
                    <Flex.Item width="15%">Endurance</Flex.Item>
                    <Flex.Item width="15%">Maturation</Flex.Item>
                    <Flex.Item width="15%">Production</Flex.Item>
                    <Flex.Item width="15%">Yield</Flex.Item>
                    <Flex.Item width="15%">Potency</Flex.Item>
                    <Flex.Item width="15%">Stock</Flex.Item>
                  </Flex>
                  <Flex.Item height="1em" />
                  {seeds.map((item) => (
                    <Flex direction="row" key={item.hash}>
                      <Flex.Item bold width="25%" textAlign="left">
                        {item.name}
                      </Flex.Item>
                      <Flex.Item width="15%">{item.endurance}</Flex.Item>
                      <Flex.Item width="15%">{item.maturation}</Flex.Item>
                      <Flex.Item width="15%">{item.production}</Flex.Item>
                      <Flex.Item width="15%">{item.yield}</Flex.Item>
                      <Flex.Item width="15%">{item.potency}</Flex.Item>
                      <Flex.Item width="15%">
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
                      </Flex.Item>
                    </Flex>
                  ))}
                </Flex>
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
