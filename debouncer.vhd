----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/24/2022 11:59:19 AM
-- Design Name: 
-- Module Name: debouncer - Behavioral
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
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debouncer is
  Port ( 
    clk : in std_logic;
    btn : in std_logic;
    btn_out : out std_logic
  );
end debouncer;

architecture Behavioral of debouncer is
    signal counter : std_logic_vector(23 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if (rising_edge(clk)) then
            if (counter = "000000000000000000000000") then
                btn_out <= btn;
            else
                btn_out <= '0';
            end if;
            counter <= counter + 1;
        end if;

    end process;
end Behavioral;
