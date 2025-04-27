/**
 * @file
 * @copyright 2022-2023
 * @author Original skeletonman0 (https://github.com/skeletonman0/)
 * @author Changes garash2k (https://github.com/garash2l)
 * @license MIT
 */

import { useBackend } from '../../backend';
import { Stack } from '../../components';
import { Window } from '../../layouts';
import { InputAndButtonsSection } from './InputAndButtonsSection';
import { PeripheralsSection } from './PeripheralsSection';
import { TerminalOutputSection } from './TerminalOutputSection';
import type { TerminalData } from './types';

export const Terminal = (props) => {
  const { data } = useBackend<TerminalData>();
  const { bgColor, displayHTML, fontColor, peripherals, windowName } = data;

  return (
    <Window theme="retro-dark" title={windowName} width={670} height={500}>
      <Window.Content fontFamily="Consolas">
        <Stack vertical fill>
          <Stack.Item grow>
            <TerminalOutputSection
              bgColor={bgColor}
              displayHTML={displayHTML}
              fontColor={fontColor}
            />
          </Stack.Item>
          <Stack.Item>
            <InputAndButtonsSection />
          </Stack.Item>
          <Stack.Item>
            <PeripheralsSection peripherals={peripherals} />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
