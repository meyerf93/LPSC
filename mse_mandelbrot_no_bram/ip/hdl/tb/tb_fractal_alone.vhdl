library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

--User Define Librairy/Packages
library work;
use work.tb_package.all;

entity tb_fractal is
end tb_fractal;

architecture behavior of tb_fractal is
	component Mandelbrot_iteration is
        generic (   comma    : integer := 12;  -- nombre de bits après la virgule
                max_iter : integer := 100;
                SIZE     : integer := 16);

        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               ready : out STD_LOGIC;
               start : in STD_LOGIC;
               finished : out STD_LOGIC;
               c_real : in STD_LOGIC_VECTOR (SIZE-1 downto 0);
               c_imaginary : in STD_LOGIC_VECTOR (SIZE-1 downto 0);
               z_real : out STD_LOGIC_VECTOR (SIZE-1 downto 0);
               z_imaginary : out STD_LOGIC_VECTOR (SIZE-1 downto 0);
               iterations : out STD_LOGIC_VECTOR (SIZE-1 downto 0));
	end component Mandelbrot_iteration;
    
	--UUT

	signal rst_sti : std_logic := '0';
	signal start_sti : std_logic := '0';
	signal c_real_sti : std_logic_vector(15 downto 0);
	signal c_imaginary_sti : std_logic_vector(15 downto 0);
	
	signal zn_real_obs :   std_logic_vector(15 downto 0);
    signal zn_imaginary_obs :  std_logic_vector(15 downto 0);	
	signal n_obs : std_logic_vector(15 downto 0);
	signal ready_obs : std_logic;
	signal finished_obs : std_logic;
	
	signal x_screen_obs : std_logic_vector(9 downto 0);
	signal y_screen_obs : std_logic_vector(9 downto 0);
	
	--Constants
	constant clk_100MHz_period : time := 10 ns;  
	constant clk_44MHz_period : time := 22 ns;  
	  
	 --Signal
	 signal clk_100MHz_sti : std_logic;
	 signal clk_44MHz_sti : std_logic;
	 
	 constant clk_period : time := 10 ns;
	 constant C_DATA_SIZE : integer := 16;
	 constant C_DATA_COMMA : integer := 12;    

begin

    ---------------------------------------------------------------------------
    -- MandelBrot Calculator
    ---------------------------------------------------------------------------
     Mandelbort : component mandelbrot_iteration
		generic map(
			SIZE 		=> C_DATA_SIZE,
			COMMA		=> C_DATA_COMMA,
			MAX_ITER 	=> 100
		)

		port map(
			clk 		=>	clk_100MHz_sti,
			rst 		=>	rst_sti,
			start 		=> start_sti,
			c_real 		=> c_real_sti,
			c_imaginary	=> c_imaginary_sti,
			z_real		=> open,
			z_imaginary	=> open,
			iterations	=> n_obs,
			ready 		=> ready_obs,
			finished	=> finished_obs
		);
		

	-- Clock Process generation
	clk_100MHz_process :process
       begin
            clk_100MHz_sti <= '0';
            wait for clk_100MHz_period/2;  --for 0.5 ns signal is '0'.
            clk_100MHz_sti <= '1';
            wait for clk_100MHz_period/2;  --for next 0.5 ns signal is '1'.
       end process;
       
      -- Clock Process generation
	clk_44MHz_process :process
       begin
            clk_44MHz_sti <= '0';
            wait for clk_44MHz_period/2;  --for 0.5 ns signal is '0'.
            clk_44MHz_sti <= '1';
            wait for clk_44MHz_period/2;  --for next 0.5 ns signal is '1'.
       end process;
      
     
     -- Stimulus
    stim_process : process
    
    procedure async_reset is
    begin
        wait until rising_edge(clk_100MHz_sti);
        wait for clk_100MHz_period/4;
        rst_sti <= '1';
        wait for 4*clk_100MHz_period;
        rst_sti <= '0';
                
    end procedure async_reset;
    
    procedure sequencer(
        constant cr    :in real;
        constant ci    :in real
    ) is
    variable res_r : real;
    variable res_i : real;
    variable n : integer;

    variable res_exr : real;
    variable res_exi : real;

    variable res_exr_std : std_logic_vector(15 downto 0);
    variable res_exi_std : std_logic_vector(15 downto 0);
	    
    variable n_ex : integer;
    
    variable i : integer;
    begin

    		report "Test for " & real'image(cr) &" + i*" & real'image(ci);
			
            c_real_sti <= floattostd16(cr, 12);
            c_imaginary_sti <= floattostd16(ci, 12);
            
			while ready_obs = '0' loop
				wait until rising_edge(clk_100MHz_sti);
			end loop;
            
			wait until falling_edge(clk_100MHz_sti);
            start_sti <= '1';
            
            wait for 1*clk_100MHz_period;
            start_sti <= '0';
            
            
            wait until finished_obs = '1';
			
            report "Finished with n : " & integer'image(to_integer(unsigned(n_obs)));
            report "Zr : " & real'image(real(to_integer(signed(zn_real_obs)))/2**12) & " " & integer'image(to_integer(unsigned(zn_real_obs)));
            report "Zi : " & real'image(real(to_integer(signed(zn_imaginary_obs)))/2**12)& " " & integer'image(to_integer(unsigned(zn_imaginary_obs)));
            
            
            res_r := real(to_integer(signed(zn_real_obs))/2**12);
            res_i := real(to_integer(signed(zn_imaginary_obs))/2**12) ;
            n := to_integer(unsigned(n_obs));
            
            --Launch verification calculus
            res_exr := 0.0;
            res_exi := 0.0;
            n_ex := -1;
            
            while (not((res_exr * res_exr + res_exi*res_exi >= 4.0) or (n_ex >= 100))) loop
				n_ex := n_ex + 1;                
				
                res_exr := res_exr * res_exr - res_exi*res_exi + cr;
                res_exi := 2 * res_exr * res_exi + ci;
                
                
            end loop; 
            
            if(n_ex >= 100) then
                n_ex := 0;
            end if;
            
			res_exr_std := floattostd16(res_exr,12);
			res_exi_std := floattostd16(res_exi,12);

            report "n_ex : " & integer'image(n_ex);
            report "Zr_ex : " & real'image(real(to_integer(signed(res_exr_std)))/2**12) & " " & integer'image(to_integer(unsigned(res_exr_std)));
            report "Zi_ex : " & real'image(real(to_integer(signed(res_exi_std)))/2**12) & " " & integer'image(to_integer(unsigned(res_exi_std)));
       
            
            assert (res_r = res_exr) and (res_i = res_exi) and (n_ex = n)
            report  "Unexpected result"    severity  error;
            wait for 2*clk_period;

    end procedure sequencer;
    
    begin
        report "Test Bench Started";
        
        --Reset 
        async_reset;
        
		wait for 2*clk_period;
        
        --Test Case N°0
        --c_real_sti <= floattostd16(0.5, 12);
        --c_imaginary_sti <= floattostd16(0.5, 12);
		
	    --	start_sti <= '1';
        --    
        --    wait for 1*clk_100MHz_period;
        --    start_sti <= '0';
		
        --Test Case N°0
        --sequencer(0.25,0.25);
        
        --Test Case N°1
		--sequencer(-0.25,0.25);

 		--Test Case N°2
		sequencer(0.05,0.125);
        
        wait;
    end process;
end architecture behavior;
