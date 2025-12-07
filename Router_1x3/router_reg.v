module router_reg(
	input clock, resetn,
	input pkt_valid, fifo_full, rst_int_reg, detect_add, ld_state, laf_state, full_state, lfd_state,
	input [7:0] data_in,
	output reg parity_done, low_pkt_valid, err,
	output reg [7:0] dout
	);

	reg [7:0] header_reg;
	reg [7:0] fifo_full_reg;
	reg [7:0] packet_parity_reg;
	reg [7:0] internal_parity_reg;


	always @(posedge clock)
	begin
		if(!resetn)
			header_reg <= 0;
			
		else if(detect_add && pkt_valid)
			header_reg <= data_in;
	end

	always @(posedge clock)
	begin
		if(!resetn)
			internal_parity_reg <= 0;
		else if(detect_add)
			internal_parity_reg <= 0;
		else if (lfd_state)
			internal_parity_reg <= internal_parity_reg ^ header_reg;
		else if (pkt_valid && ld_state && !full_state)
			internal_parity_reg <= internal_parity_reg ^ data_in;
	end

	always @(posedge clock)
	begin
		if(!resetn)
			packet_parity_reg <= 0;
		else if(detect_add)
			packet_parity_reg <= 0;
		else if (ld_state && !pkt_valid)
			packet_parity_reg <= data_in;
	end

	always@(posedge clock)
	begin
		if(!resetn)
		begin
			dout <= 0;
			fifo_full_reg <= 0;
		end
		else if(detect_add && pkt_valid)
			dout <= dout;
		else if (ld_state && !fifo_full)
			dout <= data_in;
		else if (ld_state && fifo_full)
			fifo_full_reg <= data_in;
		else if(lfd_state)
			dout <= header_reg;
		else if (laf_state)
			dout <= fifo_full_reg;
	end

	always @(posedge clock)
	begin
		if(!resetn)
			parity_done <= 0;
		else if(detect_add)
			parity_done <= 0;
		else if ((ld_state && !fifo_full && !pkt_valid) || (laf_state && low_pkt_valid && !parity_done))
			parity_done <= 1;
	end

	always @(posedge clock)
	begin
		if (!resetn)
			low_pkt_valid <= 0;
		else if (ld_state && !pkt_valid)
			low_pkt_valid <= 1;
		else if (rst_int_reg)
			low_pkt_valid <= 0;
		else 
			low_pkt_valid <= 0;
	end
	
	
	always @(posedge clock)
	begin
		if(!resetn)
			err <= 0;
		else if ((packet_parity_reg != internal_parity_reg) && parity_done)
			err <= 1;
		else 
			err <= 0;
	end

endmodule
