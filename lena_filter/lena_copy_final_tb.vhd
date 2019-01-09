library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity TB_lena_copy is
       
end;

architecture arch_TB_lena_copy of TB_lena_copy is

    COMPONENT filt_and_memcache
    PORT ( 
 --inputs
        filt_and_memcache_clk    : in  STD_LOGIC;
        filt_and_memcache_reset  : in  STD_LOGIC;
        filt_and_memcache_cam_in : in  STD_LOGIC_VECTOR (7 downto 0);
        filt_and_memcache_en     : in  STD_LOGIC;
-- outputs
              filt_and_memcache_output   : out STD_LOGIC_VECTOR (7 downto 0);
              filt_and_memcache_finished : out  STD_LOGIC;
        filt_and_memcache_output_fifo_en : out STD_LOGIC
      );
       
    end COMPONENT;

	COMPONENT fifo_jd
	  PORT (
		clk   : IN STD_LOGIC;
		rst   : IN STD_LOGIC;
		din   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		wr_en : IN STD_LOGIC;
		rd_en : IN STD_LOGIC;
		prog_full_thresh : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
		
		
		dout      : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		full      : OUT STD_LOGIC;
		empty     : OUT STD_LOGIC;
		prog_full : OUT STD_LOGIC
	  );
	END COMPONENT;
	
	
--  filt_and_memcache signals
  signal fifo_to_memcache_input  : std_logic_vector (7 downto 0);
  signal filt_to_memcache_finished : std_logic := '0';
  signal memcache_output_to_fifo : std_logic_vector (7 downto 0);
  signal filt_and_memcache_output_fifo_en_sg : std_logic;
  signal filt_and_memcache_FIFO_RESET : std_logic;
  
  signal clk : std_logic ;
  signal rst : std_logic ;

--  r/w fifo signals
  signal I1 : std_logic_vector (7 downto 0); --write image to fifo
  signal O1 : std_logic_vector (7 downto 0);-- write output fifo data to result file
  
  --signal CLK,rst,wr_en,rd_en,full, empty,prog_full : std_logic;
  
  signal wr_en,rd_en: std_logic;
  signal wr_en_out,rd_en_out: std_logic;
  signal empty_in,empty_out: std_logic;
  
  signal prog_full_in,prog_full_out : std_logic;
  --signal full_output : std_logic; --?
  
  signal prog_full_thresh : STD_LOGIC_VECTOR(10 DOWNTO 0);
  
  signal full_input_fifo  : std_logic;
  signal full_output_fifo : std_logic;
  --constants
  constant CLK_period : time := 10 ns;  
  
begin
   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;

