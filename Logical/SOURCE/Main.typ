
TYPE
	Main_typ : 	STRUCT 
		Cmd : MainCmd_typ;
	END_STRUCT;
	MainCmd_typ : 	STRUCT 
		bStart : BOOL;
		bStop : BOOL;
		bEStop : BOOL;
		bDoubleBlade : BOOL;
		bSingleBlade : BOOL;
	END_STRUCT;
END_TYPE
