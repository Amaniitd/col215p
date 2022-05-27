----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/23/2022 02:37:39 PM
-- Design Name: 
-- Module Name: A9 - Behavioral
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

entity A9 is
  Port ( 
    clk : in std_logic;
    sw : in std_logic_vector(15 downto 0);
    an  : out std_logic_vector (3 downto 0);
    seg : out std_logic_vector (6 downto 0);
    btnU : in std_logic;
    btnC : in std_logic;
    led: out std_logic_vector(1 downto 0)
  );
end A9;

architecture Behavioral of A9 is
    signal BRAM_PORTA_addr :  STD_LOGIC_VECTOR ( 2 downto 0 ) := "000";
    signal BRAM_PORTA_din : STD_LOGIC_VECTOR ( 15 downto 0 ) := "0000000000000000";
    signal BRAM_PORTA_dout :  STD_LOGIC_VECTOR ( 15 downto 0 ) := "0000000000000000";
    signal BRAM_PORTA_en : STD_LOGIC := '1';
    signal BRAM_PORTA_we : STD_LOGIC_VECTOR ( 0 to 0 );
    signal take_input : std_logic := '0';
    signal isFull : std_logic := '0';
    signal isEmpty : std_logic := '1';
    signal front : std_logic_vector(2 downto 0) := "000";
    signal rear : std_logic_vector(2 downto 0) := "000";
    signal take_output : std_logic := '0';
    signal data : std_logic_vector(15 downto 0):= "0000000000000000";
    signal wait_counter : std_logic_vector(1 downto 0) := "00";
    signal display_output : std_logic := '0';
    
 component BRAM_wrapper is
 port (
   BRAM_PORTA_addr : in STD_LOGIC_VECTOR ( 2 downto 0 );
   BRAM_PORTA_clk : in STD_LOGIC;
   BRAM_PORTA_din : in STD_LOGIC_VECTOR ( 15 downto 0 );
   BRAM_PORTA_dout : out STD_LOGIC_VECTOR ( 15 downto 0 );
   BRAM_PORTA_en : in STD_LOGIC;
   BRAM_PORTA_we : in STD_LOGIC_VECTOR ( 0 to 0 )
 );
 end component BRAM_wrapper;
 component seg7 is
 port(
     clk : in std_logic;
     sw : in std_logic_vector(15 downto 0);
     an  : out std_logic_vector (3 downto 0);
     seg : out std_logic_vector (6 downto 0)
 );
 end component seg7;
 component debouncer is
 port(
    clk : in std_logic;
    btn : in std_logic;
    btn_out : out std_logic
);
end component;
begin
BRAM_wrapper_1: component BRAM_wrapper
    port map (
     BRAM_PORTA_addr(2 downto 0) => BRAM_PORTA_addr(2 downto 0),
     BRAM_PORTA_clk => clk,
     BRAM_PORTA_din(15 downto 0) => BRAM_PORTA_din(15 downto 0),
     BRAM_PORTA_dout(15 downto 0) => BRAM_PORTA_dout(15 downto 0),
     BRAM_PORTA_en => BRAM_PORTA_en,
     BRAM_PORTA_we(0) => BRAM_PORTA_we(0)
   );

Seg7_1 : component seg7
    port map(
    clk => clk,
    sw(15 downto 0) => data,
    an(3 downto 0) => an(3 downto 0),
    seg(6 downto 0) => seg(6 downto 0)
    );
debouncer_1 : component debouncer
    port map(
    clk => clk,
    btn => btnU,
    btn_out => take_input
    
    );    
debouncer_2 : component debouncer
    port map(
    clk => clk,
    btn => btnC,
    btn_out => take_output
    );
    
    
   --Led update
process(clk)
begin
    if (isEmpty = '1') then
        led <= "01";
    elsif(isFull = '1') then
        led <= "10";
    else
        led <= "00";
    end if;
end process;



-- Process to handle enqueue and dequeue

-- We are taking input from rear and dequeue from the front  
process(clk)
begin
    if (rising_edge(clk)) then          
        if (display_output = '1') then
            if (wait_counter = "11") then
                data <= BRAM_PORTA_dout;
                display_output <= '0';
            else
                wait_counter <= wait_counter + 1;
            end if;
        end if;
        if (take_input = '1') then               -- Enqueue
            if (isFull = '0') then               -- Enqueue only if not full
                -- data <= sw;
                BRAM_PORTA_din <= sw;
                if (isEmpty = '1') then           -- initilizing front and rear for empty queue
                    isEmpty <= '0';
                    front <= "000";
                    rear <= "000";
                    BRAM_PORTA_addr <= "000";
                    BRAM_PORTA_we <= "1";
                else                                
                    BRAM_PORTA_addr <= rear + 1;
                    rear <= rear + 1;
                    BRAM_PORTA_we <= "1";
                end if; 
                if (front = rear + 1) then       -- Checking condition for full 
                    isFull <= '1';
                end if;
            end if;
        elsif (take_output = '1') then  -- Dequeue
            if (isEmpty = '0') then              -- Dequeue only if queue is not empty
                BRAM_PORTA_we <= "0";
                BRAM_PORTA_addr <= front;       
                display_output <= '1';
                wait_counter <= "00";
                if((front = rear) and isFull = '0') then    -- Checking empty condition
                    front <= "000";
                    rear <= "000";
                    isEmpty <= '1';
                else
                    front <= front + 1;
                end if;
            end if;
            isFull <= '0';
        end if;
    end if;
    
end process;




end Behavioral;
