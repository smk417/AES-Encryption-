module addRoundKey  #(   parameter NK__KEY_LENGTH		  =	 8	,
		   parameter NR__ROUNDS		  	  =	14	,
	       	   parameter NB__BLOCK_LENGTH_IN_TEXT 	  =	 4	   ) 	(

		   round_number_in	,
		   state_text_in	,
		   key_schedule_in	,
		   state_text_out 	   
		   								);

										
input 	wire [NB__BLOCK_LENGTH_IN_TEXT-1:0] 			round_number_in 	;
input 	wire [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	state_text_in  		;
input   wire [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0]  key_schedule_in		;

output  wire [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	state_text_out  	;

        reg  [15:0]						round_no_store		;	


assign state_text_out = state_text_in ^ key_schedule_in 				;

always@(round_number_in)
begin
	round_no_store = round_number_in	;
end

endmodule

