/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import {
  changeSettingsTab,
  loadSettings,
  openChatSettings,
  toggleSettings,
  updateSettings,
} from './actions';
import {
  CHAT_SETTINGS_VERSION,
  DEFAULT_FONT,
  DEFAULT_FONT_SIZE,
  DEFAULT_LINE_HEIGHT,
  DEFAULT_THEME,
  SETTINGS_TABS,
  Theme,
} from './constants';

type ReducerState = {
  adminMusicVolume: number;
  chatSettingsVersion: number;
  fontFamily: string;
  fontSize: number;
  highlightColor: string;
  highlightText?: string;
  lineHeight: number;
  matchCase: boolean;
  matchWord: boolean;
  theme: Theme;
  version: number;
  view: {
    activeTab: string;
    visible: boolean;
  };
};

const initialState: ReducerState = {
  version: 1,
  chatSettingsVersion: CHAT_SETTINGS_VERSION,
  fontSize: DEFAULT_FONT_SIZE,
  fontFamily: DEFAULT_FONT.toCSS(),
  lineHeight: DEFAULT_LINE_HEIGHT,
  theme: DEFAULT_THEME,
  adminMusicVolume: 0.5,
  highlightText: '',
  highlightColor: '#ffdd44',
  matchWord: false,
  matchCase: false,
  view: {
    visible: false,
    activeTab: SETTINGS_TABS[0].id,
  },
};

export const settingsReducer = (state = initialState, action) => {
  const { type, payload } = action;
  if (type === updateSettings.type) {
    return {
      ...state,
      ...payload,
    };
  }
  if (type === loadSettings.type) {
    // Validate version and/or migrate state
    if (!payload?.version) {
      return state;
    }

    if (
      !payload.chatSettingsVersion ||
      payload.chatSettingsVersion < state.chatSettingsVersion
    ) {
      delete payload.fontFamily;
      delete payload.fontSize;
      delete payload.lineHeight;
      if (payload.chatSettingsVersion) {
        delete payload.chatSettingsVersion;
      }
    }

    delete payload.view;
    return {
      ...state,
      ...payload,
    };
  }
  if (type === toggleSettings.type) {
    return {
      ...state,
      view: {
        ...state.view,
        visible: !state.view.visible,
      },
    };
  }
  if (type === openChatSettings.type) {
    return {
      ...state,
      view: {
        ...state.view,
        visible: true,
        activeTab: 'chatPage',
      },
    };
  }
  if (type === changeSettingsTab.type) {
    const { tabId } = payload;
    return {
      ...state,
      view: {
        ...state.view,
        activeTab: tabId,
      },
    };
  }
  return state;
};
