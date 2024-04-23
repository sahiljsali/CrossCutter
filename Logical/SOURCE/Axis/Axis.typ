
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
	END_STRUCT;
	AxisPara_typ : 	STRUCT 
		gMachineSpeed : USINT;
	END_STRUCT;
END_TYPE