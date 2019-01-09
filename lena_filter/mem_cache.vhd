----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:19:43 11/20/2018 
-- Design Name: 
-- Module Name:    mem_cache 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mem_cache is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           mem_cache_en: in STD_LOGIC;
           FIFO_RESET : in  STD_LOGIC;
           camera_input : in  STD_LOGIC_VECTOR (7 downto 0);
           px_window_ready: out STD_LOGIC;
           px0,px1,px2,px3,px4,px5,px6,px7,px8 : out STD_LOGIC_VECTOR (7 downto 0)
           );
end mem_cache;
 
architecture mem_cache_arch of mem_cache is

COMPONENT CONTROL_GATE
PORT(
en_input : in std_logic;
fifo_input: in std_logic;
fifo_control: out std_logic
);
end COMPONENT;

	COMPONENT D_FF
	PORT(
		ff_input : IN std_logic_vector(7 downto 0);
		ff_clk : IN std_logic;          
        ff_rst : in STD_LOGIC;
        ff_en  : in STD_LOGIC;
        ff_output : OUT std_logic_vector(7 downto 0)
		);
		END COMPONENT;
		
    COMPONENT D_FF_CONTROL
	PORT(
		ff_input : IN std_logic;
		ff_clk : IN std_logic;          
        ff_rst : in STD_LOGIC;
        ff_en  : in STD_LOGIC;
        ff_output : OUT std_logic
		);
		END COMPONENT;
	
COMPONENT FIFO_MEMCACHE
  PORT (
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    prog_full_thresh : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC;
    prog_full : OUT STD_LOGIC
  );
  END COMPONENT;
  
  
signal temp1,temp2,temp3,temp4,temp5,temp6,temp7,temp8,temp9 : std_logic_vector(7 downto 0);
signal control_1,control_2,control_3,control_4,control_5,control_6,control_7,control_8,control_9 :STD_LOGIC; --std_logic_vector(0 downto 0);
signal xtra_ctrl_row1 : STD_LOGIC;
signal xtra_ctrl_row2 : STD_LOGIC;
signal xtra_ctrl_row3 : STD_LOGIC;

signal fif_full : STD_LOGIC;
signal fif_full2 : STD_LOGIC;


signal fif_empty : STD_LOGIC;
signal fif_empty2 : STD_LOGIC;

signal prog_full_1 : STD_LOGIC;
signal prog_full_2 : STD_LOGIC;
--	signal rst : STD_LOGIC;
-- signal wr_en_1,wr_en_2 : std_logic;
-- signal rd_en_1,rd_en_2 : std_logic;

