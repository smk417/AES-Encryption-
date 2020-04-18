//This is the topmost file for AES design 
//Add all the instances here 
`include "key_expansion_rtl.v"
`include "Rounds.v"
`include "AddRoundKey.v"
`include "SubBytes_plus_ShiftRows.v"


module top_AES  
#( parameter NK__KEY_LENGTH		  =	 8	,
   parameter NR__ROUNDS		  	  =	14	,
   parameter NB__BLOCK_LENGTH_IN_TEXT 	  =	 4	   ) 	
(		
   clk_in				,
   rst_in				,
   user_plain_txt_in 			,
   cipher_key_in 			,
   rounds_for_encryption_in	        ,
   cipher_encrypted_text_out
);

//Ports sizes and types declaration here 

input    wire 								clk_in    			; 
input    wire 								rst_in 				; 
input    wire   [(NB__BLOCK_LENGTH_IN_TEXT*32) 		-1	: 0  ]	user_plain_txt_in 		; 
input    wire   [(NK__KEY_LENGTH*32)	    		-1	: 0  ]	cipher_key_in 			; 
input    wire   [(NR__ROUNDS-1)		    		-1	: 0  ]	rounds_for_encryption_in	;

output   reg    [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1  : 0  ]	cipher_encrypted_text_out	;
	 wire   [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1  : 0  ]	cipher_encrypted_text_out_w	;

//Internal nets/regs declared here