write_fifo_data: process
  FILE lena_orig : text;
  variable Iline : line;
  variable I1_var :std_logic_vector (7 downto 0);
    
    begin
	wr_en	<= '0';
	I1 <= (others =>'0'); 

    file_open (lena_orig,"Lena128x128g_8bits.dat", read_mode);
	wait for CLK_period*3;
	--wait until ((empty ='1') and (full ='0'));
	wait until ((empty_in ='1') and (full_input_fifo ='0'));
		wait for CLK_period*3;
	wait until (clk'event and clk ='1');
	wait for CLK_period/2;
    while not endfile(lena_orig) loop
      readline (lena_orig,Iline);
      read (Iline,I1_var);  
	  wr_en	<= '1';  
      I1 <= I1_var; 
	  wait for CLK_period*1;
    end loop;
	wr_en	<= '0';
    file_close (lena_orig);
    wait;
 end process;
  
read_fifo_to_f_memcache: process
  begin
  --wait for CLK_period*3;
  wait until ( (empty_in = '1' ) and (full_input_fifo = '0') );
  wait for CLK_period*3;
  while (empty_in = '0') loop
  rd_en <= '1';
  wait for CLK_period*1 ;
  end loop;
  rd_en <= '0';
  wait;
end process;
 
 write_f_memcache_to_output_fifo: process
 begin
 --wait until ((filt_to_memcache_finished = '1' ) and () )
 --wait until ((filt_to_memcache_finished = '1') and (empty_out = '0') )
 wait until ((filt_and_memcache_output_fifo_en_sg = '1') and (empty_out = '0') );
 --while (empty_out = '0' ) loop
 while (filt_and_memcache_output_fifo_en_sg = '1' ) loop
 wr_en_out <= '1';
 wait for CLK_period*1 ;
 end loop;
--wait for CLK_period*3; --delay for processing all pixels
 wr_en_out <= '0';
 wait;
end process;
 
read_fifo_data: process
  file results : text;
  variable OLine : line;
  variable O1_var :std_logic_vector (7 downto 0);  
    begin
	 --rd_en <= '0';
    rd_en_out <= '0';
    file_open (results,"Lena128x128g_8bits_r.dat", write_mode);
	wait for 100 ns;
	wait until ((empty_out ='1') and (full_output_fifo ='0'));
	wait for CLK_period*3;
	wait until (empty_out ='0');
	--wait for CLK_period*3;
	rd_en_out <= '1';
	--?why? wait for CLK_period*1.5;
	while (empty_out ='0') loop
		 --write (Oline, O1, right, 2);
		 write (Oline, O1_var, right,2);
		 writeline (results, OLine);
		 wait for CLK_period*1;
	end loop;
	--filt_and_memcache_finished 
	rd_en_out <= '0'; --added
    file_close (results);
    wait;
 end process;  
 
global: process
    begin
--    prog_full_thresh <= "00000000011";--(others => '0');
	rst <= '1';
	wait for 100 ns;
	rst <= '0';
	wait for 100 ns;
    wait;
 end process;
 
 fifo reset: process(filt_and_memcache_FIFO_RESET)
     begin
	filt_and_memcache_FIFO_RESET <= '1';
	wait for 100 ns;
	filt_and_memcache_FIFO_RESET <= '0';
	wait for 100 ns;
    wait;
 end process;
 

--     clk => clk,
--     rst => rst,
--     din => I1,
--     wr_en => wr_en,
--     rd_en => rd_en,
--     prog_full_thresh => prog_full_thresh,
--     dout => O1,
--     full => full,
--     empty => empty,
--     prog_full => prog_full
--   ); 
  

INPUT_FIFO : fifo_jd
  PORT MAP (
    clk   => clk,
    rst   => rst,
    din   => I1,
    wr_en => wr_en,
    rd_en => rd_en,
    prog_full_thresh => prog_full_thresh,
    dout  => fifo_to_memcache_input , --connecting input fifo to filt_and_memcache component    O1,
    full  => full_input_fifo, --full,
    empty => empty_in,
    prog_full => prog_full_in
  ); 

  
inst_filt_and_memcache : filt_and_memcache PORT MAP ( 
 --inputs
	 filt_and_memcache_FIFO_RESET => filt_and_memcache_FIFO_RESET,
    filt_and_memcache_clk      => CLK,
    filt_and_memcache_reset    => rst,
    filt_and_memcache_cam_in   => fifo_to_memcache_input, --connecting input fifo to filt_and_memcache component
    filt_and_memcache_en       => rd_en, -- input fifo read flag is raised, start memcache component!!
-- outputs
    filt_and_memcache_output   => memcache_output_to_fifo, -- 8bit- connecting filt_and_memcache component to output fifo
        
	 filt_and_memcache_output_fifo_en => filt_and_memcache_output_fifo_en_sg,
    filt_and_memcache_finished => filt_to_memcache_finished
      );

OUTPUT_FIFO : fifo_jd
  PORT MAP (
    clk => clk,
    rst => rst,
    din => memcache_output_to_fifo,  --connecting filt_and_memcache component to output fifo
    wr_en => wr_en_out,
    rd_en => rd_en_out,
    prog_full_thresh => prog_full_thresh,
    dout => O1,
    full => full_output_fifo,
    empty => empty_out,
    prog_full => prog_full_out
  );   
 
end arch_TB_lena_copy;

