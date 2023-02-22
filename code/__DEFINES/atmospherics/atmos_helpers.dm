//Helpers
///Moves the icon of the device based on the piping layer and on the direction
#define PIPING_LAYER_SHIFT(T, PipingLayer) \
	if(T.dir & (NORTH|SOUTH)) { \
		T.pixel_x = (PipingLayer - PIPING_LAYER_DEFAULT) * PIPING_LAYER_P_X;\
	} \
	if(T.dir & (EAST|WEST)) { \
		T.pixel_y = (PipingLayer - PIPING_LAYER_DEFAULT) * PIPING_LAYER_P_Y;\
	}

///Moves the icon of the device based on the piping layer and on the direction, the shift amount is dictated by more_shift
#define PIPING_FORWARD_SHIFT(T, PipingLayer, more_shift) \
	if(T.dir & (NORTH|SOUTH)) { \
		T.pixel_y += more_shift * (PipingLayer - PIPING_LAYER_DEFAULT);\
	} \
	if(T.dir & (EAST|WEST)) { \
		T.pixel_x += more_shift * (PipingLayer - PIPING_LAYER_DEFAULT);\
	}

///Moves the icon of the device based on the piping layer on both x and y
#define PIPING_LAYER_DOUBLE_SHIFT(T, PipingLayer) \
	T.pixel_x = (PipingLayer - PIPING_LAYER_DEFAULT) * PIPING_LAYER_P_X;\
	T.pixel_y = (PipingLayer - PIPING_LAYER_DEFAULT) * PIPING_LAYER_P_Y;

///Calculate the thermal energy of the selected gas (J)
#define THERMAL_ENERGY(gas) (gas.temperature * gas.getHeatCapacity())
