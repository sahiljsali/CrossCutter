
PROGRAM _INIT
	(* Insert code here *)
	MasterPara.Acceleration := 5000;
	MasterPara.Deceleration := 10000;
	
	MasterPara.Position := 0;

	
	SlavePara.Acceleration := 5000;
	SlavePara.Deceleration := 10000;
	
	SlavePara.Position := 0;;

	
	
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	
	MpAxisMaster.MpLink := ADR(gML_Master);
	MpAxisMaster.Enable := TRUE;
	MpAxisMaster.Parameters := ADR(MasterPara);
	MpAxisMaster.Axis := ADR(gAxis02);
	MpAxisMaster();
	
	MpAxisSlave.MpLink := ADR(gML_Slave);
	MpAxisSlave.Enable := TRUE;
	MpAxisSlave.Parameters := ADR(SlavePara);
	MpAxisSlave.Axis := ADR(gAxis01);
	MpAxisSlave();
	
	SingleBladeCam;
	
	MpAxisCamSequencer_0.MpLink := ADR(gML_Slave);
	MpAxisCamSequencer_0.MpLinkMaster := ADR(gML_Master);
	MpAxisCamSequencer_0.Enable := TRUE;
	MpAxisCamSequencer_0.Parameters := ADR(CamSeqPara);
	MpAxisCamSequencer_0();
	
	IF Axis.Cmd.bHome THEN
		MasterPara.Direction := mpAXIS_DIR_SHORTEST_WAY;
		SlavePara.Direction := mpAXIS_DIR_SHORTEST_WAY;
		MasterPara.Velocity := 1200;
		SlavePara.Velocity := 1200;
	ELSE
		MasterPara.Direction := mpAXIS_DIR_POSITIVE;
		SlavePara.Direction := mpAXIS_DIR_POSITIVE;
		MasterPara.Velocity := 3600;
		SlavePara.Velocity := 3600;
	END_IF

	
	
//	IF (MpAxisMaster.Position <= 1560) AND (MpAxisMaster.Position >= 2060) THEN
//		MpAxisMaster.Power := FALSE;
//		MpAxisSlave.Power := FALSE;
//	ELSIF MpAxisMaster.Active AND MpAxisSlave.Active THEN
//		MpAxisMaster.Power := TRUE;
//		MpAxisSlave.Power := TRUE;
//	END_IF
	
	CASE AxisHomeState OF
		WAIT:
			IF (MpAxisMaster.Power = TRUE) AND (MpAxisSlave.Power = TRUE) THEN
				IF Axis.Cmd.bHome THEN
					AxisHomeState := HOME;
				END_IF
			END_IF
		HOME:
			MpAxisCamSequencer_0.StartSequence := FALSE;
			MpAxisMaster.MoveAbsolute := TRUE;
			MpAxisSlave.MoveAbsolute := TRUE;
			IF (MpAxisMaster.Position = MasterPara.Position) AND (MpAxisSlave.Position = SlavePara.Position) THEN
				AxisHomeState := HOMING_ACTIVE;
			END_IF
			

		HOMING_ACTIVE:
			MpAxisMaster.MoveAbsolute := FALSE;
			MpAxisSlave.MoveAbsolute := FALSE;
			MpAxisMaster.Home := TRUE;
			MpAxisSlave.Home := TRUE;
			IF MpAxisMaster.IsHomed AND MpAxisSlave.IsHomed THEN
				AxisHomeState := HOME_OK;
			END_IF
			
			
		HOME_OK:
			MpAxisCamSequencer_0.StartSequence := TRUE;
			Axis.Cmd.bHome := FALSE;
			MpAxisMaster.MoveAbsolute := FALSE;
			MpAxisSlave.MoveAbsolute := FALSE;
			MpAxisMaster.Home := FALSE;
			MpAxisSlave.Home := FALSE;
			AxisHomeState := WAIT;

	END_CASE;
	

END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

