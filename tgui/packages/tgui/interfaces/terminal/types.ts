/**
 * @file
 * @copyright 2023
 * @author Garash2k (https://github.com/garash2k)
 * @license ISC
 */

import { BooleanLike } from 'common/react';

export type PeripheralData = {
  Clown?: BooleanLike;
  card: string;
  color: any;
  icon: string;
  index: number;
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
