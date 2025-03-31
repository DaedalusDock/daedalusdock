/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { canRender, classes } from 'common/react';
import { Component, createRef, ReactNode, RefObject } from 'react';

import { addScrollableNode, removeScrollableNode } from '../events';
import { BoxProps, computeBoxClassName, computeBoxProps } from './Box';

interface SectionProps extends BoxProps {
  buttons?: ReactNode;
  className?: string;
  fill?: boolean;
  fitted?: boolean;
  /** @deprecated This property no longer works, please remove it. */
  level?: boolean;
  noTitleBorder?: boolean;
  /** @deprecated Please use `scrollable` property */
  overflowY?: any;
  scrollable?: boolean;
  title?: ReactNode;
}

export class Section extends Component<SectionProps> {
  scrollableRef: RefObject<HTMLDivElement>;
  scrollable: boolean;

  constructor(props) {
    super(props);
    this.scrollableRef = createRef();
    this.scrollable = props.scrollable;
  }

  componentDidMount() {
    if (this.scrollable) {
      addScrollableNode(this.scrollableRef.current);
    }
  }

  componentWillUnmount() {
    if (this.scrollable) {
      removeScrollableNode(this.scrollableRef.current);
    }
  }

  render() {
    const {
      className,
      title,
      buttons,
      fill,
      fitted,
      scrollable,
      children,
      noTitleBorder,
      ...rest
    } = this.props;
    const hasTitle = canRender(title) || canRender(buttons);
    return (
      <div
        className={classes([
          'Section',
          fill && 'Section--fill',
          fitted && 'Section--fitted',
          scrollable && 'Section--scrollable',
          className,
          computeBoxClassName(rest),
        ])}
        {...computeBoxProps(rest)}
      >
        {hasTitle && (
          <div
            className={classes([
              'Section__title',
              noTitleBorder && 'Section--titleBorderless',
            ])}
          >
            <span className="Section__titleText">{title}</span>
            <div className="Section__buttons">{buttons}</div>
          </div>
        )}
        <div className="Section__rest">
          <div ref={this.scrollableRef} className="Section__content">
            {children}
          </div>
        </div>
      </div>
    );
  }
}
