----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/05/2022 09:33:55 AM
-- Design Name: 
-- Module Name: A4 - Behavioral
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
    signal rotate_counter : std_logic_vector (27 downto 0):= "0000000000000000000000000000";
    signal clk_o : std_logic_vector(3 downto 0);
    signal clk_b : std_logic_vector(1 downto 0);
    signal sw_s : std_logic_vector (15 downto 0);
    signal sw_t : std_logic_vector (15 downto 0);

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
            rotate_counter <= rotate_counter + 1;
        end if;
    end process;
    clk_o <= refresh_counter(19 downto 16);
    clk_b <= rotate_counter(27 downto 26);
    
    
    process (clk_o, sw_s)
    begin 
        if (clk_o >= "0111") then
           an      <= "0111";
           LED_BCD <= sw_s(15 downto 12);
        elsif (clk_o >= "0011") then 
            an      <= "1011";
            LED_BCD <= sw_s(11 downto 8);
        elsif (clk_o >= "0001") then
            an      <= "1101";
            LED_BCD <= sw_s(7 downto 4);
        else 
            an      <= "1110";
            LED_BCD <= sw_s(3 downto 0);
        end if;
    end process;

--    process (clk_o, sw_s)
--    begin
--        case clk_o is
--            when "00" =>
--                an      <= "0111";
--                LED_BCD <= sw_s(15 downto 12);
--            when "01" =>
--                an      <= "1011";
--                LED_BCD <= sw_s(11 downto 8);
--            when "10" =>
--                an      <= "1101";
--                LED_BCD <= sw_s(7 downto 4);
--            when "11" =>
--                an      <= "1110";
--                LED_BCD <= sw_s(3 downto 0);
--           when others =>                          
--                an      <= "1111";
--                LED_BCD <= "1111";
--        end case;
--    end process;
    
    process(clk_b, sw_s, sw_t)
    begin
        if (clk_b = "00") then
            sw_t <= sw;
            sw_s <= sw;
        elsif (clk_b = "01") then 
            sw_s <= sw_t(11 downto 0) & sw_t(15 downto 12);
        elsif (clk_b = "10") then 
            sw_s <= sw_t(7 downto 0) & sw_t(15 downto 8) ;
        else
            sw_s <= sw_t(3 downto 0) & sw_t(15 downto 4) ;
        end if;
        
    end process;

end Behavioral;