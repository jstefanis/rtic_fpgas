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


entity average_image_filter is
  Port ( 
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
    filter_output   : out  STD_LOGIC_VECTOR (7 downto 0);
    --controlling filter output
    filter_finished : out  STD_LOGIC := '0';
    filter_output_fifo_en : out STD_LOGIC := '0' 
	 );
end average_image_filter;

architecture image_filter_arch of average_image_filter is
signal output_fifo_en_sig : STD_LOGIC := '0' ;
--new for connecting memcache filter!!

signal sum1 : STD_LOGIC_VECTOR (8  downto 0);
signal sum2 : STD_LOGIC_VECTOR (8  downto 0);
signal sum3 : STD_LOGIC_VECTOR (8  downto 0);
signal sum4 : STD_LOGIC_VECTOR (8  downto 0);
signal sum5 : STD_LOGIC_VECTOR (9  downto 0);
signal sum6 : STD_LOGIC_VECTOR (9  downto 0);
signal sum7 : STD_LOGIC_VECTOR (10 downto 0);

signal central_px : STD_LOGIC_VECTOR (7 downto 0);
-- signal sum7 : STD_LOGIC_VECTOR (7 downto 0);
-- signal sum8 : STD_LOGIC_VECTOR (7 downto 0);

--        p1 p2  p3 p5  p6 p7 p8 p9 p4   8bit
--L1        sum1 sum2   sum3  sum4  |    8+1 bit
--               |         |        |     
--L2              sum5    sum6      |    8+2 bit
--                  |    |          |
--L3                 sum7           p4   8+3 bit
--                    |             | 
--                                  X
--L4                 sum8    8+4 bit
begin

averaging: process(CLK,EN)
-- it will average all values apart from the central pixel of the window
-- due to performance reasons. I can use 3shifts to the right to make 
--the averaging in binary system and add the middle pixel at the end.
    variable level :integer := 0;   -- 1 2 3 4
begin
--if (EN = '1') then --then
while (EN = '1') loop	
	if(CLK'event and CLK = '1') then
 central_px <= fp4;
 
    -- L1
	 -- example sum <= ('0' & operand1) + ('0' & operand2);
	 --better : I take the msb and i put it in front
    sum1 <= (fp0(7)&fp0) + (fp1(7)&fp1); --fp0(7)&fp0
    sum2 <= (fp2(7)&fp2) + (fp3(7)&fp3);  --bit manipulation for addition
    sum3 <= (fp5(7)&fp5) + (fp6(7)&fp6);
    sum4 <= (fp7(7)&fp8) + (fp8(7)&fp8);
     --L2
    sum5 <= (sum1(8)&sum1) + (sum2(8)&sum2);
    sum6 <= (sum3(8)&sum3) + (sum4(8)&sum4);
	 --L3
    sum7 <= (sum5(9)&sum5) + (sum6(9)&sum6);
 -- we leave px4, the middle pixel aside!!
	filter_output <= sum7(7 downto 0) ; --discard 3MSB,division by 2^3 result   

	filter_output_fifo_en <= '1'; -- send message for enabling output fifo
 end if;
end loop;
  
 filter_output_fifo_en <= '0';
 filter_finished <= '1' ;
-- end if;

 end process averaging;
end image_filter_arch;

