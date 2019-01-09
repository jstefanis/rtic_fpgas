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

entity filt_and_memcache_tb is
end filt_and_memcache_tb ;

architecture filt_and_memcache_tb_arch of filt_and_memcache_tb is

-- COMPONENT mem_cache
-- 	PORT(
-- 		clk : IN std_logic;
-- 		reset : IN std_logic;
-- 	   FIFO_RESET : in  STD_LOGIC;
--   		mem_cache_en : IN std_logic;
-- 		camera_input : IN std_logic_vector(7 downto 0);          
-- 		px_window_ready : OUT std_logic;
-- 		px0 : OUT std_logic_vector(7 downto 0);
-- 		px1 : OUT std_logic_vector(7 downto 0);
-- 		px2 : OUT std_logic_vector(7 downto 0);
-- 		px3 : OUT std_logic_vector(7 downto 0);
-- 		px4 : OUT std_logic_vector(7 downto 0);
-- 		px5 : OUT std_logic_vector(7 downto 0);
-- 		px6 : OUT std_logic_vector(7 downto 0);
-- 		px7 : OUT std_logic_vector(7 downto 0);
-- 		px8 : OUT std_logic_vector(7 downto 0)
-- 		);
-- 	END COMPONENT;

    COMPONENT filt_and_memcache PORT( 
 --inputs
        filt_and_memcache_clk    : in  STD_LOGIC;
        filt_and_memcache_reset  : in  STD_LOGIC;
        filt_and_memcache_cam_in : in  STD_LOGIC_VECTOR (7 downto 0);
        filt_and_memcache_en     : in STD_LOGIC;
        filt_and_memcache_FIFO_RESET : in  STD_LOGIC;
-- outputs
        filt_and_memcache_output         : out STD_LOGIC_VECTOR (7 downto 0);
        filt_and_memcache_finished       : out  STD_LOGIC;
        filt_and_memcache_output_fifo_en : out STD_LOGIC
      );
      
    end COMPONENT;
    
    
--  filt_and_memcache signals
  signal fifo_to_memcache_input  : std_logic_vector (7 downto 0);
  signal filt_to_memcache_finished : std_logic := '0';
  signal memcache_output_to_fifo : std_logic_vector (7 downto 0);
  signal filt_and_memcache_output_fifo_en_sg : std_logic;
  
  signal clk : std_logic ;
  signal rst : std_logic ;
  
     signal rd_en : std_logic;

    -- signals and constants!
  --signal      RESET : std_logic := '0';
  signal FIFO_RESET : std_logic := '0';

--	signal RESETFIFO : std_logic := '0';
--signal CLK : std_logic := '0';
--signal camInput : std_logic_vector(7 downto 0) := (others => '0');
--signal EN : std_logic := '0';
--signal prog_full_thresh : std_logic_vector(9 downto 0) := (others => '0');

 	--Outputs
--    signal px1 : std_logic_vector(7 downto 0);
--    signal px2 : std_logic_vector(7 downto 0);
--    signal px3 : std_logic_vector(7 downto 0);
--    signal px4 : std_logic_vector(7 downto 0);
--    signal px5 : std_logic_vector(7 downto 0);
--    signal px6 : std_logic_vector(7 downto 0);
--    signal px7 : std_logic_vector(7 downto 0);
--    signal px8 : std_logic_vector(7 downto 0);
--    signal px9 : std_logic_vector(7 downto 0);
--    signal winReady : std_logic;

 -- constants
  constant CLK_period : time := 10 ns;  
-- signal prog_full_thresh is calculated as row_px_number-nr_of_px_before-cycles_inside_fifo
-- = 128 - 3 - 2 = 123
-- constant prog_full_thresh_1: STD_LOGIC_VECTOR(9 DOWNTO 0) := "0001111010"; --123

begin

-- 	Inst_mem_cache: mem_cache PORT MAP(
-- 		clk => CLK,
-- 		reset => RESET,
-- 		FIFO_RESET => FIFO_RESET,
-- 		mem_cache_en => EN,
-- 		camera_input => camInput,
-- 		px_window_ready => winReady,
-- 		px0 => px1,
-- 		px1 => px2,
-- 		px2 => px3,
-- 		px3 => px4,
-- 		px4 => px5,
-- 		px5 => px6,
-- 		px6 => px7,
-- 		px7 => px8,
-- 		px8 => px9
-- 	);
-- Clock process definitions

inst_filt_and_memcache : filt_and_memcache PORT MAP (
 --inputs
    
    filt_and_memcache_clk      => CLK,
    filt_and_memcache_reset    => rst,
    filt_and_memcache_FIFO_RESET => FIFO_RESET,
    filt_and_memcache_cam_in   => fifo_to_memcache_input, --connecting input fifo to filt_and_memcache component
    filt_and_memcache_en       => rd_en, -- input fifo read flag is raised, start memcache component!!
-- outputs
    filt_and_memcache_output   => memcache_output_to_fifo, -- 8bit- connecting filt_and_memcache component to output fifo
        
    filt_and_memcache_output_fifo_en => filt_and_memcache_output_fifo_en_sg,
    filt_and_memcache_finished => filt_to_memcache_finished

      );

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
		rst <= '1';
		--FIFO_RESET <= '1';
		
		fifo_to_memcache_input <= "00000000";
	--	prog_full_thresh <= "0001111011";

      wait for CLK_period*10;
		--FIFO_RESET <= '0';
		 rst <= '0';
		wait for CLK_period*5;
		rst <= '0';
		
--		wait for CLK_PERIOD*5; 3px *5 = 15 ?? test 3px * 90 = 270
  -- EN <= '1';
     rd_en <= '1';
	wait for CLK_PERIOD*10;

     
		for count in 1 to 255 loop
	 
			fifo_to_memcache_input <= std_logic_vector(unsigned(fifo_to_memcache_input) + 1); --1 replaced with count
			--fifo_to_memcache_input <= "00010000";

			wait for CLK_period*1;
		end loop;
 
 wait;
   end process;

end filt_and_memcache_tb_arch;

