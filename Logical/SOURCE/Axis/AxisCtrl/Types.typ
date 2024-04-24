
TYPE
	eAxisHome : 
		(
		WAIT,
		HOMING_ACTIVE,
		HOME,
		HOME_OK,
		ERROR,
		NO_ERROR
		);
	eSequence : 
		(
		CHECK_STATUS,
		START_SEQ,
		SEQ_DONE
		);
	eEStop : 
		(
		ESTOP_DETECT,
		ERROR_RESET,
		RESET_DONE
		);
END_TYPE
