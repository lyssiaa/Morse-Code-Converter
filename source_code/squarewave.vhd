--=============================================================================
--ENGS 31/ CoSc 56 24X
--Project: Morse
--Square_wave developed by Alyssia Salas & Atziri Enriquez 
--Created 08/19/2024
---=============================================================================
--Library Declarations:
--=============================================================================
library IEEE;
use IEEE.std_logic_1164.all;

ENTITY square_wave IS
    PORT (
        clk             : in  STD_LOGIC;   -- 100 MHz clock input
        square_wave_out : out STD_LOGIC    -- square wave output
    );
END square_wave;

architecture behavior of square_wave is
    signal tick_counter   : integer := 0;  -- Counter for clock ticks
    signal toggle_rate    : integer := 200000;  -- Total period for 250 Hz wave
    signal wave_state     : std_logic := '0';  -- Internal signal for wave state
begin
    process (clk)
    begin
        if rising_edge(clk) then
            tick_counter <= tick_counter + 1;
            if (tick_counter = (toggle_rate / 2)) then
                wave_state <= not wave_state;  -- Toggle the wave state
            end if;
            if (tick_counter = toggle_rate) then
                tick_counter <= 0;  -- Reset the tick counter after one full period
            end if;
        end if;
    end process;

    square_wave_out <= wave_state;
end behavior;
