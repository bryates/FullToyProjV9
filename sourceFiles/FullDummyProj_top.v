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
  output[4:0] mem1_readaddr,
  input[31:0] mem1_dout,
  output[4:0] mem2_readaddr,
  input[31:0] mem2_dout,
  output memout_ena,
  output memout_wea,
  output[4:0] memout_writeaddr,
  output[31:0] memout_din
);

// memAB_BRAM signals
wire[31:0] memAB_din;
wire[31:0] memAB_dout;
wire[4:0] memAB_readaddr;
wire[4:0] memAB_writeaddr;
wire memAB_ena;
wire memAB_wea;
wire memAB_enb;
wire[4:0] memAB_nent1;
wire[4:0] memAB_nent2;
wire[4:0] memAB_nent3;
wire[4:0] memAB_nent4;

// memAC_BRAM signals
wire[31:0] memAC_din;
wire[31:0] memAC_dout;
wire[5:0] memAC_readaddr;
wire[5:0] memAC_writeaddr;
wire memAC_ena;
wire[4:0] memAC_nent1;
wire[4:0] memAC_nent2;

// memBC_BRAM signals
wire[31:0] memBC_din;
wire[31:0] memBC_dout;
wire[4:0] memBC_readaddr;
wire[4:0] memBC_writeaddr;
wire memBC_ena;
wire memBC_wea;
wire memBC_enb;
wire[4:0] memBC_nent1;
wire[4:0] memBC_nent2;

// Process start/done signals
reg processB_start;
reg processC_start;
wire processA_done;
wire processB_done;

initial begin
  processB_start = 1'b0;
  processC_start = 1'b0;
end

//always @(posedge clk) begin
always @(processA_done) begin
  if (processA_done) processB_start = 1'b1;
end
always @(processB_done) begin
  if (processB_done) processC_start = 1'b1;
end

// Instantiate all BRAMs
Memory #(
    .RAM_WIDTH(32),
    .RAM_DEPTH(32),
    .RAM_PERFORMANCE("HIGH_PERFORMANCE"),
    .HEX(0),
    .INIT_FILE("/home/byates/FullToyProjV9/FullToyProjV9/FullToyProjV9.ip_user_files/mem_init_files/fives.dat")
    ) memAB_BRAM (
    .clka(clk),
    .addra(memAB_writeaddr),
    .dina(memAB_din),
    .wea(memAB_wea),
    .clkb(clk),
    .addrb(memAB_readaddr),
    .doutb(memAB_dout),
    .regceb(1'b1),
    .nevt(memAB_nent1),
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
    .RAM_DEPTH(64),
    .RAM_PERFORMANCE("HIGH_PERFORMANCE"),
    .INIT_FILE("")
    ) memAC_BRAM (
    .clka(clk),
    .addra(memAC_writeaddr),
    .dina(memAC_din),
    .wea(memAC_wea),
    .clkb(clk),
    .addrb(memAC_readaddr),
    .doutb(memAC_dout),
    .regceb(1'b1),
    .nevt(memAC_nent1),
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
    .RAM_DEPTH(32),
    .RAM_PERFORMANCE("HIGH_PERFORMANCE"),
    .INIT_FILE("")
    ) memBC_BRAM (
    .clka(clk),
    .addra(memBC_writeaddr),
    .dina(memBC_din),
    .wea(memBC_wea),
    .clkb(clk),
    .addrb(memBC_readaddr),
    .doutb(memBC_dout),
    .regceb(1'b1),
    .nevt(memBC_nent1),
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
  .nent_i_0('h0F),
  .nent_o_0(memAB_nent1),
  .nent_o_1(memAC_nent2),
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
//  .nent_o_0(memAB_nent1),
//  .nent_o_1(memBC_nent2),
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
  .bx_V(bx_out_B),
  .bx_o_V(bx_out),
  .inmem1_address0(memBC_readaddr),
  .inmem1_q0(memBC_dout),
  .inmem2_address0(memAC_readaddr),
  .inmem2_q0(memAC_dout),
  .outmem_address0(memout_writeaddr),
  .outmem_d0(memout_din)
);
endmodule
