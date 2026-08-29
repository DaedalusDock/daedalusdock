import type { Placement } from '@floating-ui/react';
import type { ReactNode } from 'react';

import { Floating } from './Floating';

type Props = {
  /** The content to display in the tooltip */
  content?: ReactNode;
  innerhtml?: ReactNode;
} & Partial<{
  /** Hovering this element will show the tooltip */
  children: ReactNode;
  /** Where to place the tooltip relative to the reference element */
  position: Placement;
}>;

/**
 * ## Tooltip
 *
 * Displays a tooltip when hovering over the element. The tooltip
 * can be customized with a custom content and position.
 *
 * Example:
 *
 * ```tsx
 * <Tooltip content="This is a tooltip" position="top">
 *   <Box>Hover over me</Box>
 * </Tooltip>
 * ```
 *
 * - [View documentation on tgui core](https://tgstation.github.io/tgui-core/?path=/docs/components-tooltip--docs)
 */
export function Tooltip(props: Props) {
  const { content, children, innerhtml, position } = props;

  return (
    <Floating
      content={content}
      innerhtml={innerhtml}
      contentClasses="Tooltip"
      hoverOpen
      placement={position}
    >
      {children}
    </Floating>
  );
}
