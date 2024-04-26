
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	CASE MainState OF
		WAIT:
			IF Main.Cmd.bStart THEN
				MainState := SELECT_MODE;
			END_IF
		
		SELECT_MODE:
			IF Main.Cmd.bSingleBlade THEN
				MainState := SINGLE_BLADE;
			ELSIF Main.Cmd.bDoubleBlade THEN
				MainState := DUAL_BLADE;
			END_IF
			MpAxisMaster.Update := FALSE;
			MpAxisSlave.Update := FALSE;
			
		SINGLE_BLADE:
			Main.Cmd.bDoubleBlade := FALSE;
			Axis.Cmd.bDoubleBlade := FALSE;
			Main.Cmd.bSingleBlade := FALSE;
			Axis.Cmd.bSingleBlade := TRUE;
			MpAxisMaster.Update := TRUE;
			MpAxisSlave.Update := TRUE;
			IF MpAxisMaster.UpdateDone AND MpAxisSlave.UpdateDone THEN
				MainState := SELECT_MODE;
			END_IF
		
		DUAL_BLADE:
			Main.Cmd.bSingleBlade := FALSE;
			Axis.Cmd.bSingleBlade := FALSE;
			Main.Cmd.bDoubleBlade := FALSE;
			Axis.Cmd.bDoubleBlade := TRUE;
			MpAxisMaster.Update := TRUE;
			MpAxisSlave.Update := TRUE;
			IF MpAxisMaster.UpdateDone AND MpAxisSlave.UpdateDone THEN
				MainState := SELECT_MODE;
			END_IF
		  

	END_CASE;
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

