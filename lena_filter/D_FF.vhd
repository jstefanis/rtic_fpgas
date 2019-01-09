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

entity D_FF is
    Port (ff_clk : in  STD_LOGIC;
           ff_rst : in  STD_LOGIC;
           ff_en : in  STD_LOGIC;
           ff_input : in  STD_LOGIC_VECTOR (7 downto 0);
           ff_output : out  STD_LOGIC_VECTOR (7 downto 0));
end D_FF;

architecture Behavioral of D_FF is
begin

p1 : process(ff_clk, ff_rst, ff_en)
begin
	if ff_rst = '1' then ff_output <= (others => '0');
	elsif (ff_clk'event and ff_clk = '1') then
		if (ff_en = '1') then ff_output <= ff_input;
		end if;
	end if;
end process p1;


end Behavioral;

