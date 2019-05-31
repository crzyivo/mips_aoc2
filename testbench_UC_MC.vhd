-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;
  use IEEE.std_logic_arith.all;
  use IEEE.std_logic_unsigned.all;


  ENTITY testbench_UC_MC IS
  END testbench_UC_MC;

  ARCHITECTURE behavior OF testbench_UC_MC IS 

  -- Component Declaration
  component UC_MC is
    Port ( 	clk : in  STD_LOGIC;
			reset : in  STD_LOGIC;
			RE : in  STD_LOGIC; --RE y WE son las ordenes del MIPs
			WE : in  STD_LOGIC;
			hit : in  STD_LOGIC; --se activa si hay acierto
			bus_TRDY : in  STD_LOGIC; --indica que la memoria no puede realizar la operación solicitada en este ciclo
			Bus_DevSel: in  STD_LOGIC; --indica que la memoria ha reconocido que la dirección está dentro de su rango
			MC_RE : out  STD_LOGIC; --RE y WE de la MC
            MC_WE : out  STD_LOGIC;
            MC_bus_Rd_Wr : out  STD_LOGIC; --1 para escritura en Memoria y 0 para lectura
            MC_tags_WE : out  STD_LOGIC; -- para escribir la etiqueta en la memoria de etiquetas
            palabra : out  STD_LOGIC_VECTOR (1 downto 0);--indica la palabra actual dentro de una transferencia de bloque (1ª, 2ª...)
            mux_origen: out STD_LOGIC; -- Se utiliza para elegir si el origen de la dirección y el dato es el Mips (cuando vale 0) o la UC y el bus (cuando vale 1)
            ready : out  STD_LOGIC; -- indica si podemos procesar la orden actual del MIPS en este ciclo. En caso contrario habrá que detener el MIPs
            block_addr : out  STD_LOGIC; -- indica si la dirección a enviar es la de bloque (rm) o la de palabra (w)
			MC_send_addr : out  STD_LOGIC; --ordena que se envíen la dirección y las señales de control al bus
            MC_send_data : out  STD_LOGIC; --ordena que se envíen los datos
            Frame : out  STD_LOGIC; --indica que la operación no ha terminado
			Replace_block	: out  STD_LOGIC; -- indica que se ha reemplazado un bloque
			inc_rm : out STD_LOGIC; -- indica que ha habido un fallo de lectura
			inc_wm : out STD_LOGIC; -- indica que ha habido un fallo de escritura
			inc_wh : out STD_LOGIC -- indica que ha habido un acierto de escritura
           );
end component;
		--Entradas  
     	SIGNAL clk, reset, RE, WE,hit,bus_TRDY,Bus_DevSel :  std_logic;
     	--Salidas
     	signal MC_RE,MC_WE,MC_bus_Rd_Wr,MC_tags_WE,mux_origen,ready,block_addr,MC_send_addr,MC_send_data,Frame,Replace_block,inc_rm,inc_wm,inc_wh : std_logic;
      	signal palabra : std_logic_vector (1 downto 0);
         
			           
  -- Clock period definitions
   constant CLK_period : time := 10 ns;
  BEGIN

  -- Component Instantiation
   uut: UC_MC PORT MAP(clk=> clk, reset => reset, RE => RE, WE => WE,hit=>hit,bus_TRDY=>bus_TRDY,Bus_DevSel=>Bus_DevSel,MC_RE=>MC_RE,MC_WE=>MC_WE,MC_bus_Rd_Wr=>MC_bus_Rd_Wr,
    MC_tags_WE=>MC_tags_WE,palabra=>palabra,mux_origen=>mux_origen,ready=>ready,block_addr=>block_addr,MC_send_addr=>MC_send_addr,MC_send_data=>MC_send_data,Frame=>Frame,Replace_block=>Replace_block,
    inc_rm=>inc_rm,inc_wm=>inc_wm,inc_wh=>inc_wh);

-- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;

 stim_proc: process
   begin		
      		
    	reset <= '1';
    	hit <= '0';
  	   	RE <= '0';
		WE <= '0';
		bus_TRDY <= '0';
		Bus_DevSel <= '0';
	  	wait for 20 ns;	
	  	reset <= '0';
	  	--Estado Inicio, no llega nada
	  	wait for 20 ns ;
	  	wait for clk_period;
	  	RE <= '1';
	  	hit <='1';
	  	wait for clk_period;
	  	--Hit en lectura
    	if ready = '0' then 
			wait until ready ='1'; --Este wait espera hasta que se ponga Mem_ready a uno
	  	end if;
	  	RE <= '0';
	  	hit <='0';
		wait for clk_period;
      	WE <='1';
      	hit <='1';
      	--Hit en escritura, paso al estado MD_write y se levanta MC_WE, espero a frame
	  	wait for 1 ns ;
      	if frame = '0' then 
			wait until frame ='1'; 
	  	end if;
		wait for clk_period;
		--Espero un poco a levantar Bus_DevSel
		wait for 20 ns;
		Bus_DevSel <='1';
		if MC_send_data='0' then
			wait until MC_send_data='1';
		end if;
		--Retardo en Bus_TRDY
		wait for 20 ns;
		Bus_TRDY <= '1';
		--Fin de escritura
		wait for 1 ns ;
  	   	RE <= '0';
		WE <= '0';		
		Bus_DevSel <= '0';
	  	wait for 20 ns ;
		bus_TRDY <= '0';
	  	if ready = '0' then 
			wait until ready ='1'; 
	  	end if;
	  	wait for clk_period;
	  	--El fallo en escritura funciona igual que el acierto, pero en este caso no se levanta MC_WE
	  	WE <='1';
      	hit <='0';
	  	wait for 1 ns ;
      	if frame = '0' then 
			wait until frame ='1'; 
	  	end if;
		wait for clk_period;
		--Espero un poco a levantar Bus_DevSel
		wait for 20 ns;
		Bus_DevSel <='1';
		if MC_send_data='0' then
			wait until MC_send_data='1';
		end if;
		--Retardo en Bus_TRDY
		wait for 20 ns;
		Bus_TRDY <= '1';
		--Fin de escritura
		wait for 1 ns ;
  	   	RE <= '0';
		WE <= '0';		
		Bus_DevSel <= '0';
	  	wait for 20 ns ;
		bus_TRDY <= '0';
	  	if ready = '0' then 
			wait until ready ='1'; 
	  	end if;
	  	wait for clk_period;
	  	--Fallo en lectura, paso al estado MD_read_rdy y levanto frame
	  	RE <= '1';
	  	hit <= '0';
	  	wait for 1 ns ;
	  	if Frame ='0' then
  			wait until Frame='1';
		end if;
		wait for clk_period;
		--Espero un poco a levantar Bus_DevSel
		wait for 20 ns;
		Bus_DevSel <='1';
		wait for clk_period;
		wait for 1 ns;
		bus_TRDY <= '1';
		wait for 20 ns; --Provoco un retardo en el envio del bloque
		wait for clk_period;
		bus_TRDY <= '0';
		wait for 30 ns; 
		wait for clk_period;
		bus_TRDY <='1';
		--Espero hasta el envio de la ultima palabra
		if (Replace_block='0') then
			wait until Replace_block='1';
	 	end if;
	 	--Fin de lectura
	 		  	if ready = '0' then 
			wait until ready ='1'; 
	  	end if;
	  	wait for clk_period;
	  	RE <='0';
	  	WE <='0';
	  	bus_TRDY <= '0';
	  	Bus_DevSel <='0';
   end process;
  END;
