import { Feature, FeatureDropdownInput } from '../base';

export const preferred_map: Feature<string> = {
  name: 'Preferred map',
  category: 'GAMEPLAY',
  description: `
    During map rotation, prefer this map be chosen.
    This does not affect the map vote, only random rotation when a vote
    is not held.
  `,
  component: FeatureDropdownInput,
};
