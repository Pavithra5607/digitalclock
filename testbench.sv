module tb_clock;

    
    reg Clk_1sec;
    reg reset;

    wire [5:0] seconds;
    wire [5:0] minutes;
    wire [4:0] hours;
  wire blink_led;
  wire [6:0] seg_min, seg_hr;
  wire [3:0] an_min, an_hr;

    Digital_Clock uut (
        .Clk_1sec(Clk_1sec), 
        .reset(reset), 
        .seconds(seconds), 
        .minutes(minutes), 
        .hours(hours)
    );
  assign blink_led = seconds[0]; 
  wire [3:0] min_units = minutes % 10;
  wire [3:0] min_tens = minutes / 10;
  wire [3:0] hr_units = hours% 10;
  wire [3:00] hr_tens = hours / 10;
  
  bcd_to_7seg_display min_display (.clk(Clk_1sec), .reset(reset), .bcd_data({4'b0000, 4'b0000, hr_tens, hr_units}), .seg(seg_hr), .an(an_hr));
  
    
    initial Clk_1sec = 0;
    always #500 Clk_1sec = ~Clk_1sec;  
    initial begin
      $dumpfile("Digital_Clock.vcd");
      $dumpvars;
      $monitor("Time:%0t | H:%0d M:%0d S:%0d", $time, hours, minutes, seconds, blink_led);
        reset = 1;
       
        #100;
        reset = 0;  
      #50000;
      $finish;
      
    end
      
endmodule