
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	MpAuditRegPar_0(MpLink := ADR(gAuditTrail), Enable := TRUE, PVName := ADR('VisuCtrl:SpeedInRPM') );
	
	MpAuditTrail_0(MpLink := ADR(gAuditTrail), Enable := TRUE, Language := ADR('en'), DeviceName := ADR('Audit'));
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

