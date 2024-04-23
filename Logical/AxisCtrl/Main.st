
PROGRAM _INIT
	(* Insert code here *)
	MasterPara.Acceleration := 5000;
	MasterPara.Deceleration := 10000;
	MasterPara.Velocity := 3600;
	SlavePara.Acceleration := 5000;
	SlavePara.Deceleration := 10000;
	SlavePara.Velocity := 3600;
	
	
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	
	MpAxisMaster.MpLink := ADR(gML_Master);
	MpAxisMaster.Enable := TRUE;
	MpAxisMaster.Parameters := ADR(MasterPara);
	MpAxisMaster.Axis := ADR(gAxis04);
	MpAxisMaster();
	
	MpAxisSlave.MpLink := ADR(gML_Slave);
	MpAxisSlave.Enable := TRUE;
	MpAxisSlave.Parameters := ADR(SlavePara);
	MpAxisSlave.Axis := ADR(gAxis03);
	MpAxisSlave();
	
	Exercise4;
	
	MpAxisCamSequencer_0.MpLink := ADR(gML_Slave);
	MpAxisCamSequencer_0.MpLinkMaster := ADR(gML_Master);
	MpAxisCamSequencer_0.Enable := TRUE;
	MpAxisCamSequencer_0.Parameters := ADR(CamSeqPara);
	MpAxisCamSequencer_0();
	
//	MasterPosition := LREAL_TO_UDINT(MpAxisMaster.Position) MOD 3600;
//	IF (MasterPosition >= 600) AND (MasterPosition < 900) THEN
//		gMi_Signal1 := TRUE;
//	ELSIF (MasterPosition >= 900) THEN
//		gMi_Signal1 := FALSE;
//	END_IF
//		
	
//	CASE MasterState OF
//		PowerOn:
//			IF MpAxisMaster.Active THEN
//				MpAxisMaster.Power := TRUE;
//			END_IF
//			IF MpAxisMaster.PowerOn THEN
//				MasterState := Home;
//			END_IF
//		Home:
//			MpAxisMaster.Home := TRUE;
//			IF MpAxisMaster.IsHomed THEN
//				MasterState := HomingOk;
//			END_IF
//		HomingOk:
//			MpAxisMaster.Home := FALSE;
//	END_CASE
//	
//	CASE SlaveState OF
//		PowerOn:
//			IF MpAxisSlave.Active THEN
//				MpAxisSlave.Power := TRUE;
//			END_IF
//			IF MpAxisSlave.PowerOn THEN
//				SlaveState := Home;
//			END_IF
//		Home:
//			MpAxisSlave.Home := TRUE;
//			IF MpAxisSlave.IsHomed THEN
//				SlaveState := HomingOk;
//			END_IF
//		HomingOk:
//			MpAxisSlave.Home := FALSE;
//	END_CASE
//	
//	IF MpAxisMaster.IsHomed AND MpAxisSlave.IsHomed THEN
//		MpAxisCamSequencer_0.StartSequence := TRUE;
//	END_IF
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

