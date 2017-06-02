module task_83coder_new (din,select,dout,s_out,ex_out);
      input[7:0] din;    //8个输入信号，低有效
      input select;        //片选使能信号，低有效
      output[2:0] dout;//优先编码输出信号
      output ex_out;    //扩展输出端，低有效
      output s_out;      //选通输出端，高有效 
		
		
		reg[2:0] dout;
      reg ex_out;   
      reg s_out; 
      
     task coder; //任务的定义
        input[7:0] din;
        input select;
        output[2:0] dout;
        output ex_out;
        output s_out;        
        reg[4:0] coder_out; //中间变量，5位输出（优先编码输出、选通输出和扩展输出信号） 
       begin
           if(select) coder_out = 5'b111_1_1;//禁止工作
           else
             begin     
                 casex(din)
                     8'b0xxx_xxxx : coder_out = 5'b000_0_1; //din[7]有效
                     8'b10xx_xxxx : coder_out = 5'b001_0_1;
                     8'b110x_xxxx : coder_out = 5'b010_0_1;
                     8'b1110_xxxx : coder_out = 5'b011_0_1;
                     8'b1111_0xxx : coder_out = 5'b100_0_1;
                     8'b1111_10xx : coder_out = 5'b101_0_1;
                     8'b1111_110x : coder_out = 5'b110_0_1;
                     8'b1111_1110 : coder_out = 5'b111_0_1;//din[0]有效
                    default: coder_out = 5'b111_1_0;              // 无有效信号输入
                endcase
            end
      {dout, ex_out, s_out}= coder_out;               //从中间变量中提取任务的输出
    end
  endtask

  always @( din or select)   
     coder(din, select, dout, ex_out, s_out);     
endmodule
