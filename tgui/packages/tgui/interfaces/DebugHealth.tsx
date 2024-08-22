import { toTitleCase } from 'common/string';

import { useBackend, useLocalState } from '../backend';
import {
  Button,
  Collapsible,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
  Tabs,
  Tooltip,
} from '../components';
import { TableCell, TableRow } from '../components/Table';
import { Window } from '../layouts';

export const DebugHealth = (props) => {
  const { data } = useBackend<Record<string, any>>();

  const tabs = Object.keys(data);
  const [currentTab, setCurrentTab] = useLocalState('currentTab', tabs[0]);

  return (
    <Window width={400} height={500}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Tabs>
              {tabs.map((key) => (
                <Tabs.Tab
                  key={key}
                  selected={currentTab === key}
                  onClick={() => setCurrentTab(key)}
                >
                  {toTitleCase(key)}
                </Tabs.Tab>
              ))}
            </Tabs>
          </Stack.Item>
          <Stack.Item grow>
            <Section fill scrollable>
              {currentTab === 'body' ? (
                <InfoSection data={data[currentTab]} />
              ) : (
                <ExpandableSection data={data[currentTab]} />
              )}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const InfoSection = (props: { data: Record<string, any> }) => {
  const { data } = props;

  return (
    <LabeledList>
      {Object.entries(data).map(([key, value]) => {
        if (value instanceof Array) {
          return <ArrayDisplay key={key} label={key} items={value} />;
        }
        if (value instanceof Object) {
          return <ObjectDisplay key={key} items={value} />;
        }
        return <ListItem key={key} entry={[key, value]} />;
      })}
    </LabeledList>
  );
};

const ExpandableSection = (props: { data: Record<string, any> }) => {
  const { data } = props;

  return (
    <>
      {Object.entries(data).map(([key, value]) => (
        <Collapsible key={key} title={toTitleCase(key)}>
          <InfoSection data={value} />
        </Collapsible>
      ))}
    </>
  );
};

const ArrayDisplay = (props: { items: any[]; label: string }) => {
  const { label, items = [] } = props;

  return (
    <LabeledList.Item className="candystripe" label={toTitleCase(label)}>
      {items.length === 0 && 'None'}

      {items.map((item, index) => {
        if (item instanceof Object) {
          return (
            <Collapsible key={index} title="View" color="average">
              <TooltipButton item={item} />
            </Collapsible>
          );
        }

        return (
          <TableRow key={index}>
            <TableCell key={index}>{item}</TableCell>
          </TableRow>
        );
      })}
    </LabeledList.Item>
  );
};

const ObjectDisplay = (props: { items: Record<string, any> }) => {
  const { items = {} } = props;
  const name = items.name || items.Name || items.NAME || 'Unknown';

  return (
    <Section ml={2} title={name}>
      <LabeledList>
        {Object.entries(items).map((entry) => {
          if (entry[0] === 'name') return;

          return <ListItem key={entry[0]} entry={entry} />;
        })}
      </LabeledList>
    </Section>
  );
};

const TooltipButton = (props) => {
  const { item } = props;
  const name = item.name || item.Name || item.NAME || 'Unknown';

  return (
    <Tooltip
      content={
        <>
          <NoticeBox>{name}</NoticeBox>
          <LabeledList>
            {Object.entries(item).map((entry) => (
              <ListItem key={entry[0]} entry={entry} />
            ))}
          </LabeledList>
        </>
      }
    >
      <Button color="bad">{name}</Button>
    </Tooltip>
  );
};

const ListItem = (props: { entry: [string, any] }) => {
  const {
    entry: [label, value],
  } = props;

  return (
    <LabeledList.Item className="candystripe" label={toTitleCase(label)}>
      {value?.toString() || 'Unknown'}
    </LabeledList.Item>
  );
};
