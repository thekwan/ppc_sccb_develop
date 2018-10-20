//----------------------------------------------------------------------------
// user_logic.vhd - module
//----------------------------------------------------------------------------
//
// ***************************************************************************
// ** Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.            **
// **                                                                       **
// ** Xilinx, Inc.                                                          **
// ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"         **
// ** AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND       **
// ** SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,        **
// ** OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,        **
// ** APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION           **
// ** THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,     **
// ** AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE      **
// ** FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY              **
// ** WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE               **
// ** IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR        **
// ** REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF       **
// ** INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       **
// ** FOR A PARTICULAR PURPOSE.                                             **
// **                                                                       **
// ***************************************************************************
//
//----------------------------------------------------------------------------
// Filename:          user_logic.vhd
// Version:           1.00.a
// Description:       User logic module.
// Date:              Fri Sep  7 22:57:09 2018 (by Create and Import Peripheral Wizard)
// Verilog Standard:  Verilog-2001
//----------------------------------------------------------------------------
// Naming Conventions:
//   active low signals:                    "*_n"
//   clock signals:                         "clk", "clk_div#", "clk_#x"
//   reset signals:                         "rst", "rst_n"
//   generics:                              "C_*"
//   user defined types:                    "*_TYPE"
//   state machine next state:              "*_ns"
//   state machine current state:           "*_cs"
//   combinatorial signals:                 "*_com"
//   pipelined or register delay signals:   "*_d#"
//   counter signals:                       "*cnt*"
//   clock enable signals:                  "*_ce"
//   internal version of output port:       "*_i"
//   device pins:                           "*_pin"
//   ports:                                 "- Names begin with Uppercase"
//   processes:                             "*_PROCESS"
//   component instantiations:              "<ENTITY_>I_<#|FUNC>"
//----------------------------------------------------------------------------

module user_logic
(
  // -- ADD USER PORTS BELOW THIS LINE ---------------
  // --USER ports added here 
  Scl_I,                          // Serial clock input
  Scl_O,                          // Serial clock output
  Scl_T,                          // Serial clock tri-control
  Sda_I,                          // Serial data  input
  Sda_O,                          // Serial data  output
  Sda_T,                          // Serial data  tri-control
  // -- ADD USER PORTS ABOVE THIS LINE ---------------

  // -- DO NOT EDIT BELOW THIS LINE ------------------
  // -- Bus protocol ports, do not add to or delete 
  Bus2IP_Clk,                     // Bus to IP clock
  Bus2IP_Reset,                   // Bus to IP reset
  Bus2IP_Data,                    // Bus to IP data bus
  Bus2IP_BE,                      // Bus to IP byte enables
  Bus2IP_RdCE,                    // Bus to IP read chip enable
  Bus2IP_WrCE,                    // Bus to IP write chip enable
  IP2Bus_Data,                    // IP to Bus data bus
  IP2Bus_RdAck,                   // IP to Bus read transfer acknowledgement
  IP2Bus_WrAck,                   // IP to Bus write transfer acknowledgement
  IP2Bus_Error                    // IP to Bus error response
  // -- DO NOT EDIT ABOVE THIS LINE ------------------
); // user_logic

// -- ADD USER PARAMETERS BELOW THIS LINE ------------
// --USER parameters added here 
// -- ADD USER PARAMETERS ABOVE THIS LINE ------------

// -- DO NOT EDIT BELOW THIS LINE --------------------
// -- Bus protocol parameters, do not add to or delete
parameter C_SLV_DWIDTH                   = 32;
parameter C_NUM_REG                      = 5;
// -- DO NOT EDIT ABOVE THIS LINE --------------------

// -- ADD USER PORTS BELOW THIS LINE -----------------
// --USER ports added here 
// -- ADD USER PORTS ABOVE THIS LINE -----------------

// -- DO NOT EDIT BELOW THIS LINE --------------------
// -- Bus protocol ports, do not add to or delete
input                                     Bus2IP_Clk;
input                                     Bus2IP_Reset;
input      [0 : C_SLV_DWIDTH-1]           Bus2IP_Data;
input      [0 : C_SLV_DWIDTH/8-1]         Bus2IP_BE;
input      [0 : C_NUM_REG-1]              Bus2IP_RdCE;
input      [0 : C_NUM_REG-1]              Bus2IP_WrCE;
output     [0 : C_SLV_DWIDTH-1]           IP2Bus_Data;
output                                    IP2Bus_RdAck;
output                                    IP2Bus_WrAck;
output                                    IP2Bus_Error;
// -- DO NOT EDIT ABOVE THIS LINE --------------------

