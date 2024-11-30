import { useBackend } from '../backend';
import { Section } from '../components';
import { Window } from '../layouts';
import type { Gasmix } from './common/GasmixParser';
import { GasmixParser } from './common/GasmixParser';

export const GasAnalyzerContent = (props) => {
  const { act, data } = useBackend<{ gasmixes: Gasmix[] }>();
  const { gasmixes } = data;
  return (
    <>
      {gasmixes.map((gasmix) => (
        <Section title={gasmix.name} key={gasmix.reference}>
          <GasmixParser gasmix={gasmix} />
        </Section>
      ))}
    </>
  );
};

export const GasAnalyzer = (props) => {
  return (
    <Window width={500} height={450}>
      <Window.Content scrollable>
        <GasAnalyzerContent />
      </Window.Content>
    </Window>
  );
};
