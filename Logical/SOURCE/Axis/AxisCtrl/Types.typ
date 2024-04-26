
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
	eUpdate : 
		(
		CHECK_UPDATE,
		START_UPDATE,
		UPDATE_DONE
		);
	eJogSlave : 
		(
		WAIT_JOG,
		JOG_POSITIVE,
		JOG_NEGATIVE,
		STOP_JOG
		);
	ePower : 
		(
		WAIT_CMD,
		POWER_ON,
		RUNNING,
		STOP_RUN,
		POWER_OFF
		);
END_TYPE
