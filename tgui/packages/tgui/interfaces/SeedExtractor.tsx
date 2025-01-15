import { useBackend } from '../backend';
import { Button, Section, Table } from '../components';
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
      <Window.Content scrollable>
        <Section title="Stored seeds:">
          <Table cellpadding="3" textAlign="center">
            <Table.Row header>
              <Table.Cell>Name</Table.Cell>
              <Table.Cell>Endurance</Table.Cell>
              <Table.Cell>Maturation</Table.Cell>
              <Table.Cell>Production</Table.Cell>
              <Table.Cell>Yield</Table.Cell>
              <Table.Cell>Potency</Table.Cell>
              <Table.Cell>Stock</Table.Cell>
            </Table.Row>
            {seeds.map((item) => (
              <Table.Row key={item.hash}>
                <Table.Cell bold>{item.name}</Table.Cell>
                <Table.Cell>{item.endurance}</Table.Cell>
                <Table.Cell>{item.maturation}</Table.Cell>
                <Table.Cell>{item.production}</Table.Cell>
                <Table.Cell>{item.yield}</Table.Cell>
                <Table.Cell>{item.potency}</Table.Cell>
                <Table.Cell>
                  <Button
                    content="Vend"
                    onClick={() =>
                      act('select', {
                        item: item.hash,
                      })
                    }
                  />
                  ({item.amount} left)
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
