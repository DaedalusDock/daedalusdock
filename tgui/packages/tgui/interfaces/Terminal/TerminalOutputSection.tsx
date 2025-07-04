/**
 * @file
 * @copyright 2023
 * @author Garash2k (https://github.com/garash2k)
 * @license ISC
 */

import { BooleanLike } from 'common/react';
import { useEffect } from 'react';

import { Box, Section } from '../../components';
import type { TerminalData } from './types';

type TerminalOutputSectionProps = Pick<
  TerminalData,
  'bgColor' | 'displayHTML' | 'fontColor'
> & { noscroll?: BooleanLike };

export const TerminalOutputSection = (props: TerminalOutputSectionProps) => {
  const { displayHTML, fontColor, bgColor, noscroll } = props;

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
      scrollable={!noscroll}
      fill
      container_id="terminalOutput"
    >
      <Box
        fontFamily="Consolas"
        height="100%"
        color={fontColor}
        fontSize="1.2em"
        preserveWhitespace
        dangerouslySetInnerHTML={{ __html: displayHTML }}
      />
    </Section>
  );
};
