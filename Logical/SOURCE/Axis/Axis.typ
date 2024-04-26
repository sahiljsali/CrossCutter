
TYPE
	Axis_typ : 	STRUCT 
		Cmd : AxisCmd_typ;
		Para : AxisPara_typ;
	END_STRUCT;
	AxisCmd_typ : 	STRUCT 
		bStart : BOOL;
		bHome : BOOL;
		bStop : BOOL;
		bEStop : BOOL;
		bErrorReset : BOOL;
		bSingleBlade : BOOL;
		bDoubleBlade : BOOL;
		bReverse : BOOL;
		bJogPositive : BOOL;
		bJogNegative : BOOL;
		bJogStop : BOOL;
		bPowerOn : BOOL;
		bPowerOff : BOOL;
	END_STRUCT;
	AxisPara_typ : 	STRUCT 
		gMachineSpeed : REAL;
		gNewMachineSpeed : REAL;
	END_STRUCT;
END_TYPE
