module _BCDto7LED(input[3:0] qh, 
	input[3:0] ql, 
	output reg[7:0] segh, 
	output reg[7:0] segl);
    always@(qh)
        case(qh)
            4'h0: segh=~8'h3F;
            4'h1: segh=~8'h06;
            4'h2: segh=~8'h5B;
            4'h3: segh=~8'h4F;
            4'h4: segh=~8'h66;
            4'h5: segh=~8'h6D;
            4'h6: segh=~8'h7D;
            4'h7: segh=~8'h07;
            4'h8: segh=~8'h7F;
            4'h9: segh=~8'h6f;
            4'ha: segh=~8'h77;
            4'hb: segh=~8'h7C;
            4'hc: segh=~8'h39;
            4'hd: segh=~8'h5E;
            4'he: segh=~8'h79;
            4'hf: segh=~8'h71;
        endcase
    always@(ql)
        case(ql)
            4'h0: segl=~8'h3F;
            4'h1: segl=~8'h06;
            4'h2: segl=~8'h5B;
            4'h3: segl=~8'h4F;
            4'h4: segl=~8'h66;
            4'h5: segl=~8'h6D;
            4'h6: segl=~8'h7D;
            4'h7: segl=~8'h07;
            4'h8: segl=~8'h7F;
            4'h9: segl=~8'h6f;
            4'ha: segl=~8'h77;
            4'hb: segl=~8'h7C;
            4'hc: segl=~8'h39;
            4'hd: segl=~8'h5E;
            4'he: segl=~8'h79;
            4'hf: segl=~8'h71;
        endcase
endmodule
