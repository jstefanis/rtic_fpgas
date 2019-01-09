library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity final_circuit_tb is
       
end;

architecture final_circuit_tb_arch of final_circuit_tb is

COMPONENT filt_and_memcache
 Port ( 
 --inputs
        filt_and_memcache_clk    : in  STD_LOGIC;
        filt_and_memcache_reset  : in  STD_LOGIC;
        filt_and_memcache_cam_in : in  STD_LOGIC_VECTOR (7 downto 0);
        filt_and_memcache_en     : in STD_LOGIC;
        filt_and_memcache_FIFO_RESET : in  STD_LOGIC;
-- outputs
        filt_and_memcache_output : out STD_LOGIC_VECTOR (7 downto 0);
        filt_and_memcache_finished : out  STD_LOGIC
      );
       
end COMPONENT;

end final_circuit_tb;
