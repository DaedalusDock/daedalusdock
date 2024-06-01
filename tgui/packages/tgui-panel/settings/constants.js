/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

export const SETTINGS_TABS = [
  {
    id: 'general',
    name: 'General',
  },
  {
    id: 'chatPage',
    name: 'Chat Tabs',
  },
];

export const FONTS_DISABLED = 'System Default';

export const FONTS = [
  'Times New Roman', // By placing this at index zero, it is the default for our server
  FONTS_DISABLED,
  'Verdana',
  'Arial',
  'Arial Black',
  'Comic Sans MS',
  'Impact',
  'Lucida Sans Unicode',
  'Tahoma',
  'Trebuchet MS',
  'Courier New',
  'Lucida Console',
];

export const THEME_DARK = 'dark';
export const THEME_LIGHT = 'light';

export const DEFAULT_THEME = THEME_DARK;

export const THEMES = [THEME_LIGHT, THEME_DARK];
