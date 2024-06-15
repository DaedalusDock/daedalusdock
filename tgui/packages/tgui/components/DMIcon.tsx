import { Component, ReactNode } from 'react';

import { resolveAsset } from '../assets';
import { fetchRetry } from '../http';
import { logger } from '../logging';
import { BoxProps } from './Box';
import { Image } from './Image';

enum Direction {
  NORTH = 1,
  SOUTH = 2,
  EAST = 4,
  WEST = 8,
  NORTHEAST = 5,
  NORTHWEST = 9,
  SOUTHEAST = 6,
  SOUTHWEST = 10,
}

type Props = {
  /** Required: The path of the icon */
  icon: string;
  /** Required: The state of the icon */
  icon_state: string;
} & Partial<{
  /** Facing direction. See direction enum. Default is South */
  direction: Direction;
  /** Fallback icon. */
  fallback: ReactNode;
  /** Frame number. Default is 1 */
  frame: number;
  /** Movement state. Default is false */
  movement: boolean;
}> &
  BoxProps;

type State = {
  iconRef: string;
};

let refMap: Record<string, string> | undefined;

export class DmIcon extends Component<Props, State> {
  state = {
    iconRef: '',
  };

  constructor(props) {
    super(props);
  }

  componentDidMount() {
    this.fetchRefMap();
  }

  async fetchRefMap() {
    const { icon } = this.props;

    if (refMap) {
      this.setState({ iconRef: refMap[icon] });
      return;
    }

    try {
      const response = await fetchRetry(resolveAsset('icon_ref_map.json'));
      const data = await response.json();
      if (!refMap) {
        refMap = data;
      }
      this.setState({ iconRef: data[icon] });
    } catch (error) {
      logger.error('Error fetching icon ref map:', error);
    }
  }

  render() {
    const {
      className,
      direction = Direction.SOUTH,
      fallback,
      frame = 1,
      icon_state,
      icon,
      movement = false,
      ...rest
    } = this.props;

    const { iconRef } = this.state;
    if (!iconRef) return fallback;

    const query = `${iconRef}?state=${icon_state}&dir=${direction}&movement=${movement}&frame=${frame}`;

    return <Image fixErrors src={query} {...rest} />;
  }
}
