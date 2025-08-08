module topdisplay (
    input clk,
    input rst,
    input [13:0] switches,
    output [6:0] seg,
    output [3:0] digit_sel,
    output DP
);
    // Processor interface signals
    wire [1:0] reg_write_data_W_out;
    wire gprs_we_i_W;
    wire [31:0] display_7_seg_data;
    
    // Display conversion signals
    wire [15:0] bcd_data;

    // Instantiate the RISC-V processor
    risc_v_piplined #(
        .DATA_MEM_SIZE(10240),
        .INSTR_SIZE(1024)
    ) processor (
        .clk(clk),
        .rst(rst),
        .ce(1'b1),
        .reg_write_data_W_out(reg_write_data_W_out),
        .gprs_we_i_W(gprs_we_i_W),
        .switch_in_data({2'b00, switches}),  // Pad switches to 16-bit
        .display_7_seg_data(display_7_seg_data)
    );

    // Convert binary to BCD (using either switches or processor output)
    bin2bcd bcd_converter (
        .bin(display_7_seg_data[13:0]),  // Using lower 14 bits of processor output
        .bcd(bcd_data)
    );

    // Instantiate the 7-segment display controller
    display_bcd_7segment_4digit display_unit (
        .data_in(bcd_data),
        .seg(seg),
        .digit_sel(digit_sel),
        .DP(DP),
        .clk(clk)
    );

endmodule
