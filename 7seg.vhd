----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/23/2022 02:07:39 PM
-- Design Name: 
-- Module Name: 7seg - Behavioral
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
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
entity seg7 is
    port (
        clk : in std_logic;
        sw : in std_logic_vector(15 downto 0);
        an  : out std_logic_vector (3 downto 0);
        seg : out std_logic_vector (6 downto 0));
end seg7;

architecture Behavioral of seg7 is

    signal LED_BCD         : std_logic_vector (3 downto 0);
    signal refresh_counter : std_logic_vector (19 downto 0) := "00000000000000000000";

    signal clk_o : std_logic_vector(1 downto 0);

begin

    process (LED_BCD)
    begin
        case LED_BCD is
            when "0000" => seg <= "1000000";
            when "0001" => seg <= "1111001";
            when "0010" => seg <= "0100100";
            when "0011" => seg <= "0110000";
            when "0100" => seg <= "0011001";
            when "0101" => seg <= "0010010";
            when "0110" => seg <= "0000010";
            when "0111" => seg <= "1111000";
            when "1000" => seg <= "0000000";
            when "1001" => seg <= "0010000";
            when "1010" => seg <= "0100000";
            when "1011" => seg <= "0000011";
            when "1100" => seg <= "1000110";
            when "1101" => seg <= "0100001";
            when "1110" => seg <= "0000110";
            when "1111" => seg <= "0001110";
            when others => seg <= "1111111";
        end case;
    end process;

    process (clk)
    begin
        if (rising_edge(clk)) then
            refresh_counter <= refresh_counter + 1;
        end if;
    end process;
    clk_o <= refresh_counter(19 downto 18);

    process (clk_o)
    begin
        case clk_o is
            when "00" =>
                an      <= "0111";
                LED_BCD <= sw(15 downto 12);
            when "01" =>
                an      <= "1011";
                LED_BCD <= sw(11 downto 8);
            when "10" =>
                an      <= "1101";
                LED_BCD <= sw(7 downto 4);
            when "11" =>
                an      <= "1110";
                LED_BCD <= sw(3 downto 0);
           when others =>                          
                an      <= "1111";
                LED_BCD <= "1111";
        end case;
    end process;

end Behavioral;
