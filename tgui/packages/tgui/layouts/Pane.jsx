/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { Box } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import { useBackend } from '../backend';
import { useDebug } from '../debug';
import { Layout } from './Layout';

export const Pane = (props) => {
  const { theme, children, className, ...rest } = props;
  const { suspended } = useBackend();
  const { debugLayout = false } = useDebug();
  return (
    <Layout className={classes(['Window', className])} theme={theme} {...rest}>
      <Box fillPositionedParent className={debugLayout && 'debug-layout'}>
        {!suspended && children}
      </Box>
    </Layout>
  );
};

const PaneContent = (props) => {
  const { className, fitted, children, ...rest } = props;
  return (
    <Layout.Content
      className={classes(['Window__content', className])}
      {...rest}
    >
      {fitted ? (
        children
      ) : (
        <div className="Window__contentPadding">{children}</div>
      )}
    </Layout.Content>
  );
};

Pane.Content = PaneContent;
