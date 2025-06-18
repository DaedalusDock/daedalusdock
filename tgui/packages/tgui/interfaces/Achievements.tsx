import { BooleanLike } from 'common/react';

import { useBackend, useLocalState } from '../backend';
import { Box, Table, Tabs } from '../components';
import { Window } from '../layouts';

type AchievementDatum = {
  category: string;
  desc: string;
  hidden: BooleanLike;
  icon_class: string;
  name: string;
  score: BooleanLike;
  value: number;
};

type AchievementData = {
  achievements: AchievementDatum[];
  categories: string[];
  undiscovered_icon_class: string;
  user_ckey: string;
};

export const Achievements = (props) => {
  const { data } = useBackend<AchievementData>();
  const { categories } = data;
  const [selectedCategory, setSelectedCategory] = useLocalState(
    'category',
    categories[0],
  );
  const achievements = data.achievements.filter(
    (x) => x.category === selectedCategory,
  );
  return (
    <Window title="Achievements" width={540} height={680}>
      <Window.Content scrollable>
        <Tabs>
          {categories.map((category) => (
            <Tabs.Tab
              key={category}
              selected={selectedCategory === category}
              onClick={() => setSelectedCategory(category)}
            >
              {category}
            </Tabs.Tab>
          ))}
        </Tabs>
        <AchievementTable achievements={achievements} />
      </Window.Content>
    </Window>
  );
};

type AchievementTableProps = {
  achievements: AchievementDatum[];
};
const AchievementTable = (props: AchievementTableProps) => {
  const { achievements } = props;
  const { data } = useBackend<AchievementData>();
  const { undiscovered_icon_class } = data;
  return (
    <Table>
      {achievements
        .sort((a, b) => a.name.localeCompare(b.name))
        .map((achievement) => {
          if (!achievement.hidden || !!achievement.value) {
            return (
              <Achievement key={achievement.name} achievement={achievement} />
            );
          } else {
            const placeholder_achievement: AchievementDatum = {
              category: achievement.category,
              desc: 'Hidden',
              hidden: false,
              icon_class: undiscovered_icon_class,
              name: achievement.name,
              score: false,
              value: 0,
            };
            return (
              <Achievement
                key={achievement.name}
                achievement={placeholder_achievement}
              />
            );
          }
        })}
    </Table>
  );
};

const Achievement = (props) => {
  const { achievement } = props;
  const { name, desc, icon_class, value, score } = achievement;
  return (
    <Table.Row key={name}>
      <Table.Cell collapsing>
        <Box m={1} className={icon_class} />
      </Table.Cell>
      <Table.Cell verticalAlign="top">
        <h1>{name}</h1>
        {desc}
        {(score && (
          <Box color={value > 0 ? 'good' : 'bad'}>
            {`Earned ${value} times`}
          </Box>
        )) || (
          <Box color={value ? 'good' : 'bad'}>
            {value ? 'Unlocked' : 'Locked'}
          </Box>
        )}
      </Table.Cell>
    </Table.Row>
  );
};
