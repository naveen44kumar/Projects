`timescale 1ps/1fs

module router_1x3_tb();

    reg clock, rstn;
    reg read_enb_0, read_enb_1, read_enb_2;
    reg [7:0] data_in;
    reg pkt_valid;
    wire [7:0] data_out_0, data_out_1, data_out_2;
    wire valid_out_0, valid_out_1, valid_out_2;
    wire err, busy;
    integer k;

    router_1x3 DUT (
        .clock(clock), .resetn(rstn),
        .read_enb_0(read_enb_0), .read_enb_1(read_enb_1), .read_enb_2(read_enb_2),
        .data_in(data_in), .pkt_valid(pkt_valid), 
        .data_out_0(data_out_0), .data_out_1(data_out_1), .data_out_2(data_out_2),
        .valid_out_0(valid_out_0), .valid_out_1(valid_out_1), .valid_out_2(valid_out_2),
        .err(err), .busy(busy)
    );

    initial clock = 0;
    always #5 clock = ~clock;

    task initialise;
    begin
        {rstn, read_enb_0, read_enb_1, read_enb_2, pkt_valid} = 0;
    end
    endtask

    task rst_task;
    begin
        @(negedge clock) rstn = 0;
        @(negedge clock) rstn = 1;
    end
    endtask


    task data(input [5:0] payload_len, input [1:0] addr);
        reg [7:0] payload_data, parity, header;
    begin
        @(negedge clock);
        wait(~busy);
        @(negedge clock);
        header = {payload_len, addr};
        parity = 0;
        data_in = header;
        pkt_valid = 1;
        parity = parity ^ header;

        @(negedge clock);
        wait(~busy);
        for (k = 0; k < payload_len; k = k + 1) begin
            @(negedge clock);
            wait(~busy);
            payload_data = {$random} % 256;
            data_in = payload_data;
            parity = parity ^ payload_data;
        end

        @(negedge clock);
        wait(~busy);
        pkt_valid = 0;
        data_in = parity;
    end
    endtask


    initial begin
        initialise;

        rst_task;
		  fork
        data(25, 2'b00);
			begin
				wait(valid_out_0);#200;
				read_enb_0=1;
				wait(~valid_out_0);
				read_enb_0=0;
           end
        join
        rst_task;
		  
		  fork
        data(10, 2'b10);
			begin
				wait(valid_out_2);#20;
				read_enb_2=1;
				wait(~valid_out_2);
				read_enb_2=0;
           end
        join
		 

        rst_task;
		  fork
        data(8, 2'b01);
			begin
				wait(valid_out_1);
				read_enb_1=1;
				wait(~valid_out_1);
				read_enb_1=0;
           end
        join
		  
        
        rst_task;
		  fork
        data(16, 2'b10);
			begin
				wait(valid_out_2);
				#10;
				read_enb_2=1;
				wait(~valid_out_2);
				read_enb_2=0;
           end
        join

        rst_task;
		  fork
        data(12, 2'b00);
			begin
				wait(valid_out_0);
				read_enb_0=1;
				wait(~valid_out_0);
				read_enb_0=0;
           end
        join
        

        $display("Test completed");
        $finish;
    end

endmodule
