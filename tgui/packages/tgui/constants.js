/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

// UI states, which are mirrored from the BYOND code.
export const UI_INTERACTIVE = 2;
export const UI_UPDATE = 1;
export const UI_DISABLED = 0;
export const UI_CLOSE = -1;

// All game related colors are stored here
export const COLORS = {
  // Department colors
  department: {
    captain: '#c06616',
    security: '#e74c3c',
    medbay: '#3498db',
    science: '#9b59b6',
    engineering: '#f1c40f',
    cargo: '#f39c12',
    centcom: '#00c100',
    other: '#c38312',
  },
  // Damage type colors
  damageType: {
    oxy: '#3498db',
    toxin: '#2ecc71',
    burn: '#e67e22',
    brute: '#e74c3c',
  },
  // reagent / chemistry related colours
  reagent: {
    acidicbuffer: '#fbc314',
    basicbuffer: '#3853a4',
  },
};

// Colors defined in CSS
export const CSS_COLORS = [
  'black',
  'white',
  'red',
  'orange',
  'yellow',
  'olive',
  'green',
  'teal',
  'blue',
  'violet',
  'purple',
  'pink',
  'brown',
  'grey',
  'good',
  'average',
  'bad',
  'label',
];

/* IF YOU CHANGE THIS KEEP IT IN SYNC WITH CHAT CSS */
export const RADIO_CHANNELS = [
  {
    name: 'Syndicate',
    freq: 1213,
    color: '#8f4a4b',
  },
  {
    name: 'Red Team',
    freq: 1215,
    color: '#ff4444',
  },
  {
    name: 'Blue Team',
    freq: 1217,
    color: '#3434fd',
  },
  {
    name: 'Green Team',
    freq: 1219,
    color: '#34fd34',
  },
  {
    name: 'Yellow Team',
    freq: 1221,
    color: '#fdfd34',
  },
  {
    name: 'CentCom',
    freq: 1337,
    color: '#2681a5',
  },
  {
    name: 'Supply',
    freq: 1347,
    color: '#b88646',
  },
  {
    name: 'Service',
    freq: 1349,
    color: '#6ca729',
  },
  {
    name: 'Science',
    freq: 1351,
    color: '#c68cfa',
  },
  {
    name: 'Command',
    freq: 1353,
    color: '#fcdf03',
  },
  {
    name: 'Medical',
    freq: 1355,
    color: '#57b8f0',
  },
  {
    name: 'Engineering',
    freq: 1357,
    color: '#f37746',
  },
  {
    name: 'Security',
    freq: 1359,
    color: '#dd3535',
  },
  {
    name: 'AI Private',
    freq: 1447,
    color: '#d65d95',
  },
  {
    name: 'Common',
    freq: 1459,
    color: '#1ecc43',
  },
];

