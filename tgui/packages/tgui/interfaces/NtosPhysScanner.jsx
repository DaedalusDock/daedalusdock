import { useBackend } from '../backend';
import { Box, Dropdown, Section } from '../components';
import { NtosWindow } from '../layouts';
import { sanitizeText } from '../sanitize';

export const NtosPhysScanner = (props) => {
  const { act, data } = useBackend();
  const { set_mode, last_record, available_modes = [] } = data;
  const textHtml = {
    __html: sanitizeText(last_record),
  };
  return (
    <NtosWindow width={600} height={350}>
      <NtosWindow.Content scrollable>
        <Section>
          Tap something (right-click) with your tablet to use the physical
          scanner.
        </Section>
        <Section>
          <Box bold>
            SELECTED MODE <br /> <br />
          </Box>
          <Dropdown
            options={available_modes}
            selected={set_mode}
            onSelected={(value) =>
              act('selectMode', {
                newMode: value,
              })
            }
          />
        </Section>
        <Section>
          <Box bold>
            LAST SAVED RESULT
            <br />
            <br />
          </Box>
          <Box
            style={{ whiteSpace: 'pre-line' }}
            dangerouslySetInnerHTML={textHtml}
          />
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
