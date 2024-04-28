(*|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|*)
(*| Copyright      :-  B&R Industrial Automation GmbH                                                            |*)
(*| Contact Person :-   salis                                                                          		     |*)
(*|——————————————————————————————————————————————————————————————————————————————————————————————————————————————|*)
(*| System       :-  Cross Cutter                                                                                |*)
(*| Task Name    :-  VisuCtrl.st                                                                                 |*)
(*| Auther Name  :-   salis                                                                                      |*)
(*| Created Date :-  April 28, 2024/10:21 AM                                                                     |*)
(*| AS Version   :-  AS 4.12.4.107 SP                                                                            |*)
(*|——————————————————————————————————————————————————————————————————————————————————————————————————————————————|*)
(*| Description  :-  Visualization Control Logic                               									 |*)
(*|                                                                                                              |*)
(*|——————————————————————————————————————————————————————————————————————————————————————————————————————————————|*)
(*| Version :-         V 1.0                      salis                                                          |*)
(*|——————————————————————————————————————————————————————————————————————————————————————————————————————————————|*)
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	(********************************* Logic for Error Status ***************************************)

	IF MpAxisMaster.Error OR MpAxisSlave.Error OR MpAxisCamSequencer_0.Error THEN
		ErrorActive := TRUE;
	ELSE
		ErrorActive := FALSE;
	END_IF
	
	(********************************* Logic for Reading Parameters ***************************************)
	
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
	
	Axis.Para.gNewMachineSpeed := ((SpeedInRPM/60)*3600);
	MSpeedRPM := ((MSpeed*SafetyFactor*60)/3600);
	ACLineVoltage_1ph := ACLineVoltage/(SQRT(2));
	
	(********************************* Logic for Machine Status ***************************************)
	
	IF (Axis.Cmd.bSingleBlade = FALSE) AND (Axis.Cmd.bDoubleBlade = FALSE) AND (Main.Cmd.bStart = FALSE) THEN
		MachineStatus := 'MACHINE IS NOT STARTED';
	ELSIF (Axis.Cmd.bSingleBlade = FALSE) AND (Axis.Cmd.bDoubleBlade = FALSE) AND (Main.Cmd.bStart = TRUE) THEN
		MachineStatus := 'PLEASE SELECT MODE OF OPERATION';
	ELSIF (Main.Cmd.bSingleBlade = TRUE) AND (Main.Cmd.bDoubleBlade = FALSE) THEN
		MachineStatus := 'SINGLE BLADE MODE IS SELECTED';
	ELSIF (Main.Cmd.bSingleBlade = FALSE) AND (Main.Cmd.bDoubleBlade = TRUE) THEN
		MachineStatus := 'DUAL BLADE MODE IS SELECTED';
	ELSIF ((Axis.Cmd.bSingleBlade = TRUE) OR (Axis.Cmd.bDoubleBlade = TRUE)) AND (MpAxisMaster.IsHomed = FALSE) THEN
		MachineStatus := 'PLEASE DO HOMING OF MACHINE';
	ELSIF Axis.Cmd.bHome THEN
		MachineStatus := 'HOMING IS ACTIVE';
	ELSIF ((MasterPara.Position = MpAxisMaster.Position) AND (SlavePara.Position = MpAxisSlave.Position))
		AND ((MpAxisMaster.Velocity = FALSE) AND (MpAxisSlave.JogPositive = FALSE)) THEN
		MachineStatus := 'MACHINE IS HOMED';
	ELSIF MpAxisMaster.Error OR MpAxisSlave.Error OR MpAxisCamSequencer_0.Error THEN
		MachineStatus := 'MACHINE IS IN ERROR CONDITION';
	ELSIF (MpAxisMaster.InVelocity) AND MpAxisCamSequencer_0.InSync THEN
		MachineStatus := 'MACHINE IS RUNNING';
	ELSIF (MpAxisMaster.InVelocity = FALSE) AND MpAxisCamSequencer_0.InSync THEN 
		MachineStatus := 'MACHINE IS STOPPED';
	ELSIF MpAxisSlave.JogPositive THEN
		MachineStatus := 'SLAVE JOG ACTIVE';
	ELSIF Axis.Cmd.bJogStop THEN
		MachineStatus := 'SLAVE JOG STOPPED';
	ELSIF Axis.Cmd.bPowerOff THEN
		MachineStatus := 'AXIS POWER OFF';
	ELSIF Axis.Cmd.bPowerOn THEN
		MachineStatus := 'AXIS POWER ON';
	ELSIF MpAxisMaster.InVelocity AND MpAxisCamSequencer_0.InSync AND Axis.Cmd.bHome THEN
		MachineStatus := 'NEED TO STOP MACHINE FOR HOMING';
	ELSIF MpAxisMaster.InVelocity AND MpAxisCamSequencer_0.InSync AND Axis.Cmd.bJogPositive THEN
		MachineStatus := 'NEED TO STOP MACHINE FOR JOG';
	END_IF
	
	IF MpAxisMaster.IsHomed AND MpAxisSlave.IsHomed 
		AND NOT((MasterPara.Position = MpAxisMaster.Position) AND (SlavePara.Position = MpAxisSlave.Position))THEN
		HomeGreen := TRUE;
	ELSE
		HomeGreen := FALSE;
	END_IF
	IF ((MasterPara.Position = MpAxisMaster.Position) AND (SlavePara.Position = MpAxisSlave.Position))
		AND ((MpAxisMaster.Velocity = FALSE) AND (MpAxisSlave.JogPositive = FALSE)) THEN
		HomeReferenced := TRUE;
	ELSE
		HomeReferenced := FALSE;
	END_IF
	IF (MpAxisMaster.IsHomed = FALSE) OR (MpAxisSlave.IsHomed = FALSE) THEN
		HomeRed := TRUE;
	ELSE
		HomeRed := FALSE;
	END_IF
		
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM
