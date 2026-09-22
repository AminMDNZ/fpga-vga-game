
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  -- ??????? ?? NUMERIC_STD ???? ????? ?????

entity VGA_Square is
    port ( CLK_24MHz		: in std_logic;
			RESET				: in std_logic;
			BtnUp          : in std_logic_vector(3 downto 0);
			end_game       : in bit;
			score          : out integer:= 0;
			lose           : out bit;
			ColorOut			: out std_logic_vector(5 downto 0); -- RED & GREEN & BLUE
			SQUAREWIDTH		: in std_logic_vector(7 downto 0);
			ScanlineX		: in std_logic_vector(10 downto 0);
			health         : out integer;    
			win            : out bit;
			ScanlineY		: in std_logic_vector(10 downto 0)
  );
end VGA_Square;

architecture Behavioral of VGA_Square is
signal heal : integer range 0 to 5 := 5; 
signal flose : bit := '0';
signal fwin : bit := '0'; 
SIGNAL P4 : BIT := '0';
SIGNAL P1 : BIT := '0';
SIGNAL P2 : BIT := '0';	   
SIGNAL P3 : BIT := '0';	   
signal time_triger : bit := '0';
  -- ????? ?????? ???
  type maze_array is array (0 to 15, 0 to 15) of std_logic;
  
  
   constant ROM1 : maze_array := (
    "0000000000000000",
    "0000000000000000",
    "0000001110000000",
    "0000001110000000",
    "0000001110000000",
    "0000001110000000",
    "0000001110000000",
    "0000001110000000",
    "1111111111111111",
    "1111111111111111",
    "1111111111111111",
    "0000001110000000",
    "0000001110000000",
    "0000001110000000",
    "0000001110000000",
    "0000001110000000"
);		 
   constant ROM2 : maze_array := (
    "0000000000000000",
    "0000000000000000",
    "0000000000000000",
    "0000000000000000",
    "0000000000000000",
    "0000000111000000",
    "0000000111000000",
    "0000000111000000",
    "0000000111000000",
    "0000000111000000",
    "0000000111000000",
    "0000000111000000",
    "0000000000000000",
    "0000000000000000",
    "0000000111000000",
    "0000000111000000"
);	
   constant ROM3 : maze_array := (
    "0000000000000000",
    "0000000000000000",
    "0000000000000000",
    "0000000000000000",
    "0000000000001110",
    "0000000000011110",
    "0000000000111100",
    "0000000001111000",
    "0000000011110000",
    "0000000111100000",
    "0000001111000000",
    "0000011110000000",
    "0000111100000000",
    "0001111000000000",
    "0001110000000000",
    "0001100000000000"
);

  
  
constant Ps11x : std_logic_vector := "1110";  -- x position of 1
constant Ps11y : std_logic_vector := "0001";  -- y position of 1

constant Ps21x : std_logic_vector := "0001";  -- x position of 1
constant Ps21y : std_logic_vector := "1110";  -- y position of 1

constant Ps31x : std_logic_vector := "1011";  -- x position of 1
constant Ps31y : std_logic_vector := "1101";  -- y position of 1

constant Ps12x : std_logic_vector := "1110";  -- x position of 1
constant Ps12y : std_logic_vector := "0001";  -- y position of 1

constant Ps22x : std_logic_vector := "0001";  -- x position of 1
constant Ps22y : std_logic_vector := "1110";  -- y position of 1

constant Ps32x : std_logic_vector := "1011";  -- x position of 1
constant Ps32y : std_logic_vector := "1101";  -- y position of 1

constant Ps13x : std_logic_vector := "1110";  -- x position of 1
constant Ps13y : std_logic_vector := "0001";  -- y position of 1

constant Ps23x : std_logic_vector := "0001";  -- x position of 1
constant Ps23y : std_logic_vector := "1110";  -- y position of 1

constant Ps33x : std_logic_vector := "1011";  -- x position of 1
constant Ps33y : std_logic_vector := "1101";  -- y position of 1

constant Ps14x : std_logic_vector := "1110";  -- x position of 1
constant Ps14y : std_logic_vector := "0010";  -- y position of 1

constant Ps24x : std_logic_vector := "0001";  -- x position of 1
constant Ps24y : std_logic_vector := "0010";  -- y position of 1

