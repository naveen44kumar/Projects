module router_sync(
	input clock,resetn,
	input write_enb_reg,detect_add,
	input read_enb_0,read_enb_1,read_enb_2,
	input full_0,full_1,full_2,
	input empty_0,empty_1,empty_2,
	input [1:0] data_in,
	output reg [2:0] write_enb,
	output reg fifo_full,
	output vld_out_0,vld_out_1,vld_out_2,
	output reg soft_reset_0,soft_reset_1,soft_reset_2);
	
	reg [4:0]count0,count1,count2;
	wire w0=(count0==5'd29)?1'b1:1'b0;
	wire w1=(count1==5'd29)?1'b1:1'b0;
	wire w2=(count2==5'd29)?1'b1:1'b0;
	
	reg [1:0] addr;
	always @(posedge clock)
	begin
		if(resetn == 1'b0)
			addr <= 2'dz;
		else if (detect_add == 1'b1)
			addr <= data_in;
	end

	always @(*)
	begin
		if(write_enb_reg == 1'b1)
		begin
			case(addr)
				2'b00 : write_enb = 3'b001;
				2'b01 : write_enb = 3'b010;
				2'b10 : write_enb = 3'b100;
				default : write_enb = 3'b000;
			endcase
		end
		else 
			write_enb = 3'b000;
	end

	always @(*)
	begin
		case(addr)
			2'b00 : fifo_full = full_0;
			2'b01 : fifo_full = full_1;
			2'b10 : fifo_full = full_2;
			default : fifo_full = 1'b0;
		endcase
	end

	assign vld_out_0 = (~empty_0);
	assign vld_out_1 = (~empty_1);
	assign vld_out_2 = (~empty_2);

	
	always @(posedge clock)
		begin
			if(!resetn)
			begin
				count0 <= 5'd0;
				soft_reset_0 <= 1'd0;
			end
			else if (vld_out_0 == 1'b0)
			begin
				count0 <= 5'd0;
				soft_reset_0 <= 1'd0;
			end
			else if (read_enb_0 == 1'b1)
			begin
				count0 <= 5'd0;
				soft_reset_0 <= 1'd0;
			end
			else
				begin
				if(w0)
				begin
					count0 <= 5'd0;
					soft_reset_0 <= 1'b1;
				end
				else
					count0 <= count0 + 1'b1;
				end
		end

	
	always @(posedge clock)
		begin
			if(!resetn)
			begin
				count1 <= 5'd0;
				soft_reset_1 <= 1'd0;
			end
			else if (vld_out_1 == 1'b0)
			begin
				count1 <= 5'd0;
				soft_reset_1 <= 1'd0;
			end
			else if (read_enb_1== 1'b1)
			begin
				count1 <= 5'd0;
				soft_reset_1 <= 1'd0;
			end
			else
				begin
				if(w1)
				begin
					count1 <= 5'd0;
					soft_reset_1 <= 1'b1;
				end
				else
					count1 <= count1 + 1'b1;
				end
		end

	
	always @(posedge clock)
		begin
			if(resetn == 1'b0)
			begin
				count2 <= 5'd0;
				soft_reset_2 <= 1'd0;
			end
			else if (vld_out_2 == 1'b0)
			begin
				count2 <= 5'd0;
				soft_reset_2 <= 1'd0;
			end
			else if (read_enb_2 == 1'b1)
			begin
				count2 <= 5'd0;
				soft_reset_2 <= 1'd0;
			end
			else
				begin
				if(w2)
				begin
					count2 <= 5'd0;
					soft_reset_2 <= 1'b1;
				end
				else
					count2 <= count2 + 1'b1;
				end
		end

endmodule