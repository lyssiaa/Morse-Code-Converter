--=============================================================================
--ENGS 31/ CoSc 56 24X
--Project: Morse
--Transmitter developed by Alyssia Salas & Atziri Enriquez 
--Created 08/20/2024
---=============================================================================
--Library Declarations:
--=============================================================================
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY transmitter IS
    PORT (
        clk         : in  STD_LOGIC;
        Data_in     : in  STD_LOGIC_VECTOR(21 downto 0);
        Data_in2    : in  STD_LOGIC_VECTOR(4 downto 0);
        New_data    : in  STD_LOGIC;
        empty       : in  STD_LOGIC;
        Pop_out     : out std_logic;
        Tx          : out STD_LOGIC
    );
end transmitter;

ARCHITECTURE behavior of transmitter IS

    constant BAUD_PERIOD : integer := 10000000;  -- 100 MHz / 10 M = 10 ticks per sec

    signal baud_counter    : unsigned(23 downto 0) := (others => '0');
    signal shift_register  : std_logic_vector(21 downto 0) := (others => '0');
    signal baud_tc         : std_logic;
    signal baud_tc_cnt     : unsigned(4 downto 0) := (others => '0');
    signal Getting_Data    : std_logic := '0';
    signal pop             : std_logic := '0';
    signal clap : std_logic;

BEGIN

    -- Datapath process
    process(clk)
    begin
        if rising_edge(clk) then
             clap <= '0';
            if Getting_Data = '1' then
                clap <= '1';
            end if;
            Getting_Data <= '0';

            if pop = '1' then
                Getting_Data <= '1';
            end if;
            
       

            pop <= '0';

            -- Control transmitter enable based on empty signal
            if empty = '0' then
                if new_data = '1' then
                pop<= '1';
                end if;
                if New_data = '1' or clap = '1' then
                    baud_counter <= (others => '0');
                elsif baud_tc = '1' then
                    baud_counter <= (others => '0');
                else
                    baud_counter <= baud_counter + 1;
                end if;

                if New_data = '1' or clap = '1' then
                    shift_register <= Data_in;
                    baud_tc_cnt <= (others => '0');  -- Reset the counter when new data arrives
                elsif baud_tc = '1' then
                    shift_register <= shift_register(20 downto 0) & '0';
                    baud_tc_cnt <= baud_tc_cnt + 1;

                    if baud_tc_cnt = unsigned(Data_in2)-1 then
                        pop <= '1';
                    end if;
                end if;
            end if;
        end if;
    end process;

    baud_tc <= '1' when baud_counter = BAUD_PERIOD - 1 else '0';
    Pop_out <= pop;
    Tx <= shift_register(21);

end behavior;
