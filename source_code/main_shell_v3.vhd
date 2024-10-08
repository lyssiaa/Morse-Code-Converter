--=============================================================================
--ENGS 31/ CoSc 56 24X
--Project: Morse
--Main shell developed by Alyssia Salas & Atziri Enriquez 
--Created 08/21/2024
---=============================================================================
--Library Declarations:
--=============================================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity main_shell is
port( 	clk_ext			:	in	std_logic;
		Rx_ext			:	in	std_logic;
		light	:	out	std_logic;
--		LED_ext_port    :   out std_logic_vector (9 downto 0);
		wave			:	out	std_logic);
end main_shell;

architecture behavior of main_shell is
------------------------------------------------------------------------------------------------
-- Components
------------------------------------------------------------------------------------------------
component SCI_Rx is
    Port (
        clk           : in STD_LOGIC;  -- 100 MHz master clock
        Rx  : in STD_LOGIC;  -- received bitstream from SCI
        Rx_data : out STD_LOGIC_VECTOR(7 downto 0);   -- output data byte after reception
        Rx_done    : out STD_LOGIC   -- indicates when a full data byte is received
    );
end component;

component lookup is
    Port (
        clk : in STD_LOGIC;
          push : in STD_LOGIC;
        ascii_input : in STD_LOGIC_VECTOR(7 downto 0); -- ASCII input
       -- translate_en : in STD_LOGIC; -- Enable translation
        morse_output : out STD_LOGIC_VECTOR(21 downto 0); -- Morse code output
        morse_length_output : out STD_LOGIC_VECTOR(4 downto 0); --Length of the Morse code
        enter_out : out STD_LOGIC
    );
end component;

component CharQueue IS
    PORT (
        clk        : in STD_LOGIC;  -- 10 MHz clock signal
        Data_in    : in STD_LOGIC_VECTOR(21 downto 0);  -- 8-bit input data
        Data_in2    : in STD_LOGIC_VECTOR(4 downto 0);  -- 8-bit input data CHECK THIS
        Push       : in STD_LOGIC;
        Pop        : in STD_LOGIC;
        Data_out   : out STD_LOGIC_VECTOR(21 downto 0); -- 8-bit output data
        Data_out2   : out STD_LOGIC_VECTOR(4 downto 0); -- 8-bit output data
        Empty      : out STD_LOGIC -- High when queue is done
    );
end component;

component transmitter IS
PORT ( 	clk			: 	in 	STD_LOGIC;
		Data_in    : 	in 	STD_LOGIC_VECTOR(21 downto 0);
		Data_in2    : in 	STD_LOGIC_VECTOR(4 downto 0);
		empty       : in  STD_LOGIC;
        New_data	:	in	STD_LOGIC;
        Pop_out : out std_logic;
        Tx			:	out STD_LOGIC);
end component;

component square_wave IS
    PORT (
        clk             : in  STD_LOGIC;   -- 10 MHz clock input
        square_wave_out : out STD_LOGIC    -- square wave output
    );
END component;


---------------------------------------------------------------------------------------------------------
-- Signals
---------------------------------------------------------------------------------------------------------

signal dataout : STD_LOGIC_VECTOR(7 downto 0);
signal datadone :  STD_LOGIC;
signal morseout : STD_LOGIC_VECTOR(21 downto 0);
signal morselength : STD_LOGIC_VECTOR(4 downto 0);
signal entered :  STD_LOGIC;
signal morsesig  : STD_LOGIC_VECTOR(21 downto 0);
signal morselengsig  : STD_LOGIC_VECTOR(4 downto 0);
signal popsig :  STD_LOGIC;
signal emptysig :  STD_LOGIC;
signal TXsig : std_logic;
signal sw_sig : std_logic;
signal middle : std_logic;
signal enterpress : std_logic;
signal sound_y_o_n : std_logic;

--------------------------------------------------------------------------------------------------------------
begin
-- Port maps
    
    
--LED_ext_port <= "00" & dataout; 
 
receiver: SCI_Rx Port map(
        clk          => clk_ext, 
        Rx  => Rx_ext,
        Rx_data => dataout,
        Rx_done    => datadone
    );

dictionary: lookup Port map(
        clk    => clk_ext, 
        push => datadone,
        ascii_input => dataout,
      --  translate_en => datadone,
        morse_output => morseout,
        morse_length_output => morselength,
        enter_out => entered
    );

queue: CharQueue Port map(
        clk        => clk_ext,  
        Data_in   => morseout,
        Data_in2  => morselength,
        Push     => datadone,
        Pop  =>    popsig,
        Data_out  => morsesig,
        Data_out2  => morselengsig,
        Empty     => emptysig
    );

SCITx : transmitter Port map(
 	    clk		   => clk_ext, 
		Data_in   => morsesig,
		Data_in2   => morselengsig,
        New_data  => enterpress,
        Pop_out  =>    popsig,
        Empty => emptysig,
        Tx	=> sound_y_o_n
        );

wavegen :  square_wave Port map(
        clk             => clk_ext,   
        square_wave_out => sw_sig
    );
    
    handle_enter: process(clk_ext)
    begin
    if rising_edge(clk_ext) then
         if middle = '0' and entered = '1' then
            enterpress <= '1';
         else 
            enterpress <= '0';
         end if;
         if entered = '1' then
             middle <= '1';
         elsif entered = '0' then
               middle <= '0';
         end if;
    end if;
    end process;
    
    datapath: process(sound_y_o_n, sw_sig) 
begin
    if sound_y_o_n = '1' then
        wave <= sw_sig;
        light <= sw_sig;  -- LED follows the square wave
    else
        wave <= '0';
        light <= '0';  -- Turn off LED when there's no sound
    end if;
end process;

    
--    datapath: process(sound_y_o_n, entered, sw_sig) 
--    begin
--    if sound_y_o_n = '1' then
--        wave <= sw_sig;
--    else
--        wave <= '0';
--    end if;
    
    
--    light <= entered;
--    end process;
    
end behavior;

