import { useBackend } from '../backend';
import {
  AnimatedNumber,
  Box,
  Button,
  LabeledList,
  ProgressBar,
  Section,
} from '../components';
import { Window } from '../layouts';

export const ChemDispenser = (props) => {
  const { act, data } = useBackend();
  const { recipeReagents = [] } = data;
  const beakerTransferAmounts = data.beakerTransferAmounts || [];
  const beakerContents = data.beakerContents || [];
  return (
    <Window width={565} height={620}>
      <Window.Content scrollable>
        <Section
          title="Status"
          buttons={
            <Button
              icon="book"
              disabled={!data.isBeakerLoaded}
              content={'Reaction search'}
              tooltip={
                data.isBeakerLoaded
                  ? 'Look up recipes and reagents!'
                  : 'Please insert a beaker!'
              }
              tooltipPosition="bottom-start"
              onClick={() => act('reaction_lookup')}
            />
          }
        >
          <LabeledList>
            <LabeledList.Item label="Cartridges">
              <ProgressBar value={data.cartAmount} maxValue={data.maxCarts}>
                {data.cartAmount} cartridges
              </ProgressBar>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section
          title="Dispense"
          buttons={beakerTransferAmounts.map((amount) => (
            <Button
              key={amount}
              icon="plus"
              selected={amount === data.amount}
              content={amount}
              onClick={() =>
                act('amount', {
                  target: amount,
                })
              }
            />
          ))}
        >
          <Box mr={-1}>
            {data.chemicals.map((chemical) => (
              <Button
                key={chemical.id}
                icon="tint"
                width="129.5px"
                lineHeight={1.75}
                content={
                  <>
                    {chemical.title}
                    <br />
                    <ProgressBar
                      value={chemical.amount}
                      maxValue={chemical.max}
                      width="117px"
                      ranges={{
                        good: [70, Infinity],
                        average: [40, 70],
                        bad: [-Infinity, 40],
                      }}
                    />
                  </>
                }
                onClick={() =>
                  act('dispense', {
                    reagent: chemical.id,
                  })
                }
              />
            ))}
          </Box>
        </Section>
        <Section
          title="Beaker"
          buttons={beakerTransferAmounts.map((amount) => (
            <Button
              key={amount}
              icon="minus"
              content={amount}
              onClick={() => act('remove', { amount })}
            />
          ))}
        >
          <LabeledList>
            <LabeledList.Item
              label="Beaker"
              buttons={
                !!data.isBeakerLoaded && (
                  <Button
                    icon="eject"
                    content="Eject"
                    disabled={!data.isBeakerLoaded}
                    onClick={() => act('eject')}
                  />
                )
              }
            >
              {data.isBeakerLoaded ? data.beakerName : 'No Beaker'}
            </LabeledList.Item>
            <LabeledList.Item label="Contents">
              <Box color="label">
                {(!data.isBeakerLoaded && 'N/A') ||
                  (beakerContents.length === 0 && 'Nothing')}
              </Box>
              {beakerContents.map((chemical) => (
                <Box key={chemical.name} color="label">
                  <AnimatedNumber initial={0} value={chemical.volume} /> units
                  of {chemical.name}
                </Box>
              ))}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
