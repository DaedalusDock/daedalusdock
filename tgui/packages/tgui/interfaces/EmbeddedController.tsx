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
    ['1', '4', '7', '*'],
    ['2', '5', '8', '0'],
    ['3', '6', '9', '#'],
  ];
  return (
    <Box>
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
                fontSize="3.5rem"
                lineHeight={1.25}
                width="4.5rem"
                className={classes([
                  'EmbeddedController__Button',
                  'EmbeddedController__Button--keypad',
                  'EmbeddedController__Button--' + key,
                ])}
                onClick={() => act('text', { value: key })}
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
  const { displayHTML, bgColor, fontColor } = data;

  return (
    <Window width={412} height={638} theme="retro">
      <Window.Content
        className="EmbeddedController_Window"
        onKeyDown={handleKeyDown}
      >
        <Box m="6px">
          <Box
            mb="6px"
            height="6em"
            className="EmbeddedController__displayBox"
            style={{
              borderRight: '#949180 solid',
            }}
          >
            <TerminalOutputSection
              bgColor={bgColor}
              displayHTML={displayHTML}
              fontColor={fontColor}
              noscroll
            />
          </Box>
          <Flex mb={1.5} justify="center">
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
                      fontSize="3.5rem"
                      lineHeight={1.25}
                      width="4.5rem"
                      className={classes([
                        'EmbeddedController__Button',
                        'EmbeddedController__Button--keypad',
                      ])}
                      onClick={() => act('ec_eject_id')}
                    />
                  </Flex.Item>
                </Flex>
              </Flex.Item>
            </Flex.Item>
          </Flex>
        </Box>
      </Window.Content>
    </Window>
  );
};

function handleKeyDown(event: React.KeyboardEvent<any>) {
  const { act } = useBackend<TerminalData>();

  // This is using the "code" variable of events. Fuck you webshit.
  // Fuck you webshit for having 3 different identifiers.
  const keyToCode = {
    Numpad0: '0',
    Numpad1: '1',
    Numpad2: '2',
    Numpad3: '3',
    Numpad4: '4',
    Numpad5: '5',
    Numpad6: '6',
    Numpad7: '7',
    Numpad8: '8',
    Numpad9: '9',
    NumpadDecimal: '*',
    NumpadEnter: '#',
  };

  const associatedString = keyToCode[event.code];
  if (typeof associatedString !== 'undefined') {
    act('text', { value: associatedString });
  }
}
