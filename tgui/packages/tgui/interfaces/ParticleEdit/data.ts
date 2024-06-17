export const RandTypes = [
  'UNIFORM_RAND',
  'NORMAL_RAND',
  'LINEAR_RAND',
  'SQUARE_RAND',
];
export const RandToNumber = {
  UNIFORM_RAND: 1,
  NORMAL_RAND: 2,
  LINEAR_RAND: 3,
  SQUARE_RAND: 4,
};

export const P_DATA_GENERATOR = 'generator';
export const P_DATA_ICON_ADD = 'icon_add';
export const P_DATA_ICON_REMOVE = 'icon_remove';
export const P_DATA_ICON_WEIGHT = 'icon_edit';

export const MatrixTypes = [
  'Simple Matrix',
  'Complex Matrix',
  'Projection Matrix',
];

export const SpaceTypes = [
  'COLORSPACE_RGB',
  'COLORSPACE_HSV',
  'COLORSPACE_HSL',
  'COLORSPACE_HCY',
];
export const SpaceToNum = {
  COLORSPACE_RGB: 0,
  COLORSPACE_HSV: 1,
  COLORSPACE_HSL: 2,
  COLORSPACE_HCY: 3,
};

export const GeneratorTypes = [
  'num',
  'vector',
  'box',
  'color',
  'circle',
  'sphere',
  'square',
  'cube',
];

export const GeneratorTypesNoVectors = [
  'num',
  'color',
  'circle',
  'sphere',
  'square',
  'cube',
];

export type ParticleUIData = {
  particle_data: ParticleData;
  target_name: string;
};

type ParticleData = {
  bound1: number[];
  bound2: number[];
  color?: number | string | string[];
  color_change?: number | string[];
  count: number;
  drift?: number[] | string[];
  fade?: number | string[];
  fadein?: number | string[];
  friction?: number | string[];

  gradient?: (string | number)[];
  gravity?: number[];
  grow?: number | number[] | string[];
  height: number;
  icon?: string | { [key: string]: number };
  icon_state?: string | { [key: string]: number };
  lifespan?: number | string[];
  position?: number[] | string[];
  rotation?: number | string[];
  scale?: number | number[] | string[];
  spawning: number;
  spin?: number | string[];
  transform?: number[];
  velocity?: number[] | string[];

  width: number;
};

export type EntryFloatProps = {
  float: number;
  name: string;
  var_name: string;
};

export type EntryCoordProps = {
  coord?: number[];
  name: string;
  var_name: string;
};

export type EntryGradientProps = {
  gradient?: (string | number)[];
  name: string;
  var_name: string;
};

export type EntryTransformProps = {
  name: string;
  transform?: number[];
  var_name: string;
};

export type EntryIconStateProps = {
  icon_state?: string | { [key: string]: number };
  name: string;
  var_name: string;
};

export type FloatGeneratorProps = {
  float?: number | string[];
  name: string;
  var_name: string;
};

export type FloatGeneratorColorProps = {
  float?: number | string | string[];
  name: string;
  var_name: string;
};

export type GeneratorProps = {
  allow_vectors?: boolean;
  generator?: string[];
  var_name: string;
};

export type EntryGeneratorNumbersListProps = {
  allow_z: boolean;
  input?: number | number[] | string[];
  name: string;
  var_name: string;
};
