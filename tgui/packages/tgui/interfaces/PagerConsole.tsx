import { Section, TextArea } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type PagerConsoleContext = {
  content: string;
};

export const PagerConsole = (_) => {
  const { act, data } = useBackend<PagerConsoleContext>();
  const { content } = data;

  return (
    <Window width={450} height={70} title="Pager Console">
      <Window.Content>
        <Section fitted>
          <TextArea
            autoFocus
            autoSelect
            dontUseTabForIndent
            selfClear
            height="2em"
            value={content}
            maxLength={42}
            onBlur={(value) =>
              act('UpdateContent', {
                message: value,
              })
            }
            onEnter={(value) =>
              act('Post', {
                message: value,
              })
            }
          />
        </Section>
      </Window.Content>
    </Window>
  );
};
