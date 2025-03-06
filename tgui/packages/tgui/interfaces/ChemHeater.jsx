import { round, toFixed } from 'common/math';

import { useBackend } from '../backend';
import {
  AnimatedNumber,
  Box,
  Button,
  Flex,
  Icon,
  NumberInput,
  ProgressBar,
  RoundGauge,
  Section,
  Table,
} from '../components';
import { Window } from '../layouts';
import { BeakerContents } from './common/BeakerContents';

export const ChemHeater = (props) => {
  const { act, data } = useBackend();
  const {
    targetTemp,
    isActive,
    isFlashing,
    isBeakerLoaded,
    currentTemp,
    beakerCurrentVolume,
    beakerMaxVolume,
    dispenseVolume,
    upgradeLevel,
    beakerContents = [],
    activeReactions = [],
  } = data;
  return (
    <Window width={330} height={350}>
      <Window.Content scrollable>
        <Section
          title="Controls"
          buttons={
            <Flex>
              <Button
                icon={isActive ? 'power-off' : 'times'}
                selected={isActive}
                content={isActive ? 'On' : 'Off'}
                onClick={() => act('power')}
              />
            </Flex>
          }
        >
          <Table>
            <Table.Row>
              <Table.Cell bold collapsing color="label">
                Heat
              </Table.Cell>
              <Table.Cell />
              <Table.Cell />
            </Table.Row>
            <Table.Row>
              <Table.Cell collapsing color="label">
                Target:
              </Table.Cell>
              <Table.Cell>
                <NumberInput
                  width="65px"
                  unit="K"
                  step={10}
                  stepPixelSize={3}
                  value={round(targetTemp)}
                  minValue={0}
                  maxValue={1000}
                  onDrag={(value) =>
                    act('temperature', {
                      target: value,
                    })
                  }
                />
              </Table.Cell>
            </Table.Row>
            <Table.Row>
              <Table.Cell collapsing color="label">
                Reading:
              </Table.Cell>
              <Table.Cell collapsing color="default">
                <Box width="60px" textAlign="right">
                  {(isBeakerLoaded && (
                    <AnimatedNumber
                      value={currentTemp}
                      format={(value) => toFixed(value) + ' K'}
                    />
                  )) ||
                    '—'}
                </Box>
              </Table.Cell>
            </Table.Row>
          </Table>
        </Section>
        {!!isBeakerLoaded && (
          <Section title="Reactions">
            {(activeReactions.length === 0 && (
              <Box color="label">No active reactions.</Box>
            )) || (
              <Table>
                <Table.Row>
                  <Table.Cell bold color="label">
                    Reaction
                  </Table.Cell>
                  <Table.Cell bold color="label">
                    {upgradeLevel < 4 ? 'Status' : 'Reaction quality'}
                  </Table.Cell>
                  <Table.Cell bold color="label">
                    Target
                  </Table.Cell>
                </Table.Row>
                {activeReactions.map((reaction) => (
                  <Table.Row key="reactions">
                    <Table.Cell width={'60px'} color={reaction.danger && 'red'}>
                      {reaction.name}
                    </Table.Cell>
                    <Table.Cell width={'100px'} pr={'10px'}>
                      {(upgradeLevel < 4 && (
                        <Icon
                          name={
                            reaction.danger ? 'exclamation-triangle' : 'spinner'
                          }
                          color={reaction.danger && 'red'}
                          spin={!reaction.danger}
                          ml={2.5}
                        />
                      )) || (
                        <AnimatedNumber value={reaction.quality}>
                          {(_, value) => (
                            <RoundGauge
                              size={1.3}
                              value={value}
                              minValue={0}
                              maxValue={1}
                              alertAfter={reaction.purityAlert}
                              content={'test'}
                              format={(value) => null}
                              ml={5}
                              ranges={{
                                red: [0, reaction.minPure],
                                orange: [reaction.minPure, reaction.inverse],
                                yellow: [reaction.inverse, 0.8],
                                green: [0.8, 1],
                              }}
                            />
                          )}
                        </AnimatedNumber>
                      )}
                    </Table.Cell>
                    <Table.Cell width={'70px'}>
                      {(upgradeLevel > 2 && (
                        <ProgressBar
                          value={reaction.reactedVol}
                          minValue={0}
                          maxValue={reaction.targetVol}
                          textAlign={'center'}
                          icon={reaction.overheat && 'thermometer-full'}
                          width={7}
                          color={reaction.overheat ? 'red' : 'label'}
                        >
                          {reaction.targetVol}u
                        </ProgressBar>
                      )) || (
                        <Box color={reaction.danger && 'red'} ml={2}>
                          {reaction.targetVol}u
                        </Box>
                      )}
                    </Table.Cell>
                  </Table.Row>
                ))}
                <Table.Row />
              </Table>
            )}
          </Section>
        )}
        <Section
          title="Beaker"
          buttons={
            !!isBeakerLoaded && (
              <>
                <Box inline color="label" mr={2}>
                  {beakerCurrentVolume} / {beakerMaxVolume} units
                </Box>
                <Button
                  icon="eject"
                  content="Eject"
                  onClick={() => act('eject')}
                />
              </>
            )
          }
        >
          <BeakerContents
            beakerLoaded={isBeakerLoaded}
            beakerContents={beakerContents}
          />
        </Section>
      </Window.Content>
    </Window>
  );
};
