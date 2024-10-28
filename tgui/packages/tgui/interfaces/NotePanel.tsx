import { useBackend, useSharedState } from '../backend';
import { Box, Section, Tabs, TextArea } from '../components';
import { Window } from '../layouts';

type NoteData = {
  memories: Note[];
};

type Note = {
  content: string;
  name: string;
};

export const NotePanel = (props) => {
  const { act, data } = useBackend<NoteData>();
  const [tab, setTab] = useSharedState('tab', 0);
  const memories = data.memories || [];
  return (
    <Window title={'Notes'} width={400} height={500}>
      <Window.Content>
        <Tabs>
          {memories.map((Note, i) => (
            <Tabs.Tab key={i} selected={i === tab} onClick={() => setTab(i)}>
              {Note.name}
            </Tabs.Tab>
          ))}
        </Tabs>
        {tab === 0 ? <CustomNoteTab /> : <NoteTab />}
      </Window.Content>
    </Window>
  );
};

export const NoteTab = (props) => {
  const { act, data } = useBackend<NoteData>();
  const [tab, setTab] = useSharedState('tab', 0);
  const memories = data.memories;
  const textHtml = {
    __html: memories[tab].content,
  };

  return (
    <Section height={'400px'}>
      <Box dangerouslySetInnerHTML={textHtml} />
    </Section>
  );
};

export const CustomNoteTab = (props) => {
  const { act, data } = useBackend<NoteData>();
  const [tab, setTab] = useSharedState('tab', 0);
  const memories = data.memories;
  return (
    <Section fitted>
      <TextArea
        fluid
        height={'400px'}
        value={memories[tab].content}
        maxLength={2048}
        onInput={(e, value) =>
          act('UpdateNote', {
            newnote: value,
          })
        }
      />
    </Section>
  );
};
