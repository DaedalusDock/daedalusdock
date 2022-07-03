import { useBackend } from '../backend';
import { GasmixParser } from './common/GasmixParser';
import type { Gasmix } from './common/GasmixParser';
import { Window } from '../layouts';
import { Section } from '../components';

export const GasAnalyzerContent = (props, context) => {
  const { act, data } = useBackend<{ gasmixes: Gasmix[] }>(context);
  const { gasmixes } = data;
  return (
    <>
      {gasmixes.map((gasmix) => (
        <Section title={gasmix.name} key={gasmix.reference}>
          <GasmixParser
            gasmix={gasmix}
          />
        </Section>
      ))}
    </>
  );
};

export const GasAnalyzer = (props, context) => {
  return (
    <Window width={500} height={450}>
      <Window.Content scrollable>
        <GasAnalyzerContent />
      </Window.Content>
    </Window>
  );
};
