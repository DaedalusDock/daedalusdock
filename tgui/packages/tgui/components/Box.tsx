/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { BooleanLike, classes } from 'common/react';
import { createElement, HTMLAttributes, ReactNode } from 'react';
import { CSS_COLORS } from '../constants';

export interface BoxProps {
  [key: string]: any;
  as?: string;
  className?: string | BooleanLike;
  children?: ReactNode;
  position?: string | BooleanLike;
  overflow?: string | BooleanLike;
  overflowX?: string | BooleanLike;
  overflowY?: string | BooleanLike;
  top?: string | BooleanLike;
  bottom?: string | BooleanLike;
  left?: string | BooleanLike;
  right?: string | BooleanLike;
  width?: string | BooleanLike;
  minWidth?: string | BooleanLike;
  maxWidth?: string | BooleanLike;
  height?: string | BooleanLike;
  minHeight?: string | BooleanLike;
  maxHeight?: string | BooleanLike;
  fontSize?: string | BooleanLike;
  fontFamily?: string;
  lineHeight?: string | BooleanLike;
  opacity?: number;
  textAlign?: string | BooleanLike;
  verticalAlign?: string | BooleanLike;
  inline?: BooleanLike;
  bold?: BooleanLike;
  italic?: BooleanLike;
  nowrap?: BooleanLike;
  preserveWhitespace?: BooleanLike;
  m?: string | BooleanLike;
  mx?: string | BooleanLike;
  my?: string | BooleanLike;
  mt?: string | BooleanLike;
  mb?: string | BooleanLike;
  ml?: string | BooleanLike;
  mr?: string | BooleanLike;
  p?: string | BooleanLike;
  px?: string | BooleanLike;
  py?: string | BooleanLike;
  pt?: string | BooleanLike;
  pb?: string | BooleanLike;
  pl?: string | BooleanLike;
  pr?: string | BooleanLike;
  color?: string | BooleanLike;
  textColor?: string | BooleanLike;
  backgroundColor?: string | BooleanLike;
  fillPositionedParent?: boolean;
}

/**
 * Coverts our rem-like spacing unit into a CSS unit.
 */
export const unit = (value: unknown): string | undefined => {
  if (typeof value === 'string') {
    // Transparently convert pixels into rem units
    if (value.endsWith('px') && !Byond.IS_LTE_IE8) {
      return parseFloat(value) / 12 + 'rem';
    }
    return value;
  }
  if (typeof value === 'number') {
    if (Byond.IS_LTE_IE8) {
      return value * 12 + 'px';
    }
    return value + 'rem';
  }
};

/**
 * Same as `unit`, but half the size for integers numbers.
 */
export const halfUnit = (value: unknown): string | undefined => {
  if (typeof value === 'string') {
    return unit(value);
  }
  if (typeof value === 'number') {
    return unit(value * 0.5);
  }
};

const isColorCode = (str: unknown) => !isColorClass(str);

const isColorClass = (str: unknown): boolean => {
  return typeof str === 'string' && CSS_COLORS.includes(str);
};

const mapRawPropTo = (attrName) => (style, value) => {
  if (typeof value === 'number' || typeof value === 'string') {
    style[attrName] = value;
  }
};

const mapUnitPropTo = (attrName, unit) => (style, value) => {
  if (typeof value === 'number' || typeof value === 'string') {
    style[attrName] = unit(value);
  }
};

const mapBooleanPropTo = (attrName, attrValue) => (style, value) => {
  if (value) {
    style[attrName] = attrValue;
  }
};

const mapDirectionalUnitPropTo = (attrName, unit, dirs) => (style, value) => {
  if (typeof value === 'number' || typeof value === 'string') {
    for (let i = 0; i < dirs.length; i++) {
      style[attrName + '-' + dirs[i]] = unit(value);
    }
  }
};

const mapColorPropTo = (attrName) => (style, value) => {
  if (isColorCode(value)) {
    style[attrName] = value;
  }
};

