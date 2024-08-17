// -----------------------------------------------------------------------------
// Transmisor SPI en Verilog
// Autor: Leonardo Leiva Vasquez
// Carnet: C14172
// Año: 2023
// -----------------------------------------------------------------------------

module Transmisor(
    input wire trans,
    input wire CKP,
    input wire CPH,
    input wire CLK,
    input wire Reset,
    input wire MISO,
    output reg MOSI,
    output reg SCK,
    output reg CS 
);

// ---------------------------------
// Variables y Parámetros Internos
// ---------------------------------


reg [1:0] Estado, Prox_estado;
reg [15:0] Dato, Prox_Dato;
reg [7:0] Dato1 = 8'b00000100, Dato1_newdata; // 4
reg [7:0] Dato2 = 8'b00000001, Dato2_newdata; // 1
reg [4:0] counter ;
wire Finish_protcol;
assign Finish_protcol = counter == 5'b10001;
wire SCK_escogido;
wire [1:0] MODO;
assign MODO = {CKP, CPH};
assign SCK_escogido = (MODO == 0 || MODO == 3) ? SCK : ~SCK;

reg CLK_div2;
reg [1:0] Count_clock;

// Estados del Transmisor
parameter Reposo = 2'b00;
parameter Trans = 2'b01;

// ------------------------------
// Lógica Principal del Transmisor
// ------------------------------

// Actualizar estado, reloj dividido y contador en cada flanco positivo del CLK
always @(posedge CLK) begin
    if (Reset == 1) begin
        Estado <= Reposo;
        CLK_div2 <= 0;
        Count_clock <= 0;
        Dato <= {Dato1, Dato2};
        MOSI <= 0;
        counter <= 0;
    end else begin
        Estado <= Prox_estado;
        CLK_div2 <= ~CLK_div2;
        Count_clock <= Count_clock +1;
    end
    
end

// Actualizar contador y datos en cada flanco positivo del reloj escogido
always @(posedge SCK_escogido ) begin
    if (trans == 0) begin
        counter <= 0;
    end else begin
        counter <= counter +1;
        Dato <= Prox_Dato;
    end
end

// Definir próximo estado y datos basado en el estado actual
always @(*) begin
    Prox_Dato = Dato;
    Prox_estado = Estado;

    case (Estado)
        Reposo: begin
            Dato1_newdata = Dato[15:8];
            Dato2_newdata = Dato[7:0];
            counter = 0;
            CS = 1;
            if (CKP) begin
                SCK = 1;
            end else begin
                SCK = 0;
            end
            if (trans && Finish_protcol == 0) begin
                Prox_estado = Trans;
            end else begin
                Prox_estado = Reposo;
            end
        end
        Trans: begin
            CS = 0;
            SCK = Count_clock[1];
            if (counter == 0) begin
                MOSI = Dato[15];
            end else begin
                MOSI = Dato[15];
                Prox_Dato = {Dato, MISO};
            end
            if (Finish_protcol) begin
                Prox_estado = Reposo;
            end
        end

    endcase
    
end
endmodule