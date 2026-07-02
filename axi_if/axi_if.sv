interface axi(input bit ACLK);


  //write_address_channel
  logic [3:0] AWID;
  logic [31:0] AWADDR;
  logic [3:0] AWLEN;
  logic [2:0] AWSIZE;
  logic [1:0] AWBURST;
  logic AWVALID,AWREADY;

  //write_data channel
  logic [3:0] WID;
  logic [31:0]WDATA;
  logic [3:0]WSTRB;
  logic WREADY,WLAST,WVALID;

  //write_response channel

  logic [3:0] BID;
  logic [1:0] BRESP;
  logic BVALID,BREADY;


  //read_address_channel
  logic [3:0] ARID;
  logic [31:0] ARADDR;
  logic [3:0] ARLEN;
  logic [2:0] ARSIZE;
  logic [1:0] ARBURST;
  logic ARVALID,ARREADY;

  //read_data
  logic [3:0] RID;
  logic [31:0]RDATA;
  logic [1:0] RRESP;
  logic RREADY,RLAST,RVALID;


  clocking m_drv @(posedge ACLK);

    default input #1 output #1;

    output AWID,AWADDR,AWLEN,AWSIZE,AWBURST,AWVALID;
    input AWREADY;


    output WID,WDATA,WLAST,WVALID,WSTRB;
    input WREADY;


    input BID,BRESP,BVALID;
    output BREADY;

    output ARID,ARADDR,ARLEN,ARSIZE,ARBURST,ARVALID;
    input ARREADY;


    input RID,RDATA,RRESP,RLAST,RVALID;
    output RREADY;

  endclocking

 // ________________________________________________________________________________________________________

  clocking m_mon @(posedge ACLK);
    default input #1 output #1;

    input AWID,AWADDR,AWLEN,AWSIZE,AWBURST,AWVALID;
    input AWREADY;

    //write_data channel
    input WID,WDATA,WLAST,WVALID,WSTRB;
    input WREADY;

    //write_response channel
    input BID,BRESP,BVALID;
    input BREADY;
    //read_address_channel
    input ARID,ARADDR,ARLEN,ARSIZE,ARBURST,ARVALID;
    input ARREADY;

    //read_data/response channel
    input RID,RDATA,RRESP,RLAST,RVALID;
    input RREADY;

  endclocking


  //________________________________________________________________________________________________________

  clocking s_drv @(posedge ACLK);
    default input #1 output #1;

    //write_address_channel
    input AWID,AWADDR,AWLEN,AWSIZE,AWBURST,AWVALID;
    output AWREADY;

    //write_data channel
    input WID,WDATA,WSTRB,WLAST,WVALID;
    output WREADY;

    //write_response channel
    output BID,BRESP,BVALID;
    input BREADY;
    //read_address_channel
    input ARID,ARADDR,ARLEN,ARSIZE,ARBURST,ARVALID;
    output ARREADY;

    //read_data/response channel
    output RID,RDATA,RRESP,RLAST,RVALID;
    input RREADY;

  endclocking

 // ________________________________________________________________________________________________________



  clocking s_mon @(posedge ACLK);
    default input #1 output #1;
    input AWID,AWADDR,AWLEN,AWSIZE,AWBURST,AWVALID;
    input AWREADY;

    //write_data channel
    input WID,WDATA,WLAST,WVALID,WSTRB;
    input WREADY;

    //write_response channel
    input BID,BRESP,BVALID;
    input BREADY;
    //read_address_channel
    input ARID,ARADDR,ARLEN,ARSIZE,ARBURST,ARVALID;
    input ARREADY;

    //read_data/response channel
    input RID,RDATA,RRESP,RLAST,RVALID;
    input RREADY;

  endclocking

  //________________________________________________________________________________________________________


  modport M_DRV(clocking m_drv);
  modport M_MON(clocking m_mon);
  modport S_DRV(clocking s_drv);
  modport S_MON(clocking s_mon);





endinterface
