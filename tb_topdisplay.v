module tb_topdisplay();

    // Inputs
    reg clk;
    reg rst;
    reg [13:0] switches;

    // Outputs
    wire [6:0] seg;
    wire [3:0] digit_sel;
    wire DP;
    
    // Additional monitor signals
    wire [1:0] reg_write_data_W_out;
    wire gprs_we_i_W;
    wire [31:0] display_7_seg_data;
    wire [15:0] bcd_data;

    // Instantiate the DUT
    topdisplay dut (
        .clk(clk),
        .rst(rst),
        .switches(switches),
        .seg(seg),
        .digit_sel(digit_sel),
        .DP(DP)
    );
    
    // Probe internal signals for monitoring
    assign reg_write_data_W_out = dut.reg_write_data_W_out;
    assign gprs_we_i_W = dut.gprs_we_i_W;
    assign display_7_seg_data = dut.display_7_seg_data;
    assign bcd_data = dut.bcd_data;

    // Clock generation (100 MHz)
    initial clk = 0;
    always #5 clk = ~clk;
    
    // Stimulus and test sequence
    initial begin
        $display("Starting topdisplay testbench...");
        
        // Initialize inputs
        rst = 1;
        switches = 14'b0;
        
        // Reset sequence
        #20;
        rst = 0;
        
        // Test case 1: Basic switch input
        $display("\nTest case 1: Simple switch input (1234)");
        switches = 14'b00010011010010; // 1234 in binary
        #100;
        
        // Test case 2: Max displayable value
        $display("\nTest case 2: Maximum display value (9999)");
        switches = 14'b10011100001111; // 9999 in binary
        #100;
        
        // Test case 3: Processor operation test
        $display("\nTest case 3: Processor operation");
        switches = 14'b00000000001010; // 10 in binary
        #200;
        
        // Test case 4: Random value
        $display("\nTest case 4: Random value (3725)");
        switches = 14'b00111010001101; // 3725 in binary
        #100;
        
        // End simulation
        $display("\nSimulation completed");
        $finish;
    end
    
    // Monitoring
    initial begin
        $monitor("At time %t: rst=%b, switches=%d | Processor: reg_write=%b, we=%b | Display: raw=0x%h, BCD=%h | Segments: %b, digit_sel=%b, DP=%b",
                 $time, rst, switches,
                 reg_write_data_W_out, gprs_we_i_W,
                 display_7_seg_data, bcd_data,
                 seg, digit_sel, DP);
    end
    
    // Additional checks
    always @(posedge clk) begin
        if (!rst) begin
            // Check for valid BCD output (each nibble <= 9)
            if (bcd_data[3:0] > 4'h9 || bcd_data[7:4] > 4'h9 || 
                bcd_data[11:8] > 4'h9 || bcd_data[15:12] > 4'h9) begin
                $error("Invalid BCD output detected: %h", bcd_data);
            end
        end
    end

endmodule