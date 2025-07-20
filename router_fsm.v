module router_fsm(
	input clock, resetn, pkt_valid, parity_done,
	input soft_reset_0, soft_reset_1, soft_reset_2,
	input fifo_full, low_pkt_valid, fifo_empty_0, fifo_empty_1, fifo_empty_2,
	input [1:0] data_in,
	output busy, detect_add, ld_state, laf_state, full_state, write_enb_reg, rst_int_reg, lfd_state
	);

	parameter decode_addr = 3'b000,
		load_first_data = 3'b001,
		load_data = 3'b010,
		LOAD_PARITY = 3'b011,
		check_parity_error = 3'b100,
		fifo_full_state = 3'b101,
		load_after_full = 3'b110,
		WAIT_TILL_EMPTY = 3'b111;
		
		
	assign detect_add = (p_s == decode_addr);
	assign ld_state = (p_s == load_data);
	assign laf_state = (p_s == load_after_full);
	assign full_state = (p_s == fifo_full_state);
	assign rst_int_reg = (p_s == check_parity_error);
	assign lfd_state = (p_s == load_first_data);
	
	assign busy = (p_s == load_first_data) || (p_s == LOAD_PARITY) || (p_s == check_parity_error) || (p_s == fifo_full_state) || (p_s == load_after_full) || (p_s == WAIT_TILL_EMPTY);
	assign write_enb_reg = (p_s == load_data) || (p_s == LOAD_PARITY) || (p_s == load_after_full);
	
	reg [2:0] p_s, n_s;
	
	reg [1:0]addr;
	always@(posedge clock)
		begin
			if(!resetn)
				addr<=0;
			else if(detect_add && pkt_valid)
				addr<=data_in;
		end
	
	wire [1:0]w1=addr;
	always @(posedge clock)
	begin
		if(!resetn)
			p_s <= decode_addr;
		else if(soft_reset_0 || soft_reset_1 || soft_reset_2)
			p_s <= decode_addr;
		else
			p_s <= n_s;
	end

	always @(*)
	begin
		n_s = decode_addr;
		case(p_s)
			decode_addr:
			begin
				if((pkt_valid && (data_in == 2'd0) && fifo_empty_0) ||
					(pkt_valid && (data_in == 2'd1) && fifo_empty_1) ||
					(pkt_valid && (data_in == 2'd2) && fifo_empty_2))
					n_s = load_first_data;
				else if ((pkt_valid && (data_in == 2'd0) && !fifo_empty_0) ||
							(pkt_valid && (data_in == 2'd1) && !fifo_empty_1) ||
							(pkt_valid && (data_in == 2'd2) && !fifo_empty_2))
					n_s = WAIT_TILL_EMPTY;
				else
					n_s = decode_addr;
			end

			load_first_data: n_s = load_data;

			load_data:
			begin
				if(!fifo_full && !pkt_valid)
					n_s = LOAD_PARITY;
				else if(fifo_full)
					n_s = fifo_full_state;
				else
					n_s = load_data;
			end

			LOAD_PARITY: n_s = check_parity_error;

			check_parity_error:
			begin
				if(!fifo_full)
					n_s = decode_addr;
				else
					n_s = fifo_full_state;
			end

			fifo_full_state:
			begin
				if(!fifo_full)
					n_s = load_after_full;
				else
					n_s = fifo_full_state;
			end

			load_after_full:
			begin
				if(!parity_done && low_pkt_valid)
					n_s = LOAD_PARITY;
				else if(parity_done)
					n_s = decode_addr;
				else if(!parity_done && !low_pkt_valid)
					n_s = load_data;
				else
					n_s = load_after_full;
			end

			WAIT_TILL_EMPTY:
			begin
				if((fifo_empty_0 && w1 == 2'd0) ||
					(fifo_empty_1 && w1 == 2'd1) ||
					(fifo_empty_2 && w1 == 2'd2))
					n_s = load_first_data;
				else
					n_s = WAIT_TILL_EMPTY;
			end

		endcase
	end

endmodule
