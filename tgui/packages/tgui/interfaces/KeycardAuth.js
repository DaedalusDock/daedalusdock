import { useBackend } from '../backend';
import { Box, Button, Section } from '../components';
import { Window } from '../layouts';

export const KeycardAuth = (props) => {
  const { act, data } = useBackend();
  return (
    <Window width={375} height={58 + data.optmap.length * 22}>
      <Window.Content>
        <Section>
          <Box>
            {data.waiting === 1 && (
              <span>Waiting for another device to confirm your request...</span>
            )}
          </Box>
          <Box>
            {data.waiting === 0 && (
              <>
                {!!data.auth_required && (
                  <Button
                    icon="check-square"
                    color="red"
                    textAlign="center"
                    lineHeight="60px"
                    fluid
                    onClick={() => act('auth_swipe')}
                    content="Authorize"
                  />
                )}
                {data.auth_required === 0 && (
                  <>
                    {/* <Button
                      icon="exclamation-triangle"
                      fluid
                      onClick={() => act('red_alert')}
                      content="Red Alert" />
                    <Button
                      icon="wrench"
                      fluid
                      onClick={() => act('emergency_maint')}
                      content="Emergency Maintenance Access" />
                    <Button
                      icon="meteor"
                      fluid
                      onClick={() => act('bsa_unlock')}
                      content="Bluespace Artillery Unlock" /> */}
                    {/* frag2*/}
                    {data.optmap.map((optbundle) => {
                      return (
                        <Button
                          fluid
                          key={optbundle.trigger_key}
                          icon={optbundle.icon}
                          content={optbundle.displaymsg}
                          onClick={() =>
                            act('trigger', { path: optbundle.trigger_key })
                          }
                          disabled={!optbundle.is_valid}
                        />
                      );
                    })}
                  </>
                )}
              </>
            )}
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};
