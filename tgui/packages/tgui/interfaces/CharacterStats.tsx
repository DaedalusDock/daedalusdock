import { capitalize } from 'common/string';
import { SetStateAction, useState } from 'react';
import { Box, Section, Tabs } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

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
  color: string;
  desc: string;
  modifiers: SkillModifier[];
  name: string;
  parent_stat_name: string;
  value: number;
};

type Stat = {
  color: string;
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
      pageContent = BodyPage();
      break;
    case Page.Stats:
      pageContent = StatsPage();
      break;
  }

  return (
    <Window
      width={1200}
      height={800}
      theme={currentPage === Page.Body ? 'book' : ''}
    >
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

function generalHealthEntry(mob_statuses: Record<string, number>) {
  return (
    <Flex.Item width="100%" grow={1} style={{ padding: '0.5em' }}>
      <Flex direction="column" className="CharacterStats__healthBlock">
        <Flex.Item className="CharacterStats__healthBlock_header">
          General
        </Flex.Item>
        <Flex.Item grow={1} className="CharacterStats__healthBlock_body">
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
        <Flex.Item className="CharacterStats__healthBlock_body" grow={1}>
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
        direction="column"
        height="100%"
        width="100%"
        justify="flex-start"
        align="flex-start"
      >
        {Object.values(data.stats).map((stat) =>
          StatRow(stat, seeingModalOf, setModal),
        )}
      </Flex>
    </Box>
  );
}

function StatRow(relevantStat: Stat, seeingModalOf, setModal) {
  const { data } = useBackend<CharacterStatsData>();
  const relevantSkills = data.skills.filter(
    (skill) => skill.parent_stat_name === relevantStat.name,
  );
  return (
    <Flex.Item className="CharacterStats__statRow">
      <Flex direction="row" width="100%" justify="flex-start" height="100%">
        {StatEntry(relevantStat, seeingModalOf, setModal)}
        {relevantSkills.map((skill) =>
          SkillEntry(skill, seeingModalOf, setModal),
        )}
      </Flex>
    </Flex.Item>
  );
}

function SkillEntry(skill: Skill, seeingModalOf, setModal) {
  const { data } = useBackend<CharacterStatsData>();
  return (
    <Flex.Item
      className="CharacterStats__statBlock"
      onClick={() => {
        setModal(skill);
      }}
      style={{ borderColor: skill.color }}
    >
      <Flex direction="column" height="100%" justify="space-between">
        <Flex.Item
          textAlign="center"
          fontSize="3rem"
          height="60%"
          color={
            skill.value === data.default_skill_value
              ? ''
              : skill.value >= data.default_skill_value
                ? '#03fca1'
                : '#fc4b32'
          }
          style={{ verticalAlign: 'middle' }}
        >
          {skill.value}
        </Flex.Item>
        <Flex.Item>
          <Box textAlign="center" fontSize="2rem" style={{ lineHeight: '1.2' }}>
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
      className="CharacterStats__statBlock"
      onClick={() => {
        setModal(stat);
      }}
      style={{ borderColor: stat.color }}
    >
      <Flex direction="column" height="100%" justify="space-between">
        <Flex.Item
          textAlign="center"
          fontSize="4rem"
          height="40%"
          color={
            stat.value === data.default_skill_value
              ? ''
              : stat.value >= data.default_skill_value
                ? '#03fca1'
                : '#fc4b32'
          }
          style={{ verticalAlign: 'middle' }}
        >
          {stat.value}
        </Flex.Item>
        <hr style={{ width: '50%', border: `1px solid ${stat.color}` }} />
        <Flex.Item>
          <Box
            textAlign="center"
            fontSize="3rem"
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
        style={{
          border: `2px solid ${seeingModalOf.color}`,
          boxSizing: 'border-box',
        }}
      >
        <Flex
          width="100%"
          height="100%"
          justify="center"
          className="CharacterStats__statCard"
        >
          <Flex direction="column" height="100%" width="100%">
            <Flex.Item>
              <Box className="CharacterStats__statCard__header">
                {seeingModalOf.name}
              </Box>
              <Box textAlign="center" fontSize="1.5rem" italic>
                <i>{seeingModalOf.desc}</i>
              </Box>
            </Flex.Item>
            <Flex.Item
              textAlign="center"
              fontSize="7rem"
              mt="3rem"
              color={
                seeingModalOf.value === data.default_skill_value
                  ? ''
                  : seeingModalOf.value >= data.default_skill_value
                    ? '#03fca1'
                    : '#fc4b32'
              }
              style={{ lineHeight: '1' }}
            >
              {seeingModalOf.value}
            </Flex.Item>
            <hr
              style={{
                width: '60%',
                marginBottom: '30px',
                border: `1px solid ${seeingModalOf.color}`,
              }}
            />
            <Flex.Item grow={1} basis={0} shrink={1}>
              <Section scrollable fill style={{ border: '2px solid grey' }}>
                {seeingModalOf.modifiers.map((modifier, i) => (
                  <Flex direction="row" key={i} justify="center" align="center">
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
