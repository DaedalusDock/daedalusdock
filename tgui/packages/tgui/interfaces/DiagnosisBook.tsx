import { useBackend } from '../backend';
import { Button, Flex, Section } from '../components';
import { Window } from '../layouts';

type Condition = {
  desc: string;
  name: string;
  path: string;
  symptoms: string[];
  treatment: string;
};

type MobData = {
  name: string | undefined;
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
  mob: MobData;
  selected_symptoms: string[];
  symptom_categories: string[];
  symptoms: Symptom[];
};

export const DiagnosisBook = (_) => {
  return (
    <Window width={800} height={600} title="Diagnosis Book">
      <Window.Content>
        <Flex fill justify="center" height="100%">
          <PatientInfo />
          <SymptomInfo />
          <ConditionInfo />
        </Flex>
      </Window.Content>
    </Window>
  );
};

export const PatientInfo = (_) => {
  const { act, data } = useBackend<DiagnosisBookData>();
  const { mob } = data;
  return (
    <Flex.Item width="20%" height="100%">
      <Section title="Patient" height="100%">
        <Flex direction="column">
          <Flex.Item>{`Name: ${mob.name || ''}`}</Flex.Item>
          <Flex.Item>{`Time: ${mob.time || ''}`}</Flex.Item>
        </Flex>
      </Section>
    </Flex.Item>
  );
};

export const SymptomInfo = (_) => {
  const { act, data } = useBackend<DiagnosisBookData>();
  const { symptoms, symptom_categories } = data;
  return (
    <Flex.Item width="40%" height="100%">
      <Section title="Suspected Symptoms" height="100%" fill scrollable>
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
                      : 'red'
                  }
                  tooltip={symptom.desc}
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
    <Flex.Item width="40%" height="100%">
      <Section title="Conditons" height="100%" fill scrollable>
        <Flex direction="column">
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
  return (
    <Flex.Item>
      <Section
        title={
          <span>
            {condition.name}
            <Button
              icon="question"
              tooltip={condition.desc}
              style={{ marginLeft: '8px' }}
            />
          </span>
        }
      >
        {printConditionSymptoms(condition)}
      </Section>
    </Flex.Item>
  );
}

function printConditionSymptoms(condition: Condition) {
  const { data } = useBackend<DiagnosisBookData>();
  const { symptoms, selected_symptoms } = data;
  let strings: string[] = [];
  for (const symptom_name of condition.symptoms) {
    const symptom_object = symptoms.find(
      (symptom) => symptom.name === symptom_name,
    );
    if (typeof symptom_object === 'undefined') {
      continue;
    }

    if (selected_symptoms.includes(symptom_object.path)) {
      strings.push(symptom_object.name);
    } else {
      strings.push(
        `<span style='text-decoration: line-through'>${symptom_object.name}</span>`,
      );
    }
  }
  const text_html = { __html: strings.join(' | ') };
  /* eslint-disable react/no-danger */
  return <span dangerouslySetInnerHTML={text_html} />;
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