const GASES = [
  {
    id: 'oxygen',
    name: 'Oxygen',
    label: 'O₂',
    color: 'blue',
  },
  {
    id: 'nitrogen',
    name: 'Nitrogen',
    label: 'N₂',
    color: 'red',
  },
  {
    id: 'carbon_dioxide',
    name: 'Carbon Dioxide',
    label: 'CO₂',
    color: 'grey',
  },
  {
    id: 'plasma',
    name: 'Plasma',
    label: 'Plasma',
    color: 'pink',
  },
  {
    id: 'water',
    name: 'Water Vapor',
    label: 'H₂O',
    color: 'lightsteelblue',
  },
  {
    id: 'nob',
    name: 'Hyper-noblium',
    label: 'Hyper-nob',
    color: 'teal',
  },
  {
    id: 'sleeping_agent',
    name: 'Nitrous Oxide',
    label: 'N₂O',
    color: 'bisque',
  },
  {
    id: 'nitrodioxide',
    name: 'Nitrogen Dioxide',
    label: 'NO₂',
    color: 'brown',
  },
  {
    id: 'bz',
    name: 'BZ',
    label: 'BZ',
    color: 'mediumpurple',
  },
  {
    id: 'pluox',
    name: 'Pluoxium',
    label: 'O₁₆',
    color: 'mediumslateblue',
  },
  {
    id: 'miasma',
    name: 'Miasma',
    label: 'Miasma',
    color: 'olive',
  },
  {
    id: 'Freon',
    name: 'Freon',
    label: 'Freon',
    color: 'paleturquoise',
  },
  {
    id: 'hydrogen',
    name: 'Hydrogen',
    label: 'H₂',
    color: 'white',
  },
  {
    id: 'healium',
    name: 'Healium',
    label: 'Healium',
    color: 'salmon',
  },
  {
    id: 'proto_nitrate',
    name: 'Proto Nitrate',
    label: 'Proto-Nitrate',
    color: 'greenyellow',
  },
  {
    id: 'zauker',
    name: 'Zauker',
    label: 'Zauker',
    color: 'darkgreen',
  },
  {
    id: 'halon',
    name: 'Halon',
    label: 'Halon',
    color: 'purple',
  },
  {
    id: 'helium',
    name: 'Helium',
    label: 'He',
    color: 'aliceblue',
  },
  {
    id: 'antinoblium',
    name: 'Antinoblium',
    label: 'Anti-Noblium',
    color: 'maroon',
  },
  {
    id: 'carbon_monoxide',
    name: 'Carbon Monoxide',
    label: 'CO',
    color: 'maroon',
  },
  {
    id: 'methyl_bromide',
    name: 'Methyl Bromide',
    label: 'CH₃Br',
    color: 'maroon',
  },
  {
    id: 'methane',
    name: 'Methane',
    label: 'CH₄',
    color: 'maroon',
  },
  {
    id: 'methane',
    name: 'Methane',
    label: 'CH₄',
    color: 'maroon',
  },
  {
    id: 'argon',
    name: 'Argon',
    label: 'Ar',
    color: 'maroon',
  },
  {
    id: 'krypton',
    name: 'Krypton',
    label: 'Kr',
    color: 'maroon',
  },
  {
    id: 'xenon',
    name: 'Xenon',
    label: 'Xe',
    color: 'maroon',
  },
  {
    id: 'neon',
    name: 'Neon',
    label: 'Ne',
    color: 'maroon',
  },
  {
    id: 'ammonia',
    name: 'Ammonia',
    label: 'NH₃',
    color: 'maroon',
  },
  {
    id: 'chlorine',
    name: 'Chlorine',
    label: 'Cl',
    color: 'maroon',
  },
  {
    id: 'sulfurdioxide',
    name: 'Chlorine',
    label: 'SO₂',
    color: 'maroon',
  },
  {
    id: 'nitricoxide',
    name: 'Nitric Oxide',
    label: 'NO',
    color: 'maroon',
  },
  {
    id: 'deuterium',
    name: 'Deuterium',
    label: '²H',
    color: 'lightgrey',
  },
  {
    id: 'tritium',
    name: 'Tritium',
    label: '³H',
    color: 'limegreen',
  },
  {
    id: 'boron',
    name: 'Boron',
    label: 'B',
    color: 'limegreen',
  },
  {
    id: 'radon',
    name: 'Radon',
    label: 'Rn',
    color: 'grey',
  },
];

export const getGasLabel = (gasId, fallbackValue) => {
  const gasSearchString = String(gasId).toLowerCase();
  const gas = GASES.find(
    (gas) =>
      gas.id === gasSearchString || gas.name.toLowerCase() === gasSearchString,
  );
  return (gas && gas.label) || fallbackValue || gasId;
};

export const getGasColor = (gasId) => {
  const gasSearchString = String(gasId).toLowerCase();
  const gas = GASES.find(
    (gas) =>
      gas.id === gasSearchString || gas.name.toLowerCase() === gasSearchString,
  );
  return gas && gas.color;
};
