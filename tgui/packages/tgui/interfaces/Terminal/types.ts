/**
 * @file
 * @copyright 2023
 * @author Garash2k (https://github.com/garash2k)
 * @license ISC
 */

import { BooleanLike } from 'common/react';

export type PeripheralData = {
  clown?: BooleanLike;
  color?: string;
  disabled?: BooleanLike;
  extraInfo?: Record<string, any>;
  icon: string;
  kind: string;
  label: string;
};

export type TerminalData = {
  bgColor: string;
  ckey: string;
  displayHTML: string;
  fontColor: string;
  inputValue: string;
  loadTimestamp: number;
  peripherals: Array<PeripheralData>;
  terminalActive: BooleanLike;
  windowName: string;
};
