import { CheckboxInputInverse, FeatureToggle } from '../base';

export const hotkeys_silence: FeatureToggle = {
  name: 'Classic Hotkey Warnings',
  category: 'GAMEPLAY',
  description:
    'When enabled, will suppress the warning about bad/unbindable hotkeys. You should probably read them at least once.',
  component: CheckboxInputInverse,
};
