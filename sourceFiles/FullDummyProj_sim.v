`timescale 1ns / 1ps

// Simulation module for FullDummyProject

module FullDummyProject_sim();

reg clk;
reg reset;

// Initialize
initial begin
  reset = 1'b1;
  clk   = 1'b1;
//  #100; // wait 100ns for global reset to finish
end

// Reset
initial begin
//  #230
//  reset = 1'b1;
  #155
  reset = 1'b0;
end

// Enable processing
reg en_proc = 1'b0;
always @(posedge clk) begin
  if (reset) en_proc = 1'b0;
  else       en_proc = 1'b1;
end

// Stimulus
always begin
  #2.5 clk = ~clk; // 200 MHz clock
end

// BX
//reg new_BX;
//initial begin
//  #240
//  new_BX = 1'b0;
//end
//always begin
//    #75 new_BX = ~new_BX;
//    #5 new_BX = ~new_BX;
//end
reg [1:0] bx_in;
reg [5:0] mem1_nent_i = 'd16;
//reg [5:0] mem1_entries [1:0];
initial bx_in = 2'b00;
//initial mem1_nent_i = 'd16;
//initial begin
//    mem1_entries[0] = 'd6;
//    mem1_entries[1] = 'd5;
//end

always begin
  #80 bx_in <= bx_in + 1'b1; // bx driver
//  mem1_nent_i = mem1_entries[bx_in[0]];
end
//initial begin
//  #150
//  bx_in = 2'b00;
//end
//always @ (posedge clk) begin
//    if (new_BX) begin
//        bx_in <= bx_in + 1'b1;
//    end
//end
wire bx_out;

// mem1_BRAM signals
reg[31:0] mem1_din;
wire[31:0] mem1_dout;
wire[3:0] mem1_readaddr;
reg[3:0] mem1_writeaddr;
reg mem1_ena;
reg mem1_wea;
wire mem1_enb;
wire[4:0] mem1_nent;
wire[4:0] mem2_nent;
wire[1:0] mem1_pagea;
wire[2:0] mem1_pageb;
wire[1:0] mem2_pagea;
wire[1:0] mem2_pageb;

initial begin
  mem1_writeaddr = 0;
  mem1_ena = 1'b1;
  mem1_wea = 1'b0;
end

// mem2_BRAM signals
reg[31:0] mem2_din;
wire[31:0] mem2_dout;
wire[3:0] mem2_readaddr;
reg[3:0] mem2_writeaddr;
reg mem2_ena;
reg mem2_wea;
wire mem2_enb;

initial begin
  mem2_writeaddr = 0;
  mem2_ena = 1'b1;
  mem2_wea = 1'b0;
end

//memout_BRAM signals
wire[31:0] memout_din;
wire[31:0] memout_dout;
wire[3:0] memout_readaddr;
wire[3:0] memout_writeaddr;
wire[1:0] memout_page;
wire[4:0] memout_nent;
wire memout_ena;
wire memout_wea;
wire memout_enb;

// Instantiate all BRAMs
MemoryInit #(
    .RAM_WIDTH(32),
    .RAM_DEPTH(16),
    .PAGES(2),
    .RAM_PERFORMANCE("HIGH_PERFORMANCE"),
    .HEX(0),
    .INIT_FILE("fives.dat")
    ) mem1_BRAM (
    .clka(clk),
    .addra(mem1_writeaddr),
    .dina(mem1_din),
    .wea(mem1_wea),
    .clkb(clk),
    .pagea(mem1_pagea),
    .pageb(bx_in),
    .addrb(mem1_readaddr),
    .doutb(mem1_dout),
    .regceb(1'b1),
    .nent_i(mem1_nent_i),
//    .nent_i('d16),
    .nent_0(mem1_nent),
    .enb(mem1_enb)
);
//blk_mem_gen_mem1 mem1_BRAM (
//  .clka(clk),
//  .addra(mem1_writeaddr),
//  .dina(mem1_din),
//  .ena(mem1_ena),
//  .wea(mem1_wea),
//  .clkb(clk),
//  .addrb(mem1_readaddr),
//  .doutb(mem1_dout),
//  .enb(mem1_enb)
//);

//blk_mem_gen_mem2 mem2_BRAM (
//  .clka(clk),
//  .addra(mem2_writeaddr),
//  .dina(mem2_din),
//  .ena(mem2_ena),
//  .wea(mem2_wea),
//  .clkb(clk),
//  .addrb(mem2_readaddr),
//  .doutb(mem2_dout),
//  .enb(mem2_enb)
//);

MemoryInit #(
    .RAM_WIDTH(32),
    .RAM_DEPTH(16),
    .PAGES(2),
    .RAM_PERFORMANCE("HIGH_PERFORMANCE"),
    .HEX(0),
    .INIT_FILE("sevens.dat")
    ) mem2_BRAM (
    .clka(clk),
    .addra(mem2_writeaddr),
    .dina(mem2_din),
    .wea(mem2_wea),
    .clkb(clk),
    .pagea(mem2_pagea),
    .pageb(bx_in),
    .addrb(mem2_readaddr),
    .doutb(mem2_dout),
    .regceb(1'b1),
    .nent_i('d16),
    .nent_0(mem2_nent),
    .enb(mem2_enb)
);

Memory #(
    .RAM_WIDTH(32),
    .RAM_DEPTH(16),
    .PAGES(2),
    .RAM_PERFORMANCE("HIGH_PERFORMANCE"),
    .HEX(0),
    .INIT_FILE("")
    ) memout_BRAM (
    .clka(clk),
    .addra(memout_writeaddr),
    .dina(memout_din),
    .wea(memout_wea),
    .clkb(clk),
    .addrb(memout_readaddr),
    .doutb(memout_dout),
    .regceb(1'b1),
    .enb(memout_enb)
);

//blk_mem_gen_2page memout_BRAM (
//  .clka(clk),
//  .addra(memout_writeaddr),
//  .dina(memout_din),
//  .ena(memout_ena),
//  .wea(memout_wea),
//  .clkb(clk),
//  .addrb(memout_readaddr),
//  .doutb(memout_dout),
//  .enb(memout_enb)
//);

// Instantiate FullDummyProject_top
FullDummyProject_top doFull (
  .clk(clk),
  .reset(reset),
  .mem1_enb(mem1_enb),
  .mem2_enb(mem2_enb),
  .en_proc(en_proc),
  .bx_in(bx_in),
  .bx_out(bx_out),
  .mem1_readaddr(mem1_readaddr),
  .mem1_pagea(mem1_pagea),
  .mem1_pageb(mem1_pageb),
  .mem1_nent(mem1_nent),
  .mem1_dout(mem1_dout),
  .mem2_readaddr(mem2_readaddr),
  .mem2_pagea(mem2_pagea),
  .mem2_pageb(mem2_pageb),
  .mem2_nent(mem1_nent),
  .mem2_dout(mem2_dout),
  .memout_ena(memout_ena),
  .memout_wea(memout_wea),
  .memout_writeaddr(memout_writeaddr),
  .memout_pagea(memout_page),
  .memout_nent(memout_nent),
  .memout_din(memout_din)
);

endmodule
