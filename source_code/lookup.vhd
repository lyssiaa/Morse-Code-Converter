--=============================================================================
--ENGS 31/ CoSc 56 24X
--Project: Morse
--Lookup developed by Alyssia Salas & Atziri Enriquez 
--Created 08/19/2024
---=============================================================================
--Library Declarations:
--=============================================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity lookup is
    Port (
        clk : in STD_LOGIC;
        push : in STD_LOGIC;
        ascii_input : in STD_LOGIC_VECTOR(7 downto 0); -- ASCII input
        morse_output : out STD_LOGIC_VECTOR(21 downto 0); -- Morse code output
        morse_length_output : out STD_LOGIC_VECTOR(4 downto 0); --Length of the Morse code
        enter_out : out STD_LOGIC
    );
end lookup;

architecture Behavioral of lookup is
    signal morse_code_i: STD_LOGIC_VECTOR(21 downto 0) := (others => '0');
    signal morse_length_i: STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
begin
    process(push)
    begin
        morse_code_i <= (others =>'0');
        morse_length_i <= (others => '0');
        enter_out <= '0';
        case ascii_input is
            -- Letters A-Z
           
            when "01000001" | "01100001" => -- A/a
                morse_code_i <= "0001011100000000000000"; -- .-
                morse_length_i <= "00100";             -- Length of 8 bits
            when "01000010" | "01100010" => -- B/b
                morse_code_i <= "0001110101010000000000"; -- -...
                morse_length_i <= "01100";             -- Length of 12 bits
            when "01000011" | "01100011" => -- C/c
                morse_code_i <= "0001110101110100000000"; -- -.-.
                morse_length_i <= "01110";             -- Length of 14 bits
            when "01000100" | "01100100" => -- D/d
                morse_code_i <= "0001110101000000000000"; -- -..
                morse_length_i <= "01010";             -- Length of 10 bits
            when "01000101" | "01100101" => -- E/e
                morse_code_i <= "0001000000000000000000"; -- .
                morse_length_i <= "00100";             -- Length of 4 bits
            when "01000110" | "01100110" => -- F/f
                morse_code_i <= "0001010111010000000000"; -- ..-.
                morse_length_i <= "01100";             -- Length of 12 bits
            when "01000111" | "01100111" => -- G/g
                morse_code_i <= "0001110111010000000000"; -- --.
                morse_length_i <= "01100";             -- Length of 12 bits
            when "01001000" | "01101000" => -- H/h
                morse_code_i <= "0001010101000000000000"; -- ....
                morse_length_i <= "01010";             -- Length of 10 bits
            when "01001001" | "01101001" => -- I/i
                morse_code_i <= "0001010000000000000000"; -- ..
                morse_length_i <= "00110";             -- Length of 6 bits
            when "01001010" | "01101010" => -- J/j
                morse_code_i <= "0001011101110111000000"; -- .---
                morse_length_i <= "10000";             -- Length of 16 bits
            when "01001011" | "01101011" => -- K/k
                morse_code_i <= "0001110101110000000000"; -- -.-
                morse_length_i <= "01100";             -- Length of 12 bits
            when "01001100" | "01101100" => -- L/l
                morse_code_i <= "0001011101010000000000"; -- .-..
                morse_length_i <= "01100";             -- Length of 12 bits
            when "01001101" | "01101101" => -- M/m
                morse_code_i <= "0001110111000000000000"; -- --
                morse_length_i <= "01010";             -- Length of 10 bits
            when "01001110" | "01101110" => -- N/n
                morse_code_i <= "0001110100000000000000"; -- -.
                morse_length_i <= "01000";             -- Length of 8 bits
            when "01001111" | "01101111" => -- O/o
                morse_code_i <= "0001110111011100000000"; -- ---
                morse_length_i <= "01110";             -- Length of 14 bits
            when "01010000" | "01110000" => -- P/p
                morse_code_i <= "0001011101110100000000"; -- .--.
                morse_length_i <= "01110";             -- Length of 14 bits
            when "01010001" | "01110001" => -- Q/q
                morse_code_i <= "0001110111010111000000"; -- --.-
                morse_length_i <= "10000";             -- Length of 16 bits
            when "01010010" | "01110010" => -- R/r
                morse_code_i <= "0001011101000000000000"; -- .-.
                morse_length_i <= "01010";             -- Length of 10 bits
            when "01010011" | "01110011" => -- S/s
                morse_code_i <= "0001010100000000000000"; -- ...
                morse_length_i <= "01000";             -- Length of 8 bits
            when "01010100" | "01110100" => -- T/t
                morse_code_i <= "0001110000000000000000"; -- -
                morse_length_i <= "00110";             -- Length of 6 bit
            when "01010101" | "01110101" => -- U/u
                morse_code_i <= "0001010111000000000000"; -- ..-
                morse_length_i <= "01010";             -- Length of 10 bits
            when "01010110" | "01110110" => -- V/v
                morse_code_i <= "0001010101110000000000"; -- ...-
                morse_length_i <= "01100";             -- Length of 12 bits
            when "01010111" | "01110111" => -- W/w
                morse_code_i <= "0001011101110000000000"; -- .--
                morse_length_i <= "01100";             -- Length of 12 bits
            when "01011000" | "01111000" => -- X/x
                morse_code_i <= "0001110101011100000000"; -- -..-
                morse_length_i <= "01110";             -- Length of 14 bits
            when "01011001" | "01111001" => -- Y/y
                morse_code_i <= "0001110101110111000000"; -- -.--
                morse_length_i <= "10000";             -- Length of 16 bits
            when "01011010" | "01111010" => -- Z/z
                morse_code_i <= "0001110111010100000000"; -- --..
                morse_length_i <= "01110";             -- Length of 14 bits

            -- Digits 0-9
            when "00110000" => -- 0
                morse_code_i <= "0001110111011101110111"; -- -----
                morse_length_i <= "10110";             -- Length of 22 bits
            when "00110001" => -- 1
                morse_code_i <= "0001011101110111011100"; -- .----
                morse_length_i <= "10011";             -- Length of 19 bits
            when "00110010" => -- 2
                morse_code_i <= "0001010111011101110000"; -- ..---
                morse_length_i <= "10010";             -- Length of 18 bits
            when "00110011" => -- 3
                morse_code_i <= "0001010101110111000000"; -- ...--
                morse_length_i <= "10000";             -- Length of 16 bits
            when "00110100" => -- 4
                morse_code_i <= "0001010101011100000000"; -- ....-
                morse_length_i <= "01110";             -- Length of 14 bits
            when "00110101" => -- 5
                morse_code_i <= "0001010101010000000000"; -- .....
                morse_length_i <= "01100";             -- Length of 12 bits
            when "00110110" => -- 6
                morse_code_i <= "0001110101010100000000"; -- -....
                morse_length_i <= "01110";             -- Length of 14 bits
            when "00110111" => -- 7
                morse_code_i <= "0001110111010101000000"; -- --...
                morse_length_i <= "10000";             -- Length of 16 bits
            when "00111000" => -- 8
                morse_code_i <= "0001110111010101010000"; -- ---..
                morse_length_i <= "10010";             -- Length of 18 bits
            when "00111001" => -- 9
                morse_code_i <= "0001110111011101110100"; -- ----.
                morse_length_i <= "10100";             -- Length of 20 bits
            when "00100000" => -- Space character
                morse_code_i <= "0000000000000000000000"; -- Singular zero for space FIXED
                morse_length_i <= "00100";             -- Length of 3
            
            -- enter 
            when "00001010" => 
               
                enter_out <= '1';
                

            when others =>
                --do nothing
        end case;
    end process;

   
        morse_output <= morse_code_i;
        morse_length_output <= morse_length_i;
            
end Behavioral;

