import { BooleanLike } from 'common/react';

import { sendAct } from '../../backend';
import { Gender } from './preferences/gender';

export enum Food {
  Alcohol = 'ALCOHOL',
  Breakfast = 'BREAKFAST',
  Cloth = 'CLOTH',
  Dairy = 'DAIRY',
  Fried = 'FRIED',
  Fruit = 'FRUIT',
  Grain = 'GRAIN',
  Gross = 'GROSS',
  Junkfood = 'JUNKFOOD',
  Meat = 'MEAT',
  Nuts = 'NUTS',
  Pineapple = 'PINEAPPLE',
  Raw = 'RAW',
  Seafood = 'SEAFOOD',
  Sugar = 'SUGAR',
  Toxic = 'TOXIC',
  Vegetables = 'VEGETABLES',
}

export enum JobPriority {
  Low = 1,
  Medium = 2,
  High = 3,
}

export type Name = {
  can_randomize: BooleanLike;
  explanation: string;
  group: string;
};

export type Species = {
  desc: string;
  diet?: {
    disliked_food: Food[];
    liked_food: Food[];
    toxic_food: Food[];
  };
  enabled_features: string[];
  icon: string;

  lore: string[];
  name: string;

  perks: {
    negative: Perk[];
    neutral: Perk[];
    positive: Perk[];
  };

  sexes: BooleanLike;

  use_skintones: BooleanLike;
};

export type Perk = {
  description: string;
  name: string;
  ui_icon: string;
};

export type Department = {
  head?: string;
};

export type Job = {
  // PARIAH EDIT
  alt_titles?: string[];
  department: string;
  description: string;
  // PARIAH EDIT END
};

export type Quirk = {
  description: string;
  icon: string;
  name: string;
  value: number;
};

export type QuirkInfo = {
  max_positive_quirks: number;
  quirk_blacklist: string[][];
  quirk_info: Record<string, Quirk>;
};

export enum RandomSetting {
  AntagOnly = 1,
  Disabled = 2,
  Enabled = 3,
}

export enum JoblessRole {
  BeOverflow = 1,
  BeRandomJob = 2,
  ReturnToLobby = 3,
}

export enum GamePreferencesSelectedPage {
  Settings,
  Keybindings,
}

export const createSetPreference =
  (act: typeof sendAct, preference: string) => (value: unknown) => {
    act('set_preference', {
      preference,
      value,
    });
  };

export enum Window {
  Character = 0,
  Game = 1,
  Keybindings = 2,
}

export type PreferencesMenuData = {
  active_slot: number;
  antag_bans?: string[];

  antag_days_left?: Record<string, number>;
  // PARIAH EDIT ADDITION
  character_preferences: {
    clothing: Record<string, string>;
    features: Record<string, string>;
    game_preferences: Record<string, unknown>;
    misc: {
      gender: Gender;
      joblessrole: JoblessRole;
      species: string;
    };
    names: Record<string, string>;
    non_contextual: {
      [otherKey: string]: unknown;
      random_body: RandomSetting;
    };

    randomization: Record<string, RandomSetting>;

    secondary_features: Record<string, unknown>;

    supplemental_features: Record<string, unknown>;
  };

  character_preview_view: string;

  character_profiles: (string | null)[];

  content_unlocked: BooleanLike;
  job_alt_titles: Record<string, string>;
  job_bans?: string[];
  job_days_left?: Record<string, number>;

  job_preferences: Record<string, JobPriority>;

  job_required_experience?: Record<
    string,
    {
      experience_type: string;
      required_playtime: number;
    }
  >;
  // PARIAH EDIT ADDITION
  keybindings: Record<string, string[]>;
  name_to_use: string;

  overflow_role: string;
  preview_options: string;
  // PARIAH EDIT ADDITION
  preview_selection: string;

  selected_antags: string[];
  selected_quirks: string[];

  window: Window;
};

export type ServerData = {
  [otheyKey: string]: unknown;
  jobs: {
    departments: Record<string, Department>;
    jobs: Record<string, Job>;
  };
  names: {
    types: Record<string, Name>;
  };
  quirks: QuirkInfo;
  random: {
    randomizable: string[];
  };
  species: Record<string, Species>;
};
