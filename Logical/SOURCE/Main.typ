
TYPE
	Main_typ : 	STRUCT 
		Cmd : MainCmd_typ;
		Status : MainStatus_typ;
	END_STRUCT;
	MainCmd_typ : 	STRUCT 
		bStart : BOOL;
		bStop : BOOL;
		bEStop : BOOL;
	END_STRUCT;
	MainStatus_typ : 	STRUCT 
	END_STRUCT;
END_TYPE
