----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    04:47:54 11/30/2018 
-- Design Name: 
-- Module Name:    mem_cache_tb - mem_cache_tb_arch 
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mem_cache_tb is
end mem_cache_tb;

architecture mem_cache_tb_arch of mem_cache_tb is

COMPONENT mem_cache
	PORT(
		--inputs
   	  clk        : IN std_logic;
		reset        : IN std_logic;
	   FIFO_RESET   : in  STD_LOGIC;
  		mem_cache_en : IN std_logic;
		camera_input : IN std_logic_vector(7 downto 0);          
		--outputs
		px_window_ready : OUT std_logic;
		px0 : OUT std_logic_vector(7 downto 0);
		px1 : OUT std_logic_vector(7 downto 0);
		px2 : OUT std_logic_vector(7 downto 0);
		px3 : OUT std_logic_vector(7 downto 0);
		px4 : OUT std_logic_vector(7 downto 0);
		px5 : OUT std_logic_vector(7 downto 0);
		px6 : OUT std_logic_vector(7 downto 0);
		px7 : OUT std_logic_vector(7 downto 0);
		px8 : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
-- signals and constants!
signal      RESET : std_logic ;
signal FIFO_RESET : std_logic ;

--	signal RESETFIFO : std_logic := '0';
signal      CLK : std_logic ;
signal camInput : std_logic_vector(7 downto 0) := (others => '0');
signal       EN : std_logic ;
--signal prog_full_thresh : std_logic_vector(9 downto 0) := (others => '0');

 	--Outputs
   signal px1 : std_logic_vector(7 downto 0);
   signal px2 : std_logic_vector(7 downto 0);
   signal px3 : std_logic_vector(7 downto 0);
   signal px4 : std_logic_vector(7 downto 0);
   signal px5 : std_logic_vector(7 downto 0);
   signal px6 : std_logic_vector(7 downto 0);
   signal px7 : std_logic_vector(7 downto 0);
   signal px8 : std_logic_vector(7 downto 0);
   signal px9 : std_logic_vector(7 downto 0);
   signal winReady : std_logic;

 -- constants
       constant CLK_period : time := 10 ns;  
-- signal prog_full_thresh is calculated as row_px_number-nr_of_px_before-cycles_inside_fifo
-- = 128 - 3 - 2 = 123
constant prog_full_thresh_1: STD_LOGIC_VECTOR(9 DOWNTO 0) := "0001111010"; --123

begin

	Inst_mem_cache: mem_cache PORT MAP(
		clk => CLK,
		reset => RESET,
		FIFO_RESET => FIFO_RESET,
		mem_cache_en => EN,
		camera_input => camInput,
		px_window_ready => winReady,
		px0 => px1,
		px1 => px2,
		px2 => px3,
		px3 => px4,
		px4 => px5,
		px5 => px6,
		px6 => px7,
		px7 => px8,
		px8 => px9
	);
-- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;


 -- Stimulus process
   stim_proc: process--(all)
   begin		
      wait for 100 ns;	
		     RESET <= '1';
		FIFO_RESET <= '1';
		
		camInput <= "00000000";
	--	prog_full_thresh <= "0001111011";

      wait for CLK_period*10;
		FIFO_RESET <= '0';
		
		wait for CLK_period*5;
		RESET <= '0';
		
--		wait for CLK_PERIOD*5; 3px *5 = 15 ?? test 3px * 90 = 270
   EN <= '1';
	wait for CLK_PERIOD*10;

     
		for count in 1 to 770 loop
	 
			camInput <= std_logic_vector(unsigned(camInput) + 1); --1 replaced with count
			--camInput <= "00010000";

			wait for CLK_period;
		end loop;
 
 wait;
   end process;

end mem_cache_tb_arch;

