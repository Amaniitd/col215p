-- Testbench for 7 segment
library IEEE;
use IEEE.std_logic_1164.all;
 
entity testbench is
-- empty
end testbench; 

architecture tb of testbench is

-- DUT component
component bcd_7seg is
Port ( B0,B1,B2,B3 : in STD_LOGIC;
A,B,C,D,E,F,G : out STD_LOGIC);
end component;

signal B0_i,B1_i,B2_i,B3_i, A_o,B_o,C_o,D_o,E_o,F_o,G_o: std_logic;

begin

  -- Connect DUT
  DUT: bcd_7seg port map(B0_i,B1_i,B2_i,B3_i,A_o,B_o,C_o,D_o,E_o,F_o,G_o);

  process
  begin
    B3_i <= '0';
    B2_i <= '0';
    B1_i <= '0';
    B0_i <= '0';
    wait for 1 ns;
    assert(A_o='0' and B_o='0' and C_o='0' and D_o='0' and E_o='0' and F_o='0' and G_o='1') report "Fail 0/16" severity error;
    
    B3_i <= '0';
    B2_i <= '0';
    B1_i <= '0';
    B0_i <= '1';
    wait for 1 ns;
    assert(A_o='1' and B_o='0' and C_o='0' and D_o='1' and E_o='1' and F_o='1' and G_o='1') report "Fail 1/16" severity error;
    
    B3_i <= '0';
    B2_i <= '0';
    B1_i <= '1';
    B0_i <= '0';
    wait for 1 ns;
    assert(A_o='0' and B_o='0' and C_o='1' and D_o='0' and E_o='0' and F_o='1' and G_o='0') report "Fail 2/16" severity error;
    
    B3_i <= '0';
    B2_i <= '0';
    B1_i <= '1';
    B0_i <= '1';
    wait for 1 ns;
    assert(A_o='0' and B_o='0' and C_o='0' and D_o='0' and E_o='1' and F_o='1' and G_o='0') report "Fail 3/16" severity error;

    B3_i <= '0';
    B2_i <= '1';
    B1_i <= '0';
    B0_i <= '0';
    wait for 1 ns;
    assert(A_o='1' and B_o='0' and C_o='0' and D_o='1' and E_o='1' and F_o='0' and G_o='0') report "Fail 4/16" severity error;
    
    B3_i <= '0';
    B2_i <= '1';
    B1_i <= '0';
    B0_i <= '1';
    wait for 1 ns;
    assert(A_o='0' and B_o='1' and C_o='0' and D_o='0' and E_o='1' and F_o='0' and G_o='0') report "Fail 5/16" severity error;
    
    B3_i <= '0';
    B2_i <= '1';
    B1_i <= '1';
    B0_i <= '0';
    wait for 1 ns;
    assert(A_o='0' and B_o='1' and C_o='0' and D_o='0' and E_o='0' and F_o='0' and G_o='0') report "Fail 6/16" severity error;
   
    B3_i <= '0';
    B2_i <= '1';
    B1_i <= '1';
    B0_i <= '1';
    wait for 1 ns;
    assert(A_o='0' and B_o='0' and C_o='0' and D_o='1' and E_o='1' and F_o='1' and G_o='1') report "Fail 7/16" severity error;
    
    B3_i <= '1';
    B2_i <= '0';
    B1_i <= '0';
    B0_i <= '0';
    wait for 1 ns;
    assert(A_o='0' and B_o='0' and C_o='0' and D_o='0' and E_o='0' and F_o='0' and G_o='0') report "Fail 8/16" severity error;

    B3_i <= '1';
    B2_i <= '0';
    B1_i <= '0';
    B0_i <= '1';
    wait for 1 ns;
    assert(A_o='0' and B_o='0' and C_o='0' and D_o='1' and E_o='1' and F_o='0' and G_o='0') report "Fail 9/16" severity error;
    
    B3_i <= '1';
    B2_i <= '0';
    B1_i <= '1';
    B0_i <= '0';
    wait for 1 ns;
    assert(A_o='0' and B_o='0' and C_o='0' and D_o='1' and E_o='0' and F_o='0' and G_o='0') report "Fail 10/16" severity error;
    
    B3_i <= '1';
    B2_i <= '0';
    B1_i <= '1';
    B0_i <= '1';
    wait for 1 ns;
    assert(A_o='1' and B_o='1' and C_o='0' and D_o='0' and E_o='0' and F_o='0' and G_o='0') report "Fail 11/16" severity error;
    
    B3_i <= '1';
    B2_i <= '1';
    B1_i <= '0';
    B0_i <= '0';
    wait for 1 ns;
    assert(A_o='0' and B_o='1' and C_o='1' and D_o='0' and E_o='0' and F_o='0' and G_o='1') report "Fail 12/16" severity error;
    
    B3_i <= '1';
    B2_i <= '1';
    B1_i <= '0';
    B0_i <= '1';
    wait for 1 ns;
    assert(A_o='1' and B_o='0' and C_o='0' and D_o='0' and E_o='0' and F_o='1' and G_o='0') report "Fail 13/16" severity error;
    
    B3_i <= '1';
    B2_i <= '1';
    B1_i <= '1';
    B0_i <= '0';
    wait for 1 ns;
    assert(A_o='0' and B_o='1' and C_o='1' and D_o='0' and E_o='0' and F_o='0' and G_o='0') report "Fail 14/16" severity error;
    
    B3_i <= '1';
    B2_i <= '1';
    B1_i <= '1';
    B0_i <= '1';
    wait for 1 ns;
    assert(A_o='0' and B_o='1' and C_o='1' and D_o='1' and E_o='0' and F_o='0' and G_o='0') report "Fail 15/16" severity error;
    
    assert false report "Test done." severity note;
    wait;
  end process;
end tb;