module Clock(
	input CP, nCR, EN, Adj_M, Adj_H,
	output [3:0]Secondh,Minuteh,Hourh,
	output [3:0]Secondl,Minutel,Hourl,
	output [3:0] MinhShow, MinlShow, HouhShow, HoulShow,
	output [3:0] MinhBell, HouhBell, MinlBell, HoulBell,
	output [15:0]segS,segM,segH,
	output HourRadio,
	input SetBellMode, BellEn, 
	input SetHourBellKey, SetMinuteBellKey,
	output BellRadio
);
	wire EN_SH, EM_ML, EM_MH, EM_HL, EN_HH, NU; // Carry Flag
	wire EN_H_L, EN_H_H, EN_M_L, EM_M_H; // real Cin of the bit
	wire clk_1Hz, clk_m, clk_h;
	//clk_1hz(CP, clk_1Hz);
	assign clk_1Hz=CP;//for waveform visual test
	assign clk_h = clk_1Hz ~^ Adj_H;//clk for hour
	assign clk_m = clk_1Hz ~^ Adj_M;//clk for minute
	//clk_m/clk_h can receive the signals of both original clk and adj
	//but there still remain some problems
	//clk:__^^__^^__^^__^^__^^__
	//adj:^^^^^____^^^^^^^^^^^^^
	//out:__^^_^__^_^^__^^__^^__
	
	//Second 
	Counter10 USec0(clk_1Hz, nCR, EN, Secondl[3:0], EN_SH);
	//EN_SH==Carry Flag of SecLow
	Counter6 USec1(clk_1Hz, nCR, EN_SH, Secondh[3:0], EN_ML);
	//EN_ML==Carry Flag of SecHigh
	
	//Minute
	assign EN_M_L = ({Secondh,Secondl}==8'h59)||~Adj_M;
	//EN_M_L is the real EN for MinLow
	//only receive the signal of Second==8'h59 or Adj_M
	//EN_ML keeps enabled when Secondh==4'h5
	//in this condition, MinuteLow receives 10 signals of clk
	Counter10 UMin0(clk_m, nCR, EN_M_L, Minutel[3:0], EN_MH);
	assign EN_M_H = EN_M_L && EN_MH;
	//EN_M_H == (Minutel==4'h9)&&({Secondh,Secondl}==8'h59)
	Counter6 UMin1(clk_m, nCR, EN_M_H, Minuteh[3:0], EN_HL);
	
	//Hour
	assign EN_H_L = (EN_HL && EN_M_H)||~Adj_H;
	//only receive the signal of (Second==8'h59&&Minute==8'h59) or Adj_H
	Counter12 UHou(clk_h, nCR, EN_H_L, Hourh[3:0], Hourl[3:0]);
	
	//HourRadio(Ring when it hits an hour)
	//assign HourRadio=clk_1Hz&({Minuteh,Minutel,Secondh,Secondl}==16'h0000);
	//In this way, the clock rings once it hits 'xx:00:00', 
	//that's to say, it keeps ringing when we enable the nCR.
	assign HourRadio=clk_1Hz&(EN_HL && EN_M_H);
	//In this way, the clock only rings when it comes to an o'clock
	//that's to say, it rings at xx:59:59, which sounds a little awful
	
	// wire [3:0] MinhBell, HouhBell, MinlBell, HoulBell;
	BellSet Bs0(clk_1Hz, nCR, EN, SetBellMode,
				SetHourBellKey, SetMinuteBellKey,
				Minuteh, Minutel, Hourh, Hourl,
				MinhBell, HouhBell, MinlBell, HoulBell);
	BellAlarm Ba0(clk_1Hz, EN, SetBellMode, BellEn,
				  Minuteh, Minutel, Hourh, Hourl,
				  MinhBell, MinlBell, HouhBell, HoulBell,
				  BellRadio);
	
	// wire [3:0] MinhShow, MinlShow, HouhShow, HoulShow;
	assign MinhShow = SetBellMode ? MinhBell : Minuteh;
	assign MinlShow = SetBellMode ? MinlBell : Minutel;
	assign HouhShow = SetBellMode ? HouhBell : Hourh;
	assign HoulShow = SetBellMode ? HoulBell : Hourl;

	//BCDto7LED decoder
	_BCDto7LED Ssec(Secondh[3:0], Secondl[3:0], segS[15:8], segS[7:0]);
	_BCDto7LED Smin(MinhShow[3:0], MinlShow[3:0], segM[15:8], segM[7:0]);
	_BCDto7LED Shou(HouhShow[3:0], HoulShow[3:0], segH[15:8], segH[7:0]);
endmodule
