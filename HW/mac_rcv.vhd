library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library work;
--use work.common.all;

entity mac_rcv is
   port(
      E_RX_CLK 	: in  std_logic;                      -- Receiver Clock.
      E_RX_DV  	: in  std_logic;                      -- Received Data Valid.
      E_RXD    	: in  std_logic_vector(3 downto 0);   -- Received Nibble.
      el_byte  	: out std_logic_vector(7 downto 0);   -- 
      el_addr  	: out std_logic_vector(15 downto 0);  -- 
		clkEnable	: out std_logic;
      el_dv    	: out std_logic                      -- EtherLab data valid.

   );
end mac_rcv;

architecture rtl of mac_rcv is
   
   type state_t is (
      Preamble, StartOfFrame,             -- 7 Bytes 0x55, 1 Byte 0x5d.
      MACS,                               -- 12 Byte MAC addresses.
      EtherTypeCheck,                     -- Next Protocol EtherLab?
		AddrU, AddrL,                       --  - .
      DATA,                           		-- 
		Gap,
      Notify                              -- Inform other hardware components.
   );
   
		signal 		s				: state_t:=Preamble;
      signal 		byte 			: std_logic_vector(7 downto 0):=(others => '0');   -- 
      signal 		addr 			: std_logic_vector(15 downto 0):=(others => '0');
	   signal 		c 				: integer:=0;
      signal 		a 				: integer:=0;
		--signal		clk			: std_logic:='0';
		signal		endPacket	: std_logic:='1';

begin

--el_dv <= clk and not E_RX_CLK;

   rcv_nsl : process(E_RX_CLK)
   begin

      if rising_edge(E_RX_CLK) then
         case s is

            --------------------------------------------------------------------
            -- Ethernet II - Preamble and Start Of Frame.                     --
            --------------------------------------------------------------------
            when Preamble =>
				el_dv<='0';
               if E_RXD = x"5" then
                  if c = 14 then
                     c <= 0;
                     s <= StartOfFrame;
                  else
                     c <= c + 1;
                  end if;
               else
                  c <= 0;
               end if;

            when StartOfFrame =>
				el_dv<='0';
               if E_RXD = x"d" then
                  s <= MACS;
               else
                  s <= Preamble;
               end if;

            --------------------------------------------------------------------
            -- Ethernet II - 12 Byte MAC addresses.                           --
            --------------------------------------------------------------------
            when MACS =>
				el_dv<='0';
               if c =23 then
                  c <= 0;
                  s <= EtherTypeCheck;
               else
						if c < 12 then
							if E_RXD=x"2" then
								c <= c + 1;
							else
								с <= 0;
								s<=Preamble;		-- не для платы пакет
							end if;
						end if;
						
						if c > 11 then
							c <= c + 1;
							
							if E_RXD = x"2" then
								endPacket <= '1';
							else
								endPacket <= '0';
							end if;
							
						end if;
						
               end if;

            --------------------------------------------------------------------
            -- Ethernet II -                              --
            --------------------------------------------------------------------
            when EtherTypeCheck =>
				el_dv<='0';
             --  if E_RXD = x"0" then
                  if c = 3 then
                     c <= 0;
                     s <= AddrU;
                  else
                     c <= c + 1;
                  end if;
             --  else
            --      c <= 0;
            --      s <= Preamble;
           --    end if;

            --------------------------------------------------------------------
            --  Version                                             --
            --------------------------------------------------------------------

            --------------------------------------------------------------------
            --                           --
            --------------------------------------------------------------------
             when AddrU =>
				el_dv<='0';
              addr(15 downto 8) <= E_RXD & addr(15 downto 12) ;
					--LED <= addr(15 downto 8); 							--ADDR HI
               if c = 1 then
                  c <= 0;
                  s <= AddrL;
               else
                  c <= c + 1;
               end if;

            when AddrL =>
				el_dv<='0';
					addr(7 downto 0) <= E_RXD & addr(7 downto 4) ;

					--LED <= addr(7 downto 0);								---DATA
               if c = 1 then
                  c <= 0;
						s <= DATA;
               else
                  c <= c + 1;
               end if;
					--------------------------------------------------------------------
					--                                        --
					--------------------------------------------------------------------
					when DATA =>
					el_dv<='0';
               byte(7 downto 0) <= E_RXD & byte(7 downto 4);
               if c = 1 then
                  c <= 0;
                  s <= Gap;
               else
                  c <= c + 1;
               end if;
				---------------------------------------------------------------------
				--GAP
				---------------------------------------------------------------------
				when Gap =>
					
               if c = 1 then
                  c <= 0;
						el_dv<='1';
                
							if a = 255 then		--пришло 8 байт с адресами
								a <= 0;
								s <= Notify;	
							else
								s <= AddrU;
							end if;
						a <= a + 1;
               else
						el_byte <= byte; --byte;  --r
						el_addr(7 downto 0) <= addr(7 downto 0);
						el_addr(15 downto 8) <= addr(15 downto 8);
                  c <= c + 1;
						el_dv<='0';
               end if;
            --------------------------------------------------------------------
            -- Notification                                                   --
            --------------------------------------------------------------------
            when Notify =>

					el_dv <='0';--
               s <= Preamble;
					byte <= (others=>'0');
					addr <= (others=>'0');
					el_byte <= (others=>'0');
					el_addr <= (others=>'0');
					c<=0;
					a<=0;
					
					if endPacket = '1' then
						clkEnable<='1';
					else
						clkEnable<='0';
					end if;
					
         end case;
      end if;
   end process;

end rtl;