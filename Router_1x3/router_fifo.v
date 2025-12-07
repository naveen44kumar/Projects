module router_fifo(clock,resetn,soft_reset,write_enb,read_enb,lfd_state,data_in,empty,full,data_out);
    input clock,resetn,soft_reset,write_enb,read_enb,lfd_state;
    input [7:0]data_in;
    output empty,full;
    output reg [7:0]data_out;
    
    reg [8:0] mem[15:0];
    reg [4:0]wr_pointer,rd_pointer;
    reg [5:0]count;
    reg lfd_temp;
    integer i;
    
	 assign full=(wr_pointer==5'd16 && rd_pointer==5'd0)?1'b1:1'b0;
    assign empty=(wr_pointer==rd_pointer)?1'b1:1'b0;
	 
    always@(posedge clock)
        begin
            if(resetn==1'b0)
                begin
                    wr_pointer<=5'b0;       
                    for(i=0;i<16;i=i+1)
                        mem[i]<=9'b0;
                end
            else if(soft_reset)
                begin
                    for(i=0;i<16;i=i+1)
                        mem[i]<=9'b0;
                end
            else if(write_enb==1'b1&&full==1'b0)
                begin
                    mem[wr_pointer[3:0]]<={lfd_temp,data_in};
                    wr_pointer<=wr_pointer+1;
                end
        end
		  
    always@(posedge clock)
        begin
            if(resetn==1'b0)
                lfd_temp<=1'b0;
            else if(soft_reset)
                lfd_temp<=1'b0;
            else
                lfd_temp<=lfd_state;
        end
		  
		  
    always@(posedge clock)
    begin
        if(!resetn)
            begin
                rd_pointer<=0;
                data_out<=8'b0; 
            end
        
        else if(read_enb==1'b1&&empty==1'b0)
            begin
                data_out<=mem[rd_pointer[3:0]];
                rd_pointer<=rd_pointer+1;
					 
					 
            end
        else if(soft_reset)
            begin
                data_out<=8'bz;
            end
        else if(count==1'b0)begin
              data_out<=8'bz;
        end
    end
	 
	 
    always@(posedge clock)
        begin
            if(resetn==1'b0)
                begin  
                    count<=6'b0; 
                end
            else if(soft_reset)
                count<=6'b0;
            else if(read_enb==1'b1&&empty==1'b0)
                begin
                    if(mem[rd_pointer[3:0]][8]==1'b1)
                         begin  
                            count<=mem[rd_pointer[3:0]][7:2]+1'b1;  
                         end
                     else if(count!=0)
                           count<=count-1;
                end
        end
endmodule
