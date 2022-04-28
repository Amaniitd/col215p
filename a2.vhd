----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/28/2022 10:18:35 AM
-- Design Name: 
-- Module Name: a2 - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity a2 is
    Port ( B0 : in STD_LOGIC;
           B1 : in STD_LOGIC;
           B2 : in STD_LOGIC;
           B3 : in STD_LOGIC;
           A : out STD_LOGIC;
           B : out STD_LOGIC;
           C : out STD_LOGIC;
           D : out STD_LOGIC;
           E : out STD_LOGIC;
           F : out STD_LOGIC;
           G : out STD_LOGIC;
           an : out STD_LOGIC_VECTOR(0 to 3));
end a2;

architecture Behavioral of a2 is

begin
    A <= (not B3 and not B2 and not B1 and B0) or (not B3 and B2 and not B1 and not B0) or (B3 and not B2 and B1 and B0) or (B3 and B2 and not B1 and B0);
    B <= (not B3 and B2 and not B1 and B0) or (B2 and B1 and not B0) or (B3 and B1 and B0) or (B3 and B2 and not B0);
    C <= (not B3 and not B2 and B1 and not B0) or (B3 and B2 and not B0) or (B3 and B2 and B1);
    D <= (not B3 and not B2 and not B1 and B0) or (not B3 and B2 and not B1 and not B0) or (B2 and B1 and B0) or (B3 and not B2 and B1 and not B0);
    E <= (not B3 and B0) or (not B3 and B2 and not B1) or (not B2 and not B1 and B0);
    F <= (not B3 and not B2 and B0) or (not B3 and not B2 and B1) or (not B3 and B1 and B0) or (B3 and B2 and not B1 and B0);
    G <= (not B3 and not B2 and not B1) or (not B3 and B2 and B1 and B0) or (B3 and B2 and not B1 and not B0);
    an <= "0111";
end Behavioral;
