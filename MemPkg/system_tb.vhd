-------------------------------------------------------------------------------
-- system_tb.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library ddr2;

-- START USER CODE (Do not remove this line)

-- User: Put your libraries here. Code in this
--       section will not be overwritten.

-- END USER CODE (Do not remove this line)

entity system_tb is
end system_tb;

architecture STRUCTURE of system_tb is

  constant fpga_0_clk_1_sys_clk_pin_PERIOD : time := 10000.000000 ps;
  constant fpga_0_rst_1_sys_rst_pin_LENGTH : time := 160000 ps;

  component system is
    port (
    fpga_0_RS232_Uart_1_RX_pin : in std_logic;
    fpga_0_RS232_Uart_1_TX_pin : out std_logic;
    fpga_0_DDR2_SDRAM_DDR2_DQ_pin : inout std_logic_vector(63 downto 0);
    fpga_0_DDR2_SDRAM_DDR2_DQS_pin : inout std_logic_vector(7 downto 0);
    fpga_0_DDR2_SDRAM_DDR2_DQS_N_pin : inout std_logic_vector(7 downto 0);
    fpga_0_DDR2_SDRAM_DDR2_A_pin : out std_logic_vector(12 downto 0);
    fpga_0_DDR2_SDRAM_DDR2_BA_pin : out std_logic_vector(1 downto 0);
    fpga_0_DDR2_SDRAM_DDR2_RAS_N_pin : out std_logic;
    fpga_0_DDR2_SDRAM_DDR2_CAS_N_pin : out std_logic;
    fpga_0_DDR2_SDRAM_DDR2_WE_N_pin : out std_logic;
    fpga_0_DDR2_SDRAM_DDR2_CS_N_pin : out std_logic;
    fpga_0_DDR2_SDRAM_DDR2_ODT_pin : out std_logic_vector(1 downto 0);
    fpga_0_DDR2_SDRAM_DDR2_CKE_pin : out std_logic;
    fpga_0_DDR2_SDRAM_DDR2_DM_pin : out std_logic_vector(7 downto 0);
    fpga_0_DDR2_SDRAM_DDR2_CK_pin : out std_logic_vector(1 downto 0);
    fpga_0_DDR2_SDRAM_DDR2_CK_N_pin : out std_logic_vector(1 downto 0);
    fpga_0_LEDs_8Bit_GPIO_IO_pin : inout std_logic_vector(0 to 7);
    fpga_0_clk_1_sys_clk_pin : in std_logic;
    fpga_0_rst_1_sys_rst_pin : in std_logic;
    sccb_ip_test_0_Sda_sccb_pin : inout std_logic;
    sccb_ip_test_0_Scl_sccb_pin : inout std_logic;
    clock_generator_0_CLKOUT5_pin : out std_logic
    );
  end component;

  component ddr2 is
    port (
      ck     : in    std_logic;
      ck_n   : in    std_logic;
      cke    : in    std_logic;
      cs_n   : in    std_logic;
      ras_n  : in    std_logic;
      cas_n  : in    std_logic;
      we_n   : in    std_logic;
      dm_rdqs: inout std_logic_vector(1 downto 0);
      ba     : in    std_logic_vector(1 downto 0);
      addr   : in    std_logic_vector(12 downto 0);
      odt    : in    std_logic;
      dqs    : inout std_logic_vector(1 downto 0);
      dqs_n  : inout std_logic_vector(1 downto 0);
      dq     : inout std_logic_vector(15 downto 0);
      rdqs_n : out   std_logic_vector(1 downto 0)
    );
  end component;
 
  -- Internal signals

  signal fpga_0_DDR2_SDRAM_DDR2_A_pin : std_logic_vector(12 downto 0);
  signal fpga_0_DDR2_SDRAM_DDR2_BA_pin : std_logic_vector(1 downto 0);
  signal fpga_0_DDR2_SDRAM_DDR2_CAS_N_pin : std_logic;
  signal fpga_0_DDR2_SDRAM_DDR2_CKE_pin : std_logic;
  signal fpga_0_DDR2_SDRAM_DDR2_CK_N_pin : std_logic_vector(1 downto 0);
  signal fpga_0_DDR2_SDRAM_DDR2_CK_pin : std_logic_vector(1 downto 0);
  signal fpga_0_DDR2_SDRAM_DDR2_CS_N_pin : std_logic;
  signal fpga_0_DDR2_SDRAM_DDR2_DM_pin : std_logic_vector(7 downto 0);
  signal fpga_0_DDR2_SDRAM_DDR2_DQS_N_pin : std_logic_vector(7 downto 0);
  signal fpga_0_DDR2_SDRAM_DDR2_DQS_pin : std_logic_vector(7 downto 0);
  signal fpga_0_DDR2_SDRAM_DDR2_DQ_pin : std_logic_vector(63 downto 0);
  signal fpga_0_DDR2_SDRAM_DDR2_ODT_pin : std_logic_vector(1 downto 0);
  signal fpga_0_DDR2_SDRAM_DDR2_RAS_N_pin : std_logic;
  signal fpga_0_DDR2_SDRAM_DDR2_WE_N_pin : std_logic;
  signal fpga_0_LEDs_8Bit_GPIO_IO_pin : std_logic_vector(0 to 7);
  signal fpga_0_RS232_Uart_1_RX_pin : std_logic;
  signal fpga_0_RS232_Uart_1_TX_pin : std_logic;
  signal fpga_0_clk_1_sys_clk_pin : std_logic;
  signal fpga_0_rst_1_sys_rst_pin : std_logic;
  signal sccb_ip_test_0_Sda_sccb_pin : std_logic;
  signal sccb_ip_test_0_Scl_sccb_pin : std_logic;
  signal clock_generator_0_CLKOUT5_pin : std_logic;

  -- START USER CODE (Do not remove this line)

  -- User: Put your signals here. Code in this
  --       section will not be overwritten.
  signal net_gnd2: std_logic_vector(1 downto 0);

  -- END USER CODE (Do not remove this line)

