module task_83coder_new (din,select,dout,s_out,ex_out);
      input[7:0] din;    //8�������źţ�����Ч
      input select;        //Ƭѡʹ���źţ�����Ч
      output[2:0] dout;//���ȱ�������ź�
      output ex_out;    //��չ����ˣ�����Ч
      output s_out;      //ѡͨ����ˣ�����Ч 
		
		
		reg[2:0] dout;
      reg ex_out;   
      reg s_out; 
      
     task coder; //����Ķ���
        input[7:0] din;
        input select;
        output[2:0] dout;
        output ex_out;
        output s_out;        
        reg[4:0] coder_out; //�м������5λ��������ȱ��������ѡͨ�������չ����źţ� 
       begin
           if(select) coder_out = 5'b111_1_1;//��ֹ����
           else
             begin     
                 casex(din)
                     8'b0xxx_xxxx : coder_out = 5'b000_0_1; //din[7]��Ч
                     8'b10xx_xxxx : coder_out = 5'b001_0_1;
                     8'b110x_xxxx : coder_out = 5'b010_0_1;
                     8'b1110_xxxx : coder_out = 5'b011_0_1;
                     8'b1111_0xxx : coder_out = 5'b100_0_1;
                     8'b1111_10xx : coder_out = 5'b101_0_1;
                     8'b1111_110x : coder_out = 5'b110_0_1;
                     8'b1111_1110 : coder_out = 5'b111_0_1;//din[0]��Ч
                    default: coder_out = 5'b111_1_0;              // ����Ч�ź�����
                endcase
            end
      {dout, ex_out, s_out}= coder_out;               //���м��������ȡ��������
    end
  endtask

  always @( din or select)   
     coder(din, select, dout, ex_out, s_out);     
endmodule
