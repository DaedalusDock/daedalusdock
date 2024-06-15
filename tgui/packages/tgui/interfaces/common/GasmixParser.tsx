import { Box, Button, LabeledList } from '../../components';

export type Gasmix = {
  gases: [string, string, number][];
  name?: string;
  pressure: number;
  reference: string;
  // ID, name, and amount.
  temperature: number;
  total_moles: number;
  volume: number;
};

type GasmixParserProps = {
  gasesOnClick?: (gas_id: string) => void;
  gasmix: Gasmix;
  pressureOnClick?: () => void;
  temperatureOnClick?: () => void;
  volumeOnClick?: () => void;
};

export const GasmixParser = (props: GasmixParserProps) => {
  const {
    gasmix,
    gasesOnClick,
    temperatureOnClick,
    volumeOnClick,
    pressureOnClick,
    ...rest
  } = props;

  const { gases, temperature, volume, pressure, total_moles } = gasmix;

  return !total_moles ? (
    <Box nowrap italic mb="10px">
      {'No Gas Detected!'}
    </Box>
  ) : (
    <LabeledList {...rest}>
      {gases.map((gas) => (
        <LabeledList.Item
          label={
            gasesOnClick ? (
              <Button content={gas[1]} onClick={() => gasesOnClick(gas[0])} />
            ) : (
              gas[1]
            )
          }
          key={gas[1]}
        >
          {gas[2].toFixed(2) +
            ' mol (' +
            ((gas[2] / total_moles) * 100).toFixed(2) +
            ' %)'}
        </LabeledList.Item>
      ))}
      <LabeledList.Item
        label={
          temperatureOnClick ? (
            <Button
              content={'Temperature'}
              onClick={() => temperatureOnClick()}
            />
          ) : (
            'Temperature'
          )
        }
      >
        {(total_moles ? temperature.toFixed(2) : '-') + ' K'}
      </LabeledList.Item>
      <LabeledList.Item
        label={
          volumeOnClick ? (
            <Button content={'Volume'} onClick={() => volumeOnClick()} />
          ) : (
            'Volume'
          )
        }
      >
        {(total_moles ? volume.toFixed(2) : '-') + ' L'}
      </LabeledList.Item>
      <LabeledList.Item
        label={
          pressureOnClick ? (
            <Button content={'Pressure'} onClick={() => pressureOnClick()} />
          ) : (
            'Pressure'
          )
        }
      >
        {(total_moles ? pressure.toFixed(2) : '-') + ' kPa'}
      </LabeledList.Item>
    </LabeledList>
  );
};
