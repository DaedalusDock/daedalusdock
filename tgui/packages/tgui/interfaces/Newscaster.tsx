/**
 * @file
 * @author Original by ArcaneMusic (https://github.com/ArcaneMusic)
 * @author Changes Shadowh4nD/jlsnow301
 * @license MIT
 */

import { decodeHtmlEntities } from 'common/string';
import { marked } from 'marked';
import { BooleanLike } from 'tgui-core/react';

import { useBackend, useLocalState, useSharedState } from '../backend';
import {
  BlockQuote,
  Box,
  Button,
  Divider,
  LabeledList,
  Modal,
  Section,
  Stack,
  Tabs,
  TextArea,
} from '../components';
import { Image } from '../components/Image';
import { sanitizeText } from '../sanitize';
import { BountyBoardContent } from './BountyBoard';
import { UserDetails } from './Vending';

const CENSOR_MESSAGE =
  'The contents of this channel or message have been deemed as threatening to the welfare of the colony, and marked with a D-Notice.';

type User = {
  department: string;
  job: string;
  name: string;
};

type NewscasterData = {
  bountyText: string;
  bountyValue: number;
  channelAuthor: string | undefined;
  channelCensored: BooleanLike;
  channelDesc: string | undefined;
  channelLocked: BooleanLike;
  channelName: string | undefined;
  channels: Channel[];
  creating_channel: BooleanLike;
  creating_comment: BooleanLike;
  crime_description: string | undefined;
  criminal_name: string | undefined;
  messages: Message[];
  paper: number;
  photo_data: BooleanLike;
  security_mode: BooleanLike;
  user: User;
  viewing_channel: number | undefined;
  viewing_wanted: BooleanLike;
  wanted: WantedInfo[];
};

type Channel = {
  ID: number;
  author: string;
  censored: BooleanLike;
  locked: BooleanLike;
  name: string;
};

type Comment = {
  auth: string;
  body: string;
  time: string;
};

type Message = {
  ID: number;
  auth: string;
  body: string;
  censored_author: BooleanLike;
  censored_message: BooleanLike;
  channel_num: number;
  comments: Comment[];
  photo: string;
  time: string;
};

type WantedInfo = {
  active: BooleanLike;
  author: string;
  crime: string;
  criminal: string;
  id: number;
  image: string;
};

export const Newscaster = (props) => {
  const { act, data } = useBackend<NewscasterData>();
  const NEWSCASTER_SCREEN = 1;
  const BOUNTYBOARD_SCREEN = 2;
  const [screenmode, setScreenmode] = useSharedState(
    'tab_main',
    NEWSCASTER_SCREEN,
  );
  return (
    <>
      <NewscasterChannelCreation />
      <NewscasterCommentCreation />
      <Stack fill vertical>
        <NewscasterWantedScreen />
        <Stack.Item>
          <Tabs fluid textAlign="center">
            <Tabs.Tab
              color="Green"
              selected={screenmode === NEWSCASTER_SCREEN}
              onClick={() => setScreenmode(NEWSCASTER_SCREEN)}
            >
              Newscaster
            </Tabs.Tab>
            <Tabs.Tab
              Color="Blue"
              selected={screenmode === BOUNTYBOARD_SCREEN}
              onClick={() => setScreenmode(BOUNTYBOARD_SCREEN)}
            >
              Bounty Board
            </Tabs.Tab>
          </Tabs>
        </Stack.Item>
        <Stack.Item grow>
          {screenmode === NEWSCASTER_SCREEN && <NewscasterContent />}
          {screenmode === BOUNTYBOARD_SCREEN && <BountyBoardContent />}
        </Stack.Item>
      </Stack>
    </>
  );
};

