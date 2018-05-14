-------------------------------------------------------------------------------
-- Title       : Fractal
-- Project     : 
-------------------------------------------------------------------------------
-- File        : fractal.vhd
-- Authors     : Jonathan Hendriks
-- Company     : ROSAS
-- Created     : 20.03.2018
-- Last update : 20.03.2018
-- Platform    : Vivado (synthesis)
-- Standard    : VHDL'08
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2018 ROSAS, Lausanne
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 26.02.2018   0.0      SCJ      Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package tb_package is

	--Procedure(s)
	--procedure monitor(
	--	signal cr : in std_logic_vector(15 downto 0);
	--	signal ci : in std_logic_vector(15 downto 0);
	--	signal zr : in std_logic_vector(15 downto 0);
	--	signal zi : in std_logic_vector(15 downto 0);
	--	signal n : in std_logic_vector(6 downto 0);
	--	signal finished : in std_logic
	--);

	--procedure sequencer(
	--	signal ready: in std_logic;
	--	signal cr_i : in std_logic_vector(15 downto 0);
	--	signal ci_i : in std_logic_vector(15 downto 0);

	--	signal cr : out std_logic_vector(15 downto 0);
	--	signal ci : out std_logic_vector(15 downto 0);
	--	signal start : out std_logic
	--);
	--Function(s)
  function floattostd16(a : real range -4.0 to 4.0;
							comma : integer)
                   return std_logic_vector;
end tb_package;

package body tb_package is
	
-----------------------------------------------------------------
--Procedure(s)
-----------------------------------------------------------------

	
-----------------------------------------------------------------
--Function(s)
-----------------------------------------------------------------
  function floattostd16 (
		a : real range -4.0 to 4.0;
		comma : integer
	) return std_logic_vector is

	variable temp : std_logic_vector(15 downto 0) := (others => '0');
	variable var : integer;
	variable sign : std_logic; 
 
	begin
    -- Conversion of float to std_logic_vector()
	var := integer(a*2.0**comma);
	temp := std_logic_vector(to_signed(var, temp'length));
	return temp;
 end floattostd16;

end tb_package;
