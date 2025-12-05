/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { classes } from 'common/react';

import { BoxProps, computeBoxClassName, computeBoxProps } from './Box';
import { Dimmer } from './Dimmer';

type ModalProps = {
  onDimmerClick?: Function;
} & BoxProps;

export const Modal = (props: ModalProps) => {
  const { className, children, onDimmerClick, ...rest } = props;
  return (
    <Dimmer onClick={onDimmerClick}>
      <div
        className={classes(['Modal', className, computeBoxClassName(rest)])}
        {...computeBoxProps(rest)}
      >
        {children}
      </div>
    </Dimmer>
  );
};
