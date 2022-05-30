----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/11/2022 03:25:28 PM
-- Design Name: 
-- Module Name: main - Behavioral
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
use IEEE.numeric_std.ALL;
use IEEE.std_logic_unsigned.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
Port ( clk,btn1,btn2,RsRx : in STD_LOGIC;
cathode : out STD_LOGIC_vector(6 DOWNTO 0);
an : out STD_LOGIC_VECTOR (3 downto 0);
led : out std_logic_vector(1 downto 0);
RsTx : out std_logic);
end main;

architecture Behavioral of main is
component debouncer is           --debounce
    Port(pb,clk : in std_logic;
         pb_out : out std_logic);
end component;

component digit is              --cathode
    Port (swt : in std_logic_vector(3 DOWNTO 0);
     cathode : out STD_LOGIC_vector(6 DOWNTO 0));
end component;

component clock_divider is              --cathode
    Port (clk : in std_logic;
     clk_out : out STD_LOGIC);
end component;

component BRAM_wrapper is
  port (
    BRAM_PORTA_addr : in STD_LOGIC_VECTOR ( 9 downto 0 );
    BRAM_PORTA_clk : in STD_LOGIC;
    BRAM_PORTA_din : in STD_LOGIC_VECTOR ( 7 downto 0 );
    BRAM_PORTA_dout : out STD_LOGIC_VECTOR ( 7 downto 0 );
    BRAM_PORTA_en : in STD_LOGIC;
    BRAM_PORTA_we : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
end component;

component receiver is
Port ( clk,btn1,RsRx : in STD_LOGIC;
        data : out std_logic_vector(7 downto 0);
        received : out std_logic);
end component;

component transmitter is
Port(to_send, clk, btn1 : in std_logic;    
     data : in std_logic_vector(7 DOWNTO 0);
     sent,RsTx : out std_logic);
end component;

signal dbtn1,dbtn2 : std_logic;
signal btn2_pressed : std_logic_vector(1 DOWNTO 0) := "00";
signal clk_out, bram_en, received, to_send, sent : std_logic;
signal fifo_out,fifo_in : std_logic_vector(7 DOWNTO 0) := (others => '0') ;
signal to_digit : std_logic_vector(3 DOWNTO 0);
signal bram_addr, head, tail : std_logic_vector(9 downto 0) := (others => '0');
signal write : std_logic_vector(0 downto 0) := "0";
signal clk_cnt : std_logic_vector(6 DOWNTO 0) := (others => '0');
begin

db1 : debouncer Port Map (pb => btn1, clk => clk, pb_out => dbtn1);      --reset
db2 : debouncer Port Map (pb => btn2, clk => clk, pb_out => dbtn2);
clk_div : clock_divider Port Map (clk => clk, clk_out => clk_out);
d : digit Port Map (swt => to_digit,        --first
               cathode => cathode);
bram : BRAM_wrapper Port Map (BRAM_PORTA_addr => bram_addr,
        BRAM_PORTA_clk => clk_out,
        BRAM_PORTA_din => fifo_in,
        BRAM_PORTA_dout => fifo_out,
        BRAM_PORTA_en => bram_en,
        BRAM_PORTA_we => write);
rec : receiver Port Map ( clk => clk_out, btn1 => dbtn1, RsRx => RsRx,
                data => fifo_in,
                received => received);
trans : transmitter Port Map ( to_send => to_send, clk => clk_out,    --whether sending required
                     btn1 => dbtn1, data => fifo_out,
                     sent => sent, RsTx => RsTx);


      
process(clk_out)
begin
    if(rising_edge(clk_out)) then
        if(head=tail) then
            led(0) <= '1';
        else
            led(0) <= '0';
        end if;
        if(tail=(head+1)) then
            led(1) <= '1';
        else
            led(1) <= '0';
        end if;
        if (dbtn2 = '1') then
            btn2_pressed <= "01";
        end if;
        bram_en <= '0';
        to_send <= '0';
        if(received = '1') then
            if(tail/=(head+1)) then
                btn2_pressed <= "00";
                bram_addr <= head;
                head <= head + 1;
                write(0) <= '1';
                bram_en <= '1';
            end if;
        elsif(btn2_pressed="01") then
            if(head/=tail) then
                if (sent='0') then
                    to_send <= '1';
                    bram_addr <= tail;
                    write(0) <= '0';
                    bram_en <= '1';
                else 
                    to_send <= '0';
                    tail <= tail+1;
                end if;
            else
                btn2_pressed <= "10";    
            end if;
        end if;
 
        if(clk_cnt="0110010") then
            an <= "1110";
            if(btn2_pressed="00") then
                to_digit <= fifo_in(3 DOWNTO 0);
            else
                to_digit <= fifo_out(3 DOWNTO 0);
            end if;
            clk_cnt <= "1000000";
        elsif(clk_cnt = "1110010") then
            an <= "1101";
            if(btn2_pressed="00") then
                to_digit <= fifo_in(7 DOWNTO 4);
            else
                to_digit <= fifo_out(7 DOWNTO 4);
            end if;
            clk_cnt <= "0000000";
        else
            clk_cnt <=clk_cnt+1;
        end if;
    end if;
    
    
end process;
end Behavioral;