import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Button, NoticeBox, Section, Table } from '../components';
import { NtosWindow } from '../layouts';
import { ManifestEntry } from './CrewManifest';

type NtosCrewManifestData = {
  have_printer: BooleanLike;
  manifest: Record<string, ManifestEntry[]>;
  manifest_key: string;
};

export const NtosCrewManifest = (props) => {
  const { act, data } = useBackend<NtosCrewManifestData>();
  const { have_printer, manifest = {}, manifest_key } = data;
  return (
    <NtosWindow width={500} height={480}>
      <NtosWindow.Content scrollable>
        <Section
          title="Staff Manifest"
          buttons={
            <Button
              icon="print"
              content="Print"
              disabled={!have_printer}
              onClick={() => act('PRG_print')}
            />
          }
        >
          <CrewManifest manifest={manifest} manifest_key={manifest_key} />
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};

type CrewManifestProps = {
  manifest: Record<string, ManifestEntry[]>;
  manifest_key: string;
};

const CrewManifest = (props: CrewManifestProps) => {
  const { manifest, manifest_key } = props;
  if (!manifest_key) {
    return <NoticeBox danger>ERROR - NO IDENTIFICATION FOUND.</NoticeBox>;
  }

  return Object.entries(manifest).map(([department, department_manifest]) => (
    <Section key={department} title={department}>
      <Table>
        {department_manifest.map((manifest_entry: ManifestEntry) => (
          <Table.Row key={manifest_entry.name} className="candystripe">
            <Table.Cell bold>{manifest_entry.name}</Table.Cell>
            <Table.Cell>{manifest_entry.rank}</Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  ));
};
