import { classes } from 'common/react';
import React from 'react';

import { useBackend } from '../backend';
import { Box, Button, ByondUi, Flex, Section, TextArea } from '../components';
import { Window } from '../layouts';

type Condition = {
  desc: string;
  name: string;
  path: string;
  symptoms: string[];
  treatment: string;
};

type MobData = {
  diagnosis: string | undefined;
  name: string | undefined;
  occupation: string | undefined;
  time: string | undefined;
};

type Symptom = {
  category: string;
  desc: string;
  name: string;
  path: string;
};

type DiagnosisBookData = {
  conditions: Condition[];
  map_ref: string;
  mob: MobData;
  selected_symptoms: string[];
  symptom_categories: string[];
  symptoms: Symptom[];
};

export const DiagnosisBook = (_) => {
  return (
    <Window width={1000} height={600} title="Diagnosis Book" theme="book">
      <Window.Content>
        <Flex fill justify="center" height="100%" width>
          <PatientInfo />
          <SymptomInfo />
          <ConditionInfo />
        </Flex>
      </Window.Content>
    </Window>
  );
};

export const PatientInfo = (_) => {
  const { data } = useBackend<DiagnosisBookData>();
  const { mob } = data;
  return (
    <Flex.Item
      width="30%"
      height="100%"
      className="DiagnosisBook__patientBlock"
    >
      <Section height="100%">
        <Flex direction="column">
          <PatientAppearance />
          <PatientEntry
            fieldName="Patient"
            actName="name"
            actValue={mob.name || ''}
          />
          <PatientEntry
            fieldName="Occupation"
            actName="occupation"
            actValue={mob.occupation || ''}
          />
          <PatientEntry
            fieldName="Time"
            actName="time"
            actValue={mob.time || ''}
          />
          <DiagnoseButton />
        </Flex>
      </Section>
    </Flex.Item>
  );
};

export const PatientAppearance = (_) => {
  const { data } = useBackend<DiagnosisBookData>();
  const { map_ref, mob } = data;
  return (
    <Flex.Item>
      <Flex justify="center" direction="row">
        <Flex.Item>
          <ByondUi
            height="256px"
            width="256px"
            params={{ id: map_ref, type: 'map' }}
          />
        </Flex.Item>
      </Flex>
    </Flex.Item>
  );
};

export const PatientEntry = (props) => {
  const { act } = useBackend<DiagnosisBookData>();
  const { fieldName, actName, actValue } = props;
  return (
    <Flex.Item>
      <Flex direction="row" align="baseline">
        <Box
          style={{
            fontSize: '200%',
            marginRight: '8px',
            width: '40%',
            fontWeight: 'bold',
          }}
        >
          {`${fieldName}:`}
        </Box>
        <Box width="60%" className="DiagnosisBook__textFieldContainer">
          <TextArea
            top="3px"
            height="1.8rem"
            maxLength={15}
            value={actValue}
            onChange={(e, value) => act('update_mob', { [actName]: value })}
            noborder
            innerClassName="DiagnosisBook__textAreaInner"
          />
        </Box>
      </Flex>
    </Flex.Item>
  );
};

export const DiagnoseButton = (_) => {
  const { data, act } = useBackend<DiagnosisBookData>();
  const { mob } = data;
  const diagnosis = mob.diagnosis;
  return (
    <Flex.Item style={{ marginTop: '40px' }}>
      <Flex direction="column" align="center" justify="center">
        <Box
          style={{
            fontSize: '200%',
            marginBottom: '8px',
            fontWeight: 'bold',
          }}
        >
          Diagnosis
        </Box>
        <Box width="60%" className="DiagnosisBook__textFieldContainer">
          <TextArea
            innerClassName="DiagnosisBook__textAreaInner"
            top="3px"
            width="100%"
            height="1.8rem"
            maxLength={15}
            value={diagnosis || ''}
            onChange={(e, value) => act('update_mob', { diagnosis: value })}
            noborder
          />
        </Box>
        <Flex.Item>
          <Button
            mt="8px"
            disabled={!diagnosis}
            onClick={() => act('diagnose', { diagnosis: diagnosis })}
          >
            <span style={!diagnosis ? { color: '#FFFFFF' } : {}}>Diagnose</span>
          </Button>
        </Flex.Item>
      </Flex>
    </Flex.Item>
  );
};

export const SymptomInfo = (_) => {
  const { act, data } = useBackend<DiagnosisBookData>();
  const { symptoms, symptom_categories } = data;
  return (
    <Flex.Item width="35%" height="100%">
      <Section
        title={
          <Box className="DiagnosisBook__symptomBlockTitle">
            Suspected Symptoms
            <hr />
          </Box>
        }
        height="100%"
        fill
        scrollable
        noTitleBorder
      >
        <Flex direction="column">
          {symptom_categories
            .sort()
            .map((category_name, i) =>
              symptomInfoEntry(category_name, i, symptoms),
            )}
        </Flex>
      </Section>
    </Flex.Item>
  );
};

