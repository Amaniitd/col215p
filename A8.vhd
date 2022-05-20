----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/20/2022 01:54:03 PM
-- Design Name: 
-- Module Name: A8 - Behavioral
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
entity A8 is
    port (
        clk : in std_logic;
        rst_btn : in std_logic;
        RsRx : in std_logic;
        seg : out std_logic_vector(6 downto 0);
        an : out std_logic_vector(3 downto 0);
        RsTx : out std_logic := '1'
        );
end A8;

architecture Behavioral of A8 is
    signal counter1 : std_logic_vector(8 downto 0) := "000000000";
    signal clock_new : std_logic :='0';                                 -- Custom clock of freq 9600*16
    signal validity : std_logic_vector(3 downto 0):= "0000";
    signal isActive : std_logic := '0';                                 -- not Active means -> idle state
    signal rec : std_logic_vector(7 downto 0) := "00000000";           -- received values
    signal rec_index :  integer range 0 to 7 := 0;
    signal LED_BCD: std_logic_vector(3 downto 0):= "0000";
    signal trans_status : std_logic := '0';
    signal to_send : std_logic_vector(7 downto 0) := "00000000";
    signal to_send_index: integer range 0 to 7 := 0;
    signal send_stp : std_logic := '0';
    signal send_zero : std_logic := '0';
    signal counter2 : std_logic_vector(3 downto 0) := "0000";
    signal rec_stp : std_logic := '0';
    signal received : std_logic := '0';
begin

                  -- Creating the counter
    process(clk)
    begin
    if (rising_edge(clk)) then
        if (counter1 = "101000101") then
            if (clock_new = '0') then
                clock_new <='1';
            else
                clock_new <= '0';
            end if;
            counter1 <= "000000000";
        else
            counter1 <= counter1 + 1;
        end if;
    end if;
    end process;
    
    -- Reading input
    
    process(clock_new)
    begin
    if (rising_edge(clock_new)) then
        received <= '0';
        if (isActive = '0') then   --idle state
            if (RsRx = '0') then
                if (validity = "0111") then  -- checking for 8 cont. '0'
                    validity <= "1000";
                    isActive <= '1';         -- if 8 '0's then -> active state
                else
                    validity <= validity + 1;
                end if;
            else
                validity <= "0000";
            end if;
        elsif (rec_stp = '0') then
            if (validity = "0111") then
                --take input
                rec(rec_index) <= RsRx;
                validity <= validity + 1;
                if (rec_index = 7) then -- if 8 bit received then go to stop state -> inactive state
                    rec_index <= 0;
                    rec_stp <= '1';
                    validity <= "0000";
                else
                    rec_index <= rec_index + 1;
                end if;
            elsif (validity = "1111") then
                validity <= "0000";
                
            else
                validity <= validity + 1;
            end if;
            if (rst_btn = '1') then  -- if reset button is pressed -> go to idle state
                isActive <= '0'; 
            end if;
        else                         -- stop state
            if (validity = "1111") then
                validity <= "0000";
                rec_stp <= '0';
                isActive <= '0';
                received <= '1';
            else
                validity <= validity + 1;
            end if;
        end if;
    end if;
    end process;
    
    --Seven Segment
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

    process(clock_new)
    begin
        if (clock_new = '1') then
            an <= "1011";
            LED_BCD <= rec(3 downto 0);
        else
            an <= "0111";
            LED_BCD <= rec(7 downto 4);
        end if;
    end process;


    --Sending back signal:-
    process(clock_new)
    begin
    if (rising_edge(clock_new)) then
        if (received = '1') then
            counter2 <= "1111";
            trans_status <= '1';
            send_zero <= '1';
            send_stp <= '0';
            to_send <= rec;
            to_send_index <= 0;
        end if;
        if (counter2 = "1111") then
            if (trans_status = '1') then
                if(send_stp = '1') then
                    RsTx <= '1';
                    send_stp <= '0';
                    trans_status <= '0';
                elsif (send_zero = '1') then
                    RsTx <= '0';
                    send_zero <= '0';
                else
                    RsTx <= to_send(to_send_index);
                    if(to_send_index = 7) then
                        to_send_index <= 0;
                        send_stp <= '1';
                    else
                        to_send_index <= to_send_index + 1;
                    end if; 
                end if;
            end if;
        end if;
        counter2 <= counter2 + 1;
    end if;
    end process;
    
    

end Behavioral;

