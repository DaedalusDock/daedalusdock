import { CheckboxInput, FeatureToggle } from '../base';

export const ready_job: FeatureToggle = {
  name: 'Show Ready Job In Lobby',
  category: 'GAMEPLAY',
  description: 'Show your Ckey and Job when you are readied up in the lobby.',
  component: CheckboxInput,
};
