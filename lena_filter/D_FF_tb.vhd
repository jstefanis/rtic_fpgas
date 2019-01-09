----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:54:39 11/27/2018 
-- Design Name: 
-- Module Name:    D_FF - Behavioral 
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

entity d_ff_tb is
--     Port (ff_clk : in  STD_LOGIC;
--            ff_rst : in  STD_LOGIC;
--            ff_en : in  STD_LOGIC;
--            ff_input : in  STD_LOGIC_VECTOR (7 downto 0);
--            ff_output : out  STD_LOGIC_VECTOR (7 downto 0));
end d_ff_tb;

architecture d_ff_sim of d_ff_tb is

	COMPONENT D_FF
	PORT(
		ff_input : IN std_logic_vector(7 downto 0);
		ff_clk : IN std_logic;          
        ff_rst : in STD_LOGIC;
        ff_en  : in STD_LOGIC;
        ff_output : OUT std_logic_vector(7 downto 0)
		);
		END COMPONENT;--D_FF;
		
		 --Inputs
   signal CLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal EN : std_logic := '0';
   signal D : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal Q : std_logic_vector(7 downto 0);
 
    --constants
 
   constant clk_period : time := 10 ns; --one cycle at 100Mhz
 

begin

d_ff_test: D_FF PORT MAP (
          ff_clk => CLK,
          ff_rst => RESET,
          ff_en => EN,
          ff_input => D,
          ff_output => Q
        );
        
--Processes

-- Clock process definitions
 
 -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		RESET <= '1';
--clk_en <= '0';
      wait for 20 ns;	
--clk_en <= '1';
		D <= x"A1";
		EN <= '0';
		wait for 100 ns;
		wait until (CLK'event and CLK = '1');
--		wait for 2 ns;
		RESET <= '0';
		wait for CLK_period*3;
		EN <= '1';
--		wait for 18 ns; --js 
		wait for CLK_period*5;
		EN <= '0';
		D <= x"0A";
		wait for CLK_period*5;
		EN <= '1';
		--D <= x"A0";
		wait for CLK_period*10;
		EN <= '1';
		D <= x"0A";
		wait for CLK_period*4;
		EN <= '0';
		D <= x"10";
		wait for CLK_Period*6;
		EN <= '1';
		D <= x"10";
     -- wait;
   end process;
	
    clk_process :process
   begin
		CLK <= '0';
		wait for clk_period/2;
		CLK <= '1';
		wait for clk_period/2;
   end process;
 
-- p1 : process(ff_clk, ff_rst, ff_en)
-- begin
-- 	if ff_rst = '1' then ff_output <= (others => '0');
-- 	elsif (ff_clk'event and ff_clk = '1') then
-- 		if (ff_en = '1') then ff_output <= ff_input;
-- 		end if;
-- 	end if;
-- end process p1;        
        
   
       
--    
--    -- Stimulus process
--    stim_proc: process
--    begin
-- 
-- ff_rst <= '1';
-- ff_en  <= '0';
-- ff_input <= x"00110000";
--       -- hold reset state for 100 ns.
--       wait for 100 ns;
-- ff_rst <= '1';
-- ff_en  <= '0';
-- ff_input <= x"00110000";
-- 
--       wait for clk_period*10;
-- 
--       wait;
--    end process;
end d_ff_sim;

