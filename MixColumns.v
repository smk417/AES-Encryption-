module MixColumn #(	parameter NK__KEY_LENGTH		  =	 8 ,
		       	parameter NR__ROUNDS		  	  =	14 ,
	       	       	parameter NB__BLOCK_LENGTH_IN_TEXT 	  =	 4	 ) 	(

			in_word	,	
			out_word
											);
//Ports declared here
input  wire [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] in_word	;
output wire [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] out_word	;

//Internal nets declare here 

//Functionality starts here 

assign out_word = MixColumn_func(in_word) ; 

//Function declared here 

function automatic [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1 : 0] MixColumn_func(input reg [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1 : 0] in_temp_MixColumn);
begin:MxCol_blk
	reg [(NK__KEY_LENGTH)-1   : 0] 	b_r0_c0,b_r1_c0,b_r2_c0,b_r3_c0,b_r0_c0_t ;
	reg [(NK__KEY_LENGTH)-1   : 0] 	b_r0_c1,b_r1_c1,b_r2_c1,b_r3_c1 ;
	reg [(NK__KEY_LENGTH)-1   : 0] 	b_r0_c2,b_r1_c2,b_r2_c2,b_r3_c2 ;
	reg [(NK__KEY_LENGTH)-1   : 0] 	b_r0_c3,b_r1_c3,b_r2_c3,b_r3_c3 ;
	reg [(NK__KEY_LENGTH*4)-1 : 0] 	mxcol_word_0,mxcol_word_1,mxcol_word_2,mxcol_word_3 ;

b_r0_c0 = (Mult_by_2_GF (in_temp_MixColumn[127:120]) ^ (Mult_by_2_GF(in_temp_MixColumn[119:112])^(in_temp_MixColumn[119:112])) ^ in_temp_MixColumn[111:104] ^ in_temp_MixColumn[103:96]   );
b_r1_c0 = ( in_temp_MixColumn[127:120] ^ Mult_by_2_GF(in_temp_MixColumn[119:112]) ^ (Mult_by_2_GF(in_temp_MixColumn[111:104])^(in_temp_MixColumn[111:104])) ^  in_temp_MixColumn[103:96]    );
b_r2_c0 = ( in_temp_MixColumn[127:120] ^ in_temp_MixColumn[119:112] ^ Mult_by_2_GF(in_temp_MixColumn[111:104]) ^ (Mult_by_2_GF(in_temp_MixColumn[103:96]) ^ (in_temp_MixColumn[103:96]))      );
b_r3_c0 = ( (Mult_by_2_GF(in_temp_MixColumn[127:120])^(in_temp_MixColumn[127:120])) ^ in_temp_MixColumn[119:112] ^ in_temp_MixColumn[111:104] ^ Mult_by_2_GF(in_temp_MixColumn[103:96]) );

b_r0_c1 = ( Mult_by_2_GF(in_temp_MixColumn[95:88]) ^ (Mult_by_2_GF(in_temp_MixColumn[87:80])^(in_temp_MixColumn[87:80])) ^ in_temp_MixColumn[79:72] ^ in_temp_MixColumn[71:64]   );
b_r1_c1 = ( in_temp_MixColumn[95:88] ^ Mult_by_2_GF(in_temp_MixColumn[87:80]) ^ (Mult_by_2_GF(in_temp_MixColumn[79:72])^(in_temp_MixColumn[79:72])) ^  in_temp_MixColumn[71:64]    );
b_r2_c1 = ( in_temp_MixColumn[95:88] ^ in_temp_MixColumn[87:80] ^ Mult_by_2_GF(in_temp_MixColumn[79:72]) ^ (Mult_by_2_GF(in_temp_MixColumn[71:64]) ^ (in_temp_MixColumn[71:64]))      );
b_r3_c1 = ( (Mult_by_2_GF(in_temp_MixColumn[95:88])^(in_temp_MixColumn[95:88])) ^ in_temp_MixColumn[87:80] ^ in_temp_MixColumn[79:72] ^ Mult_by_2_GF(in_temp_MixColumn[71:64]) );
	
b_r0_c2 = ( Mult_by_2_GF(in_temp_MixColumn[63:56]) ^ (Mult_by_2_GF(in_temp_MixColumn[55:48])^(in_temp_MixColumn[55:48])) ^ in_temp_MixColumn[47:40] ^ in_temp_MixColumn[39:32]   );
b_r1_c2 = ( in_temp_MixColumn[63:56] ^ Mult_by_2_GF(in_temp_MixColumn[55:48]) ^ (Mult_by_2_GF(in_temp_MixColumn[47:40])^(in_temp_MixColumn[47:40])) ^  in_temp_MixColumn[39:32]    );
b_r2_c2 = ( in_temp_MixColumn[63:56] ^ in_temp_MixColumn[55:48] ^ Mult_by_2_GF(in_temp_MixColumn[47:40]) ^ (Mult_by_2_GF(in_temp_MixColumn[39:32]) ^ (in_temp_MixColumn[39:32]))      	);
b_r3_c2 = ( (Mult_by_2_GF(in_temp_MixColumn[63:56])^(in_temp_MixColumn[63:56])) ^ in_temp_MixColumn[55:48] ^ in_temp_MixColumn[47:40] ^ Mult_by_2_GF(in_temp_MixColumn[39:32]) );

b_r0_c3 = ( Mult_by_2_GF(in_temp_MixColumn[31:24]) ^ (Mult_by_2_GF(in_temp_MixColumn[23:16])^(in_temp_MixColumn[23:16])) ^ in_temp_MixColumn[15:8] ^ in_temp_MixColumn[7:0]   	);
b_r1_c3 = ( in_temp_MixColumn[31:24] ^ Mult_by_2_GF(in_temp_MixColumn[23:16]) ^ (Mult_by_2_GF(in_temp_MixColumn[15:8])^(in_temp_MixColumn[15:8])) ^  in_temp_MixColumn[7:0]    	);
b_r2_c3 = ( in_temp_MixColumn[31:24] ^ in_temp_MixColumn[23:16] ^ Mult_by_2_GF(in_temp_MixColumn[15:8]) ^ (Mult_by_2_GF(in_temp_MixColumn[7:0]) ^ (in_temp_MixColumn[7:0]))      	);
b_r3_c3 = ( (Mult_by_2_GF(in_temp_MixColumn[31:24])^(in_temp_MixColumn[31:24])) ^ in_temp_MixColumn[23:16] ^ in_temp_MixColumn[15:8] ^ Mult_by_2_GF(in_temp_MixColumn[7:0]) 	);


mxcol_word_0 = { b_r0_c0 , b_r1_c0 , b_r2_c0 , b_r3_c0	};
mxcol_word_1 = { b_r0_c1 , b_r1_c1 , b_r2_c1 , b_r3_c1	};
mxcol_word_2 = { b_r0_c2 , b_r1_c2 , b_r2_c2 , b_r3_c2	};
mxcol_word_3 = { b_r0_c3 , b_r1_c3 , b_r2_c3 , b_r3_c3	};

MixColumn_func = {mxcol_word_0,mxcol_word_1,mxcol_word_2,mxcol_word_3};

end:MxCol_blk
endfunction

function automatic [(NK__KEY_LENGTH)-1  : 0] Mult_by_2_GF(input reg [(NK__KEY_LENGTH)-1  : 0] in_byte);
begin:Mult_by_2_GF_blk
	Mult_by_2_GF = (in_byte[7]==1'b1) ?  (in_byte<<1) ^ 8'h1b : ( in_byte << 1 ) ;
end:Mult_by_2_GF_blk
endfunction


endmodule