constant Ps34x : std_logic_vector := "1011";  -- x position of 1
constant Ps34y : std_logic_vector := "1100";  -- y position of 1

  -- ?????? ???? ????? ???? (???? ?? ?????)
  constant maze1 : maze_array := (
    "0011111111111111", -- ?±?¯U?U ?§UˆU„
    "1010000000000100", -- ?±?¯U?U ?¯UˆU…
    "1010111111100101", -- ?±?¯U?U ?³UˆU…
    "1000000000111101", -- ?±?¯U?U ?†U‡?§?±U…
    "1111111110100101", -- ?±?¯U?U U¾U†?¬U…
    "1000000010100101", -- ?±?¯U?U ?´?´U…
    "1011111010100101", -- ?±?¯U?U U‡U??U…
    "1010000010100001", -- ?±?¯U?U U‡?´??U…
    "1110111110101111", -- ?±?¯U?U U†U‡U…
    "1000000000100001", -- ?±?¯U?U ?¯U‡U…
    "1101111111111101", -- ?±?¯U?U U??§?²?¯U‡U…
    "1000000000000001", -- ?±?¯U?U ?¯Uˆ?§?²?¯U‡U…
    "1111111110111111", -- ?±?¯U?U ?³U??²?¯U‡U…
    "1010000000000001", -- ?±?¯U?U ?†U‡?§?±?¯U‡U…
    "1000111100111100", -- ?±?¯U?U U¾?§U†?²?¯U‡U…
    "1111111111111111"  -- ?±?¯U?U ?´?§U†?²?¯U‡U…
);

  constant maze2 : maze_array := (
"0111111111111111", 
"0000100100000001", 
"1011110111111101", 
"1010000000000101",
"1010111111100101", 
"1000000000100001", 
"1111111110111111", 
"1000000010100001",
"1011111010111101", 
"1010000000000001", 
"1010111111111111", 
"1110000000000001",
"1000111111111101", 
"1110111111101111", 
"1000000000000000", 
"1111111111111111"

  );

  constant maze3 : maze_array := (
"0011111111111111", 
"1000000000000101", 
"1011110011110101", 
"1010000010010101",
"1011111110111101", 
"1010000010000001", 
"1010111110111111", 
"1000000000000001",
"1111110111111111", 
"1000000000000001", 
"1111110111111101", 
"1000000010000001",
"1011111110111111", 
"1110000000000001", 
"1000111111111100", 
"1111111111111111"
  );

  constant maze4 : maze_array := (
"0011111111111111", 
"1000100110000001", 
"1011100111111101", 
"1000000100000101",
"1111110111110101", 
"1000000010000001", 
"1011111111111101", 
"1000000000000001",
"1111110111111111", 
"1000000000000001", 
"1111111111111101", 
"1000000000000001",
"1011111110111111", 
"1110000000000001", 
"1000111110111100", 
"1111111111111111"
  );

  -- ?????? ???? ?? ????? ????
  signal maze : maze_array := MAZE1; 
   signal pp1x : std_logic_vector(3 downto 0) := ps11x; 
   signal pp2x : std_logic_vector(3 downto 0) := ps21x; 
   signal pp3x : std_logic_vector(3 downto 0) := ps31x;  
   signal pp1y : std_logic_vector(3 downto 0) := ps11y; 
   signal pp2y : std_logic_vector(3 downto 0) := ps21y; 
   signal pp3y : std_logic_vector(3 downto 0) := ps31y; 
  -- ?????? ???? ????? ???? ?? ??????
  signal random_num : std_logic_vector(1 downto 0) := "00";

  -- ?????? ?????
  signal ColorOutput: std_logic_vector(5 downto 0);
  signal SquareX: std_logic_vector(9 downto 0) := "0000000000";  -- X position
  signal SquareY: std_logic_vector(9 downto 0) := "0000000000";  -- Y position
  constant SquareXmin: std_logic_vector(9 downto 0) := "0000000000";
  signal SquareXmax: std_logic_vector(9 downto 0) := "1110000001";  -- X max
  constant SquareYmin: std_logic_vector(9 downto 0) := "0000000000";
  signal SquareYmax: std_logic_vector(9 downto 0) := "1110000001";  -- Y max
  signal pseudo_rand: std_logic_vector(31 downto 0) :=(others => '0');
begin
  
		process(CLK_24MHz) 
  -- maximal length 32-bit xnor LFSR 
  function lfsr32(x : std_logic_vector(31 downto 0)) return std_logic_vector is 
  begin 
    return x(30 downto 0) & (x(0) xnor x(1) xnor x(21) xnor x(31)); 
  end function; 
begin 
  if rising_edge(CLK_24MHz) then 
    if reset='0' then 
      pseudo_rand <= (others => '0'); 
    else 
      pseudo_rand <= lfsr32(pseudo_rand); 
    end if; 
  end if; 
