import { classes } from 'common/react';

import { useBackend } from '../backend';
import { Box, Button, Flex, Grid } from '../components';
import { Window } from '../layouts';
import { TerminalOutputSection } from './Terminal/TerminalOutputSection';
import { type TerminalData } from './Terminal/types';

// This ui is so many manual overrides and !important tags
// and hand made width sets that changing pretty much anything
// is going to require a lot of tweaking it get it looking correct again
// I'm sorry, but it looks bangin
const ControllerKeypad = (props) => {
  const { act } = useBackend();
  const keypadKeys = [
    ['1', '4', '7', '#'],
    ['2', '5', '8', '0'],
    ['3', '6', '9', '*'],
  ];
  return (
    <Box width="185px">
      <Grid width="1px">
        {keypadKeys.map((keyColumn) => (
          <Grid.Column key={keyColumn[0]}>
            {keyColumn.map((key) => (
              <Button
                fluid
                bold
                key={key}
                mb="6px"
                content={key}
                textAlign="center"
                fontSize="40px"
                lineHeight={1.25}
                width="55px"
                className={classes([
                  'NuclearBomb__Button',
                  'NuclearBomb__Button--keypad',
                  'NuclearBomb__Button--' + key,
                ])}
                onClick={() => act('keypad', { text: key })}
              />
            ))}
          </Grid.Column>
        ))}
      </Grid>
    </Box>
  );
};

export const EmbeddedController = (props) => {
  const { act, data } = useBackend<TerminalData>();
  const { displayHTML } = data;
  return (
    <Window width={350} height={550} theme="retro">
      <Window.Content>
        <Box m="6px">
          <Box mb="6px" height="6em" className="NuclearBomb__displayBox" style={{padding: "0px"}}>
            <TerminalOutputSection
              bgColor="#1B1E1B"
              displayHTML={displayHTML}
              fontColor="#19A319"
              noscroll
            />
          </Box>
          <Flex mb={1.5} />
          <Flex ml="3px">
            <Flex.Item>
              <ControllerKeypad />
              <Flex.Item>
                <Flex direction="row" justify="center">
                  <Flex.Item>
                    <Button
                      fluid
                      bold
                      icon="eject"
                      mb="6px"
                      textAlign="center"
                      fontSize="40px"
                      lineHeight={1.25}
                      width="55px"
                      className={classes([
                        'NuclearBomb__Button',
                        'NuclearBomb__Button--keypad',
                      ])}
                      onClick={() => act('eject')}
                    />
                  </Flex.Item>
                </Flex>
              </Flex.Item>
            </Flex.Item>
            <Flex.Item ml="6px" width="129px">
              <Box> {/* Put side buttons here*/}
              </Box>
            </Flex.Item>
          </Flex>
        </Box>
      </Window.Content>
    </Window>
  );
};
