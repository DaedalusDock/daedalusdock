import { sortBy } from 'common/collections';
import { BooleanLike } from 'common/react';

import { useSharedState } from '../../backend';
import { Button, Flex, Section, Tabs } from '../../components';

type AccessListProps = {
  accessFlagNames: Record<string, any>;
  accessFlags: Record<string, any>;
  accessMod: Function;
  accesses?: AccessRegion[];
  extraButtons: React.JSX.Element;
  selectedList: string[];
  showBasic: BooleanLike;
  trimAccess: string[];
};

type AccessRegion = {
  accesses: AccessInstance[];
  name: string;
};

type AccessInstance = {
  desc: string;
  ref: string;
};

type ParsedRegion = {
  accesses: AccessInstance[];
  allSelected: BooleanLike;
  hasSelected: BooleanLike;
  name: string;
};

export const AccessList = (props: AccessListProps) => {
  const {
    accesses = [],
    selectedList = [],
    accessMod,
    trimAccess = [],
    accessFlags = {},
    accessFlagNames = {},
    extraButtons,
    showBasic,
  } = props;

  const parsedRegions: ParsedRegion[] = [];
  const selectedTrimAccess: string[] = [];
  accesses.forEach((region) => {
    const regionName = region.name;
    const regionAccess = region.accesses;
    const parsedRegion: ParsedRegion = {
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
      parsedRegion.accesses.push(access);
      if (selectedList.includes(access.ref)) {
        parsedRegion.hasSelected = true;
      } else {
        parsedRegion.allSelected = false;
      }
    });
    if (parsedRegion.accesses.length) {
      parsedRegions.push(parsedRegion);
    }
    return;
  });

  return (
    <Section title="Access" buttons={extraButtons}>
      <Flex wrap="wrap">
        <Flex.Item>
          <RegionTabList accesses={parsedRegions} />
        </Flex.Item>
        <Flex.Item grow={1}>
          <RegionAccessList
            accesses={parsedRegions}
            selectedList={selectedList}
            accessMod={accessMod}
            trimAccess={trimAccess}
            accessFlags={accessFlags}
            accessFlagNames={accessFlagNames}
          />
        </Flex.Item>
      </Flex>
    </Section>
  );
};

const RegionTabList = (props) => {
  const { accesses = [] } = props;

  const [selectedAccessName, setSelectedAccessName] = useSharedState(
    'accessName',
    accesses[0]?.name,
  );

  return (
    <Tabs vertical>
      {accesses.map((access) => {
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
  accessFlagNames: Record<string, any>;
  accessFlags: Record<string, any>;
  accessMod: Function;
  accesses?: AccessRegion[];
  selectedList: string[];
  trimAccess: string[];
};

const RegionAccessList = (props: RegionAccessListProps) => {
  const {
    accesses = [],
    selectedList = [],
    accessMod,
    trimAccess = [],
    accessFlags = {},
    accessFlagNames = {},
  } = props;

  const [selectedAccessName] = useSharedState('accessName', accesses[0]?.name);

  const selectedAccess = accesses.find(
    (access) => access.name === selectedAccessName,
  );

  const selectedAccessEntries = sortBy((entry: AccessInstance) => entry.desc)(
    selectedAccess?.accesses || [],
  );

  console.log(selectedAccessEntries);
  return selectedAccessEntries.map((entry) => {
    const id = entry.ref;
    const entryName = trimAccess.includes(id)
      ? entry.desc
      : entry.desc + ' (' + accessFlagNames[accessFlags[id]] + ')';

    return (
      <Button.Checkbox
        ml={1}
        fluid
        key={entry.desc}
        content={entryName}
        checked={selectedList.includes(entry.ref)}
        onClick={() => accessMod(entry.ref)}
      />
    );
  });
};
