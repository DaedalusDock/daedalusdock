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

export type Font = {
  fallbacks: string;
  familyName: string;
  friendlyName: string;

  toCSS: () => string;
};

/// Default font size.
export const DEFAULT_FONT_SIZE: number = 14;
/// Default line height.
export const DEFAULT_LINE_HEIGHT: number = 1.4;

/// Default font
export const DEFAULT_FONT = fontHelper('Libre Baskerville', undefined, [
  'Times',
  'serif',
]);

function fontHelper(
  family: string,
  friendly?: string,
  fallbacks?: string[],
): Font {
  const outFont: Font = {
    familyName: family,
    friendlyName: friendly || family,
    fallbacks: '',
    toCSS() {
      let composedFontCSS = `'${outFont.familyName}'`;
      if (outFont.fallbacks?.length) {
        composedFontCSS = `${composedFontCSS}, ${outFont.fallbacks}`;
      }
      return composedFontCSS;
    },
  };

  if (fallbacks) {
    outFont.fallbacks = fallbacks
      .map((fallback_str) => `'${fallback_str}'`)
      .join(',');
  }
  return outFont;
}

// This falls back onto whatever is in reset.scss
export const FONTS_DISABLED = fontHelper('TGUI Default');

export const FONTS: Font[] = [
  DEFAULT_FONT,
  fontHelper('Times New Roman', undefined, ['serif']),
  fontHelper('Verdana', undefined, ['sans-serif']),
  FONTS_DISABLED,
  fontHelper('Arial', undefined, ['sans-serif']),
  fontHelper('Arial Black', undefined, ['sans-serif']),
  fontHelper('Comic Sans MS', undefined, ['cursive']),
  fontHelper('Impact', undefined, ['sans-serif']),
  fontHelper('Lucida Sans Unicode', undefined, ['sans-serif']),
  fontHelper('Tahoma', undefined, ['sans-serif']),
  fontHelper('Trebuchet MS', undefined, ['sans-serif']),
  fontHelper('Courier New', undefined, ['monospace']),
  fontHelper('Lucida Console', undefined, ['monospace']),
];

export enum Theme {
  DARK = 'dark',
  LIGHT = 'light',
}

/// Default theme
export const DEFAULT_THEME = Theme.DARK;
