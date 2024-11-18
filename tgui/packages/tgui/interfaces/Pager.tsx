import { useBackend } from '../backend';
import { BlockQuote, Section } from '../components';
import { Window } from '../layouts';

type PagerContext = {
  messages: [];
  the_time: string;
};

export const Pager = (_) => {
  const { data } = useBackend<PagerContext>();
  const { messages, the_time } = data;

  return (
    <Window width={450} height={280} title="Pager">
      <Window.Content>
        <Section fill title={'ThinkDOS Pager | ' + the_time}>
          {messages.toReversed().map((message, i) => (
            <BlockQuote key={i}>{message}</BlockQuote>
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};