reg    [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	user_txt_in_reg  		;
reg    [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	state_int_reg  			;

wire   [(NK__KEY_LENGTH*32) -1  : 0  ]				key_schedule_created_k0	        ;
wire   [(NK__KEY_LENGTH*32) -1  : 0  ]				key_schedule_created_k1	        ;
wire   [(NK__KEY_LENGTH*32) -1  : 0  ]				key_schedule_created_k2	        ;
wire   [(NK__KEY_LENGTH*32) -1  : 0  ]				key_schedule_created_k3	        ;
wire   [(NK__KEY_LENGTH*32) -1  : 0  ]				key_schedule_created_k4	        ;
wire   [(NK__KEY_LENGTH*32) -1  : 0  ]				key_schedule_created_k5	        ;
wire   [(NK__KEY_LENGTH*32) -1  : 0  ]				key_schedule_created_k6	        ;
wire   [(NK__KEY_LENGTH*32) -1  : 0  ]				key_schedule_created_k7	        ;

wire   [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	intermediate_wire_round_0	;
wire   [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	intermediate_wire_round_0_1	;
wire   [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	intermediate_wire_round_1	;
wire   [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	intermediate_wire_round_1_1	;
wire   [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	intermediate_wire_round_2	;
wire   [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	intermediate_wire_round_2_1	;
wire   [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	intermediate_wire_round_3	;
wire   [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	intermediate_wire_round_3_1	;
wire   [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	intermediate_wire_round_4	;
wire   [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	intermediate_wire_round_4_1	;
wire   [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	intermediate_wire_round_5	;
wire   [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	intermediate_wire_round_5_1	;
wire   [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	intermediate_wire_round_6	;
wire   [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	intermediate_wire_round_6_1	;
wire   [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	intermediate_wire_round_7	;
wire   [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	intermediate_wire_round_7_1	;
wire   [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	intermediate_wire_round_8	;
wire   [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	intermediate_wire_round_8_1	;
wire   [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	intermediate_wire_round_9	;
wire   [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	intermediate_wire_round_9_1	;
wire   [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	intermediate_wire_round_10	;
wire   [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	intermediate_wire_round_10_1	;
wire   [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	intermediate_wire_round_11	;
wire   [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	intermediate_wire_round_11_1	;
wire   [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	intermediate_wire_round_12	;
wire   [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	intermediate_wire_round_12_1	;
wire   [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	intermediate_wire_round_13	;
wire   [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	intermediate_wire_round_13_1	;
wire   [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	intermediate_wire_round_14	;
wire   [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	intermediate_wire_round_14_1	;


//Functionality starts here 


key_expansion 			inst_key_exp(
 		                              .clk_in			(clk_in			  		)	 ,
		                              .rst_in			(rst_in			  		)	 ,
		                              .user_plain_txt_in	(user_plain_txt_in	  		)        ,
                                              .cipher_key_in		(cipher_key_in		  		)	 ,
                                              .rounds_for_encryption_in	(rounds_for_encryption_in 		)        ,
		                              .key_schedule_created_k0  (key_schedule_created_k0  		)        ,				    
		                              .key_schedule_created_k1  (key_schedule_created_k1  		)        ,				        
		                              .key_schedule_created_k2  (key_schedule_created_k2  		)        ,				        
		                              .key_schedule_created_k3  (key_schedule_created_k3  		)        ,				        
		                              .key_schedule_created_k4  (key_schedule_created_k4  		)        ,				        
		                              .key_schedule_created_k5  (key_schedule_created_k5  		)        ,				        
		                              .key_schedule_created_k6  (key_schedule_created_k6  		)        ,				        
		                              .key_schedule_created_k7  (key_schedule_created_k7  		)        
																);

   
//First AddRoundKey 

addRoundKey 		  inst1_addroundkey(
		   			      .round_number_in		(0			  	)	,
		   			      .state_text_in		(user_plain_txt_in	  	)	,
		   			      .key_schedule_in		(cipher_key_in[255:128]	  	)	,
		   			      .state_text_out 	   	(intermediate_wire_round_0	)
														        );
//Rounds Start

//R1
round				inst_round1(
 		        		      .round_number_in		(1				)	,
		   			      .state_text_in		(intermediate_wire_round_0	)	,
		   			      .state_text_out		(intermediate_wire_round_0_1	)	
															);
addRoundKey 		  inst2_addroundkey(
		   			      .round_number_in		(1			  	)	,
		   			      .state_text_in		(intermediate_wire_round_0_1	)	,
		   			      .key_schedule_in		(cipher_key_in[127:0]	  	)	,
		   			      .state_text_out 	   	(intermediate_wire_round_1	)
														        );
//R2
round				inst_round2(
 		        		      .round_number_in		(2					)	,
		   			      .state_text_in		(intermediate_wire_round_1		)	,
		   			      .state_text_out		(intermediate_wire_round_1_1		)	
															);
addRoundKey 		  inst3_addroundkey(
		   			      .round_number_in		(2			  		)	,
		   			      .state_text_in		(intermediate_wire_round_1_1		)	,
		   			      .key_schedule_in		(key_schedule_created_k1[255:128]	)	,
		   			      .state_text_out 	   	(intermediate_wire_round_2		)
														        );
//R3
round				inst_round3(
 		        		      .round_number_in		(3					)	,
		   			      .state_text_in		(intermediate_wire_round_2		)	,
		   			      .state_text_out		(intermediate_wire_round_2_1		)	
															);
addRoundKey 		  inst4_addroundkey(
		   			      .round_number_in		(3			  		)	,
		   			      .state_text_in		(intermediate_wire_round_2_1		)	,
		   			      .key_schedule_in		(key_schedule_created_k1[127:0]	)	,
		   			      .state_text_out 	   	(intermediate_wire_round_3		)
														        );
//R4
round				inst_round4(
 		        		      .round_number_in		(4					)	,
		   			      .state_text_in		(intermediate_wire_round_3		)	,
		   			      .state_text_out		(intermediate_wire_round_3_1		)	
															);
addRoundKey 		  inst5_addroundkey(
		   			      .round_number_in		(4			  		)	,
		   			      .state_text_in		(intermediate_wire_round_3_1		)	,
		   			      .key_schedule_in		(key_schedule_created_k2[255:128]	)	,
		   			      .state_text_out 	   	(intermediate_wire_round_4		)
														        );
//R5
round				inst_round5(
 		        		      .round_number_in		(5					)	,
		   			      .state_text_in		(intermediate_wire_round_4		)	,
		   			      .state_text_out		(intermediate_wire_round_4_1		)	
															);
addRoundKey 		  inst6_addroundkey(
		   			      .round_number_in		(5			  		)	,
		   			      .state_text_in		(intermediate_wire_round_4_1		)	,
		   			      .key_schedule_in		(key_schedule_created_k2[127:0]		)	,
		   			      .state_text_out 	   	(intermediate_wire_round_5		)
														        );
//R6
round				inst_round6(
 		        		      .round_number_in		(6					)	,
		   			      .state_text_in		(intermediate_wire_round_5		)	,
		   			      .state_text_out		(intermediate_wire_round_5_1		)	
															);
addRoundKey 		  inst7_addroundkey(
		   			      .round_number_in		(6			  		)	,
		   			      .state_text_in		(intermediate_wire_round_5_1		)	,
		   			      .key_schedule_in		(key_schedule_created_k3[255:128]	)	,
		   			      .state_text_out 	   	(intermediate_wire_round_6		)
														        );

//R7
round				inst_round7(
 		        		      .round_number_in		(7					)	,
		   			      .state_text_in		(intermediate_wire_round_6		)	,
		   			      .state_text_out		(intermediate_wire_round_6_1		)	
															);
addRoundKey 		  inst8_addroundkey(
		   			      .round_number_in		(7			  		)	,
		   			      .state_text_in		(intermediate_wire_round_6_1		)	,
		   			      .key_schedule_in		(key_schedule_created_k3[127:0]		)	,
		   			      .state_text_out 	   	(intermediate_wire_round_7		)
														        );
//R8
round				inst_round8(
 		        		      .round_number_in		(8					)	,
		   			      .state_text_in		(intermediate_wire_round_7		)	,
		   			      .state_text_out		(intermediate_wire_round_7_1		)	
															);
addRoundKey 		  inst9_addroundkey(
		   			      .round_number_in		(8			  		)	,
		   			      .state_text_in		(intermediate_wire_round_7_1		)	,
		   			      .key_schedule_in		(key_schedule_created_k4[255:128]	)	,
		   			      .state_text_out 	   	(intermediate_wire_round_8		)
														        );
//R9
round				inst_round9(
 		        		      .round_number_in		(9					)	,
		   			      .state_text_in		(intermediate_wire_round_8		)	,
		   			      .state_text_out		(intermediate_wire_round_8_1		)	
															);
addRoundKey 		  inst10_addroundkey(
		   			      .round_number_in		(9			  		)	,
		   			      .state_text_in		(intermediate_wire_round_8_1		)	,
		   			      .key_schedule_in		(key_schedule_created_k4[127:0]		)	,
		   			      .state_text_out 	   	(intermediate_wire_round_9		)
														        );
//R10
round				inst_round10(
 		        		      .round_number_in		(10					)	,
		   			      .state_text_in		(intermediate_wire_round_9		)	,
		   			      .state_text_out		(intermediate_wire_round_9_1		)	
															);
addRoundKey 		  inst11_addroundkey(
		   			      .round_number_in		(10			  		)	,
		   			      .state_text_in		(intermediate_wire_round_9_1		)	,
		   			      .key_schedule_in		(key_schedule_created_k5[255:128]	)	,
		   			      .state_text_out 	   	(intermediate_wire_round_10		)
														        );

//R11
round				inst_round11(
 		        		      .round_number_in		(11					)	,
		   			      .state_text_in		(intermediate_wire_round_10		)	,
		   			      .state_text_out		(intermediate_wire_round_10_1		)	
															);
addRoundKey 		  inst12_addroundkey(
		   			      .round_number_in		(11			  		)	,
		   			      .state_text_in		(intermediate_wire_round_10_1		)	,
		   			      .key_schedule_in		(key_schedule_created_k5[127:0]		)	,
		   			      .state_text_out 	   	(intermediate_wire_round_11		)
														        );

//R12
round				inst_round12(
 		        		      .round_number_in		(12					)	,
		   			      .state_text_in		(intermediate_wire_round_11		)	,
		   			      .state_text_out		(intermediate_wire_round_11_1		)	
															);
addRoundKey 		  inst13_addroundkey(
		   			      .round_number_in		(12			  		)	,
		   			      .state_text_in		(intermediate_wire_round_11_1		)	,
		   			      .key_schedule_in		(key_schedule_created_k6[255:128]	)	,
		   			      .state_text_out 	   	(intermediate_wire_round_12		)
														        );

//R13
round				inst_round13(
 		        		      .round_number_in		(13					)	,
		   			      .state_text_in		(intermediate_wire_round_12		)	,
		   			      .state_text_out		(intermediate_wire_round_12_1		)	
															);
addRoundKey 		  inst14_addroundkey(
		   			      .round_number_in		(13			  		)	,
		   			      .state_text_in		(intermediate_wire_round_12_1		)	,
		   			      .key_schedule_in		(key_schedule_created_k6[127:0]		)	,
		   			      .state_text_out 	   	(intermediate_wire_round_13		)
														        );

//Last Round 
SubBytes_plus_ShiftRows	

	       inst15_SubBytes_plus_ShiftRow(
					      .in_word			(intermediate_wire_round_13		)	,	
					      .out_word			(intermediate_wire_round_13_1		)
															);
addRoundKey 		  inst15_addroundkey(
		   			      .round_number_in		(14			  		)	,
		   			      .state_text_in		(intermediate_wire_round_13_1		)	,
		   			      .key_schedule_in		(key_schedule_created_k7[255:128]	)	,
		   			      .state_text_out 	   	(intermediate_wire_round_14		)
														        );


//Final Cipher text is assigned here : 

assign cipher_encrypted_text_out_w = intermediate_wire_round_14	;



always @(posedge clk_in)
begin
	cipher_encrypted_text_out <= cipher_encrypted_text_out_w ;
end

/*
always @(*)
begin
	cipher_encrypted_text_out = cipher_encrypted_text_out_w ;
end
*/

endmodule