/** The modal menu that contains the prompts to making new channels. */
const NewscasterChannelCreation = (props) => {
  const { act, data } = useBackend<NewscasterData>();
  const [lockedmode, setLockedmode] = useLocalState('lockedmode', 1);
  const { creating_channel } = data;
  if (!creating_channel) {
    return null;
  }
  return (
    <Modal textAlign="center" mr={1.5}>
      <Stack vertical>
        <>
          <Stack.Item>
            <Box pb={1}>
              Enter channel name here:
              <Button
                content="X"
                color="red"
                position="relative"
                top="20%"
                left="15%"
                onClick={() => act('cancelCreation')}
              />
            </Box>
            <TextArea
              fluid
              height="40px"
              width="240px"
              backgroundColor="black"
              textColor="white"
              maxLength={42}
              onChange={(e, name) =>
                act('setChannelName', {
                  channeltext: name,
                })
              }
            >
              Channel Name
            </TextArea>
          </Stack.Item>
          <Stack.Item>
            <Box pb={1}>Enter channel description here:</Box>
            <TextArea
              fluid
              height="150px"
              width="240px"
              backgroundColor="black"
              textColor="white"
              maxLength={512}
              onChange={(e, desc) =>
                act('setChannelDesc', {
                  channeldesc: desc,
                })
              }
            >
              Channel Description
            </TextArea>
          </Stack.Item>
          <Stack.Item>
            <Section>
              Set Channel as Public or Private
              <Box pt={1}>
                <Button
                  selected={!lockedmode}
                  content="Public"
                  onClick={() => setLockedmode(0)}
                />
                <Button
                  selected={!!lockedmode}
                  content="Private"
                  onClick={() => setLockedmode(1)}
                />
              </Box>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Box>
              <Button
                content="Submit Channel"
                onClick={() =>
                  act('createChannel', {
                    lockedmode: lockedmode,
                  })
                }
              />
            </Box>
          </Stack.Item>
        </>
      </Stack>
    </Modal>
  );
};

/** The modal menu that contains the prompts to making new comments. */
const NewscasterCommentCreation = (props) => {
  const { act, data } = useBackend<NewscasterData>();
  const { creating_comment } = data;
  if (!creating_comment) {
    return null;
  }
  return (
    <Modal textAlign="center" mr={1.5}>
      <Stack vertical>
        <Stack.Item>
          <Box pb={1}>
            Enter comment:
            <Button
              content="X"
              color="red"
              position="relative"
              top="20%"
              left="25%"
              onClick={() => act('cancelCreation')}
            />
          </Box>
          <TextArea
            fluid
            height="120px"
            width="240px"
            backgroundColor="black"
            textColor="white"
            maxLength={512}
            onChange={(e, comment) =>
              act('setCommentBody', {
                commenttext: comment,
              })
            }
          >
            Channel Name
          </TextArea>
        </Stack.Item>
        <Stack.Item>
          <Box>
            <Button
              content={'Submit Comment'}
              onClick={() => act('createComment', {})}
            />
          </Box>
        </Stack.Item>
      </Stack>
    </Modal>
  );
};

