----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/12/2022 09:23:20 AM
-- Design Name: 
-- Module Name: A6 - Behavioral
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
        an  : out std_logic_vector (3 downto 0);
        seg : out std_logic_vector (6 downto 0);
        btnU : in std_logic;
        btnC : in std_logic;
        btnD : in std_logic;
        dp : out std_logic := '0'
        );
end seg7;

architecture Behavioral of seg7 is

    signal LED_BCD         : std_logic_vector (3 downto 0);
    signal counter : std_logic_vector (19 downto 0) := "00000000000000000000";
    signal clock_counter : std_logic_vector(23 downto 0) := "000000000000000000000000";
    signal tenth_sec : std_logic_vector(3 downto 0) := "0000";
    signal sec_1 : std_logic_vector(3 downto 0) := "0000";
    signal sec_2 : std_logic_vector(3 downto 0) := "0000";
    signal min : std_logic_vector(3 downto 0) := "0000";
    signal clk_o : std_logic_vector(1 downto 0);
    signal start : std_logic := '0';

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
            when others => seg <= "1111111";
        end case;
    end process;

    process (clk)
    begin
        if (rising_edge(clk)) then
            counter <= counter + 1;
            if (btnU = '1') then 
                start <= '1';
            end if;
            if (btnC = '1') then 
                start <= '0';
            end if;
            if (btnD = '1') then
                start <= '0';
                clock_counter <= "000000000000000000000000";
                tenth_sec <= "0000";
                sec_1 <= "0000";
                sec_2 <= "0000";
                min <= "0000";
            end if;
            if (start = '1') then
                clock_counter <= clock_counter + 1;
                if (clock_counter = "100110001001011010000000") then
                    clock_counter <= "000000000000000000000000";
                    tenth_sec <= tenth_sec + 1;
                    if (tenth_sec = "1001") then
                        tenth_sec <= "0000";
                        sec_1 <= sec_1 + 1;
                        if (sec_1 = "1001") then
                            sec_1 <= "0000";
                            sec_2 <= sec_2 + 1;
                            if (sec_2 = "0101") then
                                sec_2 <= "0000";
                                min <= min + 1;
                                if (min = "1001") then 
                                    min <= "0000";
                                end if;
                            end if;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;
    clk_o <= counter(19 downto 18);

    process (clk_o)
    begin
        case clk_o is
            when "00" =>
                an      <= "0111";
                dp <= '0';
                LED_BCD <= min;
            when "01" =>
                an      <= "1011";
                dp <= '1';
                LED_BCD <= sec_2;
            when "10" =>
                an      <= "1101";
                dp <= '0';
                LED_BCD <= sec_1;
            when "11" =>
                an      <= "1110";
                dp <= '1';
                LED_BCD <= tenth_sec;
           when others =>                          
                an      <= "1111";
                dp <= '0';
                LED_BCD <= "1111";
        end case;
    end process;

end Behavioral;
