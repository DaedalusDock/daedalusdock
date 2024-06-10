import { ReactNode } from 'react';

import { useBackend, useLocalState } from '../../backend';
import {
  Box,
  Button,
  Flex,
  Input,
  LabeledList,
  Section,
  Tooltip,
} from '../../components';

/**
 * This describes something that influences a particular reaction
 * E.G.
 * factor_id = 'oxygen'
 * factor_id_type = 'gas'
 * factor_name = 'Oxygen
 * reaction_id = 'plasmafire'
 * desc = 'Influences the burn rate and consumption ratio.'
 */

type Factor = {
  desc: string;
  factor_id?: string;
  factor_name: string;

  factor_type: 'gas' | 'misc';
  tooltip?: string;
};

type Reaction = {
  description: string;
  factors: Factor[];
  id: string;
  name: string;
};

type Gas = {
  description: string;
  id: string;
  name: string;
  reactions: { [key: string]: string } | [];
  specific_heat: number;
};

const GasSearchBar = (props: {
  activeInput: boolean;
  onChange: (inputValue: string) => void;
  setActiveInput: (toggle: boolean) => void;
  title: ReactNode;
}) => {
  const { title, onChange, activeInput, setActiveInput } = props;
  return (
    <Flex align="center">
      <Flex.Item grow>
        {activeInput ? (
          <Input
            fluid
            onChange={(e, value) => {
              setActiveInput(false);
              onChange(value);
            }}
          />
        ) : (
          title
        )}
      </Flex.Item>
      <Flex.Item>
        <Button icon="search" onClick={() => setActiveInput(!activeInput)} />
      </Flex.Item>
    </Flex>
  );
};

const GasHandbook = (props) => {
  const { act, data } = useBackend<{ gasInfo: Gas[] }>();
  const { gasInfo } = data;
  const [activeGasId, setActiveGasId] = useLocalState('activeGasId', '');
  const [activeReactionId, setActiveReactionId] = useLocalState(
    'activeReactionId',
    '',
  );
  const [gasActiveInput, setGasActiveInput] = useLocalState(
    'gasActiveInput',
    false,
  );
  const relevantGas = gasInfo.find((gas) => gas.id === activeGasId);
  return (
    <Section
      title={
        <GasSearchBar
          title={relevantGas ? 'Gas: ' + relevantGas.name : 'Gas Lookup'}
          onChange={(keyword) =>
            setActiveGasId(
              gasInfo.find((gas) =>
                gas.name.toLowerCase().startsWith(keyword.toLowerCase()),
              )?.id || '',
            )
          }
          activeInput={gasActiveInput}
          setActiveInput={setGasActiveInput}
        />
      }
    >
      {relevantGas && (
        <>
          <Box mb="0.5em">{relevantGas.description}</Box>
          <Box mb="0.5em">
            {'Specific heat: ' + relevantGas.specific_heat + ' Joule/KelvinMol'}
          </Box>
          <Box mb="0.5em">{'Relevant Reactions:'}</Box>
          {Object.entries(relevantGas.reactions).map(
            ([reaction_id, reaction_name]) => (
              <Box key={reaction_id} mb="0.5em">
                <Button
                  onClick={() => setActiveReactionId(reaction_id)}
                  content={reaction_name}
                />
              </Box>
            ),
          )}
        </>
      )}
    </Section>
  );
};

const ReactionHandbook = (props) => {
  const { act, data } = useBackend<{ reactionInfo: Reaction[] }>();
  const { reactionInfo } = data;
  const [activeGasId, setActiveGasId] = useLocalState('activeGasId', '');
  const [activeReactionId, setActiveReactionId] = useLocalState(
    'activeReactionId',
    '',
  );
  const [reactionActiveInput, setReactionActiveInput] = useLocalState(
    'reactionActiveInput',
    false,
  );
  const relevantReaction = reactionInfo?.find(
    (reaction) => reaction.id === activeReactionId,
  );
  return (
    <Section
      title={
        <GasSearchBar
          title={
            relevantReaction
              ? 'Reaction: ' + relevantReaction.name
              : 'Reaction Lookup'
          }
          onChange={(keyword) =>
            setActiveReactionId(
              reactionInfo.find((reaction) =>
                reaction.name.toLowerCase().startsWith(keyword.toLowerCase()),
              )?.id || '',
            )
          }
          activeInput={reactionActiveInput}
          setActiveInput={setReactionActiveInput}
        />
      }
    >
      {relevantReaction && (
        <>
          <Box mb="0.5em">{relevantReaction.description}</Box>
          <Box mb="0.5em">{'Relevant Factors:'}</Box>
          <LabeledList>
            {relevantReaction.factors.map((factor) => (
              <LabeledList.Item
                key={`${relevantReaction.id}_${factor.factor_name}`}
                label={
                  factor.factor_type === 'gas' && factor.factor_id ? (
                    <Button
                      onClick={() => setActiveGasId(String(factor.factor_id))}
                      content={factor.factor_name}
                    />
                  ) : factor.tooltip ? (
                    <Tooltip content={factor.tooltip} position="top">
                      <Flex>
                        <Flex.Item
                          style={{ borderBottom: 'dotted 2px' }}
                          shrink
                        >
                          {factor.factor_name + ':'}
                        </Flex.Item>
                      </Flex>
                    </Tooltip>
                  ) : (
                    factor.factor_name
                  )
                }
              >
                {factor.desc}
              </LabeledList.Item>
            ))}
          </LabeledList>
        </>
      )}
    </Section>
  );
};

export const atmosHandbookHooks = () => {
  const [activeGasId, setActiveGasId] = useLocalState('activeGasId', '');
  const [activeReactionId, setActiveReactionId] = useLocalState(
    'activeReactionId',
    '',
  );
  return [setActiveGasId, setActiveReactionId];
};
