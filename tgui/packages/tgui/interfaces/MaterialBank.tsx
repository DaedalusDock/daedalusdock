import { BooleanLike } from 'common/react';
import { toTitleCase } from 'common/string';

import { useBackend, useLocalState } from '../backend';
import {
  BlockQuote,
  Box,
  Button,
  NumberInput,
  Section,
  Table,
} from '../components';
import { Window } from '../layouts';

type ORMData = {
  alloys: Alloy[];
  disconnected: string;
  diskDesigns: Design[];
  hasDisk: BooleanLike;
  materials: Material[];
};

type Design = {
  canupload: BooleanLike;
  index: number;
  name: string;
};
type Alloy = {
  amount: number;
  id: string;
  name: string;
};

type Material = {
  amount: number;
  id: string;
  name: string;
  value: number;
};

export const MaterialBank = (props) => {
  const { act, data } = useBackend<ORMData>();
  const { materials, alloys, diskDesigns, hasDisk } = data;
  return (
    <Window title="Material Bank" width={440} height={550}>
      <Window.Content scrollable>
        <Section>
          <BlockQuote mb={1}>
            This machine only accepts ore.
            <br />
            Slag is not accepted.
          </BlockQuote>
        </Section>
        <Section>
          {(hasDisk && (
            <>
              <Box mb={1}>
                <Button
                  icon="eject"
                  content="Eject design disk"
                  onClick={() => act('diskEject')}
                />
              </Box>
              <Table>
                {diskDesigns.map((design) => (
                  <Table.Row key={design.index}>
                    <Table.Cell>
                      File {design.index}: {design.name}
                    </Table.Cell>
                    <Table.Cell collapsing>
                      <Button
                        disabled={!design.canupload}
                        content="Upload"
                        onClick={() =>
                          act('diskUpload', {
                            design: design.index,
                          })
                        }
                      />
                    </Table.Cell>
                  </Table.Row>
                ))}
              </Table>
            </>
          )) || (
            <Button
              icon="save"
              content="Insert design disk"
              onClick={() => act('diskInsert')}
            />
          )}
        </Section>
        <Section title="Materials">
          <Table>
            {materials.map((material) => (
              <MaterialRow
                key={material.id}
                material={material}
                onRelease={(amount) =>
                  act('Release', {
                    id: material.id,
                    sheets: amount,
                  })
                }
              />
            ))}
          </Table>
        </Section>
        <Section title="Alloys">
          <Table>
            {alloys.map((material) => (
              <MaterialRow
                key={material.id}
                material={material}
                onRelease={(amount) =>
                  act('Smelt', {
                    id: material.id,
                    sheets: amount,
                  })
                }
              />
            ))}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};

const MaterialRow = (props) => {
  const { material, onRelease } = props;

  const [amount, setAmount] = useLocalState('amount' + material.name, 1);

  const amountAvailable = Math.floor(material.amount);
  return (
    <Table.Row>
      <Table.Cell>{toTitleCase(material.name).replace('Alloy', '')}</Table.Cell>
      <Table.Cell collapsing textAlign="right">
        <Box mr={2} color="label" inline>
          {material.value && material.value + ' cr'}
        </Box>
      </Table.Cell>
      <Table.Cell collapsing textAlign="right">
        <Box mr={2} color="label" inline>
          {amountAvailable} sheets
        </Box>
      </Table.Cell>
      <Table.Cell collapsing>
        <NumberInput
          width="32px"
          step={1}
          stepPixelSize={5}
          minValue={1}
          maxValue={50}
          value={amount}
          onChange={(value) => setAmount(value)}
        />
        <Button
          disabled={amountAvailable < 1}
          content="Release"
          onClick={() => onRelease(amount)}
        />
      </Table.Cell>
    </Table.Row>
  );
};
