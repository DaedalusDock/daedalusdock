import { CheckboxInput, FeatureToggle } from '../base';

export const disable_pain_flash: FeatureToggle = {
  name: 'Disable pain flashes',
  category: 'ACCESSIBILITY',
  component: CheckboxInput,
};

export const motion_sickness: FeatureToggle = {
  name: 'Motion sickness aid',
  description: 'Disables effects that may induce motion sickness.',
  category: 'ACCESSIBILITY',
  component: CheckboxInput,
};
