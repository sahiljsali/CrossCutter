
PROGRAM _INIT
	(* Insert code here *)
	MasterPara.Acceleration := 72000;
	MasterPara.Deceleration := 72000;
	
	
	MasterPara.Home.StartVelocity := 720;
	MasterPara.Home.HomingVelocity := 720;
	MasterPara.Home.Acceleration := 3600;
	MasterPara.Home.Mode := mpAXIS_HOME_MODE_DIRECT;
	MasterPara.Home.ReferencePulse := mpAXIS_HOME_OPTION_ON;
	
	SlavePara.Acceleration := 72000;
	SlavePara.Deceleration := 72000;
	
	SlavePara.Home.StartVelocity := 720;
	SlavePara.Home.HomingVelocity := 720;
	SlavePara.Home.Acceleration := 3600;
	SlavePara.Home.Mode := mpAXIS_HOME_MODE_DIRECT;
	SlavePara.Home.ReferencePulse := mpAXIS_HOME_OPTION_ON;

	Axis.Para.gMachineSpeed := 8000;
	
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
	
	IF Axis.Cmd.bSingleBlade THEN
		SingleBladeCam;
	ELSIF Axis.Cmd.bDoubleBlade THEN
		DoubleBladeCam;
	END_IF
	
	MpAxisCamSequencer_0.MpLink := ADR(gML_Slave);
	MpAxisCamSequencer_0.MpLinkMaster := ADR(gML_Master);
	MpAxisCamSequencer_0.Enable := TRUE;
	MpAxisCamSequencer_0.Parameters := ADR(CamSeqPara);
	MpAxisCamSequencer_0();
	
	IF Axis.Cmd.bSingleBlade THEN
		SlavePara.Position := 3550;
		MasterPara.Position := 3450;
		SlavePara.Home.SensorOffset := 0;
		MasterPara.Home.SensorOffset := 0;
		
	IF (((MpAxisMaster.Position <= 1480) AND (MpAxisMaster.Position >= 0)) OR((MpAxisMaster.Position >= 3501)AND(MpAxisMaster.Position <= 3599))) AND (MpAxisMaster.MoveVelocity = FALSE) THEN
		MasterPara.Home.StartDirection := mpAXIS_HOME_DIR_NEGATIVE;
		MasterPara.Home.HomingDirection := mpAXIS_HOME_DIR_NEGATIVE;
	ELSIF (MpAxisMaster.Position >= 1940) AND (MpAxisMaster.Position <= 3500) AND (MpAxisMaster.MoveVelocity = FALSE) THEN
		MasterPara.Home.StartDirection := mpAXIS_HOME_DIR_POSITIVE;
		MasterPara.Home.HomingDirection := mpAXIS_HOME_DIR_POSITIVE;
	ELSIF (MpAxisMaster.Position > 1480) AND (MpAxisMaster.Position < 1940) THEN
			IF (MpAxisMaster.MoveVelocity = FALSE) AND (MpAxisMaster.JogPositive) AND (MpAxisMaster.JogNegative) THEN
				MpAxisMaster.Power := FALSE;
				MpAxisSlave.Power := FALSE;
			END_IF	
	END_IF
		
	ELSIF Axis.Cmd.bDoubleBlade THEN
	
		IF (((MpAxisMaster.Position <= 1480) AND (MpAxisMaster.Position >= 0)) OR((MpAxisMaster.Position >= 3501)AND(MpAxisMaster.Position <= 3599))) THEN 
			IF (MpAxisMaster.MoveVelocity = FALSE) THEN
				MasterPara.Position := 825;
				SlavePara.Position := 2250;
				MasterPara.Direction := mpAXIS_DIR_SHORTEST_WAY;
				SlavePara.Direction := mpAXIS_DIR_SHORTEST_WAY;
			END_IF
		ELSIF (MpAxisMaster.Position >= 1940) AND (MpAxisMaster.Position <= 3500) AND (MpAxisMaster.MoveVelocity = FALSE) THEN
			MasterPara.Position := 2625;
			SlavePara.Position := 2250;
			MasterPara.Direction := mpAXIS_DIR_SHORTEST_WAY;
			SlavePara.Direction := mpAXIS_DIR_SHORTEST_WAY;
		ELSIF ((MpAxisMaster.Position > 1480) AND (MpAxisMaster.Position < 1940)) THEN 
			IF (MpAxisMaster.MoveVelocity = FALSE) THEN
				MpAxisMaster.Power := FALSE;
				MpAxisSlave.Power := FALSE;
			END_IF
		ELSIF (((MpAxisMaster.Position >= 3280) AND (MpAxisMaster.Position <= 3599)) AND ((MpAxisMaster.Position >= 1) AND (MpAxisMaster.Position <= 150)))THEN
			IF (MpAxisMaster.MoveVelocity = FALSE) AND (MpAxisMaster.JogPositive) AND (MpAxisMaster.JogNegative) THEN
				MpAxisMaster.Power := FALSE;
				MpAxisSlave.Power := FALSE;
			END_IF
		END_IF
		
		IF (MpAxisMaster.Position > 825) AND (MpAxisMaster.Position < 1480) THEN
			MasterPara.Home.SensorOffset := 825;
			MasterPara.Home.HomingDirection := mpAXIS_HOME_DIR_NEGATIVE;
		ELSIF (MpAxisMaster.Position > 0) AND (MpAxisMaster.Position < 825) THEN
			MasterPara.Home.SensorOffset := 825;
			MasterPara.Home.HomingDirection := mpAXIS_HOME_DIR_POSITIVE;
		ELSIF (MpAxisMaster.Position > 1940) AND (MpAxisMaster.Position < 2625) THEN
			MasterPara.Home.SensorOffset := 2625;
			MasterPara.Home.HomingDirection := mpAXIS_HOME_DIR_POSITIVE;
		ELSIF (MpAxisMaster.Position > 2625) AND (MpAxisMaster.Position < 3599) THEN
			MasterPara.Home.SensorOffset := 2625;
			MasterPara.Home.HomingDirection := mpAXIS_HOME_DIR_NEGATIVE;
		END_IF
	
	END_IF
	
	IF Axis.Cmd.bHome THEN
		MasterPara.Direction := mpAXIS_DIR_SHORTEST_WAY;
		SlavePara.Direction := mpAXIS_DIR_SHORTEST_WAY;
		MasterPara.Velocity := 1200;
		SlavePara.Velocity := 1200;
		
	ELSE
		MasterPara.Direction := mpAXIS_DIR_POSITIVE;
		SlavePara.Direction := mpAXIS_DIR_POSITIVE;
		MasterPara.Velocity := (Axis.Para.gMachineSpeed/SafetyFactor);
		SlavePara.Velocity := (Axis.Para.gMachineSpeed/SafetyFactor);
		
	END_IF

	
	CASE AxisHomeState OF
		WAIT:
			IF (MpAxisMaster.Power = TRUE) AND (MpAxisSlave.Power = TRUE) THEN
				IF Axis.Cmd.bHome THEN
					IF MpAxisMaster.IsHomed AND MpAxisSlave.IsHomed THEN
						AxisHomeState := HOMING_ACTIVE;
					ELSE
						AxisHomeState := HOME;
					END_IF
				END_IF
			END_IF
			
			//			IF (MpAxisMaster.Error = TRUE) OR (MpAxisSlave.Error = TRUE) OR (MpAxisCamSequencer_0.Error = TRUE) THEN
			//				AxisHomeState := ERROR;
			//			END_IF
			
		HOME:
			MpAxisCamSequencer_0.StartSequence := FALSE;
			MpAxisMaster.Home := TRUE;
			MpAxisSlave.Home := TRUE;
			IF MpAxisMaster.IsHomed AND MpAxisSlave.IsHomed THEN
				AxisHomeState := HOMING_ACTIVE;
			END_IF
			

		HOMING_ACTIVE:
			
			MpAxisMaster.Home := FALSE;
			MpAxisSlave.Home := FALSE;
			MpAxisMaster.MoveAbsolute := TRUE;
			MpAxisSlave.MoveAbsolute := TRUE;
			IF (MpAxisMaster.Position = MasterPara.Position) AND (MpAxisSlave.Position = SlavePara.Position) THEN
				AxisHomeState := HOME_OK;
			END_IF
			
			
		HOME_OK:
			MpAxisCamSequencer_0.StartSequence := TRUE;
			Axis.Cmd.bHome := FALSE;
			MpAxisMaster.MoveAbsolute := FALSE;
			MpAxisSlave.MoveAbsolute := FALSE;
			AxisHomeState := WAIT;
		
		ERROR:
			MpAxisCamSequencer_0.StartSequence := FALSE;
			IF (MpAxisMaster.Error = TRUE) THEN
				MpAxisMaster.ErrorReset := TRUE;
			END_IF
			IF (MpAxisSlave.Error = TRUE) THEN
				MpAxisSlave.ErrorReset := TRUE;
			END_IF
			IF (MpAxisCamSequencer_0.Error = TRUE) THEN
				MpAxisCamSequencer_0.ErrorReset := TRUE;
			END_IF
			IF (MpAxisMaster.Error = FALSE) OR (MpAxisSlave.Error = FALSE) OR (MpAxisCamSequencer_0.Error = FALSE) THEN
				AxisHomeState := NO_ERROR;
			END_IF
			
		NO_ERROR:
			MpAxisCamSequencer_0.StartSequence := TRUE;
			MpAxisMaster.ErrorReset := FALSE;
			MpAxisSlave.ErrorReset := FALSE;
			MpAxisCamSequencer_0.ErrorReset := FALSE;
			AxisHomeState := WAIT;
	END_CASE;
	
	
	IF (MpAxisMaster.Error = FALSE) AND (MpAxisSlave.Error = FALSE) AND (MpAxisCamSequencer_0.Error = FALSE) THEN
		CASE SequenceState OF
			CHECK_STATUS:
				IF ((MpAxisMaster.InVelocity = FALSE) AND (MpAxisMaster.Position = MasterPara.Position) AND (MpAxisMaster.Error = FALSE)) THEN
					IF ((MpAxisSlave.InVelocity = FALSE) AND (MpAxisSlave.Position = SlavePara.Position) AND (MpAxisSlave.Error = FALSE)) THEN
						IF (MpAxisCamSequencer_0.InSync = FALSE) AND (MpAxisMaster.IsHomed AND MpAxisSlave.IsHomed) THEN
							MpAxisCamSequencer_0.StartSequence := FALSE;
							SequenceState := START_SEQ;
						END_IF
					END_IF
				END_IF
		
			START_SEQ:
				MpAxisCamSequencer_0.StartSequence := TRUE;
				IF MpAxisCamSequencer_0.InSync = TRUE THEN
					SequenceState := CHECK_STATUS;
				END_IF
				
		END_CASE		
	END_IF
	
	CASE EStopState OF
		ESTOP_DETECT:
			IF (MpAxisMaster.Info.DigitalInputsStatus.DriveEnable = FALSE) OR (MpAxisSlave.Info.DigitalInputsStatus.DriveEnable = FALSE) THEN
				EStopState := ERROR_RESET;
			ELSIF (MpAxisMaster.Error = TRUE) OR (MpAxisSlave.Error = TRUE) OR (MpAxisCamSequencer_0.Error = TRUE) THEN
				EStopState := ERROR_RESET;
			END_IF
		
		ERROR_RESET:
			IF Axis.Cmd.bErrorReset THEN
				MpAxisMaster.Power := FALSE;
				MpAxisMaster.MoveAbsolute := FALSE;
				MpAxisMaster.MoveVelocity := FALSE;
				MpAxisMaster.Home := FALSE;
				MpAxisSlave.Power := FALSE;
				MpAxisSlave.MoveAbsolute := FALSE;
				MpAxisSlave.MoveVelocity := FALSE;
				MpAxisSlave.Home := FALSE;
				MpAxisCamSequencer_0.StartSequence := FALSE;
				IF (MpAxisMaster.Error = TRUE) THEN
					MpAxisMaster.ErrorReset := TRUE;
				END_IF
				IF (MpAxisSlave.Error = TRUE) THEN
					MpAxisSlave.ErrorReset := TRUE;
				END_IF
				IF (MpAxisCamSequencer_0.Error = TRUE) THEN
					MpAxisCamSequencer_0.ErrorReset := TRUE;
				END_IF
			END_IF
			
			IF (MpAxisMaster.Error = FALSE) AND (MpAxisSlave.Error = FALSE) AND (MpAxisCamSequencer_0.Error = FALSE) THEN 
				EStopState := RESET_DONE;
			END_IF
		
		RESET_DONE:
			Axis.Cmd.bErrorReset:= FALSE;
			MpAxisMaster.ErrorReset := FALSE;
			MpAxisSlave.ErrorReset := FALSE;
			MpAxisCamSequencer_0.ErrorReset := FALSE;
			
			IF MpAxisMaster.Info.ReadyToPowerOn AND MpAxisSlave.Info.ReadyToPowerOn THEN
				MpAxisMaster.Power := TRUE;
				MpAxisSlave.Power := TRUE;
				EStopState := ESTOP_DETECT;
			END_IF		
	END_CASE;

	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