end process; 
  -- ?????? ????? ???? ?? ???? ??????? ?????
  process(CLK_24MHz, RESET)
  begin
    if RESET = '1' then
      -- ????? ?????? ?? ???? ????? ?? ????
      random_num <= pseudo_rand(16 DOWNTO 15);

      -- ????? ??? ?????? ?? ????? ??? ?????
      case random_num is
        when "00" => 
		maze <= maze1;
		pp1x <= ps11x;
		pp2x <= ps21x;
		pp3x <= ps31x;  
		pp1y <= ps11y;
		pp2y <= ps21y;
		pp3y <= ps31y;
        when "01" => 
		maze <= maze2;
         pp1x <= ps12x;
		pp2x <= ps22x;
		pp3x <= ps32x;
		pp1x <= ps12y;
		pp2x <= ps22y;
		pp3x <= ps32y;
		when "10" => 
		maze <= maze3;	
		pp1x <= ps13x;
		pp2x <= ps23x;
		pp3x <= ps33x; 
		pp1y <= ps13y;
		pp2y <= ps23y;
		pp3y <= ps33y;
        when "11" => 
		maze <= maze4;
		pp1x <= ps14x;
		pp2x <= ps24x;
		pp3x <= ps34x;
		pp1y <= ps14y;
		pp2y <= ps24y;
		pp3y <= ps34y;
        when others => 
		maze <= maze1;
		maze <= maze1;
		pp1x <= ps11x;
		pp2x <= ps21x;
		pp3x <= ps31x;  
		pp1y <= ps11y;
		pp2y <= ps21y;
		pp3y <= ps31y;
      end case;
    end if;
  end process;

process(CLK_24MHz, RESET)
    variable next_X, next_Y: std_logic_vector(9 downto 0);
    variable maze_x, maze_y: integer;
    variable maze_x2, maze_y2: integer;
    variable btn_timer: integer range 0 to 48000 := 0;  -- 0.5 second timer (24 MHz clock)
    variable BtnPressed: std_logic_vector(3 downto 0) := "0000"; -- To hold the state of button presses
    variable move_counter: integer range 0 to 12000 := 0;  -- Counter for movement speed
    constant MOVE_THRESHOLD: integer := 100;  -- Set the threshold for move speed
    variable col: integer range 0 to 12000 := 0;
	Variable SI : INTegeR;
	Variable MOVE: integer;	

	variable p3f : bit := '0';
begin
    if RESET = '1' then
        SquareX <= "0000000000";  -- Reset X position
        SquareY <= "0000000000";  -- Reset Y position
        btn_timer := 0;  -- Reset timer
        move_counter := 0;  -- Reset move counter  
        flose <= '0';
        fwin <= '0';
    elsif rising_edge(CLK_24MHz) then
        if flose = '0' and fwin = '0' then
            next_X := SquareX;
            next_Y := SquareY;

            -- Update button press timer
            if BtnUp(0) = '0' or BtnUp(1) = '0' or BtnUp(2) = '0' or BtnUp(3) = '0' then
                if btn_timer < 4800 then  -- 0.5 second = 12000 clock cycles
                    btn_timer := btn_timer + 1;
                else
                    -- Increase move counter on each clock cycle
                    move_counter := move_counter + 1;
					if(p1 = '1') then
						move := MOVE_THRESHOLD/2;
					else 
						move := MOVE_THRESHOLD;
					end if;
                    -- If move counter reaches threshold, move the square
                    if move_counter >= move then
                        -- Move the square after the counter threshold is reached
                        if BtnUp(0) = '0' and SquareY > SquareYmin then  -- Move Up
                            next_Y := std_logic_vector(unsigned(SquareY) - 1);
                        elsif BtnUp(1) = '0' and SquareY < SquareYmax then  -- Move Down
                            next_Y := std_logic_vector(unsigned(SquareY) + 1);
                        elsif BtnUp(2) = '0' and SquareX > SquareXmin then  -- Move Left
                            next_X := std_logic_vector(unsigned(SquareX) - 1);
                        elsif BtnUp(3) = '0' and SquareX < SquareXmax then  -- Move Right
                            next_X := std_logic_vector(unsigned(SquareX) + 1);
                        end if;

                        -- Reset the move counter after the move is made
                        move_counter := 0;
                    end if;

                    -- Reset the button press timer after the move
                    btn_timer := 0;  
                end if;
            else
                btn_timer := 0;  -- Reset the timer if no button is pressed
            end if;

            -- Maze collision check
            if(p1 = '1') then
				si := to_integer(unsigned(SQUAREWIDTH)/2);
			else 
				si := to_integer(unsigned(SQUAREWIDTH));
			end if;
            maze_x := to_integer(unsigned(next_X)) / 40;
            maze_y := to_integer(unsigned(next_Y)) / 30;
            maze_x2 := to_integer(unsigned(next_X) + si) / 40;
            maze_y2 := to_integer(unsigned(next_Y) + si) / 30;
			
			if (maze(maze_y, maze_x) = '0' and maze(maze_y2, maze_x2) = '0') OR (p3 = '1' AND time_triger = '0')  then
                SquareX <= next_X;
                SquareY <= next_Y;	
				
				if to_integer(unsigned(Pp1y)) = maze_y and to_integer(unsigned(Pp1x)) = maze_x  then
			  		p1 <= '1';
				else 
					p1 <= '0';
				end if;
				
                if to_integer(unsigned(Pp2y)) = maze_y and to_integer(unsigned(Pp2x)) = maze_x  then
					p2 <= '1'; 
					
				else 
					p2 <= '0';
				end if;
				
				if to_integer(unsigned(Pp3y)) = maze_y and to_integer(unsigned(Pp3x)) = maze_x  then
				
					p3 <= '1';
					p4 <= '1';
				else 
					p3 <= '0';
					p4 <= '0';
				end if ; 
				if (SquareX = "1001011010") then
                    fwin <= '1';
                else 
                    fwin <= '0';
                end if;
            else
                if col >= 40 then
                    SquareX <= "0010001000";
                    SquareY <= "0011000000";
                    heal <= heal - 1;
                    if (heal = 0) then
                        flose <= '1'; 
                    else 
                        flose <= '0';
                    end if;
                    col := 0; 
                else 
                    col := col + 1;
                end if;
            end if;
        else 
            -- Reset positions when 'flose' is active
            SquareX <= "0000000000";
            SquareY <= "0000000000";
        end if;
    end if;
