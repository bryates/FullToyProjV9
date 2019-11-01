`timescale 1ns / 1ps

// Top-level module for fullDummyProject

module FullDummyProject_top(
  input clk,
  input reset,
  output mem1_enb,
  output mem2_enb,
  input en_proc,
  input[1:0] bx_in,
  output[1:0] bx_out,
  output[3:0] mem1_readaddr,
  output[1:0] mem1_pagea,
  output[1:0] mem1_pageb,
  input[5:0] mem1_nent,
  input[31:0] mem1_dout,
  output[3:0] mem2_readaddr,
  output[1:0] mem2_pagea,
  output[1:0] mem2_pageb,
  input[5:0] mem2_nent,
  input[31:0] mem2_dout,
  output memout_ena,
  output memout_wea,
  output[3:0] memout_writeaddr,
  output[1:0] memout_pagea,
  output[1:0] memout_nent,
  output[31:0] memout_din
);

// memAB_BRAM signals
wire[31:0] memAB_din;
wire[31:0] memAB_dout;
wire[3:0] memAB_readaddr;
wire[3:0] memAB_writeaddr;
wire memAB_ena;
wire memAB_wea;
wire memAB_enb;
wire memAC_wea;
wire memAC_enb;
wire[4:0] memAB_nent1;
wire[4:0] memAB_nent2;
wire[4:0] memAB_nent3;
wire[4:0] memAB_nent4;
reg[1:0] memAB_page;
reg[1:0] memAB_page_w;
reg[1:0] memAB_page_r;

// memAC_BRAM signals
wire[31:0] memAC_din;
wire[31:0] memAC_dout;
wire[5:0] memAC_readaddr;
wire[5:0] memAC_writeaddr;
wire memAC_ena;
wire[4:0] memAC_nent1;
wire[4:0] memAC_nent2;
reg [2:0] memAC_page_w;
reg [2:0] memAC_page_r;

// memBC_BRAM signals
wire[31:0] memBC_din;
wire[31:0] memBC_dout;
wire[3:0] memBC_readaddr;
wire[3:0] memBC_writeaddr;
wire memBC_ena;
wire memBC_wea;
wire memBC_enb;
wire[4:0] memBC_nent1;
wire[4:0] memBC_nent2;
reg[1:0] memBC_page;
reg[1:0] memBC_page_w;
reg[1:0] memBC_page_r;
reg[1:0] memo_page;

// Process start/done signals
reg processB_start;
reg processC_start;
wire processA_done;
wire processB_done;
wire processC_done;

initial begin
  processB_start = 1'b0;
  processC_start = 1'b0;
  memAB_page_w = 1'b0;
  memAB_page_r = 1'b0;
  memAC_page_w = 1'b0;
  memAC_page_r = 1'b0;
  memBC_page_w = 1'b0;
  memBC_page_r = 1'b0;
end

//always @(posedge clk) begin
always @(processA_done) begin
  if (processA_done) begin
    memAB_page_w = memAB_page_w + 1'b1;
    memAC_page_w = memAC_page_w + 1'b1;
  end
  if (processA_done) processB_start = 1'b1;
end
//always @(posedge clk) begin
//  if (mem1_nent == memAB_nent1) processB_start = 1'b1;
//end
always @(processB_done) begin
  if (processB_done) memBC_page_w = memBC_page_w + 1'b1;
  if (processB_done) processC_start = 1'b1;
end
always @(processC_start) begin
  if(processC_start) begin
    memAB_page = memAB_page_r;
    memBC_page = memBC_page_r;
  end
end
always @(processC_done) begin
  if (processC_done) memo_page = memo_page + 1'b1;
  if (processC_done) begin
    memAB_page_r = memAB_page_r + 1'b1;
    memBC_page_r = memBC_page_r + 1'b1;
    memAB_page = memAB_page_w;
    memBC_page = memBC_page_w;
  end
end

assign mem1_pagea = memAB_page_w;
assign mem2_pagea = memAC_page_w;

// Instantiate all BRAMs
Memory #(
    .RAM_WIDTH(32),
    .RAM_DEPTH(16),
    .PAGES(2),
    .RAM_PERFORMANCE("HIGH_PERFORMANCE"),
    .HEX(0),
    .INIT_FILE("")
    ) memAB_BRAM (
    .clka(clk),
    .addra(memAB_writeaddr),
    .dina(memAB_din),
    .wea(memAB_wea),
    .clkb(clk),
    .pagea(memAB_page_w),
    .pageb(memAB_page_r),
    .addrb(memAB_readaddr),
    .doutb(memAB_dout),
    .regceb(1'b1),
    .nent_i(memAB_nent1),
    .enb(memAB_enb)
);
//blk_mem_gen_2page memAB_BRAM (
//  .clka(clk),
//  .addra(memAB_writeaddr),
//  .dina(memAB_din),
//  .ena(memAB_ena),
//  .wea(memAB_wea),
//  .clkb(clk),
//  .addrb(memAB_readaddr),
//  .doutb(memAB_dout),
//  .enb(memAB_enb)
//);

//blk_mem_gen_4page memAC_BRAM (
//  .clka(clk),
//  .addra(memAC_writeaddr),
//  .dina(memAC_din),
//  .ena(memAC_ena),
//  .wea(memAC_wea),
//  .clkb(clk),
//  .addrb(memAC_readaddr),
//  .doutb(memAC_dout),
//  .enb(memAC_enb)
//);
Memory #(
    .RAM_WIDTH(32),
    .RAM_DEPTH(16),
    .PAGES(4),
    .RAM_PERFORMANCE("HIGH_PERFORMANCE"),
    .INIT_FILE("")
    ) memAC_BRAM (
    .clka(clk),
    .addra(memAC_writeaddr),
    .dina(memAC_din),
    .wea(memAC_wea),
    .clkb(clk),
    .pagea(memAC_page_w),
    .pageb(memAC_page_r),
    .addrb(memAC_readaddr),
    .doutb(memAC_dout),
    .regceb(1'b1),
    .nent_i(memAC_nent1),
    .enb(memAC_enb)
);

//blk_mem_gen_2page memBC_BRAM (
//  .clka(clk),
//  .addra(memBC_writeaddr),
//  .dina(memBC_din),
//  .ena(memBC_ena),
//  .wea(memBC_wea),
//  .clkb(clk),
//  .addrb(memBC_readaddr),
//  .doutb(memBC_dout),
//  .enb(memBC_enb)
//);
Memory #(
    .RAM_WIDTH(32),
    .RAM_DEPTH(16),
    .PAGES(2),
    .RAM_PERFORMANCE("HIGH_PERFORMANCE"),
    .INIT_FILE("")
    ) memBC_BRAM (
    .clka(clk),
    .addra(memBC_writeaddr),
    .dina(memBC_din),
    .wea(memBC_wea),
    .clkb(clk),
    .pagea(memBC_page_w),
    .pageb(memBC_page_r),
    .addrb(memBC_readaddr),
    .doutb(memBC_dout),
    .regceb(1'b1),
    .nent_i(memBC_nent1),
    .enb(memBC_enb)
);

// Internal BX signals
wire[1:0] bx_out_A;
wire[1:0] bx_out_B;

// Instantiate ProcessA
processA_0 doA (
  .inmem1_ce0(mem1_enb),
  .inmem2_ce0(mem2_enb),
  .outmem1_ce0(memAB_ena),
  .outmem1_we0(memAB_wea),
  .outmem2_ce0(memAC_ena),
  .outmem2_we0(memAC_wea),
  .ap_clk(clk),
  .ap_rst(reset),
  .ap_start(en_proc),
  .ap_done(processA_done),
  .bx_V(bx_in),
  .bx_o_V(bx_out_A),
  .inmem1_address0(mem1_readaddr),
  .inmem1_q0(mem1_dout),
  .inmem2_address0(mem2_readaddr),
  .inmem2_q0(mem2_dout),
  .outmem1_address0(memAB_writeaddr),
  .outmem1_d0(memAB_din),
  .outmem2_address0(memAC_writeaddr),
  .nent_i1_0_V(mem1_nent),
  .nent_i2_0_V(mem2_nent),
  .nent_o1_0_V(memAB_nent1),
  .nent_o2_0_V(memAC_nent1),
  .outmem2_d0(memAC_din)
);

// Instantiate ProcessB
processB_0 doB (
  .inmem_ce0(memAB_enb),
  .outmem_ce0(memBC_ena),
  .outmem_we0(memBC_wea),
  .ap_clk(clk),
  .ap_rst(reset),
  .ap_start(processB_start),
  .ap_done(processB_done),
  .bx_V(bx_out_A),
  .bx_o_V(bx_out_B),
  .inmem_address0(memAB_readaddr),
  .inmem_q0(memAB_dout),
  .outmem_address0(memBC_writeaddr),
  .nent_i_0_V(memAB_nent1),
  .nent_o_0_V(memBC_nent1),
  .outmem_d0(memBC_din)
);

// Instantiate ProcessC
processC_0 doC (
  .inmem1_ce0(memBC_enb),
  .inmem2_ce0(memAC_enb),
  .outmem_ce0(memout_ena),
  .outmem_we0(memout_wea),
  .ap_clk(clk),
  .ap_rst(reset),
  .ap_start(processC_start),
  .ap_done(processC_done),
  .bx_V(bx_out_B),
  .bx_o_V(bx_out),
  .inmem1_address0(memBC_readaddr),
  .inmem1_q0(memBC_dout),
  .inmem2_address0(memAC_readaddr),
  .inmem2_q0(memAC_dout),
  .nent_i1_0_V(memBC_nent1),
  .nent_i2_0_V(memAC_nent1),
  .outmem_address0(memout_writeaddr),
  .outmem_d0(memout_din)
);
endmodule
