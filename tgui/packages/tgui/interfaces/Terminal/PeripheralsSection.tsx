/**
 * @file
 * @copyright 2023
 * @author Garash2k (https://github.com/garash2k)
 * @license ISC
 */

import { useCallback } from 'react';

import { useBackend } from '../../backend';
import { Button, Section } from '../../components';
import type { PeripheralData, TerminalData } from './types';

interface PeripheralsSectionProps {
  peripherals: PeripheralData[];
}

export const PeripheralsSection = (props: PeripheralsSectionProps) => {
  const { act } = useBackend<TerminalData>();
  const { peripherals } = props;

  const handlePeripheralClick = useCallback(
    (peripheral: PeripheralData) =>
      act('buttonPressed', { kind: peripheral.kind }),
    [act],
  );

  return (
    <Section fitted>
      {peripherals.map((peripheral) => {
        return (
          <Button
            key={peripheral.kind}
            icon={peripheral.icon}
            fontFamily={peripheral.clown ? 'Comic Sans MS' : 'Consolas'}
            color={!peripheral.disabled && peripheral.color}
            disabled={peripheral.disabled}
            onClick={() => handlePeripheralClick(peripheral)}
          >
            {peripheral.label}
          </Button>
        );
      })}
    </Section>
  );
};
