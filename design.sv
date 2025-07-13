module Digital_Clock(
    Clk_1sec,  
    reset,     
    seconds,
    minutes,
    hours);

    input Clk_1sec;  
    input reset;
    output [5:0] seconds;
    output [5:0] minutes;
    output [4:0] hours;
    reg [5:0] seconds;
    reg [5:0] minutes;
    reg [4:0] hours; 

   
    always @(posedge(Clk_1sec) or posedge(reset))
    begin
        if(reset == 1'b1) begin  
            seconds = 0;
            minutes = 0;
            hours = 0;  end
        else if(Clk_1sec == 1'b1) begin 
            seconds = seconds + 1; 
            if(seconds == 60) begin
                seconds = 0;  
                minutes = minutes + 1; 
                if(minutes == 60) begin 
                    minutes = 0;  
                    hours = hours + 1;  
                   if(hours ==  24) begin  
                        hours = 0; 
                    end 
                end
            end     
        end
    end     

endmodule

module bcd_to_7seg_display (
    input clk,
    input reset,
    input [15:0] bcd_data,
    output reg [6:0] seg,
    output reg [3:0] an
);
    reg [1:0] digit_select = 0;
    reg [15:0] refresh_counter = 0;
    reg [3:0] current_bcd;

    wire refresh_tick = (refresh_counter == 49999);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            refresh_counter <= 0;
            digit_select <= 0;
        end else if (refresh_tick) begin
            refresh_counter <= 0;
            digit_select <= digit_select + 1;
        end else begin
            refresh_counter <= refresh_counter + 1;
        end
    end

    always @(*) begin
        case (digit_select)
            2'b00: begin current_bcd = bcd_data[3:0];   an = 4'b1110; end
            2'b01: begin current_bcd = bcd_data[7:4];   an = 4'b1101; end
            2'b10: begin current_bcd = bcd_data[11:8];  an = 4'b1011; end
            2'b11: begin current_bcd = bcd_data[15:12]; an = 4'b0111; end
        endcase
    end

    always @(*) begin
        case (current_bcd)
            4'd0: seg = 7'b1111110;
            4'd1: seg = 7'b0110000;
            4'd2: seg = 7'b1101101;
            4'd3: seg = 7'b1111001;
            4'd4: seg = 7'b0110011;
            4'd5: seg = 7'b1011011;
            4'd6: seg = 7'b1011111;
            4'd7: seg = 7'b1110000;
            4'd8: seg = 7'b1111111;
            4'd9: seg = 7'b1111011;
            default: seg = 7'b0000001;
        endcase
    end
endmodule