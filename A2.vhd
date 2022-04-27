library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity bcd_7seg is
Port ( B0,B1,B2,B3 : in STD_LOGIC;
A,B,C,D,E,F,G : out STD_LOGIC);
end bcd_7seg;
 
architecture Behavioral of bcd_7seg is
 
begin
    A <= (not B3 and not B2 and not B1 and B0) or (not B3 and B2 and not B1 and not B0) or (B3 and not B2 and B1 and B0) or (B3 and B2 and not B1 and B0);
    B <= (not B3 and B2 and not B1 and B0) or (B2 and B1 and not B0) or (B3 and B1 and B0) or (B3 and B2 and not B0);
    C <= (not B3 and not B2 and B1 and not B0) or (B3 and B2 and not B0) or (B3 and B2 and B1);
    D <= (not B3 and not B2 and not B1 and B0) or (not B3 and B2 and not B1 and not B0) or (B2 and B1 and B0) or (B3 and not B2 and B1 and not B0);
    E <= (not B3 and B0) or (not B3 and B2 and not B1) or (not B2 and not B1 and B0);
    F <= (not B3 and not B2 and B0) or (not B3 and not B2 and B1) or (not B3 and B1 and B0) or (B3 and B2 and not B1 and B0);
    G <= (not B3 and not B2 and not B1) or (not B3 and B2 and B1 and B0) or (B3 and B2 and not B1 and not B0);
end Behavioral;