begin

  dut : system
    port map (
      fpga_0_DDR2_SDRAM_DDR2_DQ_pin => fpga_0_DDR2_SDRAM_DDR2_DQ_pin,
      fpga_0_DDR2_SDRAM_DDR2_DQS_pin => fpga_0_DDR2_SDRAM_DDR2_DQS_pin,
      fpga_0_DDR2_SDRAM_DDR2_DQS_N_pin => fpga_0_DDR2_SDRAM_DDR2_DQS_N_pin,
      fpga_0_DDR2_SDRAM_DDR2_A_pin => fpga_0_DDR2_SDRAM_DDR2_A_pin,
      fpga_0_DDR2_SDRAM_DDR2_BA_pin => fpga_0_DDR2_SDRAM_DDR2_BA_pin,
      fpga_0_DDR2_SDRAM_DDR2_RAS_N_pin => fpga_0_DDR2_SDRAM_DDR2_RAS_N_pin,
      fpga_0_DDR2_SDRAM_DDR2_CAS_N_pin => fpga_0_DDR2_SDRAM_DDR2_CAS_N_pin,
      fpga_0_DDR2_SDRAM_DDR2_WE_N_pin => fpga_0_DDR2_SDRAM_DDR2_WE_N_pin,
      fpga_0_DDR2_SDRAM_DDR2_CS_N_pin => fpga_0_DDR2_SDRAM_DDR2_CS_N_pin,
      fpga_0_DDR2_SDRAM_DDR2_ODT_pin => fpga_0_DDR2_SDRAM_DDR2_ODT_pin,
      fpga_0_DDR2_SDRAM_DDR2_CKE_pin => fpga_0_DDR2_SDRAM_DDR2_CKE_pin,
      fpga_0_DDR2_SDRAM_DDR2_DM_pin => fpga_0_DDR2_SDRAM_DDR2_DM_pin,
      fpga_0_DDR2_SDRAM_DDR2_CK_pin => fpga_0_DDR2_SDRAM_DDR2_CK_pin,
      fpga_0_DDR2_SDRAM_DDR2_CK_N_pin => fpga_0_DDR2_SDRAM_DDR2_CK_N_pin,
      fpga_0_LEDs_8Bit_GPIO_IO_pin => fpga_0_LEDs_8Bit_GPIO_IO_pin,
      fpga_0_RS232_Uart_1_RX_pin => fpga_0_RS232_Uart_1_RX_pin,
      fpga_0_RS232_Uart_1_TX_pin => fpga_0_RS232_Uart_1_TX_pin,
      fpga_0_clk_1_sys_clk_pin => fpga_0_clk_1_sys_clk_pin,
      fpga_0_rst_1_sys_rst_pin => fpga_0_rst_1_sys_rst_pin,
	  sccb_ip_test_0_Sda_sccb_pin => sccb_ip_test_0_Sda_sccb_pin,
	  sccb_ip_test_0_Scl_sccb_pin => sccb_ip_test_0_Scl_sccb_pin,
	  clock_generator_0_CLKOUT5_pin => clock_generator_0_CLKOUT5_pin 
    );

  -- Clock generator for fpga_0_clk_1_sys_clk_pin

  process
  begin
    fpga_0_clk_1_sys_clk_pin <= '0';
    loop
      wait for (fpga_0_clk_1_sys_clk_pin_PERIOD/2);
      fpga_0_clk_1_sys_clk_pin <= not fpga_0_clk_1_sys_clk_pin;
    end loop;
  end process;

  -- Reset Generator for fpga_0_rst_1_sys_rst_pin

  process
  begin
    fpga_0_rst_1_sys_rst_pin <= '0';
    wait for (fpga_0_rst_1_sys_rst_pin_LENGTH);
    fpga_0_rst_1_sys_rst_pin <= not fpga_0_rst_1_sys_rst_pin;
    wait;
  end process;

  -- START USER CODE (Do not remove this line)

