import {
  Component,
  createRef,
  HTMLAttributes,
  ReactNode,
  RefObject,
} from 'react';

const DEFAULT_ACCEPTABLE_DIFFERENCE = 5;

export class FitText extends Component<
  {
    acceptableDifference?: number;
    children: ReactNode;
    maxFontSize: number;
    maxWidth: number;
    native?: HTMLAttributes<HTMLDivElement>;
  },
  {
    fontSize: number;
  }
> {
  ref: RefObject<HTMLDivElement> = createRef();
  state = {
    fontSize: 0,
  };

  constructor(props) {
    super(props);

    this.resize = this.resize.bind(this);

    window.addEventListener('resize', this.resize);
  }

  componentDidUpdate(prevProps) {
    if (prevProps.children !== this.props.children) {
      this.resize();
    }
  }

  componentWillUnmount() {
    window.removeEventListener('resize', this.resize);
  }

  resize() {
    const element = this.ref.current;
    if (!element) {
      return;
    }

    const maxWidth = this.props.maxWidth;

    let start = 0;
    let end = this.props.maxFontSize;

    for (let _ = 0; _ < 10; _++) {
      const middle = Math.round((start + end) / 2);
      element.style.fontSize = `${middle}px`;

      const difference = element.offsetWidth - maxWidth;

      if (difference > 0) {
        end = middle;
      } else if (
        difference <
        (this.props.acceptableDifference ?? DEFAULT_ACCEPTABLE_DIFFERENCE)
      ) {
        start = middle;
      } else {
        break;
      }
    }

    this.setState({
      fontSize: Math.round((start + end) / 2),
    });
  }

  componentDidMount() {
    this.resize();
  }

  render() {
    return (
      <span
        ref={this.ref}
        style={{
          fontSize: `${this.state.fontSize}px`,
          ...(typeof this.props.native?.style === 'object' &&
            this.props.native.style),
        }}
      >
        {this.props.children}
      </span>
    );
  }
}
