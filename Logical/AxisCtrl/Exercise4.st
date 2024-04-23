
ACTION Exercise4: 
	CamSeqPara.Configuration.Master 			:= ADR(gAxis04);
	CamSeqPara.Configuration.MasterParID 		:= ACP10PAR_PCTRL_S_ACT;
	
	(** Event 0 - WAIT FOR TRIGGER **) 
	CamSeqPara.Configuration.State[0].Event[0].Type 				:= ncST_END; //Trigger 
	CamSeqPara.Configuration.State[0].Event[0].Attribute		 	:= ncST_END; //Reaction 
	CamSeqPara.Configuration.State[0].Event[0].NextState 			:= 1; //Next State 
	(*************************** STATE 1 ****************************)
	CamSeqPara.Configuration.State[1].CamProfileIndex 		  		:= 16#FFFE;
	CamSeqPara.Configuration.State[1].MasterFactor 					:= 1; //Master Dist. 
	CamSeqPara.Configuration.State[1].SlaveFactor 					:= 1; //Slave Dist.
	
	CamSeqPara.Configuration.State[1].CompMode   	 				:= ncONLYCOMP;
	CamSeqPara.Configuration.State[1].MasterCompDistance			:= 1620; //Master Dist. 
	CamSeqPara.Configuration.State[1].SlaveCompDistance				:= 1620; //Slave Dist.
	
	(** Event **)
	CamSeqPara.Configuration.State[1].Event[0].Type 				:= ncST_END; //Trigger 
	CamSeqPara.Configuration.State[1].Event[0].Attribute 			:= ncST_END; //Reaction 
	CamSeqPara.Configuration.State[1].Event[0].NextState 			:= 2; //Next State 
	
	(*************************** STATE 2 ****************************)
	CamSeqPara.Configuration.State[2].CamProfileIndex 				:= 16#FFFF;
	CamSeqPara.Configuration.State[2].MasterFactor 					:= 360;  //Master Dist. 
	CamSeqPara.Configuration.State[2].SlaveFactor 					:= -360; //Slave Dist.
	
	
	(** Event **)
	CamSeqPara.Configuration.State[2].Event[0].Type 				:= ncST_END; //Trigger 
	CamSeqPara.Configuration.State[2].Event[0].Attribute 			:= ncST_END; //Reaction 
	CamSeqPara.Configuration.State[2].Event[0].NextState 			:= 3; //Next State
	
	
	(*************************** STATE 3 ****************************)
	CamSeqPara.Configuration.State[3].CamProfileIndex 				:= 16#FFFE;
	CamSeqPara.Configuration.State[3].MasterFactor 					:= 1; //Master Dist. 
	CamSeqPara.Configuration.State[3].SlaveFactor 					:= 1; //Slave Dist.
	
	CamSeqPara.Configuration.State[3].CompMode   	 				:= ncONLYCOMP;
	CamSeqPara.Configuration.State[3].MasterCompDistance			:= 1620; //Master Dist. 
	CamSeqPara.Configuration.State[3].SlaveCompDistance				:= 1620; //Slave Dist.
	
	(** Event **)
	CamSeqPara.Configuration.State[3].Event[0].Type 				:= ncST_END; //Trigger 
	CamSeqPara.Configuration.State[3].Event[0].Attribute 			:= ncST_END; //Reaction 
	CamSeqPara.Configuration.State[3].Event[0].NextState 			:= 1; //Next State
END_ACTION