const NewscasterWantedScreen = (props) => {
  const { act, data } = useBackend<NewscasterData>();
  const {
    viewing_wanted,
    photo_data,
    security_mode,
    wanted = [],
    criminal_name,
    crime_description,
  } = data;
  if (!viewing_wanted) {
    return null;
  }
  return (
    <Modal textAlign="center" mr={1.5} width={25}>
      {wanted.map((activeWanted) => (
        <>
          <Stack vertical>
            <Stack.Item>
              <Box bold color="red">
                {activeWanted.active
                  ? 'Active Wanted Issue:'
                  : 'Dismissed Wanted Issue:'}
                <Button
                  content="X"
                  color="red"
                  position="relative"
                  top="20%"
                  left="18%"
                  onClick={() => act('cancelCreation')}
                />
              </Box>
              <Section>
                <Box bold>{activeWanted.criminal}</Box>
                <Box italic>{activeWanted.crime}</Box>
              </Section>
              <Image src={activeWanted?.image} />
              <Box italic>
                Posted by {activeWanted.author ? activeWanted.author : 'N/A'}
              </Box>
            </Stack.Item>
          </Stack>
          <Divider />
        </>
      ))}
      {security_mode ? (
        <>
          <LabeledList>
            <LabeledList.Item label="Criminal Name">
              <Button
                content={criminal_name ? criminal_name : ' N/A'}
                disabled={!security_mode}
                icon="pen"
                onClick={() => act('setCriminalName')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Criminal Activity">
              <Button
                content={crime_description ? crime_description : ' N/A'}
                nowrap={false}
                disabled={!security_mode}
                icon="pen"
                onClick={() => act('setCrimeData')}
              />
            </LabeledList.Item>
          </LabeledList>
          <Section>
            <Button
              icon="camera"
              selected={photo_data}
              disabled={!security_mode}
              content={photo_data ? 'Remove photo' : 'Attach photo'}
              onClick={() => act('togglePhoto')}
            />
            <Button
              content={'Set Wanted Issue'}
              disabled={!security_mode}
              icon="volume-up"
              onClick={() => act('submitWantedIssue')}
            />
            <Button
              content={'Clear Wanted'}
              disabled={!security_mode}
              icon="times"
              color="red"
              onClick={() => act('clearWantedIssue')}
            />
          </Section>
        </>
      ) : (
        <Box>
          {wanted.length
            ? 'Please contact your local security officer if spotted.'
            : 'No wanted issue posted. Have a secure day.'}
        </Box>
      )}
    </Modal>
  );
};

const NewscasterContent = (props) => {
  const { act, data } = useBackend<NewscasterData>();
  const { channelAuthor, channelName, channelDesc } = data;
  return (
    <Stack fill vertical>
      <Stack.Item grow>
        <Stack fill>
          <Stack.Item grow>
            <NewscasterChannelSelector />
          </Stack.Item>
          <Stack.Item grow={2}>
            <Stack fill vertical>
              <Stack.Item>
                <UserDetails />
              </Stack.Item>
              <Stack.Item>
                <NewscasterChannelBox
                  channelName={channelName}
                  channelOwner={channelAuthor}
                  channelDesc={channelDesc}
                />
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item grow>
        <NewscasterChannelMessages />
      </Stack.Item>
    </Stack>
  );
};

/** The Channel Box is the basic channel information where buttons live.*/
const NewscasterChannelBox = (_) => {
  const { act, data } = useBackend<NewscasterData>();
  const {
    channelName,
    channelDesc,
    channelLocked,
    channelAuthor,
    channelCensored,
    viewing_channel,
    security_mode,
    photo_data,
    paper,
    user,
  } = data;
  return (
    <Section fill title={channelName}>
      <Stack fill vertical>
        <Stack.Item>
          {channelCensored ? (
            <Section>
              <BlockQuote color="red">
                <b>ATTENTION:</b> {CENSOR_MESSAGE}
              </BlockQuote>
            </Section>
          ) : (
            <Section fill scrollable height="8rem">
              <Box italic fontSize={1.2}>
                {decodeHtmlEntities(channelDesc || '')}
              </Box>
            </Section>
          )}
        </Stack.Item>
        <Stack.Item>
          <Box>
            <Button
              icon="print"
              content="Submit Story"
              disabled={
                (channelLocked && channelAuthor !== user.name) ||
                channelCensored
              }
              onClick={() => act('createStory', { current: viewing_channel })}
              mt={1}
            />
            <Button
              icon="camera"
              selected={photo_data}
              content="Select Photo"
              disabled={
                (channelLocked && channelAuthor !== user.name) ||
                channelCensored
              }
              onClick={() => act('togglePhoto')}
            />
            {!!security_mode && (
              <Button
                icon="ban"
                content={'D-Notice'}
                tooltip="Censor the whole channel and it's contents as dangerous to the station."
                disabled={!security_mode || !viewing_channel}
                selected={!!channelCensored}
                onClick={() =>
                  act('channelDNotice', {
                    secure: security_mode,
                    channel: viewing_channel,
                  })
                }
              />
            )}
          </Box>
          <Box>
            <Button
              icon="newspaper"
              content="Print Newspaper"
              disabled={paper <= 0}
              onClick={() => act('printNewspaper')}
            />
          </Box>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

/** Channel select is the left-hand menu where all the channels are listed. */
const NewscasterChannelSelector = (props) => {
  const { act, data } = useBackend<NewscasterData>();
  const { channels = [], viewing_channel, security_mode, wanted = [] } = data;
  return (
    <Section height="100%" width={window.innerWidth - 410 + 'px'}>
      <Tabs vertical>
        {wanted.map((activeWanted, i) => (
          <Tabs.Tab
            pt={0.75}
            pb={0.75}
            mr={1}
            key={i}
            icon={activeWanted.active ? 'skull-crossbones' : null}
            textColor={activeWanted.active ? 'red' : 'grey'}
            onClick={() => act('toggleWanted')}
          >
            Wanted: {activeWanted.criminal}
          </Tabs.Tab>
        ))}
        {channels.map((channel, i) => (
          <Tabs.Tab
            key={i}
            pt={0.75}
            pb={0.75}
            mr={1}
            selected={viewing_channel === channel.ID}
            icon={channel.censored ? 'ban' : null}
            textColor={channel.censored ? 'red' : 'black'}
            onClick={() =>
              act('setChannel', {
                channel: channel.ID,
              })
            }
          >
            {channel.name}
          </Tabs.Tab>
        ))}
        <Tabs.Tab
          pt={0.75}
          pb={0.75}
          mr={1}
          textColor="black"
          color="Green"
          onClick={() => act('startCreateChannel')}
        >
          Create Channel [+]
        </Tabs.Tab>
      </Tabs>
    </Section>
  );
};

const processedText = (value) => {
  const textHtml = {
    __html: sanitizeText(
      marked(value, {
        breaks: true,
        smartypants: true,
        smartLists: true,
        baseUrl: 'thisshouldbreakhttp',
      }),
    ),
  };
  return textHtml;
};

/** This is where the channels comments get spangled out (tm) */
const NewscasterChannelMessages = (_) => {
  const { act, data } = useBackend<NewscasterData>();
  const {
    messages = [],
    viewing_channel,
    security_mode,
    channelCensored,
    channelLocked,
    channelAuthor,
    user,
  } = data;
  if (channelCensored) {
    return (
      <Section color="red">
        <b>ATTENTION:</b> Comments cannot be read at this time.
        <br />
        Thank you for your understanding, and have a secure day.
      </Section>
    );
  }
  const visibleMessages = messages.filter(
    (message) => message.ID !== viewing_channel,
  );
  return (
    <Section>
      {visibleMessages.map((message) => {
        return (
          <Section
            key={message.ID}
            textColor="white"
            title={
              <i>
                {message.censored_author ? (
                  <Box textColor="red">
                    By: [REDACTED]. <b>D-Notice</b>.
                  </Box>
                ) : (
                  <>
                    By: {message.auth} at {message.time}
                  </>
                )}
              </i>
            }
            buttons={
              <>
                {!!security_mode && (
                  <Button
                    icon="comment-slash"
                    tooltip="Censor Story"
                    disabled={!security_mode}
                    selected={!!message.censored_message}
                    onClick={() =>
                      act('storyCensor', {
                        messageID: message.ID,
                      })
                    }
                  />
                )}
                {!!security_mode && (
                  <Button
                    icon="user-slash"
                    tooltip="Censor Author"
                    disabled={!security_mode}
                    selected={!!message.censored_author}
                    onClick={() =>
                      act('authorCensor', {
                        messageID: message.ID,
                      })
                    }
                  />
                )}
                <Button
                  icon="comment"
                  tooltip="Leave a Comment."
                  disabled={
                    message.censored_author ||
                    message.censored_message ||
                    user.name === 'Unknown' ||
                    (!!channelLocked && channelAuthor !== user.name)
                  }
                  onClick={() =>
                    act('startComment', {
                      messageID: message.ID,
                    })
                  }
                />
              </>
            }
          >
            <BlockQuote>
              {message.censored_message ? (
                <Section textColor="red">{CENSOR_MESSAGE}</Section>
              ) : (
                <Section pl={1}>
                  <Box dangerouslySetInnerHTML={processedText(message.body)} />
                </Section>
              )}
              {message.photo !== null && !message.censored_message && (
                <Image src={message.photo} />
              )}
              {!!message.comments && (
                <Box>
                  {message.comments.map((comment, i) => (
                    <BlockQuote key={i}>
                      <Box italic textColor="white">
                        By: {comment.auth} at {comment.time}
                      </Box>
                      <Section ml={2.5}>
                        <Box
                          dangerouslySetInnerHTML={processedText(comment.body)}
                        />
                      </Section>
                    </BlockQuote>
                  ))}
                </Box>
              )}
            </BlockQuote>
            <Divider />
          </Section>
        );
      })}
    </Section>
  );
};
