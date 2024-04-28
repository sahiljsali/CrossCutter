(*|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|*)
(*| Copyright      :-  B&R Industrial Automation GmbH                                                            |*)
(*| Contact Person :-   salis                                                                          		     |*)
(*|——————————————————————————————————————————————————————————————————————————————————————————————————————————————|*)
(*| System       :-  Cross Cutter                                                                                |*)
(*| Task Name    :-  Audit.st                                                                                    |*)
(*| Auther Name  :-   salis                                                                                      |*)
(*| Created Date :-  April 28, 2024/10:21 AM                                                                     |*)
(*| AS Version   :-  AS 4.12.4.107 SP                                                                            |*)
(*|——————————————————————————————————————————————————————————————————————————————————————————————————————————————|*)
(*| Description  :-  Audit Control Logic                               											 |*)
(*|                                                                                                              |*)
(*|——————————————————————————————————————————————————————————————————————————————————————————————————————————————|*)
(*| Version :-         V 1.0                      salis                                                          |*)
(*|——————————————————————————————————————————————————————————————————————————————————————————————————————————————|*)
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	(********************************* Function Block For Audit and Event Log ***************************************)
	
	MpAuditRegPar_0(MpLink := ADR(gAuditTrail), Enable := TRUE, PVName := ADR('VisuCtrl:SpeedInRPM') );
	
	MpAuditTrail_0(MpLink := ADR(gAuditTrail), Enable := TRUE, Language := ADR('en'), DeviceName := ADR('Audit'));
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

