----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:38:16 04/08/2014 
-- Design Name: 
-- Module Name:    memoriaRAM_I_lw_sw - Behavioral 
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

entity memoriaRAM_I_lw_sw is port (
		  CLK : in std_logic;
		  ADDR : in std_logic_vector (31 downto 0); --Dir 
        Din : in std_logic_vector (31 downto 0);--entrada de datos para el puerto de escritura
        WE : in std_logic;		-- write enable	
		  RE : in std_logic;		-- read enable		  
		  Dout : out std_logic_vector (31 downto 0));
end memoriaRAM_I_lw_sw;

architecture Behavioral of memoriaRAM_I_lw_sw is
type RamType is array(0 to 127) of std_logic_vector(31 downto 0);
--RAM test de loads y stores en cache. Primero se cargan las direcciones a usar en registros mediante la.
-- Fallo de lectura en bloque de cjto 2 del cual usaremos los datos para escrituras
-- Se realizan dos fallos en escritura que escriben BB en la palabra 0 de cjto 0 y 1
-- Se realiza un fallo de escritura que escribe F1 en la palabra 1 de un bloque de cjto 1 distinto al anterior
-- Se traen los bloques donde se ha escrito mediante 2 LW
-- Se realizan 2 aciertos de lectura en palabras distintas del mismo bloque
-- Se realizan 2 aciertos de lectura en palabras distintas de distinto bloque
-- Se realiza un acierto de escritura en la palabra 1 del cjto 1
-- Se realiza un fallo de lectura que reemplace el bloque en cjto 1 por el escrito en el 3 fallo de escritura
-- Se vuelve a reemplazar el bloque del cjto 1 por uno limpio
-- 	20010000 	 LA R1, 0(R0) //bloque cjto 0 -> X"00000001", X"00000004", X"00000008", X"0000000C"
-- 	20020010 	 LA R2, 10(R0) //bloque cjto 1[tag 0] -> X"FFFFFFFF", X"FFFFFFFF", X"FFFFFFFF", X"FFFFFFFF"
-- 	20030050 	 LA R3, 50(R0) //bloque cjto 1[tag 1] -> X"30008001", X"00000001", X"20000000", X"30002001"
-- 	20040090 	 LA R4, 90(R0) //bloque cjto 1[tag 2] -> X"00000000", X"00000000", X"00000000", X"00000002",
-- 	20050020 	 LA R5, 20(R0) //bloque cjto 2 -> X"000000BB", X"11220044", X"FFFFFFFF", X"FFFFFFFF"
-- 	200600F1 	 LA R6, F1(R0) //Dato de escritura F1
-- 	08A70000	 LW R7, 0(R5) // R7 -> BB
-- 	0C270000	 SW R7, 0(R1) //Fallo W
-- 	0C470000	 SW R7, 0(R2) //Fallo W
-- 	0C660004	 SW R6, 4(R3) //Fallo W
-- 	08270000	 LW R7, 0(R1) //Fallo R
-- 	08470000	 LW R7, 0(R2) //Fallo R
-- 	08280000	 LW R8, 0(R1) //Acierto R R8->BB
-- 	08290004	 LW R9, 4(R1) //Acierto R R9->04
-- 	082A0008	 LW R10, 8(R1) //Acierto R R10->08
-- 	084B000C	 LW R11, C(R2) //Acierto R R11->ffffffff
-- 	0C490004	 SW R9, 4(R2) //Acierto W 04 en palabra 1
-- 	086B0004	 LW R11, 4(R3) //Fallo R R11->F1
-- 	088C000C	 LW R12, C(R4) //Fallo R R12->02
signal RAM : RamType := (  			X"20010000", X"20020010", X"20030050", X"20040090", X"20050020", X"200600F1", X"08A70000", X"0C270000", -- posiciones 0,1,2,3,4,5,6,7
									X"0C470000", X"0C660004", X"08270000", X"08470000", X"08280000", X"08290004", X"082A0008", X"084B000C", --posicones 8,9,...
									X"0C490004", X"086B0004", X"088C000C", X"00000000", X"00000000", X"00000000", X"00000000", X"00000000",
									X"00010900", X"20000000", X"30004000", X"5000102D", X"01000300", X"80000400", X"10000000", X"00000000",
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
									X"20800000", X"00000004", X"00000000", X"00000004", X"00000000", X"00000000", X"20000000", X"00000004");
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


