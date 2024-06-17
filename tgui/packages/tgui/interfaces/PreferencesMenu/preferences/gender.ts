export enum Gender {
  Female = 'female',
  Male = 'male',
  Other = 'plural',
}

export const GENDERS = {
  [Gender.Male]: {
    icon: 'male',
    text: 'Male',
  },

  [Gender.Female]: {
    icon: 'female',
    text: 'Female',
  },

  [Gender.Other]: {
    icon: 'tg-non-binary',
    text: 'Other',
  },
};
