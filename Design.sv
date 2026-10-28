
module counter_enable (
  output logic [3:0] count, 
  input logic clk,
  input logic reset,
  input logic enable,
  input logic [3:0] load,
  input logic load_in,
  input logic down
);
  
  always_ff @(posedge clk or posedge reset) begin 
    if (reset) begin 
      count <= 4'b0000;
    end
    else if (load_in) begin
      count <= load;          
    end
    else if (enable) begin
      if (down) 
        count <= count - 1'b1;
      else 
        count <= count + 1'b1;
    end
    
  end
  
endmodule

module reg4 (
  input logic [3:0] D,
  output logic [3:0] Q,
  input logic reset,
  input logic clk
);
  
  always_ff @(posedge clk or posedge reset) begin
    
    if(reset)
      Q <= 0;
    else
      Q <= D;
    
  end
  
endmodule


module counter_reg (
  
  output logic [3:0] count_result,
  input logic clk,
  input logic reset,
  input logic enable,
  input logic [3:0] load,
  input logic load_in,
  input logic down
	
);
  
  logic [3:0] count;
  
  counter_enable counter (
    .count(count),
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .load(load),
    .load_in(load_in),
    .down(down)
  );
  
  reg4 regester (
    .D(count),
    .Q(count_result),
    .reset(reset),
    .clk(clk)
  );
    
  
endmodule


module ALU (
  input logic [7:0] A,B , 
  input logic [1:0] op_code,
  input logic enable,
  input logic carry_in,
  output logic [7:0] result,
  output logic zero_f
);
  
  
  always_comb begin
    result = 8'd0;
    if(enable) begin 
      case(op_code)
        2'b00 : result = A + B + carry_in;
        2'b01 : result = A - B;
        2'b10 : result = A & B;
        2'b11 : result = A ^ B;
		default : result = 0;
      endcase
    end
     zero_f = (result == 0);
  end
endmodule


module Register_8bit (
  input logic [7:0] D,
  output logic [7:0] Q,Q_not,
  input logic reset,
  input logic clk,
  input logic write_enable
);
 
  always_ff @(posedge clk or posedge reset) begin 
    
    if(reset) begin
       Q <= 8'b00000000;
    end
    else begin
      if(write_enable)
      Q <= D;
    end
  end
  assign Q_not = ~Q;
endmodule

module Register_File_4x8 (
  input logic write_enable,
  input logic clk,
  input logic reset,
  
  input logic [1:0] write_addr,
  input logic [7:0] write_data,
  
  input logic [1:0] read_addr1,read_addr2,
  output logic [7:0] read_data1, read_data2
);
  
  logic [3:0] reg_en;
  logic [7:0] reg1_data, reg2_data, reg3_data, reg4_data;
  
  //write_decoding
  always_comb begin 
    reg_en = 4'b0000;
    if(write_enable) begin 
      case(write_addr)
        2'b00 : reg_en = 4'b0001;
      	2'b01 : reg_en = 4'b0010;
        2'b10 : reg_en = 4'b0100;
        2'b11 : reg_en = 4'b1000;
        default : reg_en = 4'b0000;
      endcase
    end
  end
  
  
  Register_8bit R1 (
    .D(write_data),
    .Q(reg1_data),
    .Q_not(),
    .reset(reset),
    .clk(clk),
    .write_enable(reg_en[0])
   
  );
  
  Register_8bit R2 (
    .D(write_data),
    .Q(reg2_data),
    .Q_not(),
    .reset(reset),
    .clk(clk),
    .write_enable(reg_en[1])
   
  );
  
  Register_8bit R3 (
    .D(write_data),
    .Q(reg3_data),
    .Q_not(),
    .reset(reset),
    .clk(clk),
    .write_enable(reg_en[2])
   
  );
  
  Register_8bit R4 (
    .D(write_data),
    .Q(reg4_data),
    .Q_not(),
    .reset(reset),
    .clk(clk),
    .write_enable(reg_en[3])
   
  );
  
  //read_decoding
  always_comb begin 
    case(read_addr1)
      2'b00 : read_data1 = reg1_data;
      2'b01 : read_data1 = reg2_data;
      2'b10 : read_data1 = reg3_data;
      2'b11 : read_data1 = reg4_data;
  	  default : read_data1 = 8'd0;
    endcase
    
    case(read_addr2)
      2'b00 : read_data2 = reg1_data;
      2'b01 : read_data2 = reg2_data;
      2'b10 : read_data2 = reg3_data;
      2'b11 : read_data2 = reg4_data;
  	  default : read_data2 = 8'd0;
    endcase
  end
  
endmodule
  
  
      
  	
