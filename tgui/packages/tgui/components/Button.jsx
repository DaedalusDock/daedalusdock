/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { KEY_ENTER, KEY_ESCAPE, KEY_SPACE } from 'common/keycodes';
import { classes } from 'common/react';
import { Component, createRef } from 'react';
import { Tooltip } from 'tgui-core/components';

import { createLogger } from '../logging';
import { Box, computeBoxClassName, computeBoxProps } from './Box';
import { Icon } from './Icon';

const logger = createLogger('Button');

export const Button = (props) => {
  const {
    className,
    fluid,
    icon,
    iconRotation,
    iconSpin,
    iconColor,
    iconPosition,
    color,
    disabled,
    selected,
    tooltip,
    tooltipPosition,
    ellipsis,
    compact,
    circular,
    content,
    children,
    noclip,
    onclick,
    onClick,
    verticalAlignContent,
    ...rest
  } = props;
  const hasContent = !!(content || children);

  rest.onClick = (e) => {
    if (!disabled && onClick) {
      onClick(e);
    }
  };

  let buttonContent = (
    <div
      className={classes([
        'Button',
        fluid && 'Button--fluid',
        disabled && 'Button--disabled',
        selected && 'Button--selected',
        hasContent && 'Button--hasContent',
        ellipsis && 'Button--ellipsis',
        circular && 'Button--circular',
        compact && 'Button--compact',
        iconPosition && 'Button--iconPosition--' + iconPosition,
        verticalAlignContent && 'Button--flex',
        verticalAlignContent && fluid && 'Button--flex--fluid',
        verticalAlignContent &&
          'Button--verticalAlignContent--' + verticalAlignContent,
        color && typeof color === 'string'
          ? 'Button--color--' + color
          : 'Button--color--default',
        noclip && 'Button--noClip',
        className,
        computeBoxClassName(rest),
      ])}
      tabIndex={!disabled && '0'}
      onKeyDown={(e) => {
        if (props.captureKeys === false) {
          return;
        }
        const keyCode = window.event ? e.which : e.keyCode;
        // Simulate a click when pressing space or enter.
        if (keyCode === KEY_SPACE || keyCode === KEY_ENTER) {
          e.preventDefault();
          if (!disabled && onClick) {
            onClick(e);
          }
          return;
        }
        // Refocus layout on pressing escape.
        if (keyCode === KEY_ESCAPE) {
          e.preventDefault();
          return;
        }
      }}
      {...computeBoxProps(rest)}
    >
      <div className="Button__content">
        {icon && iconPosition !== 'right' && (
          <Icon
            name={icon}
            color={iconColor}
            rotation={iconRotation}
            spin={iconSpin}
          />
        )}
        {content}
        {children}
        {icon && iconPosition === 'right' && (
          <Icon
            name={icon}
            color={iconColor}
            rotation={iconRotation}
            spin={iconSpin}
          />
        )}
      </div>
    </div>
  );

  if (tooltip) {
    buttonContent = (
      <Tooltip content={tooltip} position={tooltipPosition}>
        {buttonContent}
      </Tooltip>
    );
  }

  return buttonContent;
};

export const ButtonCheckbox = (props) => {
  const { checked, className, ...rest } = props;
  return (
    <Button
      color="transparent"
      icon={checked ? 'check-square-o' : 'square-o'}
      selected={checked}
      className={classes([className, 'Button--checkbox'])}
      {...rest}
    />
  );
};

Button.Checkbox = ButtonCheckbox;

export class ButtonConfirm extends Component {
  constructor(props) {
    super(props);
    this.state = {
      clickedOnce: false,
    };
    this.handleClick = () => {
      if (this.state.clickedOnce) {
        this.setClickedOnce(false);
      }
    };
  }

  setClickedOnce(clickedOnce) {
    this.setState({
      clickedOnce,
    });
    if (clickedOnce) {
      setTimeout(() => window.addEventListener('click', this.handleClick));
    } else {
      window.removeEventListener('click', this.handleClick);
    }
  }

  render() {
    const {
      className,
      confirmContent = 'Confirm?',
      confirmColor = 'bad',
      confirmIcon,
      icon,
      color,
      content,
      onClick,
      ...rest
    } = this.props;
    return (
      <Button
        content={this.state.clickedOnce ? confirmContent : content}
        icon={this.state.clickedOnce ? confirmIcon : icon}
        color={this.state.clickedOnce ? confirmColor : color}
        onClick={() =>
          this.state.clickedOnce ? onClick() : this.setClickedOnce(true)
        }
        className={classes([className, 'Button--confirm'])}
        {...rest}
      />
    );
  }
}

Button.Confirm = ButtonConfirm;

export class ButtonInput extends Component {
  constructor(props) {
    super(props);
    this.inputRef = createRef();
    this.state = {
      inInput: false,
    };
  }

  setInInput(inInput) {
    this.setState({
      inInput,
    });
    if (this.inputRef) {
      const input = this.inputRef.current;
      if (inInput) {
        input.value = this.props.currentValue || '';
        try {
          input.focus();
          input.select();
        } catch {}
      }
    }
  }

  commitResult(e) {
    if (this.inputRef) {
      const input = this.inputRef.current;
      const hasValue = input.value !== '';
      if (hasValue) {
        this.props.onCommit(e, input.value);
        return;
      } else {
        if (!this.props.defaultValue) {
          return;
        }
        this.props.onCommit(e, this.props.defaultValue);
      }
    }
  }

  render() {
    const {
      fluid,
      className,
      content,
      icon,
      iconRotation,
      iconSpin,
      tooltip,
      tooltipPosition,
      color = 'default',
      placeholder,
      maxLength,
      ...rest
    } = this.props;

    let buttonContent = (
      <Box
        className={classes([
          'Button',
          'Button--input',
          fluid && 'Button--fluid',
          'Button--color--' + color,
        ])}
        {...rest}
        onClick={() => this.setInInput(true)}
      >
        {icon && <Icon name={icon} rotation={iconRotation} spin={iconSpin} />}
        <div>{content}</div>
        <input
          ref={this.inputRef}
          className="NumberInput__input"
          style={{
            display: !this.state.inInput ? 'none' : undefined,
            textAlign: 'left',
          }}
          onBlur={(e) => {
            if (!this.state.inInput) {
              return;
            }
            this.setInInput(false);
            this.commitResult(e);
          }}
          onKeyDown={(e) => {
            if (e.keyCode === KEY_ENTER) {
              this.setInInput(false);
              this.commitResult(e);
              return;
            }
            if (e.keyCode === KEY_ESCAPE) {
              this.setInInput(false);
            }
          }}
        />
      </Box>
    );

    if (tooltip) {
      buttonContent = (
        <Tooltip content={tooltip} position={tooltipPosition}>
          {buttonContent}
        </Tooltip>
      );
    }

    return buttonContent;
  }
}

Button.Input = ButtonInput;
