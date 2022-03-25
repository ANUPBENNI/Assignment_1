module parking_system(input clk,reset,
input sensor_entrance,sensor_exit,
input [0:2]password,
output wire green_led,red_led,
output reg [0:6]hex_1,hex_2);
parameter idle=3'b000,wait_password=3'b001,right_password=3'b010,wrong_password=3'b011;
reg [2:0]current_state,next_state;
reg [31:0] counter_wait;
reg red_tmp,green_tmp;
always @(posedge clk)  
begin
if(reset==0)
current_state=idle;
else
current_state=next_state;
end
always @(posedge clk)
begin
if(reset==0)
counter_wait<=0;
else if(current_state==wait_password)
counter_wait<=counter_wait+1;
else
counter_wait<=0;
end
always @(*)
begin
case(current_state)
idle:
begin
if(sensor_entrance==1)
next_state=wait_password;
else
next_state=idle;
end
wait_password:
begin
if(counter_wait<=3)
next_state<=wait_password;
else begin
if(password==3'b010)
next_state=right_password;
else
next_state=wrong_password;
end
end
wrong_password:
begin
if(password==3'b010)
next_state=right_password;
else
next_state=wrong_password;
end
right_password:
begin
if(sensor_entrance==1 && sensor_exit==1)
next_state=idle;
else if(sensor_exit==1)
next_state=idle;
else
next_state=right_password;
end
endcase
end
always @(posedge clk)
begin
case(current_state)
idle:
begin
green_tmp=1'b0;
red_tmp=1'b0;
hex_1=7'b1111111;
hex_2=7'b1111111;
end
wait_password: begin
 green_tmp = 1'b0;
 red_tmp = 1'b1;
 hex_1 = 7'b000_0110; // E
 hex_2 = 7'b010_1011; // n 
 end
 wrong_password: begin
 green_tmp = 1'b0;
 red_tmp = ~red_tmp;
 hex_1 = 7'b000_0110; // E
 hex_2 = 7'b000_0110; // E 
 end
 right_password: begin
 green_tmp = ~green_tmp;
 red_tmp = 1'b0;
 hex_1 = 7'b000_0010; // 6
 hex_2 = 7'b100_0000; // 0 
 end
 endcase
 end
 assign red_led = red_tmp  ;
 assign green_led = green_tmp;

endmodule
