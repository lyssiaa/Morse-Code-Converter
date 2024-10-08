--=============================================================================
--ENGS 31/ CoSc 56 24X
--Project: Morse
--SCI_Rx developed by Alyssia Salas & Atziri Enriquez 
--Created 08/19/2024
---=============================================================================
--Library Declarations:
--=============================================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY SCI_Rx IS
PORT ( 	clk			: 	in 	STD_LOGIC;
		Rx			: 	in 	STD_LOGIC;
        Rx_Data		:	out	STD_LOGIC_VECTOR(7 downto 0);
        Rx_Done		:	out STD_LOGIC);
end SCI_Rx;


ARCHITECTURE behavioral of SCI_Rx is

-- Signal declarations

-- shift register
signal SCI_Reg : STD_LOGIC_VECTOR(9 downto 0) := (others => '0'); --10 bits to hold start and stop bits
signal shift_en : std_logic := '0'; -- control signal to shift the next bit of data in

--bit counter
signal bit_cnt : unsigned(3 downto 0); --4 bits to count 0-9;
signal bit_cnt_en, bit_cnt_clr, bit_cnt_tc : std_logic := '0';
constant BIT_CNT_MAX : integer := 9;

--baud counter
signal baud_cnt : unsigned(14 downto 0); --
signal baud_cnt_en, baud_cnt_clr1, baud_cnt_clr2, baud_cnt_tc : std_logic := '0';
constant BAUD_CNT_MAX : integer := 10416;

-- start/stop bit checking
signal check_bits : std_logic;

-- FSM
type state_type is (idle, wait_for_bit1, shift, done);
signal cs,ns : state_type := idle;


BEGIN
Rx_Data <= SCI_Reg(8 downto 1); --hardwired so that the data is always present. Data should only be used when RX_Done goes high.

-- Finite state machine
state_update : process(clk)
begin
	if rising_edge(clk) then
    	cs <= ns;
    end if;
end process state_update;

ns_logic : process(cs, Rx, baud_cnt_tc, bit_cnt_tc)
begin
	baud_cnt_clr1 <= '0';
	baud_cnt_clr2 <= '0';
    baud_cnt_en <= '0';
    bit_cnt_clr <= '0';
    bit_cnt_en <= '0';
    shift_en <= '0';
    check_bits <= '0';
    
    ns <= cs;
    
    case cs is
    	
        when idle =>
       		baud_cnt_clr1 <= '1';
        	bit_cnt_clr <= '1';
        	if Rx = '0' then
            	ns <= wait_for_bit1;
            end if;
        when wait_for_bit1 =>
        	baud_cnt_en <= '1';
            if baud_cnt_tc = '1' then
            	ns <= shift;
            end if;
        when shift =>
        	shift_en <= '1';
            bit_cnt_en <= '1';
            baud_cnt_clr2 <= '1';
            if bit_cnt_tc = '1' then
            	ns <= done;
            else
            	ns <= wait_for_bit1;
            end if;
        when done =>
        	Check_bits <= '1';
            ns <= idle;
        when others => 
        	ns <= idle;
    end case;
end process ns_logic;

--Datapath

datapath : process(clk, baud_cnt, bit_cnt, SCI_Reg, check_bits)
begin
	-- Baud Counter
	if rising_edge(clk) then
    	if baud_cnt_clr2 = '1' then
        	baud_cnt <= (others => '0');
        elsif baud_cnt_clr1 = '1' then
            baud_cnt <= "001010001011000";
        elsif baud_cnt_en = '1' then
        	baud_cnt <= baud_cnt + 1;
        end if;
    end if;
    
    baud_cnt_tc <= '0';
    if baud_cnt = BAUD_CNT_MAX then
    	baud_cnt_tc <= '1';
    end if;
    
    -- Bit Counter
	if rising_edge(clk) then
    	if bit_cnt_clr = '1' then
        	bit_cnt <= (others => '0');
        elsif bit_cnt_en = '1' then
        	bit_cnt <= bit_cnt + 1;
        end if;
    end if;
    
    bit_cnt_tc <= '0';
    if bit_cnt = BIT_CNT_MAX then
    	bit_cnt_tc <= '1';
    end if;
    
    
    -- Shift Register
    if rising_edge(clk) then
    	if shift_en = '1' then
        	SCI_Reg <= Rx & SCI_Reg(9 downto 1);
        end if;
    end if;
    
    
    
    -- Start/stop bit checking
    RX_Done <= check_bits AND(SCI_Reg(9) AND NOT(SCI_Reg(0)));
    
end process datapath;

end behavioral;
