// This is a generated file. Use and modify at your own risk.
////////////////////////////////////////////////////////////////////////////////
// default_nettype of none prevents implicit wire declaration.
`default_nettype none

module sdx_kernel_wizard_0_example_vadd #(
  parameter integer C_M_AXI_ADDR_WIDTH       = 64 ,
  parameter integer C_M_AXI_DATA_WIDTH       = 512,
  parameter integer C_XFER_SIZE_WIDTH        = 32,
  parameter integer C_ADDER_BIT_WIDTH        = 32
)
(
  // System Signals
  input wire                                    aclk               ,
  input wire                                    areset             ,
  // Extra clocks
  input wire                                    kernel_clk         ,
  input wire                                    kernel_rst         ,
  // AXI4 master interface
  output wire                                   m_axi_awvalid      ,
  input wire                                    m_axi_awready      ,
  output wire [C_M_AXI_ADDR_WIDTH-1:0]          m_axi_awaddr       ,
  output wire [8-1:0]                           m_axi_awlen        ,
  output wire                                   m_axi_wvalid       ,
  input wire                                    m_axi_wready       ,
  output wire [C_M_AXI_DATA_WIDTH-1:0]          m_axi_wdata        ,
  output wire [C_M_AXI_DATA_WIDTH/8-1:0]        m_axi_wstrb        ,
  output wire                                   m_axi_wlast        ,
  output wire                                   m_axi_arvalid      ,
  input wire                                    m_axi_arready      ,
  output wire [C_M_AXI_ADDR_WIDTH-1:0]          m_axi_araddr       ,
  output wire [8-1:0]                           m_axi_arlen        ,
  input wire                                    m_axi_rvalid       ,
  output wire                                   m_axi_rready       ,
  input wire [C_M_AXI_DATA_WIDTH-1:0]           m_axi_rdata        ,
  input wire                                    m_axi_rlast        ,
  input wire                                    m_axi_bvalid       ,
  output wire                                   m_axi_bready       ,
  input wire                                    ap_start           ,
  output wire                                   ap_done            ,
  input wire [C_M_AXI_ADDR_WIDTH-1:0]           ctrl_addr_offset   ,
  input wire [C_XFER_SIZE_WIDTH-1:0]            ctrl_xfer_size_in_bytes,
  input wire [C_ADDER_BIT_WIDTH-1:0]            ctrl_constant
);

timeunit 1ps;
timeprecision 1ps;


///////////////////////////////////////////////////////////////////////////////
// Local Parameters
///////////////////////////////////////////////////////////////////////////////
localparam integer LP_DW_BYTES             = C_M_AXI_DATA_WIDTH/8;
localparam integer LP_AXI_BURST_LEN        = 4096/LP_DW_BYTES < 256 ? 4096/LP_DW_BYTES : 256;
localparam integer LP_LOG_BURST_LEN        = $clog2(LP_AXI_BURST_LEN);
localparam integer LP_BRAM_DEPTH           = 512;
localparam integer LP_RD_MAX_OUTSTANDING   = LP_BRAM_DEPTH / LP_AXI_BURST_LEN;
localparam integer LP_WR_MAX_OUTSTANDING   = 32;

///////////////////////////////////////////////////////////////////////////////
// Wires and Variables
///////////////////////////////////////////////////////////////////////////////

// Control logic
logic                          done = 1'b0;
// AXI read master stage
logic                          read_done;
logic                          rd_tvalid;
logic                          rd_tready;
logic                          rd_tlast;
logic [C_M_AXI_DATA_WIDTH-1:0] rd_tdata;
// Adder stage
logic                          adder_tvalid;
logic                          adder_tready;
logic [C_M_AXI_DATA_WIDTH-1:0] adder_tdata;

// AXI write master stage
logic                          write_done;

///////////////////////////////////////////////////////////////////////////////
// Begin RTL
///////////////////////////////////////////////////////////////////////////////

logic read_empty;
logic read_fifo_enable;

// AXI4 Read Master, output format is an AXI4-Stream master, one stream per thread.
sdx_kernel_wizard_0_example_axi_read_master #(
  .C_M_AXI_ADDR_WIDTH  ( C_M_AXI_ADDR_WIDTH    ) ,
  .C_M_AXI_DATA_WIDTH  ( C_M_AXI_DATA_WIDTH    ) ,
  .C_XFER_SIZE_WIDTH   ( C_XFER_SIZE_WIDTH     ) ,
  .C_MAX_OUTSTANDING   ( LP_RD_MAX_OUTSTANDING ) ,
  .C_INCLUDE_DATA_FIFO ( 1                     )
)
inst_axi_read_master (
  .aclk                    ( aclk                    ) ,
  .areset                  ( areset                  ) ,
  .ctrl_start              ( ap_start                ) ,
  .ctrl_done               ( read_done               ) ,
  .ctrl_addr_offset        ( ctrl_addr_offset        ) ,
  .ctrl_xfer_size_in_bytes ( ctrl_xfer_size_in_bytes ) ,
  .m_axi_arvalid           ( m_axi_arvalid           ) ,
  .m_axi_arready           ( m_axi_arready           ) ,
  .m_axi_araddr            ( m_axi_araddr            ) ,
  .m_axi_arlen             ( m_axi_arlen             ) ,
  .m_axi_rvalid            ( m_axi_rvalid            ) ,
  .m_axi_rready            ( m_axi_rready            ) ,
  .m_axi_rdata             ( m_axi_rdata             ) ,
  .m_axi_rlast             ( m_axi_rlast             ) ,
  .m_axis_aclk             ( kernel_clk              ) ,
  .m_axis_areset           ( kernel_rst              ) ,
  .m_axis_tvalid           ( rd_tvalid               ) ,
  .m_axis_tready           ( read_fifo_enable/*rd_tready*/               ) ,
  .m_axis_tlast            ( rd_tlast                ) ,
  .m_axis_tdata            ( rd_tdata                ),
  .read_empty              (read_empty)
);

reg d, d_bar;
logic pulse;
logic valid_out;
logic int_enable;
logic kernel_enable;
assign pulse = d && !d_bar;
always @(posedge aclk)
begin 
        if(areset)
        begin 
            d <=0;
            d_bar <=0;
            kernel_enable <=0;
        end 
        else
        begin 
            if(!read_empty)
            begin 
                d <=1;
                d_bar <= d;
            end
            else
             begin 
                d <= 0;
                d_bar <= d;
             
             end 
        kernel_enable <= read_fifo_enable || pulse;
        end 

end 



always @(*)
begin 
    int_enable <= valid_out || pulse;
 //   read_fifo_enable <= int_enable && !read_empty;
end 

logic kernel_done;
logic [127:0] text_out;
logic [127:0]key;
logic [127:0] text_in;
logic [383:0] temp_data;
logic [127:0] data_out;
logic [511:0] dout;
assign temp_data = rd_tdata[383:0];
assign    key   = temp_data[383:256];
assign text_in = temp_data[255:128];


aes encrypter(.clk(aclk),.reset(!areset),.load_i(kernel_enable),.decrypt_i(1'd0),.data_i(text_in),.key_i(key),.ready_o(kernel_done),.data_o(text_out));
aes decrypter(.clk(aclk),.reset(!areset),.load_i(kernel_done),.decrypt_i(1'd1),.data_i(text_out),.key_i(key),.ready_o(valid_out),.data_o(data_out));

assign read_fifo_enable = valid_out;
assign dout = {{384{1'd0}},data_out};
/*
// Adder is combinatorial
sdx_kernel_wizard_0_example_adder #(
  .C_AXIS_TDATA_WIDTH ( C_M_AXI_DATA_WIDTH ) ,
  .C_ADDER_BIT_WIDTH  ( C_ADDER_BIT_WIDTH  )
)
inst_adder  (
  .aclk          ( kernel_clk                   ) ,
  .aresetn       ( ~kernel_rst                  ) ,
  .ctrl_constant ( ctrl_constant                ) ,
  .s_axis_tvalid ( rd_tvalid                    ) ,
  .s_axis_tready ( rd_tready                    ) ,
  .s_axis_tdata  ( rd_tdata                     ) ,
  .s_axis_tkeep  ( {C_M_AXI_DATA_WIDTH/8{1'b1}} ) ,
  .s_axis_tlast  ( rd_tlast                     ) ,
  .m_axis_tvalid ( adder_tvalid                 ) ,
  .m_axis_tready ( adder_tready                 ) ,
  .m_axis_tdata  ( adder_tdata                  ) ,
  .m_axis_tkeep  (                              ) , // Not used
  .m_axis_tlast  (                              )   // Not used
);
*/
// AXI4 Write Master

sdx_kernel_wizard_0_example_axi_write_master #(
  .C_M_AXI_ADDR_WIDTH  ( C_M_AXI_ADDR_WIDTH    ) ,
  .C_M_AXI_DATA_WIDTH  ( C_M_AXI_DATA_WIDTH    ) ,
  .C_XFER_SIZE_WIDTH   ( C_XFER_SIZE_WIDTH     ) ,
  .C_MAX_OUTSTANDING   ( LP_WR_MAX_OUTSTANDING ) ,
  .C_INCLUDE_DATA_FIFO ( 1                     )
)
inst_axi_write_master (
  .aclk                    ( aclk                    ) ,
  .areset                  ( areset                  ) ,
  .ctrl_start              ( ap_start                ) ,
  .ctrl_done               ( write_done              ) ,
  .ctrl_addr_offset        ( ctrl_addr_offset        ) ,
  .ctrl_xfer_size_in_bytes ( ctrl_xfer_size_in_bytes ) ,
  .m_axi_awvalid           ( m_axi_awvalid           ) ,
  .m_axi_awready           ( m_axi_awready           ) ,
  .m_axi_awaddr            ( m_axi_awaddr            ) ,
  .m_axi_awlen             ( m_axi_awlen             ) ,
  .m_axi_wvalid            ( m_axi_wvalid            ) ,
  .m_axi_wready            ( m_axi_wready            ) ,
  .m_axi_wdata             ( m_axi_wdata             ) ,
  .m_axi_wstrb             ( m_axi_wstrb             ) ,
  .m_axi_wlast             ( m_axi_wlast             ) ,
  .m_axi_bvalid            ( m_axi_bvalid            ) ,
  .m_axi_bready            ( m_axi_bready            ) ,
  .s_axis_aclk             ( kernel_clk              ) ,
  .s_axis_areset           ( kernel_rst              ) ,
  .s_axis_tvalid           ( valid_out/*adder_tvalid*/            ) ,
  .s_axis_tready           ( adder_tready            ) ,
  .s_axis_tdata            ( dout/*adder_tdata */            )
);

assign ap_done = write_done;

endmodule : sdx_kernel_wizard_0_example_vadd
`default_nettype wire

