import { Feature, FeatureTextInput } from "../../base";

export const flavor_text: Feature<string> = {
  name: "Flavor Text",
  description: "Describe your character!",
  component: FeatureTextInput,
};

export const ooc_notes: Feature<string> = {
  name: "OOC Notes",
  description: "Talk about your character OOCly!",
  component: FeatureTextInput,
};
