import { useBackend } from '../backend';
import { Window } from '../layouts';
import { Image } from '../components/Image';
import { resolveAsset } from '../assets';

export const Holomap = (props) => {
  const { act, data } = useBackend();
  const { url } = data;
  return (
    <Window width={960} height={960}>
      <Window.Content>
        <Image
          src={resolveAsset('holomap_z2.png')}
          fixErrors
          objectFit="cover"
          width="220%"
          style={{
            position: 'absolute',
            overflow: 'hidden',
            bottom: '-100px',
            left: '-100px',
          }}
        />
      </Window.Content>
    </Window>
  );
};
