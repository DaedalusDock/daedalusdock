import { FeatureColorInput, Feature, FeatureChoiced, FeatureDropdownInput } from "./base";

export const eye_color: Feature<string> = {
  name: "Eye color",
  component: FeatureColorInput,
};

export const facial_hair_color: Feature<string> = {
  name: "Facial hair color",
  component: FeatureColorInput,
};

export const facial_hair_gradient: FeatureChoiced = {
  name: "Facial hair gradient",
  component: FeatureDropdownInput,
};

export const facial_hair_gradient_color: Feature<string> = {
  name: "Facial hair gradient color",
  component: FeatureColorInput,
};

export const hair_color: Feature<string> = {
  name: "Hair color",
  component: FeatureColorInput,
};

export const hair_gradient: FeatureChoiced = {
  name: "Hair gradient",
  component: FeatureDropdownInput,
};

export const hair_gradient_color: Feature<string> = {
  name: "Hair gradient color",
  component: FeatureColorInput,
};


export const feature_human_ears: FeatureChoiced = {
  name: "Ears",
  component: FeatureDropdownInput,
};

export const feature_human_tail: FeatureChoiced = {
  name: "Tail",
  component: FeatureDropdownInput,
};

export const feature_lizard_legs: FeatureChoiced = {
  name: "Legs",
  component: FeatureDropdownInput,
};

export const feature_lizard_spines: FeatureChoiced = {
  name: "Spines",
  component: FeatureDropdownInput,
};

export const feature_lizard_tail: FeatureChoiced = {
  name: "Tail",
  component: FeatureDropdownInput,
};

export const feature_mcolor: Feature<string> = {
  name: "Mutant color",
  component: FeatureColorInput,
};

export const feature_mcolor2: Feature<string> = {
  name: "Secondary Mutant color",
  component: FeatureColorInput,
};

export const feature_mcolor3: Feature<string> = {
  name: "Tertiary Mutant color",
  component: FeatureColorInput,
};

export const underwear_color: Feature<string> = {
  name: "Underwear color",
  component: FeatureColorInput,
};

export const feature_vampire_status: Feature<string> = {
  name: "Vampire status",
  component: FeatureDropdownInput,
};

export const feature_headtails: FeatureChoiced = {
  name: "Headtails",
  component: FeatureDropdownInput,
};

export const feature_vox_tail: FeatureChoiced = {
  name: "Tail",
  component: FeatureDropdownInput,
};

export const feature_vox_hair: FeatureChoiced = {
  name: "Hairstyle",
  component: FeatureDropdownInput,
};

export const feature_vox_facial_hair: FeatureChoiced = {
  name: "Facial hair",
  component: FeatureDropdownInput,
};

export const feature_vox_spines: FeatureChoiced = {
  name: "Spines",
  component: FeatureDropdownInput,
};

export const feature_vox_snout: FeatureChoiced = {
  name: "Snout",
  component: FeatureDropdownInput,
};

export const teshari_feathers: Feature<string> = {
  name: "Head feathers",
  component: FeatureDropdownInput,
};

export const teshari_ears: Feature<string> = {
  name: "Ears",
  component: FeatureDropdownInput,
};

export const teshari_body_feathers: Feature<string> = {
  name: "Body feathers",
  component: FeatureDropdownInput,
};

export const tail_teshari: Feature<string> = {
  name: "Tail",
  component: FeatureDropdownInput,
};
