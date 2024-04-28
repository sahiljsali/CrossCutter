(*|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|*)
(*| Copyright      :-  B&R Industrial Automation GmbH                                                            |*)
(*| Contact Person :-   salis                                                                          		     |*)
(*|——————————————————————————————————————————————————————————————————————————————————————————————————————————————|*)
(*| System       :-  Cross Cutter                                                                                |*)
(*| Task Name    :-  MainCtrl.st                                                                                 |*)
(*| Auther Name  :-   salis                                                                                      |*)
(*| Created Date :-  April 28, 2024/10:21 AM                                                                     |*)
(*| AS Version   :-  AS 4.12.4.107 SP                                                                            |*)
(*|——————————————————————————————————————————————————————————————————————————————————————————————————————————————|*)
(*| Description  :-  Main Control and Mode Selection Logic                                                       |*)
(*|                                                                                                              |*)
(*|——————————————————————————————————————————————————————————————————————————————————————————————————————————————|*)
(*| Version :-         V 1.0                      salis                                                          |*)
(*|——————————————————————————————————————————————————————————————————————————————————————————————————————————————|*)
PROGRAM _INIT
	
	 
END_PROGRAM

PROGRAM _CYCLIC
	(********************************* State Machine for Main Control and Mode Selection ***************************************)

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
	
	 
END_PROGRAM

