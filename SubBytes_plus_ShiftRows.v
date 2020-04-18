module SubBytes_plus_ShiftRows #(	parameter NK__KEY_LENGTH		  =	 8 ,
		       			parameter NR__ROUNDS		  	  =	14 ,
	       	       			parameter NB__BLOCK_LENGTH_IN_TEXT 	  =	 4	 ) 	(

					in_word	,	
					out_word
													);

//Ports Declared to be set here 
input  wire [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] in_word	;
output wire [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1:0] out_word	;

//Internal nets declare here 

//Functionality starts here 

assign out_word = ShiftRow(SubByte(in_word)) ; 

//Functions defined here 

function automatic [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1 : 0] SubByte(input reg [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1 : 0] in_temp_SubByte);
begin:SubByte_blk
	reg [(NK__KEY_LENGTH*4)-1 : 0] 	word_1,word_2,word_3,word_4 ;
	reg [(NK__KEY_LENGTH*4)-1 : 0] 	sub_word_1,sub_word_2,sub_word_3,sub_word_4 ;

	word_1 = in_temp_SubByte[((NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1    ) -: 32]; 
	word_2 = in_temp_SubByte[((NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1 -32) -: 32]; 
	word_3 = in_temp_SubByte[((NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1 -64) -: 32]; 
	word_4 = in_temp_SubByte[((NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1 -96) -: 32]; 
	
	sub_word_1  =  SubWord(word_1);
	sub_word_2  =  SubWord(word_2);
	sub_word_3  =  SubWord(word_3);
	sub_word_4  =  SubWord(word_4);
	
	SubByte  =  {sub_word_1,sub_word_2,sub_word_3,sub_word_4};
		
end:SubByte_blk
endfunction

//            127..    95..     63..     31..
//SBox  -->   63cab704 0953d051 cd60e0e7 ba70e18c
//ShRow -->   6353e08c 0960e104 cd70b751 bacad0e7
//MxCol -->   5f726415 57f5bc92 f7be3b29 1db9f91a


function automatic [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1 : 0] ShiftRow (input reg [(NB__BLOCK_LENGTH_IN_TEXT*NK__KEY_LENGTH*4)-1 : 0] in_temp_ShiftRow);
begin
	ShiftRow = {	
			in_temp_ShiftRow[127:120]	,
			in_temp_ShiftRow[87:80] 	,
			in_temp_ShiftRow[47:40]		,
			in_temp_ShiftRow[7:0]		,		
			in_temp_ShiftRow[95:88]		,
			in_temp_ShiftRow[55:48]		,
			in_temp_ShiftRow[15:8]		,
			in_temp_ShiftRow[103:96]	,		
			in_temp_ShiftRow[63:56]		,
			in_temp_ShiftRow[23:16]		,
			in_temp_ShiftRow[111:104]	,
			in_temp_ShiftRow[71:64]		,		
			in_temp_ShiftRow[31:24]		,
			in_temp_ShiftRow[119:112]	,
			in_temp_ShiftRow[79:72]		,
			in_temp_ShiftRow[39:32]				
								};

end
endfunction


function automatic [(NK__KEY_LENGTH*4)-1 : 0] SubWord(input reg [(NK__KEY_LENGTH*4)-1 : 0] in_temp_SubWord);
begin:SubWord_blk
	reg [7:0] s_boxed_value_first_byte,s_boxed_value_second_byte,s_boxed_value_third_byte,s_boxed_value_fourth_byte ;	
	reg [15:0] i , j ;
	reg [(NK__KEY_LENGTH*4)-1 : 0 ] s_box_lut [(NB__BLOCK_LENGTH_IN_TEXT*4)-1 : 0][(NB__BLOCK_LENGTH_IN_TEXT*4)-1 : 0];
																				
	s_box_lut   [0][0]   =  8'h63 ;	
	s_box_lut   [0][1]   =  8'h7c ; 	
	s_box_lut   [0][2]   =  8'h77 ; 	
	s_box_lut   [0][3]   =  8'h7b ; 	
	s_box_lut   [0][4]   =  8'hf2 ; 	
	s_box_lut   [0][5]   =  8'h6b ; 	
	s_box_lut   [0][6]   =  8'h6f ; 	
	s_box_lut   [0][7]   =  8'hc5 ; 	
	s_box_lut   [0][8]   =  8'h30 ; 	
	s_box_lut   [0][9]   =  8'h01 ; 	
	s_box_lut   [0][10]  =  8'h67 ; 	
	s_box_lut   [0][11]  =  8'h2b ; 	
	s_box_lut   [0][12]  =  8'hfe ; 	
	s_box_lut   [0][13]  =  8'hd7 ; 	
	s_box_lut   [0][14]  =  8'hab ; 	
	s_box_lut   [0][15]  =  8'h76 ; 	
	s_box_lut   [1][0]   =  8'hca ;	
	s_box_lut   [1][1]   =  8'h82 ; 	
	s_box_lut   [1][2]   =  8'hc9 ; 	
	s_box_lut   [1][3]   =  8'h7d ; 	
	s_box_lut   [1][4]   =  8'hfa ; 	
	s_box_lut   [1][5]   =  8'h59 ; 	
	s_box_lut   [1][6]   =  8'h47 ; 	
	s_box_lut   [1][7]   =  8'hf0 ; 	
	s_box_lut   [1][8]   =  8'had ; 	
	s_box_lut   [1][9]   =  8'hd4 ; 	
	s_box_lut   [1][10]  =  8'ha2 ; 	
	s_box_lut   [1][11]  =  8'haf ; 	
	s_box_lut   [1][12]  =  8'h9c ; 	
	s_box_lut   [1][13]  =  8'ha4 ; 	
	s_box_lut   [1][14]  =  8'h72 ; 	
	s_box_lut   [1][15]  =  8'hc0 ; 	
	s_box_lut   [2][0]   =  8'hb7 ;	
	s_box_lut   [2][1]   =  8'hfd ; 	
	s_box_lut   [2][2]   =  8'h93 ; 	
	s_box_lut   [2][3]   =  8'h26 ; 	
	s_box_lut   [2][4]   =  8'h36 ; 	
	s_box_lut   [2][5]   =  8'h3f ; 	
	s_box_lut   [2][6]   =  8'hf7 ; 	
	s_box_lut   [2][7]   =  8'hcc ; 	
	s_box_lut   [2][8]   =  8'h34 ; 	
	s_box_lut   [2][9]   =  8'ha5 ; 	
	s_box_lut   [2][10]  =  8'he5 ; 	
	s_box_lut   [2][11]  =  8'hf1 ; 	
	s_box_lut   [2][12]  =  8'h71 ; 	
	s_box_lut   [2][13]  =  8'hd8 ; 	
	s_box_lut   [2][14]  =  8'h31 ; 	
	s_box_lut   [2][15]  =  8'h15 ; 	
	s_box_lut   [3][0]   =  8'h04 ;	
	s_box_lut   [3][1]   =  8'hc7 ; 	
	s_box_lut   [3][2]   =  8'h23 ; 	
	s_box_lut   [3][3]   =  8'hc3 ; 	
	s_box_lut   [3][4]   =  8'h18 ; 	
	s_box_lut   [3][5]   =  8'h96 ; 	
	s_box_lut   [3][6]   =  8'h05 ; 	
	s_box_lut   [3][7]   =  8'h9a ; 	
	s_box_lut   [3][8]   =  8'h07 ; 	
	s_box_lut   [3][9]   =  8'h12 ; 	
	s_box_lut   [3][10]  =  8'h80 ; 	
	s_box_lut   [3][11]  =  8'he2 ; 	
	s_box_lut   [3][12]  =  8'heb ; 	
	s_box_lut   [3][13]  =  8'h27 ; 	
	s_box_lut   [3][14]  =  8'hb2 ; 	
	s_box_lut   [3][15]  =  8'h75 ; 	
	s_box_lut   [4][0]   =  8'h09 ;	
	s_box_lut   [4][1]   =  8'h83 ; 	
	s_box_lut   [4][2]   =  8'h2c ; 	
	s_box_lut   [4][3]   =  8'h1a ; 	
	s_box_lut   [4][4]   =  8'h1b ; 	
	s_box_lut   [4][5]   =  8'h6e ; 	
	s_box_lut   [4][6]   =  8'h5a ; 	
	s_box_lut   [4][7]   =  8'ha0 ; 	
	s_box_lut   [4][8]   =  8'h52 ; 	
	s_box_lut   [4][9]   =  8'h3b ; 	
	s_box_lut   [4][10]  =  8'hd6 ; 	
	s_box_lut   [4][11]  =  8'hb3 ; 	
	s_box_lut   [4][12]  =  8'h29 ; 	
	s_box_lut   [4][13]  =  8'he3 ; 	
	s_box_lut   [4][14]  =  8'h2f ; 	
	s_box_lut   [4][15]  =  8'h84 ; 	
	s_box_lut   [5][0]   =  8'h53 ;	
	s_box_lut   [5][1]   =  8'hd1 ;	
	s_box_lut   [5][2]   =  8'h00 ; 	
	s_box_lut   [5][3]   =  8'hed ; 	
	s_box_lut   [5][4]   =  8'h20 ; 	
	s_box_lut   [5][5]   =  8'hfc ; 	
	s_box_lut   [5][6]   =  8'hb1 ; 	
	s_box_lut   [5][7]   =  8'h5b ; 	
	s_box_lut   [5][8]   =  8'h6a ; 	
	s_box_lut   [5][9]   =  8'hcb ; 	
	s_box_lut   [5][10]  =  8'hbe ; 	
	s_box_lut   [5][11]  =  8'h39 ; 	
	s_box_lut   [5][12]  =  8'h4a ; 	
	s_box_lut   [5][13]  =  8'h4c ; 	
	s_box_lut   [5][14]  =  8'h58 ; 	
	s_box_lut   [5][15]  =  8'hcf ; 	
	s_box_lut   [6][0]   =  8'hd0 ;	
	s_box_lut   [6][1]   =  8'hef ; 	
	s_box_lut   [6][2]   =  8'haa ; 	
	s_box_lut   [6][3]   =  8'hfb ; 	
	s_box_lut   [6][4]   =  8'h43 ; 	
	s_box_lut   [6][5]   =  8'h4d ; 	
	s_box_lut   [6][6]   =  8'h33 ; 	
	s_box_lut   [6][7]   =  8'h85 ; 	
	s_box_lut   [6][8]   =  8'h45 ; 	
	s_box_lut   [6][9]   =  8'hf9 ; 	
	s_box_lut   [6][10]  =  8'h02 ; 	
	s_box_lut   [6][11]  =  8'h7f ; 	
	s_box_lut   [6][12]  =  8'h50 ; 	
	s_box_lut   [6][13]  =  8'h3c ; 	
	s_box_lut   [6][14]  =  8'h9f ; 	
	s_box_lut   [6][15]  =  8'ha8 ; 	
	s_box_lut   [7][0]   =  8'h51 ;	
	s_box_lut   [7][1]   =  8'ha3 ; 	
	s_box_lut   [7][2]   =  8'h40 ; 	
	s_box_lut   [7][3]   =  8'h8f ; 	
	s_box_lut   [7][4]   =  8'h92 ; 	
	s_box_lut   [7][5]   =  8'h9d ; 	
	s_box_lut   [7][6]   =  8'h38 ; 	
	s_box_lut   [7][7]   =  8'hf5 ; 	
	s_box_lut   [7][8]   =  8'hbc ; 	
	s_box_lut   [7][9]   =  8'hb6 ; 	
	s_box_lut   [7][10]  =  8'hda ; 	
	s_box_lut   [7][11]  =  8'h21 ; 	
	s_box_lut   [7][12]  =  8'h10 ; 	
	s_box_lut   [7][13]  =  8'hff ; 	
	s_box_lut   [7][14]  =  8'hf3 ; 	
	s_box_lut   [7][15]  =  8'hd2 ; 	
	s_box_lut   [8][0]   =  8'hcd ;	
	s_box_lut   [8][1]   =  8'h0c ; 	
	s_box_lut   [8][2]   =  8'h13 ; 	
	s_box_lut   [8][3]   =  8'hec ; 	
	s_box_lut   [8][4]   =  8'h5f ; 	
	s_box_lut   [8][5]   =  8'h97 ; 	
	s_box_lut   [8][6]   =  8'h44 ; 	
	s_box_lut   [8][7]   =  8'h17 ; 	
	s_box_lut   [8][8]   =  8'hc4 ; 	
	s_box_lut   [8][9]   =  8'ha7 ; 	
	s_box_lut   [8][10]  =  8'h7e ; 	
	s_box_lut   [8][11]  =  8'h3d ; 	
	s_box_lut   [8][12]  =  8'h64 ; 	
	s_box_lut   [8][13]  =  8'h5d ; 	
	s_box_lut   [8][14]  =  8'h19 ; 	
	s_box_lut   [8][15]  =  8'h73 ; 	
	s_box_lut   [9][0]   =  8'h60 ;	
	s_box_lut   [9][1]   =  8'h81 ; 	
	s_box_lut   [9][2]   =  8'h4f ; 	
	s_box_lut   [9][3]   =  8'hdc ; 	
	s_box_lut   [9][4]   =  8'h22 ; 	
	s_box_lut   [9][5]   =  8'h2a ; 	
	s_box_lut   [9][6]   =  8'h90 ; 	
	s_box_lut   [9][7]   =  8'h88 ; 	
	s_box_lut   [9][8]   =  8'h46 ; 	
	s_box_lut   [9][9]   =  8'hee ; 	
	s_box_lut   [9][10]  =  8'hb8 ; 	
	s_box_lut   [9][11]  =  8'h14 ; 	
	s_box_lut   [9][12]  =  8'hde ; 	
	s_box_lut   [9][13]  =  8'h5e ; 	
	s_box_lut   [9][14]  =  8'h0b ; 	
	s_box_lut   [9][15]  =  8'hdb ; 	
	s_box_lut   [10][0]  =  8'he0 ;	
	s_box_lut   [10][1]  =  8'h32 ; 	
	s_box_lut   [10][2]  =  8'h3a ; 	
	s_box_lut   [10][3]  =  8'h0a ; 	
	s_box_lut   [10][4]  =  8'h49 ; 	
	s_box_lut   [10][5]  =  8'h06 ; 	
	s_box_lut   [10][6]  =  8'h24 ; 	
	s_box_lut   [10][7]  =  8'h5c ; 	
	s_box_lut   [10][8]  =  8'hc2 ; 	
	s_box_lut   [10][9]  =  8'hd3 ; 	
	s_box_lut   [10][10] =  8'hac ; 	
	s_box_lut   [10][11] =  8'h62 ; 	
	s_box_lut   [10][12] =  8'h91 ; 	
	s_box_lut   [10][13] =  8'h95 ; 	
	s_box_lut   [10][14] =  8'he4 ; 	
	s_box_lut   [10][15] =  8'h79 ; 	
	s_box_lut   [11][0]  =  8'he7 ;	
	s_box_lut   [11][1]  =  8'hc8 ; 	
	s_box_lut   [11][2]  =  8'h37 ; 	
	s_box_lut   [11][3]  =  8'h6d ; 	
	s_box_lut   [11][4]  =  8'h8d ; 	
	s_box_lut   [11][5]  =  8'hd5 ; 	
	s_box_lut   [11][6]  =  8'h4e ; 	
	s_box_lut   [11][7]  =  8'ha9 ; 	
	s_box_lut   [11][8]  =  8'h6c ; 	
	s_box_lut   [11][9]  =  8'h56 ; 	
	s_box_lut   [11][10] =  8'hf4 ; 	
	s_box_lut   [11][11] =  8'hea ; 	
	s_box_lut   [11][12] =  8'h65 ; 	
	s_box_lut   [11][13] =  8'h7a ; 	
	s_box_lut   [11][14] =  8'hae ; 	
	s_box_lut   [11][15] =  8'h08 ; 	
	s_box_lut   [12][0]  =  8'hba ;	
	s_box_lut   [12][1]  =  8'h78 ; 	
	s_box_lut   [12][2]  =  8'h25 ; 	
	s_box_lut   [12][3]  =  8'h2e ; 	
	s_box_lut   [12][4]  =  8'h1c ; 	
	s_box_lut   [12][5]  =  8'ha6 ; 	
	s_box_lut   [12][6]  =  8'hb4 ; 	
	s_box_lut   [12][7]  =  8'hc6 ; 	
	s_box_lut   [12][8]  =  8'he8 ; 	
	s_box_lut   [12][9]  =  8'hdd ; 	
	s_box_lut   [12][10] =  8'h74 ; 	
	s_box_lut   [12][11] =  8'h1f ; 	
	s_box_lut   [12][12] =  8'h4b ; 	
	s_box_lut   [12][13] =  8'hbd ; 	
	s_box_lut   [12][14] =  8'h8b ; 	
	s_box_lut   [12][15] =  8'h8a ; 	
	s_box_lut   [13][0]  =  8'h70 ;	
	s_box_lut   [13][1]  =  8'h3e ; 	
	s_box_lut   [13][2]  =  8'hb5 ; 	
	s_box_lut   [13][3]  =  8'h66 ; 	
	s_box_lut   [13][4]  =  8'h48 ; 	
	s_box_lut   [13][5]  =  8'h03 ; 	
	s_box_lut   [13][6]  =  8'hf6 ; 	
	s_box_lut   [13][7]  =  8'h0e ; 	
	s_box_lut   [13][8]  =  8'h61 ; 	
	s_box_lut   [13][9]  =  8'h35 ; 	
	s_box_lut   [13][10] =  8'h57 ; 	
	s_box_lut   [13][11] =  8'hb9 ; 	
	s_box_lut   [13][12] =  8'h86 ; 	
	s_box_lut   [13][13] =  8'hc1 ; 	
	s_box_lut   [13][14] =  8'h1d ; 	
	s_box_lut   [13][15] =  8'h9e ; 	
	s_box_lut   [14][0]  =  8'he1 ;	
	s_box_lut   [14][1]  =  8'hf8 ; 	
	s_box_lut   [14][2]  =  8'h98 ; 	
	s_box_lut   [14][3]  =  8'h11 ; 	
	s_box_lut   [14][4]  =  8'h69 ; 	
	s_box_lut   [14][5]  =  8'hd9 ; 	
	s_box_lut   [14][6]  =  8'h8e ; 	
	s_box_lut   [14][7]  =  8'h94 ; 	
	s_box_lut   [14][8]  =  8'h9b ; 	
	s_box_lut   [14][9]  =  8'h1e ; 	
	s_box_lut   [14][10] =  8'h87 ; 	
	s_box_lut   [14][11] =  8'he9 ; 	
	s_box_lut   [14][12] =  8'hce ; 	
	s_box_lut   [14][13] =  8'h55 ; 	
	s_box_lut   [14][14] =  8'h28 ; 	
	s_box_lut   [14][15] =  8'hdf ; 	
	s_box_lut   [15][0]  =  8'h8c ;	
	s_box_lut   [15][1]  =  8'ha1 ; 	
	s_box_lut   [15][2]  =  8'h89 ; 	
	s_box_lut   [15][3]  =  8'h0d ; 	
	s_box_lut   [15][4]  =  8'hbf ; 	
	s_box_lut   [15][5]  =  8'he6 ; 	
	s_box_lut   [15][6]  =  8'h42 ; 	
	s_box_lut   [15][7]  =  8'h68 ; 	
	s_box_lut   [15][8]  =  8'h41 ; 	
	s_box_lut   [15][9]  =  8'h99 ; 	
	s_box_lut   [15][10] =  8'h2d ; 	
	s_box_lut   [15][11] =  8'h0f ; 	
	s_box_lut   [15][12] =  8'hb0 ; 	
	s_box_lut   [15][13] =  8'h54 ; 	
	s_box_lut   [15][14] =  8'hbb ; 	
	s_box_lut   [15][15] =  8'h16 ; 	

	s_boxed_value_first_byte  = s_box_lut[(in_temp_SubWord[31:28])] [(in_temp_SubWord[27:24])] ;
	s_boxed_value_second_byte = s_box_lut[(in_temp_SubWord[23:20])] [(in_temp_SubWord[19:16])] ;
	s_boxed_value_third_byte  = s_box_lut[(in_temp_SubWord[15:12])] [(in_temp_SubWord[11:8])]  ;
	s_boxed_value_fourth_byte = s_box_lut[(in_temp_SubWord[7:4])]   [(in_temp_SubWord[3:0])]   ;
										
	SubWord = {s_boxed_value_first_byte,s_boxed_value_second_byte,s_boxed_value_third_byte,s_boxed_value_fourth_byte};

end:SubWord_blk
endfunction


//Following function not used but defined 

function automatic [(NK__KEY_LENGTH)-1 : 0 ] s_box_lut (	input reg [(NB__BLOCK_LENGTH_IN_TEXT*4)-1 : 0] in_row_number	,
								input reg [(NB__BLOCK_LENGTH_IN_TEXT*4)-1 : 0] in_column_number		);
begin:s_box_lut_blk
	reg [(NK__KEY_LENGTH*4)-1 : 0 ] s_box_lut_r [(NB__BLOCK_LENGTH_IN_TEXT*4)-1 : 0][(NB__BLOCK_LENGTH_IN_TEXT*4)-1 : 0];
																				
	s_box_lut_r   [0][0]   =  8'h63 ;	
	s_box_lut_r   [0][1]   =  8'h7c ; 	
	s_box_lut_r   [0][2]   =  8'h77 ; 	
	s_box_lut_r   [0][3]   =  8'h7b ; 	
	s_box_lut_r   [0][4]   =  8'hf2 ; 	
	s_box_lut_r   [0][5]   =  8'h6b ; 	
	s_box_lut_r   [0][6]   =  8'h6f ; 	
	s_box_lut_r   [0][7]   =  8'hc5 ; 	
	s_box_lut_r   [0][8]   =  8'h30 ; 	
	s_box_lut_r   [0][9]   =  8'h01 ; 	
	s_box_lut_r   [0][10]  =  8'h67 ; 	
	s_box_lut_r   [0][11]  =  8'h2b ; 	
	s_box_lut_r   [0][12]  =  8'hfe ; 	
	s_box_lut_r   [0][13]  =  8'hd7 ; 	
	s_box_lut_r   [0][14]  =  8'hab ; 	
	s_box_lut_r   [0][15]  =  8'h76 ; 	
	s_box_lut_r   [1][0]   =  8'hca ;	
	s_box_lut_r   [1][1]   =  8'h82 ; 	
	s_box_lut_r   [1][2]   =  8'hc9 ; 	
	s_box_lut_r   [1][3]   =  8'h7d ; 	
	s_box_lut_r   [1][4]   =  8'hfa ; 	
	s_box_lut_r   [1][5]   =  8'h59 ; 	
	s_box_lut_r   [1][6]   =  8'h47 ; 	
	s_box_lut_r   [1][7]   =  8'hf0 ; 	
	s_box_lut_r   [1][8]   =  8'had ; 	
	s_box_lut_r   [1][9]   =  8'hd4 ; 	
	s_box_lut_r   [1][10]  =  8'ha2 ; 	
	s_box_lut_r   [1][11]  =  8'haf ; 	
	s_box_lut_r   [1][12]  =  8'h9c ; 	
	s_box_lut_r   [1][13]  =  8'ha4 ; 	
	s_box_lut_r   [1][14]  =  8'h72 ; 	
	s_box_lut_r   [1][15]  =  8'hc0 ; 	
	s_box_lut_r   [2][0]   =  8'hb7 ;	
	s_box_lut_r   [2][1]   =  8'hfd ; 	
	s_box_lut_r   [2][2]   =  8'h93 ; 	
	s_box_lut_r   [2][3]   =  8'h26 ; 	
	s_box_lut_r   [2][4]   =  8'h36 ; 	
	s_box_lut_r   [2][5]   =  8'h3f ; 	
	s_box_lut_r   [2][6]   =  8'hf7 ; 	
	s_box_lut_r   [2][7]   =  8'hcc ; 	
	s_box_lut_r   [2][8]   =  8'h34 ; 	
	s_box_lut_r   [2][9]   =  8'ha5 ; 	
	s_box_lut_r   [2][10]  =  8'he5 ; 	
	s_box_lut_r   [2][11]  =  8'hf1 ; 	
	s_box_lut_r   [2][12]  =  8'h71 ; 	
	s_box_lut_r   [2][13]  =  8'hd8 ; 	
	s_box_lut_r   [2][14]  =  8'h31 ; 	
	s_box_lut_r   [2][15]  =  8'h15 ; 	
	s_box_lut_r   [3][0]   =  8'h04 ;	
	s_box_lut_r   [3][1]   =  8'hc7 ; 	
	s_box_lut_r   [3][2]   =  8'h23 ; 	
	s_box_lut_r   [3][3]   =  8'hc3 ; 	
	s_box_lut_r   [3][4]   =  8'h18 ; 	
	s_box_lut_r   [3][5]   =  8'h96 ; 	
	s_box_lut_r   [3][6]   =  8'h05 ; 	
	s_box_lut_r   [3][7]   =  8'h9a ; 	
	s_box_lut_r   [3][8]   =  8'h07 ; 	
	s_box_lut_r   [3][9]   =  8'h12 ; 	
	s_box_lut_r   [3][10]  =  8'h80 ; 	
	s_box_lut_r   [3][11]  =  8'he2 ; 	
	s_box_lut_r   [3][12]  =  8'heb ; 	
	s_box_lut_r   [3][13]  =  8'h27 ; 	
	s_box_lut_r   [3][14]  =  8'hb2 ; 	
	s_box_lut_r   [3][15]  =  8'h75 ; 	
	s_box_lut_r   [4][0]   =  8'h09 ;	
	s_box_lut_r   [4][1]   =  8'h83 ; 	
	s_box_lut_r   [4][2]   =  8'h2c ; 	
	s_box_lut_r   [4][3]   =  8'h1a ; 	
	s_box_lut_r   [4][4]   =  8'h1b ; 	
	s_box_lut_r   [4][5]   =  8'h6e ; 	
	s_box_lut_r   [4][6]   =  8'h5a ; 	
	s_box_lut_r   [4][7]   =  8'ha0 ; 	
	s_box_lut_r   [4][8]   =  8'h52 ; 	
	s_box_lut_r   [4][9]   =  8'h3b ; 	
	s_box_lut_r   [4][10]  =  8'hd6 ; 	
	s_box_lut_r   [4][11]  =  8'hb3 ; 	
	s_box_lut_r   [4][12]  =  8'h29 ; 	
	s_box_lut_r   [4][13]  =  8'he3 ; 	
	s_box_lut_r   [4][14]  =  8'h2f ; 	
	s_box_lut_r   [4][15]  =  8'h84 ; 	
	s_box_lut_r   [5][0]   =  8'h53 ;	
	s_box_lut_r   [5][1]   =  8'hd1 ;	
	s_box_lut_r   [5][2]   =  8'h00 ; 	
	s_box_lut_r   [5][3]   =  8'hed ; 	
	s_box_lut_r   [5][4]   =  8'h20 ; 	
	s_box_lut_r   [5][5]   =  8'hfc ; 	
	s_box_lut_r   [5][6]   =  8'hb1 ; 	
	s_box_lut_r   [5][7]   =  8'h5b ; 	
	s_box_lut_r   [5][8]   =  8'h6a ; 	
	s_box_lut_r   [5][9]   =  8'hcb ; 	
	s_box_lut_r   [5][10]  =  8'hbe ; 	
	s_box_lut_r   [5][11]  =  8'h39 ; 	
	s_box_lut_r   [5][12]  =  8'h4a ; 	
	s_box_lut_r   [5][13]  =  8'h4c ; 	
	s_box_lut_r   [5][14]  =  8'h58 ; 	
	s_box_lut_r   [5][15]  =  8'hcf ; 	
	s_box_lut_r   [6][0]   =  8'hd0 ;	
	s_box_lut_r   [6][1]   =  8'hef ; 	
	s_box_lut_r   [6][2]   =  8'haa ; 	
	s_box_lut_r   [6][3]   =  8'hfb ; 	
	s_box_lut_r   [6][4]   =  8'h43 ; 	
	s_box_lut_r   [6][5]   =  8'h4d ; 	
	s_box_lut_r   [6][6]   =  8'h33 ; 	
	s_box_lut_r   [6][7]   =  8'h85 ; 	
	s_box_lut_r   [6][8]   =  8'h45 ; 	
	s_box_lut_r   [6][9]   =  8'hf9 ; 	
	s_box_lut_r   [6][10]  =  8'h02 ; 	
	s_box_lut_r   [6][11]  =  8'h7f ; 	
	s_box_lut_r   [6][12]  =  8'h50 ; 	
	s_box_lut_r   [6][13]  =  8'h3c ; 	
	s_box_lut_r   [6][14]  =  8'h9f ; 	
	s_box_lut_r   [6][15]  =  8'ha8 ; 	
	s_box_lut_r   [7][0]   =  8'h51 ;	
	s_box_lut_r   [7][1]   =  8'ha3 ; 	
	s_box_lut_r   [7][2]   =  8'h40 ; 	
	s_box_lut_r   [7][3]   =  8'h8f ; 	
	s_box_lut_r   [7][4]   =  8'h92 ; 	
	s_box_lut_r   [7][5]   =  8'h9d ; 	
	s_box_lut_r   [7][6]   =  8'h38 ; 	
	s_box_lut_r   [7][7]   =  8'hf5 ; 	
	s_box_lut_r   [7][8]   =  8'hbc ; 	
	s_box_lut_r   [7][9]   =  8'hb6 ; 	
	s_box_lut_r   [7][10]  =  8'hda ; 	
	s_box_lut_r   [7][11]  =  8'h21 ; 	
	s_box_lut_r   [7][12]  =  8'h10 ; 	
	s_box_lut_r   [7][13]  =  8'hff ; 	
	s_box_lut_r   [7][14]  =  8'hf3 ; 	
	s_box_lut_r   [7][15]  =  8'hd2 ; 	
	s_box_lut_r   [8][0]   =  8'hcd ;	
	s_box_lut_r   [8][1]   =  8'h0c ; 	
	s_box_lut_r   [8][2]   =  8'h13 ; 	
	s_box_lut_r   [8][3]   =  8'hec ; 	
	s_box_lut_r   [8][4]   =  8'h5f ; 	
	s_box_lut_r   [8][5]   =  8'h97 ; 	
	s_box_lut_r   [8][6]   =  8'h44 ; 	
	s_box_lut_r   [8][7]   =  8'h17 ; 	
	s_box_lut_r   [8][8]   =  8'hc4 ; 	
	s_box_lut_r   [8][9]   =  8'ha7 ; 	
	s_box_lut_r   [8][10]  =  8'h7e ; 	
	s_box_lut_r   [8][11]  =  8'h3d ; 	
	s_box_lut_r   [8][12]  =  8'h64 ; 	
	s_box_lut_r   [8][13]  =  8'h5d ; 	
	s_box_lut_r   [8][14]  =  8'h19 ; 	
	s_box_lut_r   [8][15]  =  8'h73 ; 	
	s_box_lut_r   [9][0]   =  8'h60 ;	
	s_box_lut_r   [9][1]   =  8'h81 ; 	
	s_box_lut_r   [9][2]   =  8'h4f ; 	
	s_box_lut_r   [9][3]   =  8'hdc ; 	
	s_box_lut_r   [9][4]   =  8'h22 ; 	
	s_box_lut_r   [9][5]   =  8'h2a ; 	
	s_box_lut_r   [9][6]   =  8'h90 ; 	
	s_box_lut_r   [9][7]   =  8'h88 ; 	
	s_box_lut_r   [9][8]   =  8'h46 ; 	
	s_box_lut_r   [9][9]   =  8'hee ; 	
	s_box_lut_r   [9][10]  =  8'hb8 ; 	
	s_box_lut_r   [9][11]  =  8'h14 ; 	
	s_box_lut_r   [9][12]  =  8'hde ; 	
	s_box_lut_r   [9][13]  =  8'h5e ; 	
	s_box_lut_r   [9][14]  =  8'h0b ; 	
	s_box_lut_r   [9][15]  =  8'hdb ; 	
	s_box_lut_r   [10][0]  =  8'he0 ;	
	s_box_lut_r   [10][1]  =  8'h32 ; 	
	s_box_lut_r   [10][2]  =  8'h3a ; 	
	s_box_lut_r   [10][3]  =  8'h0a ; 	
	s_box_lut_r   [10][4]  =  8'h49 ; 	
	s_box_lut_r   [10][5]  =  8'h06 ; 	
	s_box_lut_r   [10][6]  =  8'h24 ; 	
	s_box_lut_r   [10][7]  =  8'h5c ; 	
	s_box_lut_r   [10][8]  =  8'hc2 ; 	
	s_box_lut_r   [10][9]  =  8'hd3 ; 	
	s_box_lut_r   [10][10] =  8'hac ; 	
	s_box_lut_r   [10][11] =  8'h62 ; 	
	s_box_lut_r   [10][12] =  8'h91 ; 	
	s_box_lut_r   [10][13] =  8'h95 ; 	
	s_box_lut_r   [10][14] =  8'he4 ; 	
	s_box_lut_r   [10][15] =  8'h79 ; 	
	s_box_lut_r   [11][0]  =  8'he7 ;	
	s_box_lut_r   [11][1]  =  8'hc8 ; 	
	s_box_lut_r   [11][2]  =  8'h37 ; 	
	s_box_lut_r   [11][3]  =  8'h6d ; 	
	s_box_lut_r   [11][4]  =  8'h8d ; 	
	s_box_lut_r   [11][5]  =  8'hd5 ; 	
	s_box_lut_r   [11][6]  =  8'h4e ; 	
	s_box_lut_r   [11][7]  =  8'ha9 ; 	
	s_box_lut_r   [11][8]  =  8'h6c ; 	
	s_box_lut_r   [11][9]  =  8'h56 ; 	
	s_box_lut_r   [11][10] =  8'hf4 ; 	
	s_box_lut_r   [11][11] =  8'hea ; 	
	s_box_lut_r   [11][12] =  8'h65 ; 	
	s_box_lut_r   [11][13] =  8'h7a ; 	
	s_box_lut_r   [11][14] =  8'hae ; 	
	s_box_lut_r   [11][15] =  8'h08 ; 	
	s_box_lut_r   [12][0]  =  8'hba ;	
	s_box_lut_r   [12][1]  =  8'h78 ; 	
	s_box_lut_r   [12][2]  =  8'h25 ; 	
	s_box_lut_r   [12][3]  =  8'h2e ; 	
	s_box_lut_r   [12][4]  =  8'h1c ; 	
	s_box_lut_r   [12][5]  =  8'ha6 ; 	
	s_box_lut_r   [12][6]  =  8'hb4 ; 	
	s_box_lut_r   [12][7]  =  8'hc6 ; 	
	s_box_lut_r   [12][8]  =  8'he8 ; 	
	s_box_lut_r   [12][9]  =  8'hdd ; 	
	s_box_lut_r   [12][10] =  8'h74 ; 	
	s_box_lut_r   [12][11] =  8'h1f ; 	
	s_box_lut_r   [12][12] =  8'h4b ; 	
	s_box_lut_r   [12][13] =  8'hbd ; 	
	s_box_lut_r   [12][14] =  8'h8b ; 	
	s_box_lut_r   [12][15] =  8'h8a ; 	
	s_box_lut_r   [13][0]  =  8'h70 ;	
	s_box_lut_r   [13][1]  =  8'h3e ; 	
	s_box_lut_r   [13][2]  =  8'hb5 ; 	
	s_box_lut_r   [13][3]  =  8'h66 ; 	
	s_box_lut_r   [13][4]  =  8'h48 ; 	
	s_box_lut_r   [13][5]  =  8'h03 ; 	
	s_box_lut_r   [13][6]  =  8'hf6 ; 	
	s_box_lut_r   [13][7]  =  8'h0e ; 	
	s_box_lut_r   [13][8]  =  8'h61 ; 	
	s_box_lut_r   [13][9]  =  8'h35 ; 	
	s_box_lut_r   [13][10] =  8'h57 ; 	
	s_box_lut_r   [13][11] =  8'hb9 ; 	
	s_box_lut_r   [13][12] =  8'h86 ; 	
	s_box_lut_r   [13][13] =  8'hc1 ; 	
	s_box_lut_r   [13][14] =  8'h1d ; 	
	s_box_lut_r   [13][15] =  8'h9e ; 	
	s_box_lut_r   [14][0]  =  8'he1 ;	
	s_box_lut_r   [14][1]  =  8'hf8 ; 	
	s_box_lut_r   [14][2]  =  8'h98 ; 	
	s_box_lut_r   [14][3]  =  8'h11 ; 	
	s_box_lut_r   [14][4]  =  8'h69 ; 	
	s_box_lut_r   [14][5]  =  8'hd9 ; 	
	s_box_lut_r   [14][6]  =  8'h8e ; 	
	s_box_lut_r   [14][7]  =  8'h94 ; 	
	s_box_lut_r   [14][8]  =  8'h9b ; 	
	s_box_lut_r   [14][9]  =  8'h1e ; 	
	s_box_lut_r   [14][10] =  8'h87 ; 	
	s_box_lut_r   [14][11] =  8'he9 ; 	
	s_box_lut_r   [14][12] =  8'hce ; 	
	s_box_lut_r   [14][13] =  8'h55 ; 	
	s_box_lut_r   [14][14] =  8'h28 ; 	
	s_box_lut_r   [14][15] =  8'hdf ; 	
	s_box_lut_r   [15][0]  =  8'h8c ;	
	s_box_lut_r   [15][1]  =  8'ha1 ; 	
	s_box_lut_r   [15][2]  =  8'h89 ; 	
	s_box_lut_r   [15][3]  =  8'h0d ; 	
	s_box_lut_r   [15][4]  =  8'hbf ; 	
	s_box_lut_r   [15][5]  =  8'he6 ; 	
	s_box_lut_r   [15][6]  =  8'h42 ; 	
	s_box_lut_r   [15][7]  =  8'h68 ; 	
	s_box_lut_r   [15][8]  =  8'h41 ; 	
	s_box_lut_r   [15][9]  =  8'h99 ; 	
	s_box_lut_r   [15][10] =  8'h2d ; 	
	s_box_lut_r   [15][11] =  8'h0f ; 	
	s_box_lut_r   [15][12] =  8'hb0 ; 	
	s_box_lut_r   [15][13] =  8'h54 ; 	
	s_box_lut_r   [15][14] =  8'hbb ; 	
	s_box_lut_r   [15][15] =  8'h16 ;

	s_box_lut = s_box_lut_r[in_row_number][in_column_number] ;
	
end:s_box_lut_blk
endfunction

endmodule
