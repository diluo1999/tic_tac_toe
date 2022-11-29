--=============================================================================
--ENGS 31/ CoSc 56
--Final Project: Tic-tac-toe in VGA
--VGA driver
--Implemented based on template: https://www.edaplayground.com/x/6Lwd
--Instructors: Ben Dobbins, Tad Truex
--Student name: Di Luo
--=============================================================================

--=============================================================================
--Library Declarations:
--=============================================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.math_real.all;
library UNISIM;
use UNISIM.VComponents.all;

--=============================================================================
--Entity Declaration:
--=============================================================================
ENTITY VGA_driver IS
PORT ( 	vclk_port       :	in	STD_LOGIC;  -- 25 MHz clock
		Vsync_port      : 	out	STD_LOGIC;  -- vertial sync signal to VGA monitor
		Hsync_port      : 	out	STD_LOGIC;  -- horizontal sync signal to VGA monitor
        video_on_port   :	out	STD_LOGIC;  -- accomplish blanking. 1 when inside display area. 0 when outside display area 
		pixel_x_port	:	out	STD_LOGIC_VECTOR(9 downto 0);   -- current pixel's x coordinate
        pixel_y_port	:	out	STD_LOGIC_VECTOR(9 downto 0));  -- current pixel's y coordinate
end VGA_driver;

--=============================================================================
--Architecture Type:
--=============================================================================   
architecture behavior of VGA_driver is
--=============================================================================
--Signal Declarations: 
--=============================================================================
signal H_video_on 	: STD_LOGIC := '0';
signal V_video_on 	: STD_LOGIC := '0';
--Add your signals here
signal h_counter    : unsigned(9 downto 0) := (others => '0');  -- horizontal counter
signal v_counter    : unsigned(9 downto 0) := (others => '0');  -- vertical counter

--VGA Constants (taken directly from VGA Class Notes)
constant left_border 	: integer := 48;  	-- back porch
constant h_display 		: integer := 640;	-- active image
constant right_border 	: integer := 16;	-- front porch
constant h_retrace 		: integer := 96;	-- Hsync pulse width
constant HSCAN 			: integer := left_border + h_display 
							+ right_border + h_retrace; -- =800

constant top_border 	: integer := 29;	-- 29
constant v_display 		: integer := 480;	-- active image
constant bottom_border 	: integer := 10;	-- 10
constant v_retrace 		: integer := 2;		-- Vsync pulse width
constant VSCAN 			: integer := top_border + v_display 
							+ bottom_border + v_retrace; -- =521
                            
BEGIN

--=============================================================================
--Processes: 
--=============================================================================
-- Horizontal counter generating process
h_counter_proc : process(vclk_port)
begin
    if rising_edge(vclk_port) then
        -- counter increments every clk cycle
        if (h_counter < HSCAN - 1) then
            h_counter <= h_counter + 1;
        else
            h_counter <= (others => '0');
        end if;
    end if;
end process h_counter_proc;

-- H_video_on generating process
H_video_on_proc : process(h_counter)
begin
    -- H_video_on is asserted only in the active display area (left-to-right)
    if (h_counter < h_display) then
        H_video_on <= '1';
    else
        H_video_on <= '0';
    end if;
end process H_video_on_proc;

-- Hsync generating process
Hsync_proc : process(h_counter)
begin
    -- Hsync is high except for retracing
    if (h_counter >= h_display + right_border) and (h_counter < h_display + right_border + h_retrace) then
        Hsync_port <= '0';
    else
        Hsync_port <= '1';
    end if;
end process Hsync_proc;

-- Vertical counter generating process
v_counter_proc : process(vclk_port)
begin
    if rising_edge(vclk_port) then
        -- counter increments every time Hsync is asserted
        if (h_counter = h_display + right_border - 1) then
            if (v_counter < VSCAN - 1) then
                v_counter <= v_counter + 1;
            else
                v_counter <= (others => '0');
            end if;
        end if;
    end if;
end process v_counter_proc;

-- V_video_on generating process
V_video_on_proc : process(v_counter)
begin
    -- V_video_on is asserted only in the active display area (top-to-bottom)
    if (v_counter < v_display) then
        V_video_on <= '1';
    else
        V_video_on <= '0';
    end if;
end process V_video_on_proc;

-- Vsync generating process
Vsync_proc : process(v_counter)
begin
    -- Vsync is high except for retracing
    if (v_counter >= v_display + bottom_border) and (v_counter < v_display + bottom_border + v_retrace) then
        Vsync_port <= '0';
    else
        Vsync_port <= '1';
    end if;
end process Vsync_proc;

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--Output Mapping:
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Only enable video out , when H_video_out and V_video_out are high. 
-- It's important to set the output to zero when you aren't actively displaying video. 
-- That's how the monitor determines the black level.
video_on_port <= H_video_on and V_video_on;
pixel_x_port <= std_logic_vector(h_counter);
pixel_y_port <= std_logic_vector(v_counter);

end behavior;
