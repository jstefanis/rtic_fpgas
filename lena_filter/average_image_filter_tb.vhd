----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    04:56:38 11/27/2018 
-- Design Name: 
-- Module Name:    image_filter - image_filter_arch 
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
use ieee.std_logic_unsigned.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity average_image_filter_tb is
end average_image_filter_tb;


-- entity average_image_filter is
--   Port ( 
--     CLK : in  STD_LOGIC;
--     EN : in STD_LOGIC;
-- 
--     fp0 : in  STD_LOGIC_VECTOR (7 downto 0);
--     fp1 : in  STD_LOGIC_VECTOR (7 downto 0);
--     fp2 : in  STD_LOGIC_VECTOR (7 downto 0);
--     
--     fp3 : in  STD_LOGIC_VECTOR (7 downto 0);
--     fp4 : in  STD_LOGIC_VECTOR (7 downto 0);
--     fp5 : in  STD_LOGIC_VECTOR (7 downto 0);
--     
--     fp6 : in  STD_LOGIC_VECTOR (7 downto 0);
--     fp7 : in  STD_LOGIC_VECTOR (7 downto 0);
--     fp8 : in  STD_LOGIC_VECTOR (7 downto 0);
-- --     
-- --     fp0 fp1 fp2
-- --     fp3 fp4 fp5
-- --     fp6 fp7 fp8
-- --     
--     filter_output : out  STD_LOGIC_VECTOR (7 downto 0);
--     --controlling filter output
--     filter_finished : out  STD_LOGIC := '0';
--     filter_output_fifo_en : out STD_LOGIC := '0' 
-- 	 );
--     
-- end average_image_filter;

architecture average_image_filter_tb_arch of average_image_filter_tb is

COMPONENT average_image_filter Port ( 
    CLK : in  STD_LOGIC;
    EN : in STD_LOGIC;

    fp0 : in  STD_LOGIC_VECTOR (7 downto 0);
    fp1 : in  STD_LOGIC_VECTOR (7 downto 0);
    fp2 : in  STD_LOGIC_VECTOR (7 downto 0);
    
    fp3 : in  STD_LOGIC_VECTOR (7 downto 0);
    fp4 : in  STD_LOGIC_VECTOR (7 downto 0);
    fp5 : in  STD_LOGIC_VECTOR (7 downto 0);
    
    fp6 : in  STD_LOGIC_VECTOR (7 downto 0);
    fp7 : in  STD_LOGIC_VECTOR (7 downto 0);
    fp8 : in  STD_LOGIC_VECTOR (7 downto 0);
--     
--     fp0 fp1 fp2
--     fp3 fp4 fp5
--     fp6 fp7 fp8
--     
    filter_output : out  STD_LOGIC_VECTOR (7 downto 0);
    --controlling filter output
    filter_finished : out  STD_LOGIC := '0';
    filter_output_fifo_en : out STD_LOGIC := '0' 
	 );
    
end COMPONENT;

signal output_fifo_en_sig : STD_LOGIC := '0' ;
signal clk : std_logic ;
signal rst : std_logic ;
signal EN : std_logic ;

signal filter_output : STD_LOGIC_VECTOR (7 downto 0);
signal filter_finished : std_logic ;
signal filter_output_fifo_en : std_logic ;



  -- pixel signals
   signal PIXEL_8 : std_logic_vector(7 downto 0);
   signal PIXEL_7 : std_logic_vector(7 downto 0);
   signal PIXEL_6 : std_logic_vector(7 downto 0);
   signal PIXEL_5 : std_logic_vector(7 downto 0);
   signal PIXEL_4 : std_logic_vector(7 downto 0);
   signal PIXEL_3 : std_logic_vector(7 downto 0);
   signal PIXEL_2 : std_logic_vector(7 downto 0);
   signal PIXEL_1 : std_logic_vector(7 downto 0);
   signal PIXEL_0 : std_logic_vector(7 downto 0);

-- constants
constant CLK_period : time := 10 ns;  


begin

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
--      wait for 100 ns;
--		rst <= '1';
		--FIFO_RESET <= '1';

      wait for CLK_period*10;
		--FIFO_RESET <= '0';
--		 rst <= '0';
	--	wait for CLK_period*5;
--		rst <= '0';

    EN <= '1';
	wait for CLK_PERIOD*10;

     
		for count in 1 to 16384 loop
	 
            PIXEL_0 <= "11111111";
            PIXEL_1 <= "11111111";
            PIXEL_2 <= "11111111";
            PIXEL_3 <= "11111111";
            PIXEL_4 <= "11111111";
            PIXEL_5 <= "11111111";
            PIXEL_6 <= "11111111";
            PIXEL_7 <= "11111111";
            PIXEL_8 <= "11111111";

			--fifo_to_memcache_input <= std_logic_vector(unsigned(fifo_to_memcache_input) + 1); --1 replaced with count
			--fifo_to_memcache_input <= "00010000";
			wait for CLK_period*1;
		end loop;
 
 wait;
   end process;
   
inst_average_image_filter : average_image_filter  PORT MAP (
clk => clk, --clock is common

EN  => EN,

--connecting memcach px output with filter px input
fp0 => PIXEL_0,
fp1 => PIXEL_1,
fp2 => PIXEL_2,
fp3 => PIXEL_3,
fp4 => PIXEL_4,
fp5 => PIXEL_5,
fp6 => PIXEL_6,
fp7 => PIXEL_7,
fp8 => PIXEL_8,

--OUTPUT of the entity - 8bit pixel
    filter_output => filter_output,
    --controlling filter output
    filter_finished => filter_finished,
    filter_output_fifo_en => filter_output_fifo_en
    );

end average_image_filter_tb_arch;

