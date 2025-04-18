import { sortBy } from 'common/collections';
import { BooleanLike } from 'common/react';

import { useSharedState } from '../../backend';
import { Button, Flex, Section, Tabs } from '../../components';

type AccessListProps = {
  accessGroups?: AccessGroup[];
  accessMod: Function;
  extraButtons: React.JSX.Element;
  selectedList: string[];
  showBasic: BooleanLike;
  trimAccess: string[];
};

export type AccessGroup = {
  accesses: AccessInstance[];
  name: string;
};

type AccessInstance = {
  desc: string;
  ref: string;
};

type ParsedAccessGroup = {
  accesses: AccessInstance[];
  allSelected: BooleanLike;
  hasSelected: BooleanLike;
  name: string;
};

export const AccessList = (props: AccessListProps) => {
  const {
    accessGroups = [],
    selectedList = [],
    accessMod,
    trimAccess = [],
    extraButtons,
    showBasic,
  } = props;

  const parsedGroups: ParsedAccessGroup[] = [];
  const selectedTrimAccess: string[] = [];
  accessGroups.forEach((group) => {
    const regionName = group.name;
    const regionAccess = group.accesses;
    const parsedGroup: ParsedAccessGroup = {
      name: regionName,
      accesses: [],
      hasSelected: false,
      allSelected: true,
    };

    // If we're showing the basic accesses included as part of the trim,
    // we want to figure out how many are selected for later formatting
    // logic.
    if (showBasic) {
      regionAccess.forEach((access) => {
        if (
          trimAccess.includes(access.ref) &&
          selectedList.includes(access.ref) &&
          !selectedTrimAccess.includes(access.ref)
        ) {
          selectedTrimAccess.push(access.ref);
        }
      });
    }

    regionAccess.forEach((access) => {
      if (!trimAccess.includes(access.ref)) {
        return;
      }
      parsedGroup.accesses.push(access);
      if (selectedList.includes(access.ref)) {
        parsedGroup.hasSelected = true;
      } else {
        parsedGroup.allSelected = false;
      }
    });
    if (parsedGroup.accesses.length) {
      parsedGroups.push(parsedGroup);
    }
    return;
  });

  return (
    <Section title="Access" buttons={extraButtons}>
      <Flex wrap="wrap">
        <Flex.Item>
          <RegionTabList parsedAccessGroups={parsedGroups} />
        </Flex.Item>
        <Flex.Item grow={1} style={{ paddingLeft: '1rem' }}>
          <RegionAccessList
            parsedAccessGroups={parsedGroups}
            selectedList={selectedList}
            accessMod={accessMod}
            trimAccess={trimAccess}
          />
        </Flex.Item>
      </Flex>
    </Section>
  );
};

type RegionTabListProps = {
  parsedAccessGroups: ParsedAccessGroup[];
};

const RegionTabList = (props: RegionTabListProps) => {
  const { parsedAccessGroups } = props;

  const [selectedAccessName, setSelectedAccessName] = useSharedState(
    'accessName',
    parsedAccessGroups[0]?.name,
  );

  return (
    <Tabs vertical>
      {parsedAccessGroups.map((access) => {
        const icon =
          (access.allSelected && 'check') ||
          (access.hasSelected && 'minus') ||
          'times';
        return (
          <Tabs.Tab
            key={access.name}
            icon={icon}
            minWidth={'100%'}
            altSelection
            selected={access.name === selectedAccessName}
            onClick={() => setSelectedAccessName(access.name)}
          >
            {access.name}
          </Tabs.Tab>
        );
      })}
    </Tabs>
  );
};

type RegionAccessListProps = {
  accessMod: Function;
  parsedAccessGroups?: ParsedAccessGroup[];
  selectedList: string[];
  trimAccess: string[];
};

const RegionAccessList = (props: RegionAccessListProps) => {
  const {
    parsedAccessGroups = [],
    selectedList = [],
    accessMod,
    trimAccess = [],
  } = props;

  const [selectedAccessName] = useSharedState(
    'accessName',
    parsedAccessGroups[0]?.name,
  );

  const selectedGroup = parsedAccessGroups.find(
    (access) => access.name === selectedAccessName,
  );

  const selectedGroupEntries = sortBy((entry: AccessInstance) => entry.desc)(
    selectedGroup?.accesses || [],
  );

  return selectedGroupEntries.map((entry) => {
    const id = entry.ref;

    return (
      <Button.Checkbox
        ml={1}
        fluid
        key={entry.desc}
        content={entry.desc}
        checked={selectedList.includes(entry.ref)}
        onClick={() => accessMod(entry.ref)}
      />
    );
  });
};
