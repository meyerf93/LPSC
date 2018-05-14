----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 20.03.2018 18:55:49
-- Design Name:
-- Module Name: Mandelbrot_iteration - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
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
use IEEE.NUMERIC_STD.ALL;

entity Mandelbrot_iteration is

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
           
end Mandelbrot_iteration;


architecture behavior of Mandelbrot_iteration is
    signal ite : unsigned (SIZE-1 downto 0) := (others => '0');
    signal z_real_s : std_logic_vector(SIZE-1 downto 0) := (others => '0');
    signal z_imaginary_s : std_logic_vector(SIZE-1 downto 0) := (others => '0');
    signal ready_s : std_logic := '0';
begin

    Iteration_calucaltion: process (clk, rst) is
        variable z_real_2 : unsigned (2*SIZE-1 downto 0):=(others => '0');
        variable z_imaginary_2 : unsigned (2*SIZE-1 downto 0):=(others => '0');
        variable z_real_imaginary : unsigned (2*SIZE-1 downto 0):=(others => '0');
        variable z_r_2_z_i_2 : unsigned (2*SIZE-1 downto 0):=(others => '0');
        variable z_real_d : unsigned (SIZE-1 downto 0):=(others => '0');
        variable z_imaginary_d : unsigned (SIZE-1 downto 0):=(others => '0');
    begin

        if( rst = '1') then
            z_real_d := (others => '0');
            z_imaginary_d := (others => '0');
	         ite <= (others =>'0');
            ready_s <= '1';
	        finished <='0';
  	    elsif rising_edge(clk) then
            if (start = '1') then
                z_real <= std_logic_vector(z_real_d);
                z_imaginary <= std_logic_vector(z_imaginary_d);
	            ready_s <='0';
	        elsif(ready_s = '0') then
                z_real_d := resize((z_real_2 -z_imaginary_2 + unsigned(c_real)),z_real_d'length);
                z_imaginary_d := resize((unsigned(z_real_imaginary * 2) + unsigned(c_imaginary)),z_imaginary_d'length);
            end if;
		    -- mutilplex for z_real an z_imagi
		    if( ite = 0) then
		       z_real_s <= (others => '0');
               z_imaginary_s <= (others => '0');
            else
		       z_real_s <= std_logic_vector(z_real_d);
               z_imaginary_s <= std_logic_vector(z_imaginary_d);
		    end if;
		    -- calcul of z²
    	    z_real_2 := unsigned(z_real_s)* unsigned(z_real_s);
    	    z_imaginary_2 := unsigned(z_imaginary_s)*unsigned(z_imaginary_s);
    	    z_real_imaginary := unsigned(z_real_s)*unsigned(z_imaginary_s);

		        -- combinaison of z
    	    z_r_2_z_i_2 := z_imaginary_2 + z_real_2;
    		    -- finish condition
    	    if(z_r_2_z_i_2 >= ( 4000)) then
    	        finished <= '1';
    	    else
    	        finished <= '0';
    		    ite <= ite + 1;
    	    end if;
        end if;

        z_real <= std_logic_vector(z_real_d);
        z_imaginary <= std_logic_vector(z_imaginary_d);
        ready <= ready_s;
        iterations <= std_logic_vector(ite);
    end process;

end architecture;
