library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LedController is
  Port
  (
    Clock    : in  std_logic;
    Switches : in  std_logic_vector ( 7 downto 0);
    Leds_Ext : out std_logic_vector ( 3 downto 0)
  );
end;

architecture Behavioral of LedController is

  constant Pwm_Off  : std_logic := '0'; -- trivial 0 constant - 50k Hz Period
  constant Pwm_On   : std_logic := '1'; -- trivial 1 constant - 50k Hz Period
  signal   Pwm_Half : std_logic;        -- non trivial pwm    - 50k Hz Period

  signal   Count          : unsigned( 9 downto 0) := "0000000000";
  constant Bound          : unsigned( 9 downto 0) := "1111101000"; -- 1000
  constant Pwm_Half_Bound : unsigned( 9 downto 0) := Bound/2;      -- 500

begin

  -- non trivial pwm
  Pwm_Half <= '0' when (Count < unsigned(Pwm_Half_Bound))  else '1';

  -- led update

  Leds_Ext(0) <=       Pwm_Half when Switches = "10------" else
                       Pwm_On   when Switches = "11------" else
                   not Pwm_Half when Switches = "01------" else
                       Pwm_Off ;

  Leds_Ext(1) <=       Pwm_Half when Switches = "--10----" else
                       Pwm_On   when Switches = "--11----" else
                       Pwm_Half when Switches = "--01----" else
                       Pwm_Off ;

  Leds_Ext(2) <=      Pwm_Half when Switches = "----10--" else
                      Pwm_On   when Switches = "----11--" else
                  not Pwm_Half when Switches = "----01--" else
                      Pwm_Off ;

  Leds_Ext(3) <=      Pwm_Half when Switches = "------10" else
                      Pwm_On   when Switches = "------11" else
                      Pwm_Half when Switches = "------01" else
                      Pwm_Off ;

  -- clockdiv
  process (Clock)
  begin
    if rising_edge (Clock) then

      if (Count = (Bound-1)) then
        Count <= "0000000000";
      else
        Count <= Count + 1;
      end if;

    end if;
  end process;

end;