--fpga_0_DDR2_SDRAM_DDR2_DQ_pin    <= (others => 'H');
--fpga_0_DDR2_SDRAM_DDR2_DQS_pin   <= (others => 'H');
--fpga_0_DDR2_SDRAM_DDR2_DQS_N_pin <= (others => 'H');

  fpga_0_LEDs_8Bit_GPIO_IO_pin         <= (others => 'H');
  sccb_ip_test_0_Sda_sccb_pin          <= 'H';
  sccb_ip_test_0_Scl_sccb_pin          <= 'H';

  -- input port of dut
  fpga_0_RS232_Uart_1_RX_pin <= '0';
  fpga_0_RS232_Uart_1_TX_pin <= '0';

  net_gnd2 <= (others => '0');

  ddr2_0 : ddr2
  port map (
    ck        => fpga_0_DDR2_SDRAM_DDR2_CK_pin(0)             ,
	ck_n      => fpga_0_DDR2_SDRAM_DDR2_CK_N_pin(0)           ,
	cke       => fpga_0_DDR2_SDRAM_DDR2_CKE_pin               ,
	cs_n      => fpga_0_DDR2_SDRAM_DDR2_CS_N_pin              ,
	ras_n     => fpga_0_DDR2_SDRAM_DDR2_RAS_N_pin             ,
	cas_n     => fpga_0_DDR2_SDRAM_DDR2_CAS_N_pin             ,
	we_n      => fpga_0_DDR2_SDRAM_DDR2_WE_N_pin              ,
  	dm_rdqs   => fpga_0_DDR2_SDRAM_DDR2_DM_pin(1 downto 0)    ,
	ba        => fpga_0_DDR2_SDRAM_DDR2_BA_pin                ,
	addr      => fpga_0_DDR2_SDRAM_DDR2_A_pin                 ,
	dq        => fpga_0_DDR2_SDRAM_DDR2_DQ_pin(15 downto 0)   ,
  	dqs       => fpga_0_DDR2_SDRAM_DDR2_DQS_pin(1 downto 0)   ,
  	dqs_n     => fpga_0_DDR2_SDRAM_DDR2_DQS_N_pin(1 downto 0) ,
  	rdqs_n    => net_gnd2                                     ,
	odt       => fpga_0_DDR2_SDRAM_DDR2_ODT_pin(0)
  );
   
  ddr2_1 : ddr2
  port map (
    ck        => fpga_0_DDR2_SDRAM_DDR2_CK_pin(0)              ,
	ck_n      => fpga_0_DDR2_SDRAM_DDR2_CK_N_pin(0)            ,
	cke       => fpga_0_DDR2_SDRAM_DDR2_CKE_pin                ,
	cs_n      => fpga_0_DDR2_SDRAM_DDR2_CS_N_pin               ,
	ras_n     => fpga_0_DDR2_SDRAM_DDR2_RAS_N_pin              ,
	cas_n     => fpga_0_DDR2_SDRAM_DDR2_CAS_N_pin              ,
	we_n      => fpga_0_DDR2_SDRAM_DDR2_WE_N_pin               ,
  	dm_rdqs   => fpga_0_DDR2_SDRAM_DDR2_DM_pin(3 downto 2)     ,
	ba        => fpga_0_DDR2_SDRAM_DDR2_BA_pin                 ,
	addr      => fpga_0_DDR2_SDRAM_DDR2_A_pin                  ,
	dq        => fpga_0_DDR2_SDRAM_DDR2_DQ_pin(31 downto 16)   ,
  	dqs       => fpga_0_DDR2_SDRAM_DDR2_DQS_pin(3 downto 2)    ,
  	dqs_n     => fpga_0_DDR2_SDRAM_DDR2_DQS_N_pin(3 downto 2)  ,
  	rdqs_n    => net_gnd2                                      ,
	odt       => fpga_0_DDR2_SDRAM_DDR2_ODT_pin(0)
  );

  ddr2_2 : ddr2
  port map (
    ck        => fpga_0_DDR2_SDRAM_DDR2_CK_pin(0)             ,
	ck_n      => fpga_0_DDR2_SDRAM_DDR2_CK_N_pin(0)           ,
	cke       => fpga_0_DDR2_SDRAM_DDR2_CKE_pin               ,
	cs_n      => fpga_0_DDR2_SDRAM_DDR2_CS_N_pin              ,
	ras_n     => fpga_0_DDR2_SDRAM_DDR2_RAS_N_pin             ,
	cas_n     => fpga_0_DDR2_SDRAM_DDR2_CAS_N_pin             ,
	we_n      => fpga_0_DDR2_SDRAM_DDR2_WE_N_pin              ,
  	dm_rdqs   => fpga_0_DDR2_SDRAM_DDR2_DM_pin(5 downto 4)    ,
	ba        => fpga_0_DDR2_SDRAM_DDR2_BA_pin                ,
	addr      => fpga_0_DDR2_SDRAM_DDR2_A_pin                 ,
	dq        => fpga_0_DDR2_SDRAM_DDR2_DQ_pin(47 downto 32)  ,
  	dqs       => fpga_0_DDR2_SDRAM_DDR2_DQS_pin(5 downto 4)   ,
  	dqs_n     => fpga_0_DDR2_SDRAM_DDR2_DQS_N_pin(5 downto 4) ,
  	rdqs_n    => net_gnd2                                ,
	odt       => fpga_0_DDR2_SDRAM_DDR2_ODT_pin(0)
  );
 
  ddr2_3 : ddr2
  port map (
    ck        => fpga_0_DDR2_SDRAM_DDR2_CK_pin(0)             ,
	ck_n      => fpga_0_DDR2_SDRAM_DDR2_CK_N_pin(0)           ,
	cke       => fpga_0_DDR2_SDRAM_DDR2_CKE_pin               ,
	cs_n      => fpga_0_DDR2_SDRAM_DDR2_CS_N_pin              ,
	ras_n     => fpga_0_DDR2_SDRAM_DDR2_RAS_N_pin             ,
	cas_n     => fpga_0_DDR2_SDRAM_DDR2_CAS_N_pin             ,
	we_n      => fpga_0_DDR2_SDRAM_DDR2_WE_N_pin              ,
  	dm_rdqs   => fpga_0_DDR2_SDRAM_DDR2_DM_pin(7 downto 6)    ,
	ba        => fpga_0_DDR2_SDRAM_DDR2_BA_pin                ,
	addr      => fpga_0_DDR2_SDRAM_DDR2_A_pin                 ,
	dq        => fpga_0_DDR2_SDRAM_DDR2_DQ_pin(63 downto 48)  ,
  	dqs       => fpga_0_DDR2_SDRAM_DDR2_DQS_pin(7 downto 6)   ,
  	dqs_n     => fpga_0_DDR2_SDRAM_DDR2_DQS_N_pin(7 downto 6) ,
  	rdqs_n    => net_gnd2                                     ,
	odt       => fpga_0_DDR2_SDRAM_DDR2_ODT_pin(0)
  );
 
  -- User downto  Put your stimulus here. Code in this
  --       section will not be overwritten.

  -- END USER CODE (Do not remove this line)

end architecture STRUCTURE;

