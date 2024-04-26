
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
	
	SlavePara.Jog.Acceleration := 72000;
	SlavePara.Jog.Deceleration := 72000;
	SlavePara.Jog.Velocity := 7200;

	
	
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
	
	MpAxisCamSequencer_0.MpLink := ADR(gML_Slave);
	MpAxisCamSequencer_0.MpLinkMaster := ADR(gML_Master);
	MpAxisCamSequencer_0.Enable := TRUE;
	MpAxisCamSequencer_0.Parameters := ADR(CamSeqPara);
	MpAxisCamSequencer_0();
	
	CASE PowerState OF
		WAIT_CMD:
			IF MpAxisMaster.Info.ReadyToPowerOn AND MpAxisSlave.Info.ReadyToPowerOn AND Axis.Cmd.bPowerOn THEN
				PowerState := POWER_ON;
			ELSIF Axis.Cmd.bPowerOff THEN
				PowerState := POWER_OFF;
			END_IF
			IF MpAxisCamSequencer_0.InSync AND Axis.Cmd.bStart THEN
				PowerState := RUNNING;
			ELSIF Axis.Cmd.bStop THEN
				PowerState := STOP_RUN;
			END_IF
		POWER_ON:
			Axis.Cmd.bPowerOn := FALSE;
			Axis.Cmd.bPowerOff := FALSE;
			MpAxisMaster.Power := TRUE;
			MpAxisSlave.Power := TRUE;
			PowerState := WAIT_CMD;
			
		POWER_OFF:
			Axis.Cmd.bPowerOff := FALSE;
			Axis.Cmd.bPowerOn := FALSE;
			MpAxisMaster.Power := FALSE;
			MpAxisSlave.Power := FALSE;
			PowerState := WAIT_CMD;
			
		RUNNING:
			Axis.Cmd.bStart := FALSE;
			Axis.Cmd.bStop := FALSE;
			MpAxisMaster.MoveVelocity := TRUE;
			PowerState := WAIT_CMD;
			
		STOP_RUN:
			Axis.Cmd.bStart := FALSE;
			Axis.Cmd.bStop := FALSE;
			MpAxisMaster.MoveVelocity := FALSE;
			PowerState := WAIT_CMD;
			
	END_CASE;
	
	IF Axis.Cmd.bSingleBlade THEN
		SingleBladeCam;
	ELSIF Axis.Cmd.bDoubleBlade THEN
		DoubleBladeCam;
	END_IF
	
	
	
	IF (Axis.Cmd.bSingleBlade = FALSE) AND (Axis.Cmd.bDoubleBlade = FALSE) THEN
		Axis.Cmd.bHome := FALSE;
	END_IF
	
	IF Axis.Cmd.bSingleBlade THEN
		SlavePara.Position := SPositionSingle;
		MasterPara.Position := MPositionSingle;
		SlavePara.Home.SensorOffset := SlaveOffsetSingle;
		MasterPara.Home.SensorOffset := MasterOffsetSingle;
		
		IF (((MpAxisMaster.Position <= MUpPosLimit1) AND (MpAxisMaster.Position >= MUpNegLimit1)) OR((MpAxisMaster.Position >= MUpPosLimit2)AND(MpAxisMaster.Position <= MUpNegLimit2))) AND (MpAxisMaster.MoveVelocity = FALSE) THEN
			MasterPara.Home.StartDirection := mpAXIS_HOME_DIR_NEGATIVE;
			MasterPara.Home.HomingDirection := mpAXIS_HOME_DIR_NEGATIVE;
		ELSIF (MpAxisMaster.Position >= MDownNegLimit) AND (MpAxisMaster.Position <= MDownPosLimit) AND (MpAxisMaster.MoveVelocity = FALSE) THEN
			MasterPara.Home.StartDirection := mpAXIS_HOME_DIR_POSITIVE;
			MasterPara.Home.HomingDirection := mpAXIS_HOME_DIR_POSITIVE;
		ELSIF (MpAxisMaster.Position > MCutRegionNegLimit1) AND (MpAxisMaster.Position < MCutRegionPosLimit1) THEN
			IF (MpAxisMaster.MoveVelocity = FALSE) AND (MpAxisMaster.JogPositive) AND (MpAxisMaster.JogNegative) THEN
				MpAxisMaster.Power := FALSE;
				MpAxisSlave.Power := FALSE;
			END_IF	
		END_IF
		
	ELSIF Axis.Cmd.bDoubleBlade THEN
	
		IF (((MpAxisMaster.Position <= MUpPosLimit1) AND (MpAxisMaster.Position >= MUpNegLimit1)) OR((MpAxisMaster.Position >= MUpPosLimit2)AND(MpAxisMaster.Position <= MUpNegLimit2))) THEN 
			IF (MpAxisMaster.MoveVelocity = FALSE) THEN
				MasterPara.Position := MUpPositionDouble;
				SlavePara.Position := SPositionDouble;
				MasterPara.Direction := mpAXIS_DIR_SHORTEST_WAY;
				SlavePara.Direction := mpAXIS_DIR_SHORTEST_WAY;
			END_IF
		ELSIF (MpAxisMaster.Position >= MDownNegLimit) AND (MpAxisMaster.Position <= MDownPosLimit) AND (MpAxisMaster.MoveVelocity = FALSE) THEN
			MasterPara.Position := MDownPositionDouble;
			SlavePara.Position := SPositionDouble;
			MasterPara.Direction := mpAXIS_DIR_SHORTEST_WAY;
			SlavePara.Direction := mpAXIS_DIR_SHORTEST_WAY;
		ELSIF ((MpAxisMaster.Position > MCutRegionNegLimit1) AND (MpAxisMaster.Position < MCutRegionPosLimit1)) THEN 
			IF (MpAxisMaster.MoveVelocity = FALSE) THEN
				MpAxisMaster.Power := FALSE;
				MpAxisSlave.Power := FALSE;
			END_IF
		ELSIF (((MpAxisMaster.Position >= MCutRegionNegLimit2) AND (MpAxisMaster.Position <= MCutRegionPosLimit2)) AND ((MpAxisMaster.Position >= MCutRegionPosLimit3) AND (MpAxisMaster.Position <= MCutRegionNegLimit3)))THEN
			IF (MpAxisMaster.MoveVelocity = FALSE) AND (MpAxisMaster.JogPositive) AND (MpAxisMaster.JogNegative) THEN
				MpAxisMaster.Power := FALSE;
				MpAxisSlave.Power := FALSE;
			END_IF
		END_IF
		
		IF (MpAxisMaster.Position > 825) AND (MpAxisMaster.Position < 1480) THEN
			MasterPara.Home.SensorOffset := MasterUpOffsetDouble;
			MasterPara.Home.HomingDirection := mpAXIS_HOME_DIR_NEGATIVE;
		ELSIF (MpAxisMaster.Position > 0) AND (MpAxisMaster.Position < 825) THEN
			MasterPara.Home.SensorOffset := MasterUpOffsetDouble;
			MasterPara.Home.HomingDirection := mpAXIS_HOME_DIR_POSITIVE;
		ELSIF (MpAxisMaster.Position > 1940) AND (MpAxisMaster.Position < 2625) THEN
			MasterPara.Home.SensorOffset := MasterDownOffsetDouble;
			MasterPara.Home.HomingDirection := mpAXIS_HOME_DIR_POSITIVE;
		ELSIF (MpAxisMaster.Position > 2625) AND (MpAxisMaster.Position < 3599) THEN
			MasterPara.Home.SensorOffset := MasterDownOffsetDouble;
			MasterPara.Home.HomingDirection := mpAXIS_HOME_DIR_NEGATIVE;
		END_IF
	
	END_IF
	
	IF Axis.Cmd.bHome THEN
		MasterPara.Direction := mpAXIS_DIR_SHORTEST_WAY;
		SlavePara.Direction := mpAXIS_DIR_SHORTEST_WAY;
		MasterPara.Velocity := HomingVelocity;
		SlavePara.Velocity := HomingVelocity;
		
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
				MpAlarmXSet(gAlarmXCore,'EStopActive');
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
			MpAlarmXReset(gAlarmXCore,'EStopActive');
			IF MpAxisMaster.Info.ReadyToPowerOn AND MpAxisSlave.Info.ReadyToPowerOn THEN
				MpAxisMaster.Power := TRUE;
				MpAxisSlave.Power := TRUE;
				EStopState := ESTOP_DETECT;
			END_IF		
	END_CASE;

	CASE UpdateState OF
		CHECK_UPDATE:
			IF Axis.Para.gMachineSpeed <> Axis.Para.gNewMachineSpeed THEN
				UpdateState := START_UPDATE;
			END_IF
			
		START_UPDATE:
			Axis.Para.gMachineSpeed := Axis.Para.gNewMachineSpeed;
			IF Axis.Para.gMachineSpeed = Axis.Para.gNewMachineSpeed THEN
				MpAxisMaster.Update := TRUE;
				MpAxisSlave.Update := TRUE;
			END_IF
			IF MpAxisMaster.UpdateDone AND MpAxisSlave.UpdateDone THEN
				UpdateState := UPDATE_DONE;
			END_IF
		
		UPDATE_DONE:
			MpAxisMaster.Update := FALSE;
			MpAxisSlave.Update := FALSE;
			UpdateState := CHECK_UPDATE;
	END_CASE;
	
	Axis.Para.gMachineSpeed := LIMIT(0.0,Axis.Para.gMachineSpeed,18000.0);
	
	IF MpAxisSlave.InVelocity THEN
		Axis.Cmd.bJogPositive := FALSE;
		Axis.Cmd.bJogNegative := FALSE;
	END_IF
	
	
	
	CASE JogState OF
		WAIT_JOG:
			IF Axis.Cmd.bJogPositive THEN
				JogState := JOG_POSITIVE;
			ELSIF Axis.Cmd.bJogNegative THEN
				JogState := JOG_NEGATIVE;
			END_IF
			
		JOG_POSITIVE:
			MpAxisSlave.JogNegative := FALSE;
			IF MpAxisSlave.JogNegative = FALSE THEN
				MpAxisSlave.JogPositive := TRUE;
			END_IF
			IF Axis.Cmd.bJogStop THEN
				JogState := STOP_JOG;
			END_IF
			
		JOG_NEGATIVE:
			MpAxisSlave.JogPositive := FALSE;
			IF MpAxisSlave.JogPositive = FALSE THEN
				MpAxisSlave.JogNegative := TRUE;
			END_IF
			IF Axis.Cmd.bJogStop THEN
				JogState := STOP_JOG;
			END_IF
		
		STOP_JOG:
			MpAxisSlave.JogPositive := FALSE;
			MpAxisSlave.JogNegative := FALSE;
			Axis.Cmd.bJogPositive := FALSE;
			Axis.Cmd.bJogNegative := FALSE;
			IF MpAxisSlave.MoveActive = FALSE THEN
				Axis.Cmd.bHome := TRUE;
				Axis.Cmd.bJogStop := FALSE;
				JogState := WAIT_JOG;
			END_IF
	END_CASE

	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

