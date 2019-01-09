library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity filt_and_memcache is
 Port ( 
 --inputs
        filt_and_memcache_clk    : in  STD_LOGIC;
        filt_and_memcache_reset  : in  STD_LOGIC;
        filt_and_memcache_cam_in : in  STD_LOGIC_VECTOR (7 downto 0);
        filt_and_memcache_en     : in  STD_LOGIC;
        filt_and_memcache_FIFO_RESET : in  STD_LOGIC;
-- outputs
        filt_and_memcache_output   : out STD_LOGIC_VECTOR (7 downto 0);
        filt_and_memcache_finished : out  STD_LOGIC;
        
        filt_and_memcache_output_fifo_en : out STD_LOGIC
      );
       
end filt_and_memcache;

architecture filt_and_memcache_arch of filt_and_memcache  is

COMPONENT mem_cache PORT(
		  	   CLK : in  STD_LOGIC;
          reset : in  STD_LOGIC;
   mem_cache_en : in  STD_LOGIC;
     FIFO_RESET : in  STD_LOGIC;
	filt_and_memcache_FIFO_RESET : in  STD_LOGIC;
           --mem_cache_start : in  STD_LOGIC;
           --din : in  STD_LOGIC_VECTOR (7 downto 0);
 camera_input : in  STD_LOGIC_VECTOR (7 downto 0);
           --dout : out  STD_LOGIC_VECTOR (7 downto 0);
 px_window_ready: out STD_LOGIC;
 px0,px1,px2,px3,px4,px5,px6,px7,px8 : out STD_LOGIC_VECTOR (7 downto 0)
          -- prog_full_thresh : in  STD_LOGIC_VECTOR (9 downto 0)
           );
end COMPONENT;

COMPONENT average_image_filter PORT( 
    CLK : in  STD_LOGIC;
     EN : in  STD_LOGIC;

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
          filter_finished : out  STD_LOGIC ;
    filter_output_fifo_en : out STD_LOGIC 
    );
end COMPONENT;

--signals

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

   -- px_window_ready is connected with EN of average_image_filter
   signal mem_cache_finished_filter_enable : STD_LOGIC ;
   signal			   filter_output_fifo_en : STD_LOGIC ;
   signal      filt_and_memcache_reset_sig : STD_LOGIC ;

   
begin
inst_memcache :  mem_cache PORT MAP(
mem_cache_en => filt_and_memcache_en,    --enable filt and memcache entity
       reset => filt_and_memcache_reset,
        clk  => filt_and_memcache_clk,   --clock is common
FIFO_RESET   => filt_and_memcache_reset, --reset memcache
--INPUT of the entity
camera_input => filt_and_memcache_cam_in,
px0 => PIXEL_0,
px1 => PIXEL_1,
px2 => PIXEL_2,
px3 => PIXEL_3,
px4 => PIXEL_4,
px5 => PIXEL_5,
px6 => PIXEL_6,
px7 => PIXEL_7,
px8 => PIXEL_8,
--flag to enable filter component
px_window_ready => mem_cache_finished_filter_enable
);

inst_average_image_filter : average_image_filter  PORT MAP(
clk => filt_and_memcache_clk, --clock is common
-- enable is connected with the flag of memcache end
EN  => mem_cache_finished_filter_enable,
--connecting memcache px output with filter px input
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
filter_output   => filt_and_memcache_output,
--enable output fifo for writing the result
filter_output_fifo_en => filt_and_memcache_output_fifo_en,
--flag that filtering has finished
filter_finished => filt_and_memcache_finished
);

end  filt_and_memcache_arch ;
