// Copyright 2015 ETH Zurich and University of Bologna.
// Copyright 2017 Embecosm Limited <www.embecosm.com>
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

module dp_ram #(
    parameter ADDR_WIDTH = 8,
    parameter INSTR_RDATA_WIDTH = 128
) (
    input logic clk_i,

    input  logic                         en_a_i,
    input  logic [       ADDR_WIDTH-1:0] addr_a_i,
    input  logic [                 31:0] wdata_a_i,
    output logic [INSTR_RDATA_WIDTH-1:0] rdata_a_o,
    input  logic                         we_a_i,
    input  logic [                  3:0] be_a_i,

    input  logic                  en_b_i,
    input  logic [ADDR_WIDTH-1:0] addr_b_i,
    input  logic [          31:0] wdata_b_i,
    output logic [          31:0] rdata_b_o,
    input  logic                  we_b_i,
    input  logic [           3:0] be_b_i
);

  localparam bytes = 2 ** ADDR_WIDTH;

  logic [           7:0] mem        [bytes];
  logic [ADDR_WIDTH-1:0] addr_a_int;
  logic [ADDR_WIDTH-1:0] addr_b_int;

  always_comb addr_a_int = {addr_a_i[ADDR_WIDTH-1:2], 2'b0};
  always_comb addr_b_int = {addr_b_i[ADDR_WIDTH-1:2], 2'b0};

  always @(posedge clk_i) begin
    for (int i = 0; i < INSTR_RDATA_WIDTH / 8; i++) begin
      rdata_a_o[(i*8)+:8] <= mem[addr_a_int+i];
    end

    /* addr_b_i is the actual memory address referenced */
    if (en_b_i) begin
      /* handle writes */
      if (we_b_i) begin
        if (be_b_i[0]) mem[addr_b_int] <= wdata_b_i[0+:8];
        if (be_b_i[1]) mem[addr_b_int+1] <= wdata_b_i[8+:8];
        if (be_b_i[2]) mem[addr_b_int+2] <= wdata_b_i[16+:8];
        if (be_b_i[3]) mem[addr_b_int+3] <= wdata_b_i[24+:8];
      end
            /* handle reads */
            else
      begin
        /*if ($test$plusargs("verbose"))
          $display("read  addr=0x%08x: data=0x%08x", addr_b_int, {
                   mem[addr_b_int+3], mem[addr_b_int+2], mem[addr_b_int+1], mem[addr_b_int+0]});*/

        rdata_b_o[7:0]   <= mem[addr_b_int];
        rdata_b_o[15:8]  <= mem[addr_b_int+1];
        rdata_b_o[23:16] <= mem[addr_b_int+2];
        rdata_b_o[31:24] <= mem[addr_b_int+3];
      end
    end
  end
  
  
  
  
 /* 
initial begin

    // pixel 0 @ 0x1000
    mem[32'h1000] = 8'h44;
    mem[32'h1001] = 8'h33;
    mem[32'h1002] = 8'h22;
    mem[32'h1003] = 8'h11;


    // pixel 1 @ 0x1004
    mem[32'h1004] = 8'h88;
    mem[32'h1005] = 8'h77;
    mem[32'h1006] = 8'h66;
    mem[32'h1007] = 8'h55;


    // pixel 2 @ 0x1008
    mem[32'h1008] = 8'hCC;
    mem[32'h1009] = 8'hBB;
    mem[32'h100A] = 8'hAA;
    mem[32'h100B] = 8'h99;
	
	
	mem[32'h100C] = 8'hDD;
mem[32'h100D] = 8'hCC;
mem[32'h100E] = 8'hBB;
mem[32'h100F] = 8'hAA;

mem[32'h1010] = 8'h04;
mem[32'h1011] = 8'h03;
mem[32'h1012] = 8'h02;
mem[32'h1013] = 8'h01;

mem[32'h1014] = 8'h08;
mem[32'h1015] = 8'h07;
mem[32'h1016] = 8'h06;
mem[32'h1017] = 8'h05;

mem[32'h1018] = 8'h0C;
mem[32'h1019] = 8'h0B;
mem[32'h101A] = 8'h0A;
mem[32'h101B] = 8'h09;

mem[32'h101C] = 8'h10;
mem[32'h101D] = 8'h0F;
mem[32'h101E] = 8'h0E;
mem[32'h101F] = 8'h0D;

mem[32'h1020] = 8'h14;
mem[32'h1021] = 8'h13;
mem[32'h1022] = 8'h12;
mem[32'h1023] = 8'h11;


// weights @ 0x2000

// weight 0
mem[32'h2000] = 8'h01;
mem[32'h2001] = 8'h00;
mem[32'h2002] = 8'h00;
mem[32'h2003] = 8'h00;

// weight 1
mem[32'h2004] = 8'h02;
mem[32'h2005] = 8'h00;
mem[32'h2006] = 8'h00;
mem[32'h2007] = 8'h00;

// weight 2
mem[32'h2008] = 8'h03;
mem[32'h2009] = 8'h00;
mem[32'h200A] = 8'h00;
mem[32'h200B] = 8'h00;

// weight 3
mem[32'h200C] = 8'h04;
mem[32'h200D] = 8'h00;
mem[32'h200E] = 8'h00;
mem[32'h200F] = 8'h00;

// weight 4
mem[32'h2010] = 8'h05;
mem[32'h2011] = 8'h00;
mem[32'h2012] = 8'h00;
mem[32'h2013] = 8'h00;

// weight 5
mem[32'h2014] = 8'h06;
mem[32'h2015] = 8'h00;
mem[32'h2016] = 8'h00;
mem[32'h2017] = 8'h00;

// weight 6
mem[32'h2018] = 8'h07;
mem[32'h2019] = 8'h00;
mem[32'h201A] = 8'h00;
mem[32'h201B] = 8'h00;

// weight 7
mem[32'h201C] = 8'h08;
mem[32'h201D] = 8'h00;
mem[32'h201E] = 8'h00;
mem[32'h201F] = 8'h00;

// weight 8
mem[32'h2020] = 8'h09;
mem[32'h2021] = 8'h00;
mem[32'h2022] = 8'h00;
mem[32'h2023] = 8'h00;



end*/








  export "DPI-C"
  function read_byte
  ; export "DPI-C"
  task write_byte
  ;

  function int read_byte(input logic [ADDR_WIDTH-1:0] byte_addr);
    read_byte = mem[byte_addr];
  endfunction

  task write_byte(input integer byte_addr, logic [7:0] val, output logic [7:0] other);
    mem[byte_addr] = val;
    other          = mem[byte_addr];

  endtask

endmodule  // dp_ram
