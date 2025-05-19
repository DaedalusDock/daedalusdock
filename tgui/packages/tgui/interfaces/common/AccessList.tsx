import { sortBy } from 'common/collections';
import { BooleanLike } from 'common/react';

import { useSharedState } from '../../backend';
import { Button, Flex, Section, Tabs } from '../../components';
import { logger } from '../../logging';

type AccessListProps = {
  accessGroups?: AccessGroup[];
  accessMod: Function;
  extraButtons?: React.JSX.Element;
  //Access on the card itself.
  selectedList: string[];
  showBasic: BooleanLike;
  trimAccess: string[];
};

export type AccessGroup = {
  accesses: AccessInstance[];
  name: string;
};

export type AccessInstance = {
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

  const { parsedGroups, selectedTrimAccess } = parseAccessGroups(
    accessGroups,
    showBasic,
    trimAccess,
    selectedList,
  );

  return (
    <Section title="Access" buttons={extraButtons}>
      <Flex wrap="wrap">
        <Flex.Item width="100%">
          <FormatWildcards showBasic={showBasic} />
        </Flex.Item>
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
// Parse out access groups. A ParsedAccessGroup contains the additional values hasSelected and allSelected.
function parseAccessGroups(
  accessGroups: AccessGroup[],
  showBasic: BooleanLike,
  trimAccess: string[],
  selectedList: string[],
) {
  const [wildcardTab, setWildcardTab] = useSharedState(
    'wildcardSelected',
    showBasic ? 'None' : 'All',
  );

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
        // If the card trim contains the selected access, and
        // the card itself contains the selected access, and
        // does not contain the selected access,
        // add it to the virtual trim's access.
        if (
          trimAccess.includes(access.ref) &&
          selectedList.includes(access.ref) &&
          !selectedTrimAccess.includes(access.ref)
        ) {
          selectedTrimAccess.push(access.ref);
        }
      });
    }

    // If there's no wildcard selected, grab accesses in
    // the trimAccess list as they require no wildcard.
    if (wildcardTab === 'None') {
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
    }

    // This handles wildcard regions. I think.
    regionAccess.forEach((access) => {
      // If the card trim contains this access from the this region,
      // exclude it from the ParsedGroup.
      if (trimAccess.includes(access.ref)) {
        return;
      }

      // Transfer the access to the ParsedGroup
      parsedGroup.accesses.push(access);

      // If the card itself contains this access, the ParsedGroup is selected.
      if (selectedList.includes(access.ref)) {
        parsedGroup.hasSelected = true;
      } else {
        // If the nothing in this ParsedGroup is on the card, allSelected is false.
        parsedGroup.allSelected = false;
      }
    });
    // If the ParsedGroup has no access, it is discarded here.
    if (parsedGroup.accesses.length) {
      parsedGroups.push(parsedGroup);
    }
    return;
  });
  return { parsedGroups: parsedGroups, selectedTrimAccess: selectedTrimAccess };
}

type WildcardProps = {
  showBasic: BooleanLike;
};

export const FormatWildcards = (props: WildcardProps) => {
  const { showBasic } = props;
  const [wildcardTab, setWildcardTab] = useSharedState(
    'wildcardSelected',
    showBasic ? 'None' : 'All',
  );

  // if (wildcardTab !== 'None') {
  //   selectedWildcard = showBasic ? 'None' : 'All';
  //   setWildcardTab(selectedWildcard);
  // } else {
  //   selectedWildcard = wildcardTab;
  // }

  return (
    <Tabs>
      {showBasic && (
        <Tabs.Tab
          selected={wildcardTab === 'None'}
          onClick={() => setWildcardTab('None')}
        >
          Template
        </Tabs.Tab>
      )}

      <Tabs.Tab
        selected={wildcardTab === 'All'}
        onClick={() => setWildcardTab('All')}
      >
        Other
      </Tabs.Tab>
    </Tabs>
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

  logger.log(`Selected group: ${selectedGroup?.name}`);
  logger.log(
    `Available groups: ${parsedAccessGroups.map((group) => group.name).join(',')}`,
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