end process;  -- Close the process properly


 process(CLK_24MHz, P3)
    variable counter: integer range 0 to 120000000 := 0;  
    variable TimerExpired: std_logic := '0';  
begin
    if P3 = '1' then
        counter := 0;  -- Reset the counter
        TimerExpired := '0';  -- Reset the timer signal
    elsif rising_edge(CLK_24MHz) then 
        if counter < 120000000 then
            counter := counter + 1;  -- Increment the counter
            TimerExpired := '0';  -- Timer is still running
        else
            TimerExpired := '1';  -- Timer completed
            time_triger <= '1';  -- Set P4 to indicate timer expired
        end if;
    end if;
end process;


  -- ????? ??? ? ???????
  process(ScanlineX, ScanlineY, SquareX, SquareY)
  variable maze_x, maze_y: integer;
  Variable SI : INTegeR;
  begin
    -- ????? ?????? VGA ?? ????? ???
    maze_x := to_integer(unsigned(ScanlineX)) / 40;
    maze_y := to_integer(unsigned(ScanlineY)) / 30;

    -- ????????? ??? (??????? ? ??????)
    if maze(maze_y, maze_x) = '1' then
      ColorOutput <= "001000";  -- ???? (?????)
	elsif to_integer(unsigned(pp1y)) = maze_y and to_integer(unsigned(pp1x)) = maze_x and 
     to_integer(unsigned(ScanlineX)) mod 40 < 16 and 
     to_integer(unsigned(ScanlineY)) mod 40 < 16 and
     ROM1(to_integer(unsigned(ScanlineX)) mod 40, 
          to_integer(unsigned(ScanlineY)) mod 40) = '1' then
			ColorOutput <= "001000"; 
	elsif to_integer(unsigned(pp2y)) = maze_y and to_integer(unsigned(pp2x)) = maze_x and 
     to_integer(unsigned(ScanlineX)) mod 40 < 16 and 
     to_integer(unsigned(ScanlineY)) mod 40 < 16 and
     ROM2(to_integer(unsigned(ScanlineX)) mod 40, 
          to_integer(unsigned(ScanlineY)) mod 40) = '1' then  
			ColorOutput <= "001010"; 
	elsif to_integer(unsigned(pp3y)) = maze_y and to_integer(unsigned(pp3x)) = maze_x and 
     to_integer(unsigned(ScanlineX)) mod 40 < 16 and 
     to_integer(unsigned(ScanlineY)) mod 40 < 16 and
     ROM3(to_integer(unsigned(ScanlineX)) mod 40, 
	 to_integer(unsigned(ScanlineY)) mod 40) = '1' then 
	 	ColorOutput <= "101000"; 
			ColorOutput <= "111111";	
    else
      ColorOutput <= "111111";  -- ???? (????)
    end if;
	
	if(p1 = '1') then
		si := to_integer(unsigned(SQUAREWIDTH)/2);
	else 
		si := to_integer(unsigned(SQUAREWIDTH));
	end if;
    -- ????? ??????? ????
    if (unsigned(ScanlineX) >= unsigned(SquareX)) and 
       (unsigned(ScanlineX) < unsigned(SquareX) + si) and
       (unsigned(ScanlineY) >= unsigned(SquareY)) and 
       (unsigned(ScanlineY) < unsigned(SquareY) + si) then
      ColorOutput <= "000111";  -- ????
    end if;
  end process;

  -- ????? ????? ???
  ColorOut <= ColorOutput;
  lose <= flose;
  win <= fwin;
  health <= heal;
  

end Behavioral;