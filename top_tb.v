`include "top_AES.v"
`timescale 10ns/1ns 
module top_tb;

parameter NK__KEY_LENGTH		=	 8	;
parameter NR__ROUNDS		  	=	14	;
parameter NB__BLOCK_LENGTH_IN_TEXT 	=	 4	;


reg 								clk_in    			; 
reg 								rst_in 				; 
reg   [(NB__BLOCK_LENGTH_IN_TEXT*32) 		-1	: 0  ]	user_plain_txt_in 		; 
reg   [(NK__KEY_LENGTH*32)	    		-1	: 0  ]	cipher_key_in 			; 
reg   [(NR__ROUNDS-1)		    		-1	: 0  ]	rounds_for_encryption_in	;

wire  [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1  : 0  ]	cipher_encrypted_text_out	;


top_AES  
inst_top
(		
   .clk_in			(clk_in				)	,
   .rst_in			(rst_in				)	,
   .user_plain_txt_in 		(user_plain_txt_in 		)	,
   .cipher_key_in 		(cipher_key_in 			)	,
   .rounds_for_encryption_in	(rounds_for_encryption_in	)      	,
   .cipher_encrypted_text_out   (cipher_encrypted_text_out   	)
);


initial 
begin
	clk_in = 0 ;
	forever #5 clk_in = ~ clk_in ;
end				

initial 
begin
	rst_in = 0 ;
	repeat(3) @(posedge clk_in);
	rst_in = 1 ;
end	

initial 
begin
	@(posedge clk_in);
        cipher_key_in 			= 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f	;
	user_plain_txt_in   		= 128'h00112233445566778899aabbccddeeff					;
	#60;
	user_plain_txt_in   		= 128'h66778899aabbccddeeff001122334455					;
	#60;
	user_plain_txt_in   		= 128'h00112233445566770011223344556677					;
	rounds_for_encryption_in 	= 14 									; 
end


endmodule
