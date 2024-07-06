import { useBackend, useLocalState, useSharedState } from '../backend';
import {
  BlockQuote,
  Box,
  Button,
  Divider,
  Dropdown,
  Section,
  Stack,
  Tabs,
} from '../components';
import { Window } from '../layouts';

export const FaxMachine = (props) => {
  const { act, data } = useBackend();
  const {
    display_name,
    destination_options = [],
    default_destination,
    received_paperwork = [],
    received_paper,
    stored_paper,
    can_send_cc_messages,
    can_receive,
    emagged,
    unread_message,
  } = data;

  const [tab, setTab] = useSharedState('tab', 1);

  const [selectedPaperTab, setSelectedPaper] = useLocalState(
    'ref',
    received_paperwork[0]?.ref,
  );

  const [destination, setDestination] = useLocalState(
    'dest',
    default_destination,
  );

  const selectedPaper = received_paperwork.find((paper) => {
    return paper.ref === selectedPaperTab;
  });

  const selectedDestination = destination_options.find((dest) => {
    return dest === destination;
  });

  return (
    <Window width={550} height={630} theme={emagged ? 'syndicate' : 'ntos'}>
      <Window.Content>
        <Section
          title="Nanotrasen Fax Device"
          height={6.5}
          buttons={
            !!emagged && (
              <Button
                color="bad"
                content="Restore Routing Information"
                onClick={() => act('un_emag_machine')}
              />
            )
          }
        >
          Hello, {display_name}!{' '}
          {emagged
            ? 'ERR- ERRoR. ERROR.'
            : 'Welcome to the Nanotrasen Approved Faxing Device!'}
        </Section>
        <Section title="Faxed Papers">
          <Stack vertical height={15}>
            <Stack.Item height={2}>
              <Tabs>
                <Tabs.Tab
                  width="50%"
                  icon="copy"
                  selected={tab === 1}
                  onClick={() => setTab(1)}
                >
                  <b>Send A Fax</b>
                </Tabs.Tab>
                <Tabs.Tab
                  width="50%"
                  icon="broadcast-tower"
                  selected={tab === 2}
                  onClick={() => {
                    setTab(2);
                    act('read_last_received');
                  }}
                >
                  <Stack grow width="100%">
                    <Stack.Item grow textAlign="left">
                      <b>Received Faxes</b>
                    </Stack.Item>
                    {received_paper && !!unread_message && (
                      <Stack.Item grow textAlign="right">
                        <i>New message!</i>
                      </Stack.Item>
                    )}
                  </Stack>
                </Tabs.Tab>
              </Tabs>
            </Stack.Item>
            <Stack.Item mt={1} height={13}>
              {tab === 1 &&
                (stored_paper ? (
                  <Box mt={1}>
                    <span
                      style={{
                        color: emagged ? 'lightgreen' : 'lightblue',
                        fontWeight: 'bold',
                      }}
                    >
                      Message to Send:
                    </span>
                    <BlockQuote mt={1}>{stored_paper.contents}</BlockQuote>
                  </Box>
                ) : (
                  <Box>
                    <i>
                      Insert a paper into the machine to fax its contents
                      somewhere.
                    </i>
                  </Box>
                ))}
              {tab === 2 &&
                (received_paper ? (
                  <Box mt={1}>
                    <span style={{ color: 'gold', fontWeight: 'bold' }}>
                      Message from {received_paper.source}:
                    </span>
                    <BlockQuote mt={1}>{received_paper.contents}</BlockQuote>
                  </Box>
                ) : (
                  <Box>
                    <i>No papers have been received.</i>
                  </Box>
                ))}
            </Stack.Item>
            <Stack.Item>
              {tab === 1 && stored_paper && (
                <Stack>
                  <Stack.Item>
                    <Button
                      height="100%"
                      icon="fax"
                      color={emagged ? 'bad' : 'good'}
                      content="Send to: "
                      disabled={
                        tab !== 1 ||
                        !stored_paper ||
                        !(can_send_cc_messages || emagged)
                      }
                      tooltip={
                        'Send the contents of the paper currently inserted \
                      in the machine to the destination specified. Response not guaranteed. \
                      A copy of the sent paper will print, too - for record-keeping.'
                      }
                      onClick={() =>
                        act('send_stored_paper', {
                          destination_machine: destination,
                        })
                      }
                    />
                  </Stack.Item>
                  <Stack.Item grow>
                    <Dropdown
                      width="100%"
                      height="100%"
                      selected={selectedDestination}
                      options={destination_options}
                      onSelected={(dest) => {
                        setDestination(dest);
                      }}
                    />
                  </Stack.Item>
                </Stack>
              )}
              {tab === 2 && received_paper && (
                <Stack>
                  <Stack.Item>
                    <Button
                      disabled={!received_paper}
                      content="Print received Fax"
                      tooltip="Print the last received fax."
                      onClick={() => act('print_received_paper')}
                    />
                  </Stack.Item>
                </Stack>
              )}
            </Stack.Item>
          </Stack>
        </Section>
        <Section
          title="Paperwork"
          buttons={
            <Button.Checkbox
              checked={can_receive}
              content="Toggle Incoming Paperwork"
              tooltip={
                (can_receive ? 'Disable' : 'Enable') +
                ' the ability for this fax machine \
                to receive paperwork every five minutes.'
              }
              onClick={() => act('toggle_recieving')}
            />
          }
        >
          <Stack vertical grow>
            <Stack.Item height={2}>
              {received_paperwork.length > 0 ? (
                <Tabs>
                  {received_paperwork.map((paper) => (
                    <Tabs.Tab
                      width="12.5%"
                      key={paper}
                      textAlign="center"
                      selected={paper.ref === selectedPaperTab}
                      onClick={() => setSelectedPaper(paper.ref)}
                    >
                      Paper {paper.num}
                    </Tabs.Tab>
                  ))}
                </Tabs>
              ) : (
                'No stored paperwork to process.'
              )}
            </Stack.Item>
            <Stack.Item height={8}>
              {selectedPaper ? (
                <BlockQuote fontSize="14px">
                  {selectedPaper.contents}
                </BlockQuote>
              ) : (
                received_paperwork.length > 0 && 'No paper selected.'
              )}
            </Stack.Item>
            <Divider />
            <Stack.Item height={3} mb={1}>
              {!!selectedPaper && (
                <Stack vertical align="center">
                  <Stack.Item>
                    <b>
                      To fulfill this paperwork, stamp accurately and answer the
                      following:
                    </b>
                  </Stack.Item>
                  <Stack.Item>
                    <BlockQuote>{selectedPaper.required_answer}</BlockQuote>
                  </Stack.Item>
                </Stack>
              )}
            </Stack.Item>
            <Stack.Item align="center" height={2}>
              <Stack>
                <Stack.Item>
                  <Button
                    color="good"
                    disabled={!selectedPaper}
                    content="Print Paper"
                    tooltip="Print the selected paperwork. \
                      This is how you stamp and process the paperwork."
                    onClick={() =>
                      act('print_select_paperwork', {
                        ref: selectedPaper.ref,
                      })
                    }
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    disabled={!selectedPaper || emagged}
                    content="Send Paper For Processing"
                    tooltip="Send the selected paperwork \
                      to your employer to check its \
                      validity and receive your payment."
                    onClick={() =>
                      act('check_paper', {
                        ref: selectedPaper.ref,
                      })
                    }
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    color="bad"
                    disabled={!selectedPaper}
                    content="Delete Paper"
                    tooltip="Delete the selected paperwork from the machine."
                    onClick={() =>
                      act('delete_select_paperwork', {
                        ref: selectedPaper.ref,
                      })
                    }
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    color={
                      !received_paperwork || received_paperwork.length === 0
                        ? 'good'
                        : 'caution'
                    }
                    disabled={
                      !received_paperwork || received_paperwork.length === 0
                    }
                    content="Print All Papers"
                    tooltip="Print out all the paperwork stored in the machine."
                    onClick={() => act('print_all_paperwork')}
                  />
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