input                                     Scl_I;
output                                    Scl_O;
output                                    Scl_T;
input                                     Sda_I;
output                                    Sda_O;
output                                    Sda_T;

//----------------------------------------------------------------------------
// Implementation
//----------------------------------------------------------------------------

  // --USER nets declarations added here, as needed for user logic

  // Nets for user logic slave model s/w accessible register example
  reg        [0 : 7]                        slv_reg0;
  reg        [0 : 7]                        slv_reg1;
  reg        [0 : 7]                        slv_reg2;
  reg        [0 : 7]                        slv_reg3;
  reg        [0 : 7]                        slv_reg4;
  wire       [0 : 4]                        slv_reg_write_sel;
  wire       [0 : 4]                        slv_reg_read_sel;
  reg        [0 : C_SLV_DWIDTH-1]           slv_ip2bus_data;
  wire                                      slv_read_ack;
  wire                                      slv_write_ack;
  integer                                   byte_index, bit_index;
  reg                                       reg_data_r_en;
  reg  [0 : 7]                              reg_data_r;

  reg                                       update_state_reg;

  reg                                       Sda_O;
  reg                                       Sda_T;
  reg                                       Scl_O;
  reg                                       Scl_T;

  // --USER logic implementation added here
  // main state
  localparam [3:0]
    IDLE       = 4'b0000,
    START      = 4'b0001,
    PHASE1     = 4'b0010,
    PHASE2_W   = 4'b0011,
    PHASE3     = 4'b0100,
    PHASE2_R   = 4'b0101,
    END        = 4'b0110,
    END2       = 4'b0111,
    WAIT       = 4'b1000;
  // sub-state
  localparam [3:0]
    D0         = 4'b1000,
    D1         = 4'b1001,
    D2         = 4'b1010,
    D3         = 4'b1011,
    D4         = 4'b1100,
    D5         = 4'b1101,
    D6         = 4'b1110,
    D7         = 4'b1111,
  //END2       = 4'b0111,  // it is shared with that of main state
    DC         = 4'b0011;

  localparam   READ  = 1'b1,
               WRITE = 1'b0;
  // ------------------------------------------------------
  // Example code to read/write user logic slave model s/w accessible registers
  // 
  // Note:
  // The example code presented here is to show you one way of reading/writing
  // software accessible registers implemented in the user logic slave model.
  // Each bit of the Bus2IP_WrCE/Bus2IP_RdCE signals is configured to correspond
  // to one software accessible register by the top level template. For example,
  // if you have four 32 bit software accessible registers in the user logic,
  // you are basically operating on the following memory mapped registers:
  // 
  //    Bus2IP_WrCE/Bus2IP_RdCE   Memory Mapped Register
  //                     "1000"   C_BASEADDR + 0x0
  //                     "0100"   C_BASEADDR + 0x4
  //                     "0010"   C_BASEADDR + 0x8
  //                     "0001"   C_BASEADDR + 0xC
  // 
  // ------------------------------------------------------

  assign
    slv_reg_write_sel = Bus2IP_WrCE[0:4],
    slv_reg_read_sel  = Bus2IP_RdCE[0:4],
    slv_write_ack     = Bus2IP_WrCE[0] || Bus2IP_WrCE[1] || Bus2IP_WrCE[2] || Bus2IP_WrCE[3] || Bus2IP_WrCE[4],
    slv_read_ack      = Bus2IP_RdCE[0] || Bus2IP_RdCE[1] || Bus2IP_RdCE[2] || Bus2IP_RdCE[3] || Bus2IP_RdCE[4];

  // implement slave model register(s)
  always @( posedge Bus2IP_Clk )
    begin: SLAVE_REG_WRITE_PROC

      if ( Bus2IP_Reset == 1 )
        begin
          slv_reg0 <= 0;
          slv_reg1 <= 0;
          slv_reg2 <= 0;
          slv_reg3 <= 0;
          slv_reg4 <= 0;
        end
      else
	    if( slv_write_ack ) begin
          case ( slv_reg_write_sel )
            5'b10000 :
              if ( Bus2IP_BE[0] == 1 )
                slv_reg0[0:7] <= Bus2IP_Data[0:7];
            5'b01000 :
              if ( Bus2IP_BE[0] == 1 )
                slv_reg1[0:7] <= Bus2IP_Data[0:7];
            5'b00100 :
              if ( Bus2IP_BE[0] == 1 )
                slv_reg2[0:7] <= Bus2IP_Data[0:7];
            5'b00010 :
              if ( Bus2IP_BE[0] == 1 )
                slv_reg3[0:7] <= Bus2IP_Data[0:7];
            5'b00010 :
              if ( Bus2IP_BE[0] == 1 )
                slv_reg4[0:7] <= Bus2IP_Data[0:7];
            default : ;
          endcase
		end
		else if( update_state_reg ) begin
		  slv_reg0[0] <= 1'b0;
		  slv_reg4    <= reg_data_r;
		end
    end // SLAVE_REG_WRITE_PROC

  // implement slave model register read mux
  always @( slv_reg_read_sel or slv_reg0 or slv_reg1 or slv_reg2 or slv_reg3 )
    begin: SLAVE_REG_READ_PROC

      case ( slv_reg_read_sel )
        5'b10000 : slv_ip2bus_data <= {slv_reg0,24'd0};
        5'b01000 : slv_ip2bus_data <= {slv_reg1,24'd0};
        5'b00100 : slv_ip2bus_data <= {slv_reg2,24'd0};
        5'b00010 : slv_ip2bus_data <= {slv_reg3,24'd0};
        5'b00001 : slv_ip2bus_data <= {slv_reg4,24'd0};
        default  : slv_ip2bus_data <= 0;
      endcase

    end // SLAVE_REG_READ_PROC

  // ------------------------------------------------------------
  // Example code to drive IP to Bus signals
  // ------------------------------------------------------------

  assign IP2Bus_Data    = slv_ip2bus_data;
  assign IP2Bus_WrAck   = slv_write_ack;
  assign IP2Bus_RdAck   = slv_read_ack;
  assign IP2Bus_Error   = 0;

  // ------------------------------------------------------------
  // USER CODE
  // ------------------------------------------------------------
  wire                       clock;
  wire                       rst;
  reg  [0 : 3]               main_state;
  reg  [0 : 3]               sub_state;
  reg  [0 : 9]               clk_cnt;
  wire [0 : 9]               clk_cnt_max;
  wire [0 : 9]               clk_cnt_start_time;
  wire [0 : 9]               clk_cnt_scl_high;
  wire [0 : 9]               clk_cnt_end_time;
  wire [0 : 9]               clk_cnt_sda_write;
  wire [0 : 9]               clk_cnt_sda_read;
  wire                       clk_cnt_en;
  wire                       clk_cnt_clr;
  wire                       start_trigger;
  reg                        rw_flag;
  reg  [0 : 7]               dev_addr;
  reg  [0 : 7]               reg_addr;
  reg  [0 : 7]               reg_data_w;
  reg  [0 : 7]               wreg_bit_index;
  reg                        iter_index;

  assign clock = Bus2IP_Clk;
  assign rst   = Bus2IP_Reset;
  assign clk_cnt_en = (main_state == IDLE) ? 1'b0 : 1'b1;
  assign clk_cnt_clr = (clk_cnt == clk_cnt_max) ? 1'b1 : 1'b0;
  assign clk_cnt_max = 'd999;
  assign clk_cnt_start_time = 'd300;
  assign clk_cnt_end_time = 'd700;
  assign clk_cnt_scl_high = 'd499;
  assign clk_cnt_sda_write = 'd300;
  assign clk_cnt_sda_read  = 'd500;

  assign start_trigger = slv_reg0[0];

  always @( posedge clock )
  begin
    if( rst == 1 ) begin
	  clk_cnt <= 'd0;
	end
	else begin
	  if( clk_cnt_clr ) begin
	    clk_cnt <= 'd0;
      end
	  else if( clk_cnt_en ) begin
	    clk_cnt <= clk_cnt + 'd1;
	  end
	end
  end

  always @( posedge clock )
  begin
	if( rst == 1 ) begin
	  main_state <= IDLE;
	  iter_index <= 1'b0;
      update_state_reg <= 1'b0;
	  dev_addr   <= 8'd0;
	  reg_addr   <= 8'd0;
	  reg_data_w <= 8'd0;
	  rw_flag    <= 8'd0;
	end
	else begin
	  case( main_state )
	    IDLE: begin
		  if( start_trigger == 1 ) begin
		  	main_state <= START;
			dev_addr   <= slv_reg1[0 : 7];
			reg_addr   <= slv_reg2[0 : 7];
			reg_data_w <= slv_reg3[0 : 7];
			rw_flag    <= slv_reg0[1];
		  end
		  else begin
			dev_addr   <= 8'd0;
			reg_addr   <= 8'd0;
			reg_data_w <= 8'd0;
			rw_flag    <= 1'b0;
			iter_index <= 1'b0;
		  end
          update_state_reg <= 1'b0;
		end
        START: begin
		  if( sub_state == D0 && clk_cnt == clk_cnt_max ) begin
		  	main_state <= PHASE1;
		  end
		end
        PHASE1: begin
		  if( sub_state == DC && clk_cnt == clk_cnt_max ) begin
		    if( rw_flag == READ && iter_index == 1'b1 )
		  	  main_state <= PHASE2_R;
			else
		  	  main_state <= PHASE2_W;
		  end
		end
        PHASE2_W: begin
		  if( sub_state == DC && clk_cnt == clk_cnt_max ) begin
		    if( rw_flag == READ )
		  	  main_state <= END;
			else
		  	  main_state <= PHASE3;
		  end
		end
        PHASE3: begin
		  if( sub_state == DC && clk_cnt == clk_cnt_max ) begin
		  	main_state <= END;
		  end
		end
        PHASE2_R: begin
		  if( sub_state == DC && clk_cnt == clk_cnt_max ) begin
		  	main_state <= END;
		  end
		end
        END: begin
		  if( sub_state == D0 && clk_cnt == clk_cnt_max ) begin
		    if( iter_index == 1'b0 && rw_flag == READ ) begin
		  	  main_state <= WAIT;
			end
			else begin
		  	  main_state <= END2;
              update_state_reg <= 1'b1;
			end
		  end
		end
		END2: begin
		  main_state <= IDLE;
          update_state_reg <= 1'b0;
		end
        WAIT: begin
		  if( sub_state == DC && clk_cnt == clk_cnt_max ) begin
		    main_state <= START;
			iter_index <= 1'b1;
		  end
		end
	  endcase
    end
  end

  always @( posedge clock )
  begin
	if( rst == 1 ) begin
	  sub_state <= IDLE;
	end
	else begin
	  case( sub_state )
	    IDLE: begin
		  if( start_trigger == 1'b1 )
		  	sub_state <= D0;
		  else
		  	sub_state <= IDLE;
		end
        D0: begin
		  if( clk_cnt == clk_cnt_max ) begin
		    if( main_state == START )
		  	  sub_state <= D0;
			else if( main_state == END ) begin
			  if( iter_index == 1'b0 && rw_flag == READ )
	            sub_state <= D0;
			  else
	            sub_state <= END2;
			end
			else begin
		  	  sub_state <= D1;
			end
		  end
		end
        D1: begin
		  if( clk_cnt == clk_cnt_max ) begin
		  	sub_state <= D2;
		  end
		end
        D2: begin
		  if( clk_cnt == clk_cnt_max ) begin
		  	sub_state <= D3;
		  end
		end
        D3: begin
		  if( clk_cnt == clk_cnt_max ) begin
		  	sub_state <= D4;
		  end
		end
        D4: begin
		  if( clk_cnt == clk_cnt_max ) begin
		  	sub_state <= D5;
		  end
		end
        D5: begin
		  if( clk_cnt == clk_cnt_max ) begin
		  	sub_state <= D6;
		  end
		end
        D6: begin
		  if( clk_cnt == clk_cnt_max ) begin
		  	sub_state <= D7;
		  end
		end
        D7: begin
		  if( clk_cnt == clk_cnt_max ) begin
		  	sub_state <= DC;
		  end
		end
        DC: begin
		  if( clk_cnt == clk_cnt_max ) begin
		  	sub_state <= D0;
		  end
		end
        END2: begin
		  sub_state <= IDLE;
		end
	  endcase
    end
  end

  always @ (posedge clock)
  begin
    if( rst == 1 ) begin
		Scl_O <= 1'b1;
		Scl_T <= 1'b1;
		Sda_O <= 1'b1;
		Sda_T <= 1'b1;
	end
	else begin
		case( main_state )
		  IDLE: begin
			Scl_O <= 1'b1;
			Scl_T <= 1'b1;	// input mode
			Sda_O <= 1'b1;
			Sda_T <= 1'b1;  // input mode
			reg_data_r_en <= 1'b0;
		  end

		  START: begin
			Scl_T <= 1'b0;	// output mode
			Scl_O <= 1'b1;
			Sda_T <= 1'b0;	// output mode
			if( clk_cnt > clk_cnt_start_time )
			  Sda_O <= 1'b0;
			else
			  Sda_O <= 1'b1;
			reg_data_r_en <= 1'b0;
		  end

		  PHASE1, PHASE2_W, PHASE3: begin
			Scl_T <= 1'b0;
			Sda_T <= 1'b0;
			if( clk_cnt < clk_cnt_scl_high )
			  Scl_O <= 1'b0;
			else
			  Scl_O <= 1'b1;
			if( clk_cnt == clk_cnt_sda_write ) begin
			  case( main_state )
				PHASE1  : begin
				  if( sub_state == D7 ) begin
					if( iter_index == 1'b1 && rw_flag == READ )
					  Sda_O <= 1'b1;
					else
					  Sda_O <= 1'b0;
				  end
				  else
					  Sda_O <= dev_addr  [ wreg_bit_index ];
				end
				PHASE2_W: Sda_O <= reg_addr  [ wreg_bit_index ];
				PHASE3  : Sda_O <= reg_data_w[ wreg_bit_index ];
			  endcase
			end
			reg_data_r_en <= 1'b0;
		  end

		  PHASE2_R: begin
			Scl_T <= 1'b0;
			Sda_T <= 1'b1;
			if( clk_cnt < clk_cnt_scl_high )
			  Scl_O <= 1'b0;
			else
			  Scl_O <= 1'b1;
			if( sub_state != DC && clk_cnt == clk_cnt_sda_read )
			  reg_data_r_en <= 1'b1;
			else
			  reg_data_r_en <= 1'b0;
		  end

		  END, END2: begin
			Scl_T <= 1'b0;
			Sda_T <= 1'b0;
			if( clk_cnt < clk_cnt_scl_high)
			  Scl_O <= 1'b0;
			else
			  Scl_O <= 1'b1;
			if( clk_cnt < clk_cnt_end_time )
			  Sda_O <= 1'b0;
			else
			  Sda_O <= 1'b1;
			reg_data_r_en <= 1'b0;
		  end

		  WAIT: begin
			Scl_T <= 1'b1;
			Sda_T <= 1'b1;
			Scl_O <= 1'b1;
			Sda_O <= 1'b1;
			reg_data_r_en <= 1'b0;
		  end
		endcase

	end
  end

  always @(sub_state)
  begin
	case( sub_state )
	IDLE:  wreg_bit_index <= 8'd0;
	D0:    wreg_bit_index <= 8'd0;
	D1:    wreg_bit_index <= 8'd1;
	D2:    wreg_bit_index <= 8'd2;
	D3:    wreg_bit_index <= 8'd3;
	D4:    wreg_bit_index <= 8'd4;
	D5:    wreg_bit_index <= 8'd5;
	D6:    wreg_bit_index <= 8'd6;
	D7:    wreg_bit_index <= 8'd7;
	DC:    wreg_bit_index <= 8'd0;
	END2:  wreg_bit_index <= 8'd0;
	endcase
  end

  always @( posedge clock )
  begin
	if( rst == 1 ) begin
	  reg_data_r <= 8'h00;
	end
	else if (reg_data_r_en) begin
	  reg_data_r[ wreg_bit_index ] <= Sda_I;
	end
  end

endmodule
