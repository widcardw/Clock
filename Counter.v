module Counter10(
	input CP, nCR, EN,
	output reg [3:0] Q,
	output sCo
);
	always @(posedge CP or negedge nCR)
	begin
		if (~nCR) Q<=4'h0;
		else if (~EN) Q<=Q;
		else if (Q==4'h9) Q<=4'h0;
		else Q<=Q+1'b1;
	end
	assign sCo=Q==4'h9;
endmodule

module Counter6(
	input CP, nCR, EN,
	output reg [3:0] Q,
	output sCo
);
	always @(posedge CP or negedge nCR)
	begin
		if (~nCR) Q<=4'h0;
		else if (~EN) Q<=Q;
		else if (Q==4'h5) Q<=4'h0;
		else Q<=Q+1'b1;
	end
	assign sCo=Q==4'h5;
endmodule

module Counter2(
	input CP, nCR, EN,
	output reg [3:0] Q,
	output sCo
);
	always @(posedge CP or negedge nCR)
	begin
		if (~nCR) Q<=4'h0;
		else if (~EN) Q<=Q;
		else if (Q==4'h1) Q<=4'h0;
		else Q<=Q+1'b1;
	end
	assign sCo=Q==4'h1;
endmodule

module Counter60(
	input CP, nCR, EN,
	output [3:0] qh, ql,
	output sCo
);
	wire EN_H, NU;
	Counter10 U0(CP, nCR, EN, ql, EN_H);
	Counter6 U1(CP, nCR, EN_H, qh, NU);
	assign sCo = {qh, ql}==8'h59;
endmodule

module Counter12(
	input CP, nCR, EN,
	output reg [3:0] qh, ql
);
	always @ (posedge CP or negedge nCR)
	begin
		if (~nCR) {qh,ql}<=8'h00;
		else if (~EN){qh,ql}<={qh,ql};
		else if ((qh>1||ql>9)||((qh==1)&&(ql>=1))) {qh,ql}<=8'h00;
		else if ((qh==1)&&(ql<1))begin
			qh<=qh; ql<=ql+1'b1;
		end
		else if (ql==9) begin
			qh<=qh+1'b1; ql<=4'h0;
		end
		else begin
			qh<=qh; ql<=ql+1'b1;
		end
	end
endmodule
