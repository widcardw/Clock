module BellSet(
    input CP, nCR, EN, SetBellMode,
    input SetHourBellKey, SetMinuteBellKey,
    input [3:0] MinuteH, MinuteL,
    input [3:0] HourH, HourL,
    output reg [3:0] MinhBell, HouhBell,
    output reg [3:0] MinlBell, HoulBell
);
    wire MinL_CF, MinH_CF;
    wire mlEN, mhEN, hEN;
    wire [3:0]delta_mh, delta_ml, delta_hh, delta_hl;
    assign mlEN = EN && SetBellMode && SetMinuteBellKey;
    assign mhEN = EN && SetBellMode && SetMinuteBellKey && MinL_CF;
    assign hEN = EN && SetBellMode && ((SetMinuteBellKey && MinL_CF && MinH_CF)||SetHourBellKey);
    Counter10 BMin0(CP, nCR, mlEN, delta_ml, MinL_CF);
    Counter6 BMin1(CP, nCR, mhEN, delta_mh, MinH_CF);
    Counter12 BHou(CP, nCR, hEN, delta_hh, delta_hl);
    always @ (posedge CP)
    begin
		if (SetBellMode)begin
			MinhBell <= MinuteH + delta_mh;
			MinlBell <= MinuteL + delta_ml;
			HouhBell <= HourH + delta_hh;
			HoulBell <= HourL + delta_hl;
        end
    end

endmodule

module BellAlarm(
    input CP, EN, SetBellMode, BellEn,
    input [3:0] CurMinh, CurMinl, CurHouh, CurHoul,
    input [3:0] BelMinh, BelMinl, BelHouh, BelHoul,
    output BellRadio
);
    assign BellRadio = CP&(EN&&BellEn&&(~SetBellMode)
        &&CurMinh==BelMinh
        &&CurMinl==BelMinl
        &&CurHouh==BelHouh
        &&CurHoul==BelHoul);
    //assign BellRadio = CP&(EN&&BellEn&&(~SetBellMode));
endmodule
