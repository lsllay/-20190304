`timescale 1ns / 1ps
//显示
module Display(
    input clk,
    input clk_display,
    input Auto_End,
    input Power,
    input [7:0] water_level,
    input [7:0] c_time,
    input [7:0] a_time,
    input [7:0] ct_time,
    output reg [7:0] out,
    output reg [7:0] AN
 );
 
    initial out = 8'b11111111;
    initial AN = 8'b11111111;
    reg [7:0] water[1:0],ctime[1:0],atime[1:0],cttime[1:0];
    //更新数据
    always@(posedge clk)
    begin
        water[0] <= water_level % 10;
        water[1] <= water_level / 10;

        ctime[0] <=  c_time % 10;
        ctime[1] <=  c_time / 10;

        atime[0] <=  a_time % 10;
        atime[1] <=  a_time / 10;

        cttime[0] <= Auto_End ? (ct_time % 10): 10;
        cttime[1] <= Auto_End ? (ct_time / 10): 10; 
    end


    //显示管
    reg [3:0] counter;
    initial counter = 0;

    always@(posedge clk_display) counter <= (counter + 1) % 8;

    always@(posedge clk_display)
    begin
        case(counter)                 
            0: AN <= 8'b11111110;             
            1: AN <= 8'b11111101;
            2: AN <= 8'b11111011;
            3: AN <= 8'b11110111;
            4: AN <= 8'b11101111;
            5: AN <= 8'b11011111;
            6: AN <= 8'b10111111;
            7: AN <= 8'b01111111;
            default:AN <= 8'b11111110;
        endcase
    end

    //待显示的数据
    reg [3:0] num_display;
    initial num_display = 4'b1111;

    always@(posedge clk_display)
    begin
        case(counter)
            0: num_display <= water[0];
            1: num_display <= water[1];
            2: num_display <= ctime[0];
            3: num_display <= ctime[1];
            4: num_display <= atime[0];
            5: num_display <= atime[1];
            6: num_display <= cttime[0];
            7: num_display <= cttime[1];
            default: num_display <= 4'b1111;
        endcase
    end

    //译码
    always@(Power or num_display)
    begin
        if(Power == 0) out <= 8'b11111111;
        else
            begin
                case(num_display)
                    0: out <= 8'b11000000;
                    1: out <= 8'b11111001;
                    2: out <= 8'b10100100;
                    3: out <= 8'b10110000;
                    4: out <= 8'b10011001;
                    5: out <= 8'b10010010;
                    6: out <= 8'b10000010;
                    7: out <= 8'b11111000;
                    8: out <= 8'b10000000;
                    9: out <= 8'b10010000;
                    default: out <= 8'b11111111;
                endcase
            end
    end   
endmodule
