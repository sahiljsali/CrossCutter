
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	Axis.Para.gNewMachineSpeed := ((SpeedInRPM/60)*3600);
	
	MC_BR_CyclicRead_0(Axis := ADR(gAxis02), Enable := TRUE, ParID := 92, DataAddress := ADR(MSpeed), DataType := ncPAR_TYP_REAL);
	MSpeed;
	
	MC_BR_CyclicRead_1(Axis := ADR(gAxis02), Enable := TRUE, ParID := 111, DataAddress := ADR(MPosition), DataType := ncPAR_TYP_DINT);
	MPosition;
	
	MC_BR_CyclicRead_2(Axis := ADR(gAxis01), Enable := TRUE, ParID := 277, DataAddress := ADR(STorque), DataType := ncPAR_TYP_REAL);
	STorque;
	
	MC_BR_CyclicRead_3(Axis := ADR(gAxis01), Enable := TRUE, ParID := 219, DataAddress := ADR(SCurrent), DataType := ncPAR_TYP_REAL);
	SCurrent;
	
	MC_BR_CyclicRead_4(Axis := ADR(gAxis01), Enable := TRUE, ParID := 58, DataAddress := ADR(MaxSCurrent), DataType := ncPAR_TYP_REAL);
	MaxSCurrent;
	
	MC_BR_CyclicRead_5(Axis := ADR(gAxis01), Enable := TRUE, ParID := 381, DataAddress := ADR(SMotorTemp), DataType := ncPAR_TYP_REAL);
	SMotorTemp;
	
	MC_BR_CyclicRead_6(Axis := ADR(gAxis02), Enable := TRUE, ParID := 48, DataAddress := ADR(ACLineVoltage), DataType := ncPAR_TYP_REAL);
	ACLineVoltage;
	
	MSpeedRPM := ((MSpeed*SafetyFactor*60)/3600);
	ACLineVoltage_1ph := ACLineVoltage/(SQRT(2));

	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM
