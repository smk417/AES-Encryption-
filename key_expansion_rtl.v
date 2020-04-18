//takes in the user key,user text and number of rounds as input
//operates on it and gives out word schedule format

module key_expansion #(parameter NK__KEY_LENGTH		  =	 8	,
		       parameter NR__ROUNDS		  =	14	,
	       	       parameter NB__BLOCK_LENGTH_IN_TEXT =	 4	 ) 	(
				
                       clk_in				,
		       rst_in				,
		       user_plain_txt_in 			,
                       cipher_key_in 			,
                       rounds_for_encryption_in	        ,
		       key_schedule_created_k0          ,				        
		       key_schedule_created_k1          ,				        
		       key_schedule_created_k2          ,				        
		       key_schedule_created_k3          ,				        
		       key_schedule_created_k4          ,				        
		       key_schedule_created_k5          ,				        
		       key_schedule_created_k6          ,				        
		       key_schedule_created_k7           				        
		       								);

// User ports of Module added and specfied sizes here
input  wire 								clk_in    			; 
input  wire 								rst_in 				; 
input  wire   [(NB__BLOCK_LENGTH_IN_TEXT*32) 		-1	: 0  ]	user_plain_txt_in 		; 
input  wire   [(NK__KEY_LENGTH*32)	    		-1	: 0  ]	cipher_key_in 			; 
input  wire   [(NR__ROUNDS-1)		    		-1	: 0  ]	rounds_for_encryption_in	;

output reg    [(NK__KEY_LENGTH*32)                       -1     : 0  ]	key_schedule_created_k0	        ;
output reg    [(NK__KEY_LENGTH*32)                       -1     : 0  ]	key_schedule_created_k1	        ;
output reg    [(NK__KEY_LENGTH*32)                       -1     : 0  ]	key_schedule_created_k2	        ;
output reg    [(NK__KEY_LENGTH*32)                       -1     : 0  ]	key_schedule_created_k3	        ;
output reg    [(NK__KEY_LENGTH*32)                       -1     : 0  ]	key_schedule_created_k4	        ;
output reg    [(NK__KEY_LENGTH*32)                       -1     : 0  ]	key_schedule_created_k5	        ;
output reg    [(NK__KEY_LENGTH*32)                       -1     : 0  ]	key_schedule_created_k6	        ;
output reg    [(NK__KEY_LENGTH*32)                       -1     : 0  ]	key_schedule_created_k7	        ;


// Internal nets/regs declared here

wire   	      [(NK__KEY_LENGTH*32)                       -1     : 0  ]	key_schedule_created_k0_w	        ;	       
wire   	      [(NK__KEY_LENGTH*32)                       -1     : 0  ]	key_schedule_created_k1_w	        ;	       
wire   	      [(NK__KEY_LENGTH*32)                       -1     : 0  ]	key_schedule_created_k2_w	        ;	       
wire   	      [(NK__KEY_LENGTH*32)                       -1     : 0  ]	key_schedule_created_k3_w	        ;	       
wire   	      [(NK__KEY_LENGTH*32)                       -1     : 0  ]	key_schedule_created_k4_w	        ;	       
wire   	      [(NK__KEY_LENGTH*32)                       -1     : 0  ]	key_schedule_created_k5_w	        ;	       
wire   	      [(NK__KEY_LENGTH*32)                       -1     : 0  ]	key_schedule_created_k6_w	        ;	       
wire   	      [(NK__KEY_LENGTH*32)                       -1     : 0  ]	key_schedule_created_k7_w	        ;	

reg    	      [(4*NB__BLOCK_LENGTH_IN_TEXT)-1:0] 			i,j 									 ; 
reg    	      [(NK__KEY_LENGTH*4)-1: 0] 				internal_key_sched_reg [(NB__BLOCK_LENGTH_IN_TEXT*(NR__ROUNDS+1))-1 : 0] ;
reg    	      [(NK__KEY_LENGTH*4)-1: 0] 				temp 									 ;			
reg    	      [(NK__KEY_LENGTH*4)-1: 0] 				Rcon   		       [7:0] 						 ;		

// Nk Key Length                 here 8  Nk
// Nr Rounds                     here 14 Nr
// Nb Block plain text length    here 4  Nb 


//create a key_schedule in this always block 
always @(posedge clk_in)
begin
	if(!rst_in)
	begin
		i = 0 ;
		j = 0 ;

		key_schedule_created_k0 = 0 ;
		key_schedule_created_k1 = 0 ;
		key_schedule_created_k2 = 0 ;
		key_schedule_created_k3 = 0 ;
		key_schedule_created_k4 = 0 ;
		key_schedule_created_k5 = 0 ;
		key_schedule_created_k6 = 0 ;
		key_schedule_created_k7 = 0 ;

		Rcon[0] = 32'h01000000;
		Rcon[1] = 32'h01000000;
		Rcon[2] = 32'h02000000;
		Rcon[3] = 32'h04000000;
		Rcon[4] = 32'h08000000;
		Rcon[5] = 32'h10000000;
		Rcon[6] = 32'h20000000;
		Rcon[7] = 32'h40000000;

		temp = 32'h0;
		
		for( i = 0 ; i < NB__BLOCK_LENGTH_IN_TEXT*(NR__ROUNDS+1) ; i=i+1)
		begin
			internal_key_sched_reg[i] = 32'h0;
		end
	end

	else   // if reset is not applied start creating key schedule here 
	begin
		
		internal_key_sched_reg[0] = cipher_key_in[ ((NK__KEY_LENGTH*32)-1)     -: 32  ] ;
		internal_key_sched_reg[1] = cipher_key_in[ ((NK__KEY_LENGTH*32)-1)-32  -: 32  ] ;
		internal_key_sched_reg[2] = cipher_key_in[ ((NK__KEY_LENGTH*32)-1)-64  -: 32  ] ;
		internal_key_sched_reg[3] = cipher_key_in[ ((NK__KEY_LENGTH*32)-1)-96  -: 32  ] ;
		internal_key_sched_reg[4] = cipher_key_in[ ((NK__KEY_LENGTH*32)-1)-128 -: 32  ] ;
		internal_key_sched_reg[5] = cipher_key_in[ ((NK__KEY_LENGTH*32)-1)-160 -: 32  ] ;
		internal_key_sched_reg[6] = cipher_key_in[ ((NK__KEY_LENGTH*32)-1)-192 -: 32  ] ;
		internal_key_sched_reg[7] = cipher_key_in[ ((NK__KEY_LENGTH*32)-1)-224 -: 32  ] ;
		
		$display("key_schedule_created_k0=%h\n",key_schedule_created_k0);

		for (i = NK__KEY_LENGTH ; i < NB__BLOCK_LENGTH_IN_TEXT*(NR__ROUNDS+1) ; i = i+1 )
		begin
			temp = internal_key_sched_reg[i-1];
			$display("initial temp [ internal_key_sched_reg[%0d] = %h",i,temp);
			if(i % NK__KEY_LENGTH == 0)
			begin
				temp   = SubWord(RotWord(temp)) ^ Rcon[i/NK__KEY_LENGTH] ; 				
			        $display("SubWord(RotWord(temp))^Rcon at (i=%0d) = %h",i,temp);	
			end

			else if (NK__KEY_LENGTH > 6 && (i % NK__KEY_LENGTH) == 4)
			begin
				temp = SubWord(temp);
			end
                        internal_key_sched_reg[i] = internal_key_sched_reg[i-NK__KEY_LENGTH] ^ temp ;
	                $display("internal_key_sched_reg[%d] = %h",i,internal_key_sched_reg[i]);	
		end

		$display("key_schedule_created_k0=%h\n",key_schedule_created_k0);
		$display("key_schedule_created_k1=%h\n",key_schedule_created_k1);
		$display("key_schedule_created_k2=%h\n",key_schedule_created_k2);
		$display("key_schedule_created_k3=%h\n",key_schedule_created_k3);
		$display("key_schedule_created_k4=%h\n",key_schedule_created_k4);
		$display("key_schedule_created_k5=%h\n",key_schedule_created_k5);
		$display("key_schedule_created_k6=%h\n",key_schedule_created_k6);
		$display("key_schedule_created_k7=%h\n",key_schedule_created_k7);
		
	end

end

//following always block is for the storing a key schedule in output reg ports from internal wires 
always@(posedge clk_in)
begin
	key_schedule_created_k0	<= key_schedule_created_k0_w	;
	key_schedule_created_k1	<= key_schedule_created_k1_w	;
	key_schedule_created_k2	<= key_schedule_created_k2_w	;
	key_schedule_created_k3	<= key_schedule_created_k3_w	;
	key_schedule_created_k4	<= key_schedule_created_k4_w	;
	key_schedule_created_k5	<= key_schedule_created_k5_w	;
	key_schedule_created_k6	<= key_schedule_created_k6_w	;
	key_schedule_created_k7	<= key_schedule_created_k7_w	;
end


assign key_schedule_created_k0_w =          {   internal_key_sched_reg[0],	
						internal_key_sched_reg[1],	
						internal_key_sched_reg[2],	
						internal_key_sched_reg[3],	
						internal_key_sched_reg[4],	
						internal_key_sched_reg[5],	
						internal_key_sched_reg[6],	
						internal_key_sched_reg[7]  } ; 	

					

assign key_schedule_created_k1_w =          {   internal_key_sched_reg[8],	
						internal_key_sched_reg[9],	
						internal_key_sched_reg[10],	
						internal_key_sched_reg[11],	
						internal_key_sched_reg[12],	
						internal_key_sched_reg[13],	
						internal_key_sched_reg[14],	
						internal_key_sched_reg[15]  } ; 	
					
					
					
assign key_schedule_created_k2_w =          {   internal_key_sched_reg[16],	
						internal_key_sched_reg[17],	
						internal_key_sched_reg[18],	
						internal_key_sched_reg[19],	
						internal_key_sched_reg[20],	
						internal_key_sched_reg[21],	
						internal_key_sched_reg[22],	
						internal_key_sched_reg[23]  } ; 	
					
					
assign key_schedule_created_k3_w =          {   internal_key_sched_reg[24],	
						internal_key_sched_reg[25],	
						internal_key_sched_reg[26],	
						internal_key_sched_reg[27],	
						internal_key_sched_reg[28],	
						internal_key_sched_reg[29],	
						internal_key_sched_reg[30],	
						internal_key_sched_reg[31]  } ; 	
					
assign key_schedule_created_k4_w =          {   internal_key_sched_reg[32],	
						internal_key_sched_reg[33],	
						internal_key_sched_reg[34],	
						internal_key_sched_reg[35],	
						internal_key_sched_reg[36],	
						internal_key_sched_reg[37],	
						internal_key_sched_reg[38],	
						internal_key_sched_reg[39]  } ; 	


					
assign key_schedule_created_k5_w =          {   internal_key_sched_reg[40],	
						internal_key_sched_reg[41],	
						internal_key_sched_reg[42],	
						internal_key_sched_reg[43],	
						internal_key_sched_reg[44],	
						internal_key_sched_reg[45],	
						internal_key_sched_reg[46],	
						internal_key_sched_reg[47]  } ; 	
					
assign key_schedule_created_k6_w =          {   internal_key_sched_reg[48],	
						internal_key_sched_reg[49],	
						internal_key_sched_reg[50],	
						internal_key_sched_reg[51],	
						internal_key_sched_reg[52],	
						internal_key_sched_reg[53],	
						internal_key_sched_reg[54],	
						internal_key_sched_reg[55]  } ; 	

assign key_schedule_created_k7_w =          {   internal_key_sched_reg[56],	
						internal_key_sched_reg[57],	
						internal_key_sched_reg[58],	
						internal_key_sched_reg[59],
							 	     32'h0,
								     32'h0,
								     32'h0,	 
								     32'h0	
									    } ; 	


function automatic [(NK__KEY_LENGTH*4)-1 : 0] RotWord(input reg [(NK__KEY_LENGTH*4)-1 : 0] in_temp_RotWord);
begin	
	RotWord = {in_temp_RotWord[23:16],in_temp_RotWord[15:8],in_temp_RotWord[7:0],in_temp_RotWord[31:24]};
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
        $display("SubWord=%h",SubWord);											
end:SubWord_blk
endfunction

endmodule