const styleMapperByPropName = {
  // Direct mapping
  position: mapRawPropTo('position'),
  overflow: mapRawPropTo('overflow'),
  overflowX: mapRawPropTo('overflowX'),
  overflowY: mapRawPropTo('overflowY'),
  top: mapUnitPropTo('top', unit),
  bottom: mapUnitPropTo('bottom', unit),
  left: mapUnitPropTo('left', unit),
  right: mapUnitPropTo('right', unit),
  width: mapUnitPropTo('width', unit),
  minWidth: mapUnitPropTo('minWidth', unit),
  maxWidth: mapUnitPropTo('maxWidth', unit),
  height: mapUnitPropTo('height', unit),
  minHeight: mapUnitPropTo('minHeight', unit),
  maxHeight: mapUnitPropTo('maxHeight', unit),
  fontSize: mapUnitPropTo('fontSize', unit),
  fontFamily: mapRawPropTo('fontFamily'),
  lineHeight: (style, value) => {
    if (typeof value === 'number') {
      style['lineHeight'] = value;
    } else if (typeof value === 'string') {
      style['lineHeight'] = unit(value);
    }
  },
  opacity: mapRawPropTo('opacity'),
  textAlign: mapRawPropTo('textAlign'),
  verticalAlign: mapRawPropTo('verticalAlign'),
  // Boolean props
  inline: mapBooleanPropTo('display', 'inline-block'),
  bold: mapBooleanPropTo('fontWeight', 'bold'),
  italic: mapBooleanPropTo('fontStyle', 'italic'),
  nowrap: mapBooleanPropTo('whiteSpace', 'nowrap'),
  preserveWhitespace: mapBooleanPropTo('whiteSpace', 'pre-wrap'),
  // Margins
  m: mapDirectionalUnitPropTo('margin', halfUnit, [
    'top',
    'bottom',
    'left',
    'right',
  ]),
  mx: mapDirectionalUnitPropTo('margin', halfUnit, ['left', 'right']),
  my: mapDirectionalUnitPropTo('margin', halfUnit, ['top', 'bottom']),
  mt: mapUnitPropTo('marginTop', halfUnit),
  mb: mapUnitPropTo('marginBottom', halfUnit),
  ml: mapUnitPropTo('marginLeft', halfUnit),
  mr: mapUnitPropTo('marginRight', halfUnit),
  // Margins
  p: mapDirectionalUnitPropTo('padding', halfUnit, [
    'top',
    'bottom',
    'left',
    'right',
  ]),
  px: mapDirectionalUnitPropTo('padding', halfUnit, ['left', 'right']),
  py: mapDirectionalUnitPropTo('padding', halfUnit, ['top', 'bottom']),
  pt: mapUnitPropTo('paddingTop', halfUnit),
  pb: mapUnitPropTo('paddingBottom', halfUnit),
  pl: mapUnitPropTo('paddingLeft', halfUnit),
  pr: mapUnitPropTo('paddingRight', halfUnit),
  // Color props
  color: mapColorPropTo('color'),
  textColor: mapColorPropTo('color'),
  backgroundColor: mapColorPropTo('backgroundColor'),
  // Utility props
  fillPositionedParent: (style, value) => {
    if (value) {
      style['position'] = 'absolute';
      style['top'] = 0;
      style['bottom'] = 0;
      style['left'] = 0;
      style['right'] = 0;
    }
  },
};

export const computeBoxProps = (props: BoxProps) => {
  const computedProps: HTMLAttributes<any> = {};
  const computedStyles = {};
  // Compute props
  for (let propName in props) {
    if (propName === 'style') {
      continue;
    }
    // IE8: onclick workaround
    if (Byond.IS_LTE_IE8 && propName === 'onClick') {
      computedProps.onClick = props[propName];
      continue;
    }
    const propValue = props[propName];
    const mapPropToStyle = styleMapperByPropName[propName];
    if (mapPropToStyle) {
      mapPropToStyle(computedStyles, propValue);
    } else {
      computedProps[propName] = propValue;
    }
  }

  if (props.style) {
    computedProps.style = { ...computedProps.style, ...props.style };
  }

  return computedProps;
};

export const computeBoxClassName = (props: BoxProps) => {
  const color = props.textColor || props.color;
  const backgroundColor = props.backgroundColor;
  return classes([
    isColorClass(color) && 'color-' + color,
    isColorClass(backgroundColor) && 'color-bg-' + backgroundColor,
  ]);
};

export const Box = (props: BoxProps) => {
  const { as = 'div', className, children, ...rest } = props;

  // Compute class name and styles
  const computedClassName = className
    ? `${className} ${computeBoxClassName(rest)}`
    : computeBoxClassName(rest);
  const computedProps = computeBoxProps(rest);

  if (as === 'img') {
    computedProps.style!['-ms-interpolation-mode'] = 'nearest-neighbor';
  }

  // Render the component
  return createElement(
    typeof as === 'string' ? as : 'div',
    {
      ...computedProps,
      className: computedClassName,
    },
    children,
  );
};
