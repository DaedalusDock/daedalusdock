export const KelvinZeroCelcius = 273.15;

export const InternalDamageToDamagedDesc = {
  MECHA_INT_FIRE: 'Internal fire detected',
  MECHA_INT_TEMP_CONTROL: 'Temperature control inactive',
  MECHA_INT_TANK_BREACH: 'Air tank breach detected',
  MECHA_INT_CONTROL_LOST: 'Control module damaged',
};

export const InternalDamageToNormalDesc = {
  MECHA_INT_FIRE: 'No internal fires detected',
  MECHA_INT_TEMP_CONTROL: 'Temperature control active',
  MECHA_INT_TANK_BREACH: 'Air tank intact',
  MECHA_INT_CONTROL_LOST: 'Control module active',
};

export type AccessData = {
  name: string;
  number: number;
};

type MechElectronics = {
  frequency: number;
  maxfreq: number;
  microphone: boolean;
  minfreq: number;
  speaker: boolean;
};

export type MechWeapon = {
  ammo_type: string | null;
  desc: string;
  // null when not ballistic weapon
  disabledreload: boolean | null;
  energy_per_use: number;
  integrity: number;
  isballisticweapon: boolean;
  max_magazine: number | null;
  name: string;
  projectiles: number | null;
  projectiles_cache: number | null;
  projectiles_cache_max: number | null;
  ref: string;
  // first entry is always "snowflake_id"=snowflake_id if snowflake
  snowflake: any;
};

export type MainData = {
  isoperator: boolean;
};

export type MaintData = {
  capacitor: string;
  cell: string;
  idcard_access: AccessData[];
  internal_tank_valve: number;
  mecha_flags: number;
  mechflag_keys: string[];
  name: string;
  operation_req_access: AccessData[];
  scanning: string;
};

export type OperatorData = {
  air_source: string;
  airtank_pressure: number | null;
  airtank_temp: number | null;
  cabin_dangerous_highpressure: number;
  cabin_pressure: number;
  cabin_temp: number;
  dna_lock: string | null;
  integrity: number;
  internal_damage: number;
  internal_damage_keys: string[];
  left_arm_weapon: MechWeapon | null;
  mech_electronics: MechElectronics;
  mech_equipment: string[];
  mech_view: string;
  mecha_flags: number;
  mechflag_keys: string[];
  mineral_material_amount: number;
  name: string;
  port_connected: boolean | null;
  power_level: number | null;
  power_max: number | null;
  right_arm_weapon: MechWeapon | null;
};

export type MechaUtility = {
  name: string;
  ref: string;
  snowflake: any;
};