function symptomInfoEntry(
  category_name: string,
  i: number,
  symptoms: Array<Symptom>,
) {
  const { act, data } = useBackend<DiagnosisBookData>();
  return (
    <Flex.Item>
      <Section title={category_name}>
        <Flex direction="row" wrap="wrap">
          {symptoms
            .filter((symptom) => symptom.category === category_name)
            .map((symptom, i) => (
              <Flex.Item key={i}>
                <Button
                  color={
                    data.selected_symptoms.includes(symptom.path)
                      ? 'green'
                      : 'default'
                  }
                  tooltip={symptom.desc}
                  tooltipPosition="bottom-start"
                  onClick={() => act('cycle_symptom', { path: symptom.path })}
                >
                  {symptom.name}
                </Button>
              </Flex.Item>
            ))}
        </Flex>
      </Section>
    </Flex.Item>
  );
}

export const ConditionInfo = (_) => {
  const { act, data } = useBackend<DiagnosisBookData>();
  const { conditions } = data;
  return (
    <Flex.Item width="35%" height="100%">
      <Section
        title={
          <Box
            style={{
              fontSize: '200%',
              textAlign: 'center',
              color: '#B7A486',
            }}
          >
            Diagnoses
          </Box>
        }
        height="100%"
        fill
        scrollable
        noTitleBorder
        style={{ backgroundColor: 'black', color: '#B7A486' }}
      >
        <Flex
          direction="column"
          className="DiagnosisBook__conditionBlockContainer"
        >
          {conditions
            .sort(compareConditions)
            .map((condition) => conditionInfoEntry(condition))}
        </Flex>
      </Section>
    </Flex.Item>
  );
};

// Sort() compare function, compares conditions based on how many of their symptoms are selected by the user.
// Uses name if they are equivalent.
function compareConditions(a: Condition, b: Condition) {
  const { data } = useBackend<DiagnosisBookData>();
  const { selected_symptoms } = data;
  const a_matches = a.symptoms.filter((symptom_name) =>
    selected_symptoms.includes(getSymptomByName(symptom_name).path),
  ).length;
  const b_matches = b.symptoms.filter((symptom_name) =>
    selected_symptoms.includes(getSymptomByName(symptom_name).path),
  ).length;

  // Equivalent match count, use name instead
  if (a_matches === b_matches) {
    return a.name.localeCompare(b.name);
  }

  return b_matches - a_matches;
}

function conditionInfoEntry(condition: Condition) {
  const { data, act } = useBackend<DiagnosisBookData>();
  const { mob } = data;
  const diagnosis = mob.diagnosis;
  const is_selected = diagnosis === condition.name;
  return (
    <Flex.Item
      className={classes([
        'DiagnosisBook__conditionBlock',
        is_selected && 'DiagnosisBook__conditionBlock--selectedCondition',
      ])}
      onClick={() =>
        act('update_mob', { diagnosis: is_selected ? '' : condition.name })
      }
    >
      <Flex direction="column">
        <Flex.Item>
          <Box className="DiagnosisBook__conditionBlockHeader">
            <span style={{ fontSize: '150%' }}>
              {condition.name}
              <Button
                fontSize="60%"
                icon="question"
                tooltip={condition.desc}
                style={{ marginLeft: '8px' }}
                onClick={(event) => event.stopPropagation()}
              />
            </span>
          </Box>
        </Flex.Item>
        <Flex.Item>
          <Box className="DiagnosisBook__conditionBlockBody">
            {printConditionSymptoms(condition)}
          </Box>
        </Flex.Item>
      </Flex>
    </Flex.Item>
  );
}

function printConditionSymptoms(condition: Condition) {
  const { data } = useBackend<DiagnosisBookData>();
  const { symptoms, selected_symptoms } = data;
  let elements: React.JSX.Element[] = [];
  for (const symptom_name of condition.symptoms.sort()) {
    const symptom_object = symptoms.find(
      (symptom) => symptom.name === symptom_name,
    );
    if (typeof symptom_object === 'undefined') {
      continue;
    }

    if (selected_symptoms.includes(symptom_object.path)) {
      elements.push(
        <span
          style={{
            fontSize: '150%',
            textWrap: 'nowrap',
            display: 'inline-block',
          }}
        >
          {symptom_object.name}
        </span>,
      );
    } else {
      elements.push(
        <span
          style={{
            textDecoration: 'line-through',
            fontSize: '150%',
            textWrap: 'nowrap',
            display: 'inline-block',
          }}
        >
          {symptom_object.name}
        </span>,
      );
    }
  }

  return joinElementArray(
    elements,
    <span style={{ margin: '0px 4px' }}>|</span>,
  );
}

/**
 * Joins an array of React Nodes elements with an optional separator.
 * @param {React.ReactNode[]} spans - The array of <span> elements to join.
 * @param {React.ReactNode} [separator] - The optional separator <span> element.
 * @returns {React.JSX.Element[]} The joined <span> elements with the separator in between.
 */
function joinElementArray(
  elements: React.ReactNode[],
  separator?: React.ReactNode,
) {
  return elements.map((element, index) => (
    <React.Fragment key={index}>
      {element}
      {index < elements.length - 1 && separator}
    </React.Fragment>
  ));
}

function getSymptomByName(symptom_name: string) {
  const { data } = useBackend<DiagnosisBookData>();
  const { symptoms } = data;
  const symptom_object = symptoms.find(
    (symptom) => symptom.name === symptom_name,
  );
  if (typeof symptom_object === 'undefined') {
    throw new Error('Undefined symptom object');
  }
  return symptom_object;
}
