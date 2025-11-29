import { capitalize } from 'common/string';
import { SetStateAction, useState } from 'react';
import { Box, Section, Stack, Tabs } from 'tgui-core/components';
import { BooleanLike, classes } from 'tgui-core/react';

import { useBackend, useLocalState } from '../backend';
import { ByondUi, Flex, Modal } from '../components';
import { Window } from '../layouts';

type CharacterStatsData = {
  bodyparts: Bodypart[];
  byondui_map: string;
  default_skill_value: number;
  mob: Mob;
  mob_statuses: Record<string, number>;
  skills: Skill[];
  stats: Record<string, Stat>;
};

type Mob = {
  name: string;
};

type Bodypart = {
  missing: BooleanLike;
  name: string;
  statuses: Record<string, number>;
};

type Skill = {
  class: string;
  desc: string;
  modifiers: SkillModifier[];
  name: string;
  parent_stat_name: string;
  sort_order: number;
  value: number;
};

type Stat = {
  class: string;
  desc: string;
  modifiers: SkillModifier[];
  name: string;
  sort_order: number;
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
      pageContent = BodyPage();
      break;
    case Page.Stats:
      pageContent = StatsPage();
      break;
  }

  return (
    <Window
      width={700}
      height={750}
      theme={currentPage === Page.Body ? 'book' : ''}
    >
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
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
          </Stack.Item>
          <Stack.Item grow>
            <Section fill fitted>
              {pageContent}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

function BodyPage() {
  const { data } = useBackend<CharacterStatsData>();
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
          <Flex.Item className="CharacterStats__nameHeader">
            {data.mob.name}
          </Flex.Item>
          <Flex.Item grow={1}>
            <ByondUi
              height="300px"
              width="200px"
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

function generalHealthEntry(mob_statuses: Record<string, number>) {
  return (
    <Flex.Item
      width="100%"
      grow={0}
      shrink={0}
      basis="33%"
      style={{ padding: '0.5em', alignSelf: 'flex-end' }}
    >
      <Flex direction="column" className="CharacterStats__healthBlock">
        <Flex.Item className="CharacterStats__healthBlock_header">
          General
        </Flex.Item>
        <Flex.Item className="CharacterStats__healthBlock_body" height="100%">
          <Flex height="100%" direction="column">
            {Object.entries(mob_statuses)
              .sort(
                ([status_a, severity_a], [status_b, severity_b]) =>
                  severity_b - severity_a,
              )
              .map(([status, severity], i) => (
                <Flex.Item
                  key={i}
                  color={severityColor(severity)}
                  className="CharacterStats__healthBlock_entry"
                >
                  • {capitalize(status)}
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
      <Flex direction="column" className="CharacterStats__healthBlock">
        <Flex.Item className="CharacterStats__healthBlock_header">
          {bodypart.name}
        </Flex.Item>
        <Flex.Item
          className={classes([
            'CharacterStats__healthBlock_body',
            bodypart.missing && 'missing',
          ])}
          grow={1}
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
            <Flex height="100%" direction="column">
              {Object.entries(bodypart.statuses)
                .sort(
                  ([status_a, severity_a], [status_b, severity_b]) =>
                    severity_b - severity_a,
                )
                .map(([status, severity], i) => (
                  <Flex.Item
                    key={i}
                    color={severityColor(severity)}
                    className="CharacterStats__healthBlock_entry"
                  >
                    • {capitalize(status)}
                  </Flex.Item>
                ))}
            </Flex>
          )}
        </Flex.Item>
      </Flex>
    </Flex.Item>
  );
}

type ModalState = undefined | Skill | Stat;

function StatsPage() {
  const [seeingModalOf, setModal] = useState<ModalState>(undefined);
  const { data } = useBackend<CharacterStatsData>();
  return (
    <Box height="100%" width="100%" className="CharacterStats__statsPage">
      {DetailedStatOrSkillModal(seeingModalOf, setModal)}
      <Flex
        direction="row"
        height="660px"
        width="100%"
        justify="flex-start"
        align="flex-start"
      >
        {Object.values(data.stats)
          .sort((a, b) => a.sort_order - b.sort_order)
          .map((stat) => StatRow(stat, seeingModalOf, setModal))}
      </Flex>
    </Box>
  );
}

function StatRow(relevantStat: Stat, seeingModalOf, setModal) {
  const { data } = useBackend<CharacterStatsData>();
  const relevantSkills = data.skills.filter(
    (skill) => skill.parent_stat_name === relevantStat.name,
  );

  const dummySkills = 3 - relevantSkills.length;
  return (
    <Flex
      className={classes(['CharacterStats__statColumn', relevantStat.class])}
      direction="column"
      width="100%"
      justify="flex-start"
      align="center"
      height="100%"
    >
      {StatEntry(relevantStat, seeingModalOf, setModal)}
      {relevantSkills.map((skill) =>
        SkillEntry(skill, seeingModalOf, setModal),
      )}
      {fillWithDummies(dummySkills, relevantStat.class)}
    </Flex>
  );
}

function fillWithDummies(amount: number, skillClass) {
  const fragments: JSX.Element[] = [];
  for (let i = 0; i < amount; i++) {
    fragments.push(
      <Flex.Item
        key={i}
        className={classes(['CharacterStats__skillBlock', 'dummy', skillClass])}
      />,
    );
  }
  return fragments;
}

function SkillEntry(skill: Skill, seeingModalOf, setModal, dummy?: boolean) {
  const { data } = useBackend<CharacterStatsData>();
  return (
    <Flex.Item
      className={classes(['CharacterStats__skillBlock', skill.class])}
      onClick={() => {
        setModal(skill);
      }}
    >
      <Flex direction="column" height="100%" justify="space-between">
        <Flex
          direction="column"
          align="center"
          className="CharacterStats__skillBlock_statValue"
          color={
            skill.value === data.default_skill_value
              ? ''
              : skill.value >= data.default_skill_value
                ? '#03fca1'
                : '#fc4b32'
          }
        >
          {skill.value}
        </Flex>
        <Flex.Item>
          <Box
            textAlign="center"
            fontSize="1.5rem"
            style={{ lineHeight: '1.2' }}
          >
            {skill.name}
          </Box>
        </Flex.Item>
      </Flex>
    </Flex.Item>
  );
}

function StatEntry(stat: Stat, seeingModalOf, setModal) {
  const { data } = useBackend<CharacterStatsData>();
  return (
    <Flex.Item
      className={classes(['CharacterStats__statBlock', stat.class])}
      onClick={() => {
        setModal(stat);
      }}
    >
      <Flex direction="column" height="100%" justify="space-between">
        <Flex
          direction="column"
          align="center"
          justify="center"
          className="CharacterStats__statBlock_statValue"
          color={
            stat.value === data.default_skill_value
              ? ''
              : stat.value >= data.default_skill_value
                ? '#03fca1'
                : '#fc4b32'
          }
        >
          {stat.value}
        </Flex>
        <Flex.Item>
          <hr
            className={stat.class}
            style={{ width: '50%', borderWidth: '1px', borderStyle: 'solid' }}
          />
          <Box
            textAlign="center"
            fontSize="2.2rem"
            fontFamily="Libre Baskerville"
          >
            {stat.name}
          </Box>
        </Flex.Item>
      </Flex>
    </Flex.Item>
  );
}

function DetailedStatOrSkillModal(
  seeingModalOf: ModalState,
  setModal: {
    (value: SetStateAction<ModalState>): void;
    (arg0: undefined): void;
  },
) {
  const { data } = useBackend<CharacterStatsData>();
  console.log(seeingModalOf);
  return (
    !!seeingModalOf && (
      <Modal
        width="30rem"
        height="50rem"
        onClick={() => setModal(undefined)}
        onDimmerClick={() => setModal(undefined)}
        className={classes([
          'CharacterStats__statCard__modal',
          seeingModalOf.class,
        ])}
        position="relative"
      >
        <Box
          className={classes(['square', 'top', 'left', seeingModalOf.class])}
        />
        <Box
          className={classes(['square', 'top', 'right', seeingModalOf.class])}
        />
        <Box
          className={classes(['square', 'bottom', 'left', seeingModalOf.class])}
        />
        <Box
          className={classes([
            'square',
            'bottom',
            'right',
            seeingModalOf.class,
          ])}
        />
        <Flex
          width="100%"
          height="100%"
          justify="center"
          className="CharacterStats__statCard"
        >
          <Flex direction="column" height="100%" width="100%">
            <Flex.Item>
              <Box className="CharacterStats__statCard__statName">
                {seeingModalOf.name}
              </Box>
              <Box textAlign="center" fontSize="1.5rem" italic>
                <i>{seeingModalOf.desc}</i>
              </Box>
            </Flex.Item>
            <Flex
              direction="column"
              justify="center"
              align="center"
              className="CharacterStats__statCard__statValue"
              color={
                seeingModalOf.value === data.default_skill_value
                  ? ''
                  : seeingModalOf.value >= data.default_skill_value
                    ? '#03fca1'
                    : '#fc4b32'
              }
            >
              {seeingModalOf.value}
            </Flex>
            <hr
              className={seeingModalOf.class}
              style={{
                width: '60%',
                marginBottom: '30px',
                borderWidth: '1px',
                borderStyle: 'solid',
              }}
            />
            <Flex.Item grow={1} basis={0} shrink={1}>
              <Section scrollable fill style={{ border: '2px solid grey' }}>
                {seeingModalOf.modifiers
                  .sort((a, b) => b.value - a.value)
                  .map((modifier, i) => (
                    <Flex
                      direction="row"
                      key={i}
                      justify="center"
                      align="center"
                    >
                      <Flex.Item
                        width="15%"
                        fontSize="2rem"
                        mr="1rem"
                        textAlign="left"
                        color={modifier.value > 0 ? '#03fca1' : '#fc4b32'}
                      >
                        {modifier.value > 0 ? (
                          <>
                            <span
                              style={{
                                fontSize: '2rem',
                                position: 'relative',
                                bottom: '2px',
                              }}
                            >
                              +
                            </span>
                            <span>{modifier.value}</span>
                          </>
                        ) : (
                          <>
                            <span style={{ fontSize: '2rem' }}>-</span>
                            <span>{modifier.value}</span>
                          </>
                        )}
                      </Flex.Item>
                      <Flex.Item
                        inline
                        width="70%"
                        fontSize="2rem"
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
        </Flex>
      </Modal>
    )
  );
}
function severityColor(severity: number): string {
  switch (severity) {
    case 1:
      return '#7D3C3C';
    case 2:
      return '#df3e3e';
    default:
      return '';
  }
}
