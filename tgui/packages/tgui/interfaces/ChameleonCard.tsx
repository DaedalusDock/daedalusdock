import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { AccessGroup, AccessList } from './common/AccessList';

type ChameleonCardData = {
  accessGroups: AccessGroup[];
  accessOnCard: string[];
  ourTrimAccess: string[];
  showBasic: BooleanLike;
  theftAccess: string[];
};

export const ChameleonCard = (props) => {
  const { act, data } = useBackend<ChameleonCardData>();

  const { accessGroups, ourTrimAccess, accessOnCard, showBasic, theftAccess } =
    data;

  const parsedAccessGroups: AccessGroup[] = [];
  accessGroups.forEach((region: AccessGroup) => {
    const groupName = region.name;
    const groupAccess = region.accesses;
    const parsedGroup: AccessGroup = {
      name: groupName,
      accesses: [],
    };

    parsedGroup.accesses = groupAccess.filter((access) => {
      // Snip everything that's part of our trim.
      if (ourTrimAccess.includes(access.ref)) {
        return false;
      }
      // Add anything not part of our trim that's an access
      // Also add any access on the ID card we're stealing from.
      if (
        accessOnCard.includes(access.ref) ||
        theftAccess.includes(access.ref)
      ) {
        return true;
      }
      return false;
    });
    if (parsedGroup.accesses.length) {
      parsedAccessGroups.push(parsedGroup);
    }
  });

  return (
    <Window width={500} height={620}>
      <Window.Content scrollable>
        <AccessList
          accessGroups={parsedAccessGroups}
          selectedList={accessOnCard}
          trimAccess={ourTrimAccess}
          showBasic={!!showBasic}
          accessMod={(ref) =>
            act('mod_access', {
              access_target: ref,
            })
          }
        />
      </Window.Content>
    </Window>
  );
};