--
-- signal prog_full_thresh is calculated as row_px_number-nr_of_px_before-cycles_inside_fifo
-- = 128 - 3 - 2 = 123
constant prog_full_thresh_1: STD_LOGIC_VECTOR(9 DOWNTO 0) := "0001111011";--`123
constant prog_full_thresh_2: STD_LOGIC_VECTOR(9 DOWNTO 0) := "0001111011";-- 123

signal enable: STD_LOGIC := '1';
--signal prog_full_thresh_1,prog_full_thresh_2 : STD_LOGIC_VECTOR(10 DOWNTO 0);
signal fifo_out_1,fifo_out_2 : std_logic_vector(7 downto 0); 

signal gate_control_fifo1,gate_control_fifo2 :std_logic;

begin 

--- ROW 1 control flip flops
	control_ff_1: D_FF_CONTROL PORT MAP(
		ff_input => mem_cache_en,
		ff_rst => reset,
		ff_clk => clk,
		ff_en => '1', 
		ff_output => control_1
	);

		control_ff_2: D_FF_CONTROL PORT MAP(
		ff_input => control_1,
		ff_rst => reset,
		ff_clk => clk,
		ff_en => '1', 
		ff_output => control_2
	);
	
		control_ff_3: D_FF_CONTROL PORT MAP(
		ff_input => control_2,
		ff_rst => reset,
		ff_clk => clk,
		ff_en => '1', 
		ff_output => control_3
	);
	

	  --ROW1 pixel control ff
  
  --
--   -- xtra control ff for synchronization
--     xtra_control_ff_row1: D_FF_CONTROL PORT MAP(
-- 		ff_input => control_3,
-- 		ff_rst => reset,
-- 		ff_clk => clk,
-- 		ff_en => '1', 
-- 		ff_output => xtra_ctrl_row1
-- 	);
--   --end of xtra ctrl ff	
	
	
-- row 1 pixel flip flops
	Inst_D_FF1: D_FF PORT MAP(
		ff_input => camera_input,
		ff_rst => reset,
		ff_clk => clk,
		ff_en => control_1, 
		ff_output => temp1
	);
	Inst_D_FF2: D_FF PORT MAP(
		ff_input =>temp1,
		ff_rst => reset,
		ff_clk => clk,
		ff_en => control_2,
		ff_output => temp2
	);
	Inst_D_FF3: D_FF PORT MAP(
		ff_input => temp2,
		ff_rst => reset,
		ff_clk => clk,
		ff_en => control_3,
		ff_output => temp3
	);


	  --ROW1 pixel control ff
  
  --
  -- xtra control ff for synchronization
--     xtra_control_ff_row1: D_FF_CONTROL PORT MAP(
--		ff_input => prog_full_1,
--		ff_rst => reset,
--		ff_clk => clk,
--		ff_en => '1', 
--		ff_output => xtra_ctrl_row1
--	);
  --end of xtra ctrl ff

-- control fifo1 read_en gate
--control_gate_fifo1: CONTROL_GATE PORT MAP(
--en_input <= mem_cache_en,
--fifo_input <= prog_full_1,
--fifo_control <= rd_en
--);	

gate_control_fifo1 <= mem_cache_en and  prog_full_1 ; --added -not- for test
	--ROW1 FIFO1
	inst_FIFO_MEMCACHE : FIFO_MEMCACHE  PORT MAP (
    clk => clk,
    rst => FIFO_RESET, --reset, --added fifo reset
    din => temp3,
   wr_en => control_3, -- xtra_ctrl_row1,
--    wr_en => control_3,
    rd_en => gate_control_fifo1, --prog_full_1,
    prog_full_thresh => prog_full_thresh_1,
    dout => fifo_out_1,
    full => fif_full,
    empty => fif_empty,
    prog_full => prog_full_1
  );
  
  --ROW2 pixel control ff
  
  --
  -- xtra control ff for synchronization
--     xtra_control_ff_row2: D_FF_CONTROL PORT MAP(
--		ff_input => prog_full_1,
--		ff_rst => reset,
--		ff_clk => clk,
--		ff_en => '1', 
--		ff_output => xtra_ctrl_row2
--	);
  --end of xtra ctrl ff
  
   	control_ff_4: D_FF_CONTROL PORT MAP(
		--ff_input => xtra_ctrl_row2,
		ff_input => prog_full_1,
		ff_rst => reset,
		ff_clk => clk,
		ff_en => '1', 
		ff_output => control_4
	);
	
	control_ff_5: D_FF_CONTROL PORT MAP(
		ff_input => control_4,
		ff_rst => reset,
		ff_clk => clk,
		ff_en => '1', 
		ff_output => control_5
	);
  	
  	control_ff_6: D_FF_CONTROL PORT MAP(
		ff_input => control_5,
		ff_rst => reset,
		ff_clk => clk,
		ff_en => '1', 
		ff_output => control_6
	);
	
	
	-----------------------
	--
	-----------------------
	--ROW2 pixel flip flops
	
		Inst_D_FF4: D_FF PORT MAP(
		ff_input => fifo_out_1,
		ff_rst => reset,
		ff_clk => clk,
		ff_en => control_4,
		ff_output => temp4
	);
	Inst_D_FF5: D_FF PORT MAP(
		ff_input =>temp4,
		ff_rst => reset,
		ff_clk => clk,
		ff_en => control_5,
		ff_output => temp5
	);
	Inst_D_FF6: D_FF PORT MAP(
		ff_input => temp5,
		ff_rst => reset,
		ff_clk => clk,
		ff_en => control_6,
		ff_output => temp6
	);
	
	-- control fifo2 read_en gate
--control_gate_fifo2: CONTROL_GATE PORT MAP(
--en_input <= mem_cache_en,
--fifo_input <= prog_full_2,
--fifo_control <= rd_en
--);

gate_control_fifo2 <= mem_cache_en and prog_full_2 ; --added -not- for test
	
	inst_FIFO_MEMCACHE2 : FIFO_MEMCACHE  PORT MAP (
    clk => clk,
    rst =>FIFO_RESET, --reset, -- added FIFO_RESET
    din => temp6,
    wr_en => control_6,
    rd_en =>gate_control_fifo2, -- prog_full_2,
    prog_full_thresh => prog_full_thresh_2,
    dout => fifo_out_2,
    full => fif_full2,
    empty => fif_empty2,
    prog_full => prog_full_2
  );
  
   --ROW3 pixel control ff
		control_ff_7: D_FF_CONTROL PORT MAP(
		ff_input => prog_full_2,
		ff_rst => reset,
		ff_clk => clk,
		ff_en => '1', 
		ff_output => control_7
	);
	
	control_ff_8: D_FF_CONTROL PORT MAP(
		ff_input => control_7,
		ff_rst => reset,
		ff_clk => clk,
		ff_en => '1', 
		ff_output => control_8
	);
  	
  	control_ff_9: D_FF_CONTROL PORT MAP(
		ff_input => control_8,
		ff_rst => reset,
		ff_clk => clk,
		ff_en => '1', 
		ff_output => control_9
	);
	
	-----------------------
	--
	-----------------------
	--ROW3 pixel flip flops


	-- last three pixels flip-flop
		
		Inst_D_FF7: D_FF PORT MAP(
		ff_input => fifo_out_2,
		ff_rst => reset,
		ff_clk => clk,
		ff_en => control_7,
		ff_output => temp7
	);
	Inst_D_FF8: D_FF PORT MAP(
		ff_input =>temp7,
		ff_rst => reset,
		ff_clk => clk,
		ff_en => control_8,
		ff_output => temp8
	);
	Inst_D_FF9: D_FF PORT MAP(
		ff_input => temp8,
		ff_rst => reset,
		ff_clk => clk,
		ff_en => control_9,
		ff_output => temp9
	);
	
-- memory_cache_process: process(clk,mem_cache_en)
-- begin
--     if (clk'event and clk = '1') then
--         
--     
--     
--     end if;
-- end process;

--rst <=reset;

px8 <= temp1;
px7 <= temp2;
px6 <= temp3;
px5 <= temp4;
px4 <= temp5;
px3 <= temp6;
px2 <= temp7;
px1 <= temp8;
px0 <= temp9;
px_window_ready <= control_9;
--px_window_ready <= '1';
	
end mem_cache_arch;

