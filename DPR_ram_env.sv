
class ram_env;

   //Instantiate virtual interface with Write Driver modport,
   //Read Driver modport,Write monitor modport,Read monitor modport
 virtual ram_if.WR_DRV_MP wr_drv_if;
virtual ram_if.RD_DRV_MP rd_drv_if;
virtual ram_if.WR_MON_MP wr_mon_if;
virtual ram_if.RD_MON_MP rd_mon_if;

   //Declare 6 mailboxes parameterized by ram_trans and construct it


mailbox #(ram_trans) gen2wr=new();
mailbox #(ram_trans) gen2rd=new();
mailbox #(ram_trans) wr2rm=new();
mailbox #(ram_trans) rd2rm=new();
mailbox #(ram_trans) rd2sb=new();
mailbox #(ram_trans) rm2sb=new();



   //Create handle for ram_gen,ram_write_drv,ram_read_drv,ram_write_mon,
   //ram_read_mon,ram_model,ram_sb
ram_gen gen_h;
ram_write_drv wr_drv;
ram_read_drv rd_drv;
ram_write_mon wr_mon;
ram_read_mon rd_mon;
ram_model model;
ram_sb sb_h;


   //In constructor
   //pass the Driver and monitor interfaces as the argument
   //connect them with the virtual interfaces of ram_env
function new( virtual ram_if.WR_DRV_MP wr_drv_if,
virtual ram_if.RD_DRV_MP rd_drv_if,
virtual ram_if.WR_MON_MP wr_mon_if,
virtual ram_if.RD_MON_MP rd_mon_if);
this.wr_drv_if=wr_drv_if;
this.rd_drv_if=rd_drv_if;
this.wr_mon_if=wr_mon_if;
this.rd_mon_if=rd_mon_if;
endfunction:new
   //In virtual task build
   //create instances for generator,Write Driver,Read Driver,
   //Write monitor,Read monitor,Reference model,Scoreboard
virtual task build();
gen_h=new(gen2rd,gen2wr);
wr_drv=new(wr_drv_if,gen2wr);
rd_drv=new(rd_drv_if,gen2rd);
wr_mon=new(wr_mon_if,wr2rm);
rd_mon=new(rd_mon_if,wr2rm,rd2sb);
model=new(wr2rm,rd2rm,rm2sb);
sb_h=new(rm2sb,rd2sb);
endtask:build
   //Understand and include the virtual task reset_dut

   virtual task reset_dut();
      begin
         rd_drv_if.rd_drv_cb.rd_address<='0;
         rd_drv_if.rd_drv_cb.read<='0;

         wr_drv_if.wr_drv_cb.wr_address<=0;
         wr_drv_if.wr_drv_cb.write<='0;

         repeat(5) @(wr_drv_if.wr_drv_cb);
         for (int i=0; i<4096; i++)
            begin
               wr_drv_if.wr_drv_cb.write<='1;
               wr_drv_if.wr_drv_cb.wr_address<=i;
               wr_drv_if.wr_drv_cb.data_in<='0;
               @(wr_drv_if.wr_drv_cb);
            end
         wr_drv_if.wr_drv_cb.write<='0;
         repeat (5) @(wr_drv_if.wr_drv_cb);
      end
   endtask : reset_dut

   //In virtual task start
   //call the start methods of generator,Write Driver,Read Driver,
   //Write monitor,Read Monitor,reference model,scoreboard
virtual task start();
gen_h.start();
wr_drv.start();
rd_drv.start();
wr_mon.start();
rd_mon.start();
model.start();
sb_h.start();
endtask:start

   virtual task stop();
      wait(sb_h.DONE.triggered);
   endtask : stop

   //In virtual task run, call reset_dut, start, stop methods & report function from scoreboard
virtual task run();
reset_dut();
start();
stop();
sb_h.report();
endtask:run
endclass : ram_env
