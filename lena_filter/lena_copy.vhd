library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity TB_lena_copy is
       
end;

architecture arch_TB_lena_copy of TB_lena_copy is

	COMPONENT fifo_jd
	  PORT (
		clk : IN STD_LOGIC;
		rst : IN STD_LOGIC;
		din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		wr_en : IN STD_LOGIC;
		rd_en : IN STD_LOGIC;
		prog_full_thresh : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
		dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		full : OUT STD_LOGIC;
		empty : OUT STD_LOGIC;
		prog_full : OUT STD_LOGIC
	  );
	END COMPONENT;
  

  signal I1: std_logic_vector (7 downto 0);
  signal CLK,rst,wr_en,rd_en,full, empty,prog_full : std_logic;
  signal prog_full_thresh : STD_LOGIC_VECTOR(10 DOWNTO 0);
  signal O1 : std_logic_vector (7 downto 0);
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
	wait until ((empty ='1') and (full ='0'));
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
 
read_fifo_data: process
  file results : text;
  variable OLine : line;
  variable O1_var :std_logic_vector (7 downto 0);  
    begin
	 rd_en <= '0';
    file_open (results,"Lena128x128g_8bits_r.dat", write_mode);
	wait for 100 ns;
	wait until ((empty ='1') and (full ='0'));
	wait for CLK_period*3;
	wait until (empty ='0');
	wait for CLK_period*3;
	rd_en <= '1';
	wait for CLK_period*1.5;
	while (empty ='0') loop
		 write (Oline, O1, right, 2);
		 writeline (results, Oline);
		wait for CLK_period*1;
	
	end loop;
    file_close (results);
    wait;
 end process;  
 
global: process
    begin
    prog_full_thresh <= "00000000011";--(others => '0');
	rst <= '1';
	wait for 100 ns;
	rst <= '0';
	wait for 100 ns;
    wait;
 end process;
 
C1 : fifo_jd
  PORT MAP (
    clk => clk,
    rst => rst,
    din => I1,
    wr_en => wr_en,
    rd_en => rd_en,
    prog_full_thresh => prog_full_thresh,
    dout => O1,
    full => full,
    empty => empty,
    prog_full => prog_full
  ); 
 
end arch_TB_lena_copy;

