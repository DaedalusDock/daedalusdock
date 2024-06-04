import { SignalerContent } from './Signaler';
import { NtosWindow } from '../layouts';

export const NtosSignaler = (props) => {
  const { act, data } = useBackend();
  const { PC_device_theme } = data;
  return (
    <NtosWindow width={400} height={300} theme={PC_device_theme}>
      <NtosWindow.Content>
        <SignalerContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
