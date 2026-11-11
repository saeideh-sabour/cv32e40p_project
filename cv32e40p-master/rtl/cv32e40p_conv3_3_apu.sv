module cv32e40p_conv3_3_apu (

    input  logic clk_i,
    input  logic rst_ni,

    // APU handshake
    input  logic apu_req_i,
    output logic apu_gnt_o,

    // operands from core
    input  logic [2:0][31:0] apu_operands_i,

    // operation code
    input  logic [5:0] apu_op_i,

    // result back to core
    output logic apu_rvalid_o,
    output logic [31:0] apu_rdata_o,


    // Memory interface
output logic        conv_mem_req_o,
output logic [31:0] conv_mem_addr_o,

input  logic        conv_mem_gnt_i,
input  logic [31:0] conv_mem_rdata_i,
input  logic        conv_mem_rvalid_i





);


    typedef enum logic [2:0] {

        IDLE,
        READ_PIXEL,
        READ_WEIGHT,
        COMPUTE,
        DONE

    } state_t;


    state_t state;


    logic waiting_mem;


    logic [31:0] data_addr;
    logic [31:0] weight_addr;

    // One-entry cache for the current 3x3 filter.
    // Safe for the current inference flow because conv_weights are read-only.
    logic        weight_cache_valid;
    logic [31:0] cached_weight_addr;


    // Current accelerator configuration:
    // input image row stride = 28 int32_t elements = 112 bytes.
    localparam logic [31:0] INPUT_STRIDE_BYTES = 32'd112;

    function automatic logic [31:0] pixel_offset_bytes(input logic [3:0] idx);
        begin
            case (idx)
                4'd0: pixel_offset_bytes = 32'd0;
                4'd1: pixel_offset_bytes = 32'd4;
                4'd2: pixel_offset_bytes = 32'd8;

                4'd3: pixel_offset_bytes = INPUT_STRIDE_BYTES;
                4'd4: pixel_offset_bytes = INPUT_STRIDE_BYTES + 32'd4;
                4'd5: pixel_offset_bytes = INPUT_STRIDE_BYTES + 32'd8;

                4'd6: pixel_offset_bytes = (INPUT_STRIDE_BYTES << 1);
                4'd7: pixel_offset_bytes = (INPUT_STRIDE_BYTES << 1) + 32'd4;
                4'd8: pixel_offset_bytes = (INPUT_STRIDE_BYTES << 1) + 32'd8;

                default: pixel_offset_bytes = 32'd0;
            endcase
        end
    endfunction


    logic [3:0] read_count;
    logic [3:0] weight_count;


    logic signed [31:0] pixel  [0:8];
    logic signed [31:0] weight [0:8];


    logic signed [63:0] mac_comb;



   // assign data_addr   = apu_operands_i[0];
    //assign weight_addr = apu_operands_i[1];


    // accept request only when idle
    assign apu_gnt_o = apu_req_i && (state == IDLE);


logic signed [63:0] product [0:8];

integer i;

always_comb begin

    for (i = 0; i < 9; i = i + 1) begin

        product[i] =
            $signed({{32{pixel[i][31]}}, pixel[i]}) *
            $signed({{32{weight[i][31]}}, weight[i]});

    end

    mac_comb =
          product[0]
        + product[1]
        + product[2]
        + product[3]
        + product[4]
        + product[5]
        + product[6]
        + product[7]
        + product[8];

end



    always_ff @(posedge clk_i or negedge rst_ni) begin


        if(!rst_ni) begin


            state <= IDLE;

            waiting_mem <= 1'b0;


            apu_rvalid_o <= 1'b0;
            apu_rdata_o  <= 32'b0;


            conv_mem_req_o  <= 1'b0;
            conv_mem_addr_o <= 32'b0;


            read_count   <= 0;
            weight_count <= 0;
			
data_addr          <= 32'b0;
weight_addr        <= 32'b0;
weight_cache_valid <= 1'b0;
cached_weight_addr <= 32'b0;


            for(int i=0;i<9;i++) begin

                pixel[i]  <= 32'b0;
                weight[i] <= 32'b0;

            end


        end



        else begin


            apu_rvalid_o   <= 1'b0;
            //conv_mem_req_o <= 1'b0;



            //---------------------------------
            // Start convolution
            //---------------------------------

            if(state == IDLE && apu_req_i) begin


                $display("CONV START");
				
				
data_addr   <= apu_operands_i[0];
weight_addr <= apu_operands_i[1];


                read_count <= 0;

conv_mem_addr_o <= apu_operands_i[0];
                conv_mem_req_o  <= 1'b1;


                waiting_mem <= 1'b0;


                state <= READ_PIXEL;


            end
			
			
			//---------------------------------
// Memory request accepted
//---------------------------------

if (conv_mem_req_o && conv_mem_gnt_i) begin

    conv_mem_req_o <= 1'b0;
    waiting_mem    <= 1'b1;

end





            //---------------------------------
            // Memory response
            //---------------------------------

            if(conv_mem_rvalid_i && waiting_mem) begin



                if(state == READ_PIXEL) begin


                    pixel[read_count] <= conv_mem_rdata_i;


                    $display("PIXEL[%0d] = %h",
                             read_count,
                             conv_mem_rdata_i);



                    if(read_count == 8) begin


                        $display("ALL PIXELS READ");


                        waiting_mem <= 1'b0;

                        // Reuse the 9 weights when the same filter base
                        // address is requested again.
                        if(weight_cache_valid &&
                           (cached_weight_addr == weight_addr)) begin

                            state <= COMPUTE;

                        end
                        else begin

                            weight_count <= 0;

                            conv_mem_addr_o <= weight_addr;
                            conv_mem_req_o  <= 1'b1;

                            state <= READ_WEIGHT;

                        end



                    end


                    else begin


                        read_count <= read_count + 1;


                        // data_addr points directly to the top-left
                        // pixel of the 3x3 window in the 28x28 image.
                        conv_mem_addr_o <= data_addr +
                                           pixel_offset_bytes(read_count + 4'd1);


                        conv_mem_req_o <= 1'b1;


                        waiting_mem <= 1'b0;


                    end



                end




                else if(state == READ_WEIGHT) begin



                    weight[weight_count] <= conv_mem_rdata_i;



                    $display("WEIGHT[%0d] = %h",
                             weight_count,
                             conv_mem_rdata_i);



                    if(weight_count == 8) begin


                        $display("ALL WEIGHTS READ");


                        waiting_mem <= 1'b0;

                        // The full 3x3 filter is now resident in weight[].
                        cached_weight_addr <= weight_addr;
                        weight_cache_valid <= 1'b1;


                        state <= COMPUTE;



                    end


                    else begin


                        weight_count <= weight_count + 1;


                        conv_mem_addr_o <= weight_addr +
                                           ((weight_count+1)*4);


                        conv_mem_req_o <= 1'b1;


                        waiting_mem <= 1'b0;


                    end


                end



            end





            //---------------------------------
            // MAC
            //---------------------------------

            if(state == COMPUTE) begin


                $display("MAC RESULT = %h",
                         mac_comb);



                apu_rdata_o <= mac_comb[31:0];


                state <= DONE;


            end





            //---------------------------------
            // Finish
            //---------------------------------

            if(state == DONE) begin


                apu_rvalid_o <= 1'b1;


                state <= IDLE;


            end



        end

    end


endmodule