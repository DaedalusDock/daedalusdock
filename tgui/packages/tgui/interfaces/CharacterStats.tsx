import { capitalize } from 'common/string';
import { Box, Section, Stack, Tabs } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

import { useBackend, useLocalState } from '../backend';
import { ByondUi, Flex } from '../components';
import { Window } from '../layouts';

type CharacterStatsData = {
  bodyparts: Bodypart[];
  byondui_map: string;
  default_skill_value: number;
  mob: Mob;
  mob_statuses: Record<string, string>;
  skills: Skill[];
};

type Mob = {
  name: string;
};

type Bodypart = {
  missing: BooleanLike;
  name: string;
  statuses: Record<string, string>;
};

type Skill = {
  desc: string;
  modifiers: SkillModifier[];
  name: string;
  value: number;
};

type SkillModifier = {
  source: string;
  value: number;
};

enum Page {
  Body,
  Stats,
}

export const CharacterStats = (props) => {
  const { act, data } = useBackend<CharacterStatsData>();
  const [currentPage, setCurrentPage] = useLocalState('currentPage', Page.Body);

  let pageContent;

  switch (currentPage) {
    case Page.Body:
      pageContent = BodyPage(data);
      break;
    case Page.Stats:
      pageContent = StatsPage(data);
      break;
  }

  return (
    <Window width={1200} height={800}>
      <Window.Content>
        <Tabs fluid>
          <Tabs.Tab
            selected={currentPage === Page.Body}
            onClick={() => setCurrentPage(Page.Body)}
            textAlign="center"
            fontSize="1.4rem"
          >
            Body
          </Tabs.Tab>
          <Tabs.Tab
            selected={currentPage === Page.Stats}
            onClick={() => setCurrentPage(Page.Stats)}
            textAlign="center"
            fontSize="1.4rem"
          >
            Stats
          </Tabs.Tab>
        </Tabs>
        <Section fill height="94%">
          {pageContent}
        </Section>
      </Window.Content>
    </Window>
  );
};

function BodyPage(data: CharacterStatsData) {
  return (
    <Flex direction="row" justify="center" height="100%">
      <Flex.Item grow={1}>
        <Flex direction="column" width="100%" height="100%">
          {data.bodyparts
            .slice(0, 3)
            .map((bodypart) => bodypartHealthEntry(bodypart))}
        </Flex>
      </Flex.Item>
      <Flex.Item grow={1}>
        <Flex direction="column" align="center" height="100%">
          <Flex.Item fontSize="3rem" style={{ marginBottom: '1.7rem' }}>
            {data.mob.name}
          </Flex.Item>
          <Flex.Item>
            <ByondUi
              height="400px"
              width="300px"
              params={{ id: data.byondui_map, type: 'map' }}
            />
          </Flex.Item>
          {generalHealthEntry(data.mob_statuses)}
        </Flex>
      </Flex.Item>
      <Flex.Item grow={1}>
        <Flex direction="column" width="100%" height="100%">
          {data.bodyparts
            .slice(3)
            .map((bodypart) => bodypartHealthEntry(bodypart))}
        </Flex>
      </Flex.Item>
    </Flex>
  );
}

function generalHealthEntry(mob_statuses: Record<string, string>) {
  return (
    <Flex.Item width="100%" grow={1} style={{ padding: '0.5em' }}>
      <Flex direction="column" height="100%">
        <Flex.Item
          fontSize="2rem"
          color="black"
          backgroundColor="#03fca1"
          style={{
            clipPath:
              'polygon(0 0, calc(100% - 20px + 2px) 0, 100% calc(20px - 2px), 100% 100%, 0 100%)',
            padding: '0.5rem',
          }}
        >
          General
        </Flex.Item>
        <Flex.Item
          grow={1}
          style={{ border: '4px solid #03fca1', padding: '0.5rem' }}
        >
          <Flex height="100%" direction="column" flexWrap>
            {Object.entries(mob_statuses).map(([status, color], i) => (
              <Flex.Item
                key={i}
                color={color}
                fontSize={'2rem'}
                style={{ width: '50%' }}
              >
                {capitalize(status)}
              </Flex.Item>
            ))}
          </Flex>
        </Flex.Item>
      </Flex>
    </Flex.Item>
  );
}
function bodypartHealthEntry(bodypart: Bodypart) {
  return (
    <Flex.Item grow={1} style={{ padding: '0.5em' }}>
      <Flex direction="column" height="100%">
        <Flex.Item
          fontSize="2rem"
          color="black"
          backgroundColor="#03fca1"
          style={{
            clipPath:
              'polygon(0 0, calc(100% - 20px + 2px) 0, 100% calc(20px - 2px), 100% 100%, 0 100%)',
            padding: '0.5rem',
          }}
        >
          {bodypart.name}
        </Flex.Item>
        <Flex.Item
          grow={1}
          style={{ border: '4px solid #03fca1', padding: '0.5rem' }}
        >
          {bodypart.missing ? (
            <Flex
              width="100%"
              color="#fc4b32"
              height="100%"
              justify="center"
              align="center"
              fontSize="3rem"
            >
              MISSING
            </Flex>
          ) : (
            <Flex height="100%" direction="column" flexWrap>
              {Object.entries(bodypart.statuses).map(([status, color], i) => (
                <Flex.Item
                  key={i}
                  color={color}
                  fontSize={'2rem'}
                  style={{ width: '50%' }}
                >
                  {capitalize(status)}
                </Flex.Item>
              ))}
            </Flex>
          )}
        </Flex.Item>
      </Flex>
    </Flex.Item>
  );
}
function StatsPage(data: CharacterStatsData) {
  return (
    <Stack direction="row" wrap height="100%" justify="center" align="center">
      {data.skills.map((skill, i) => (
        <Stack.Item
          key={i}
          width="23%"
          height="49%"
          style={{
            border: '2px solid #03fca1',
            marginBottom: '1em',
            padding: '1em',
          }}
        >
          <Flex direction="column" height="100%">
            <Flex.Item height="25%">
              <Box textAlign="center" fontSize="2rem">
                {skill.name}
              </Box>
              <Box textAlign="center">
                <i>{skill.desc}</i>
              </Box>
            </Flex.Item>
            <Flex.Item
              textAlign="center"
              fontSize="4rem"
              style={{ marginTop: '0.5rem' }}
              color={
                skill.value === data.default_skill_value
                  ? ''
                  : skill.value >= data.default_skill_value
                    ? '#03fca1'
                    : '#fc4b32'
              }
            >
              {skill.value}
            </Flex.Item>
            <Flex.Item grow={1} basis={0} style={{ flexShrink: '1' }}>
              <Section scrollable fill>
                {skill.modifiers.map((modifier, i) => (
                  <Flex direction="row" key={i} justify="center" align="center">
                    <Flex.Item
                      width="15%"
                      fontSize="2rem"
                      mr="1rem"
                      textAlign="left"
                      color={modifier.value > 0 ? '#03fca1' : '#fc4b32'}
                    >
                      {modifier.value}
                    </Flex.Item>
                    <Flex.Item
                      inline
                      width="70%"
                      fontSize="1.5rem"
                      textAlign="right"
                      color={modifier.value > 0 ? '#03fca1' : '#fc4b32'}
                    >
                      {modifier.source}
                    </Flex.Item>
                  </Flex>
                ))}
              </Section>
            </Flex.Item>
          </Flex>
        </Stack.Item>
      ))}
    </Stack>
  );
}
