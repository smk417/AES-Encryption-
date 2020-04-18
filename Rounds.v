`include "SubBytes_plus_ShiftRows.v"
`include "MixColumns.v"

module round  #(   parameter NK__KEY_LENGTH		  =	 8	,
		   parameter NR__ROUNDS		  	  =	14	,
	       	   parameter NB__BLOCK_LENGTH_IN_TEXT 	  =	 4	   ) 	(

		   round_number_in	,
		   state_text_in	,
		   state_text_out
	   	   
		   								);
//Ports declared here with sizes and directions

input 	wire [NB__BLOCK_LENGTH_IN_TEXT-1:0] 			round_number_in 	;
input 	wire [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	state_text_in  		;

output  wire [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	state_text_out  	;


	wire [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] 	state_text_out_inter  	;
        reg  [15:0]						round_no_store		;

	
SubBytes_plus_ShiftRows	inst_SubBytes_plus_ShiftRow(
							.in_word	(state_text_in)		,	
							.out_word	(state_text_out_inter)
													);

MixColumn 			     inst_Mixcolumn(
							.in_word	(state_text_out_inter)	,	
							.out_word	(state_text_out)
													);


always@(round_number_in)
begin
	round_no_store = round_number_in	;
end	

endmodule
