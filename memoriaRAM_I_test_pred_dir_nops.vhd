----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:38:16 04/08/2014 
-- Design Name: 
-- Module Name:    memoriaRAM_I_pred_dir_nops - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity memoriaRAM_I_pred_dir_nops is port (
		  CLK : in std_logic;
		  ADDR : in std_logic_vector (31 downto 0); --Dir 
        Din : in std_logic_vector (31 downto 0);--entrada de datos para el puerto de escritura
        WE : in std_logic;		-- write enable	
		  RE : in std_logic;		-- read enable		  
		  Dout : out std_logic_vector (31 downto 0));
end memoriaRAM_I_pred_dir_nops;

architecture Behavioral of memoriaRAM_I_pred_dir_nops is
type RamType is array(0 to 127) of std_logic_vector(31 downto 0);
--RAM test prediccion, Funciona igual que test_pred_sentido, pero ahora el error es de direccion en todas las iteraciones del bucle.
-- Puesto que solo se usan 7 bits del PC para direccionar la memoria de instrucciones, saltamos a una direccion que implica tener la misma etiqueta en el predictor
-- pero direcciones completamente diferentes, aunque esten leyendo la misma instruccion.
-- En el primer BNE se salta a pc 42C, que sigue direccionando la segunda instruccion, y cuyo tag es el mismo que el almacenado en predictor.
-- Comprueba el fallo de prediccion de direccion
-- 	20210005 	LA R1, 4(R0)
-- 	08020000	LW R2, 0(R0) //dir1
-- 	08050004	LW R5, 4(R0)
--  00000000	nop
-- 	00000000	nop
-- 	04451800	ADD R3, R2,R5
-- 	00000000	nop
-- 	00000000	nop
-- 	0C030004	SW  R3, 4(R0)
-- 	146100F7	BNE R3,R1, dir1
-- 	0C030008	SW  R3, 8(R0)
signal RAM : RamType := (  			X"20210005", X"08020000", X"08050004", X"00000000", X"00000000", X"04451800", X"00000000", X"00000000", -- posiciones 0,1,2,3,4,5,6,7
									X"0C030004", X"146100F7", X"0C030008", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", --posicones 8,9,...
									X"20000000", X"20000000", X"30018001", X"02AD6093", X"30008001", X"00000001", X"20000000", X"30002001", --16-21
									X"00010900", X"20000000", X"30004000", X"5000102D", X"01000300", X"80000400", X"10000000", X"00000000", --22-29
									X"00002000", X"00000000", X"00000000", X"00000002", X"00000000", X"00000000", X"00000000", X"00000002", 
									X"00000000", X"00000002", X"00001200", X"00000000", X"00000000", X"00000002", X"00000000", X"00000002",
									X"000006AD", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
									X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00100000", X"00000000", X"00000000",
									X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"02000000", X"08010000", X"00000000",
									X"00000000", X"00000000", X"00000010", X"00000000", X"00000000", X"00000000", X"00000002", X"00200000",
									X"00000000", X"20080001", X"00000000", X"00000000", X"00000800", X"40000000", X"00000000", X"00000000",
									X"00000000", X"000009C2", X"00000000", X"00000000", X"00000800", X"00000000", X"00080800", X"00000000",
									X"00080000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
									X"00002000", X"00400000", X"00080000", X"00000000", X"00080000", X"00000000", X"50000000", X"00000001",
									X"40020000", X"00000000", X"00000000", X"40000000", X"00000000", X"00000004", X"00000800", X"00800004",
									X"20800000", X"00000004", X"00000000", X"00000004", X"00000000", X"00000000", X"20000000", X"00000004"); --119-127
						
signal dir_7:  std_logic_vector(6 downto 0); 
begin
 
 dir_7 <= ADDR(8 downto 2); -- como la memoria es de 128 plalabras no usamos la dirección completa sino sólo 7 bits. Como se direccionan los bytes, pero damos palabras no usamos los 2 bits menos significativos
 process (CLK)
    begin
        if (CLK'event and CLK = '1') then
            if (WE = '1') then -- sólo se escribe si WE vale 1
                RAM(conv_integer(dir_7)) <= Din;
            end if;
        end if;
    end process;

    Dout <= RAM(conv_integer(dir_7)) when (RE='1') else "00000000000000000000000000000000"; --sólo se lee si RE vale 1

end Behavioral;


