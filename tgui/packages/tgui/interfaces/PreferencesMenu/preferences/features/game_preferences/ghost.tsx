import { useBackend } from '../../../../../backend';
import { PreferencesMenuData } from '../../../data';
import {
  CheckboxInput,
  FeatureChoiced,
  FeatureChoicedServerData,
  FeatureDropdownInput,
  FeatureToggle,
  FeatureValueProps,
} from '../base';

export const ghost_hud: FeatureToggle = {
  name: 'Ghost HUD',
  category: 'GHOST',
  description: 'Enable HUD buttons for ghosts.',
  component: CheckboxInput,
};

export const ghost_orbit: FeatureChoiced = {
  name: 'Ghost orbit',
  category: 'GHOST',
  description: `
    The shape in which your ghost will orbit.
    Requires BYOND membership.
  `,
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    const { data } = useBackend<PreferencesMenuData>();

    return (
      <FeatureDropdownInput {...props} disabled={!data.content_unlocked} />
    );
  },
};

export const inquisitive_ghost: FeatureToggle = {
  name: 'Ghost inquisitiveness',
  category: 'GHOST',
  description: 'Clicking on something as a ghost will examine it.',
  component: CheckboxInput,
};
