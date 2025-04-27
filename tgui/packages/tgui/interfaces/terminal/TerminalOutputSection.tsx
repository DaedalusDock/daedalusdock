/**
 * @file
 * @copyright 2023
 * @author Garash2k (https://github.com/garash2k)
 * @license ISC
 */

import { useEffect } from 'react';

import { Box, Section } from '../../components';
import type { TerminalData } from './types';

type TerminalOutputSectionProps = Pick<
  TerminalData,
  'bgColor' | 'displayHTML' | 'fontColor'
>;

export const TerminalOutputSection = (props: TerminalOutputSectionProps) => {
  const { displayHTML, fontColor, bgColor } = props;

  useEffect(() => {
    // TODO: replace this with a useRef implementation once Section component supports it
    const sectionContentElement = document.querySelector(
      '#terminalOutput div.Section__content',
    );
    if (!sectionContentElement) {
      return;
    }
    sectionContentElement.scrollTop = sectionContentElement.scrollHeight;
  }, [displayHTML]);

  return (
    <Section
      backgroundColor={bgColor}
      scrollable
      fill
      container_id="terminalOutput"
    >
      <Box
        fontFamily="Consolas"
        height="100%"
        color={fontColor}
        fontSize="1.2em"
        dangerouslySetInnerHTML={{ __html: displayHTML }}
      />
    </Section>
  );
};
