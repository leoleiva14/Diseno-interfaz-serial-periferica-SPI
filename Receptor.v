// -----------------------------------------------------------------------------
// Receptor SPI en Verilog
// Autor: Leonardo Leiva Vasquez
// Carnet: C14172
// Año: 2023
// -----------------------------------------------------------------------------
module Receptor(
    input wire trans,
    input wire CKP,
    input wire CPH,
    input wire SCK,
    input wire MOSI,
    output reg MISO,
    input wire SS 
);

// ---------------------------------
// Variables y Parámetros Internos
// ---------------------------------

reg [1:0] Estado, Prox_estado;
reg [15:0] Dato, Prox_Dato;
// Datos de prueba
reg [7:0] Dato1 = 8'b00000111; // 7
reg [7:0] Dato2 = 8'b00000010; // 2
reg data_begin_dato = 0;
reg [4:0] counter;
wire SCK_escogido;
wire [1:0] MODO;
wire Finish_protcol;
// Condiciones y Módos del Protocolo
assign Finish_protcol = counter == 5'b10001;
assign MODO = {CKP, CPH};
assign SCK_escogido = (MODO == 0 || MODO == 3) ? SCK : ~SCK;

// Estados del Receptor
parameter Reposo = 2'b00;
parameter Trans = 2'b01;

// ------------------------------
// Lógica Principal del Receptor
// ------------------------------

// Actualizar estado y contador en cada flanco positivo del reloj escogido
always @(posedge SCK_escogido) begin
    if (trans == 0) begin
        Estado <= 0;
        counter <= 0;
        MISO <= 0;
        if (data_begin_dato ==0) begin
            Dato <= {Dato1, Dato2};
            data_begin_dato <= 1;
        end
    end else begin
        Estado <= Prox_estado;
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
            counter =0;
            if (trans) begin
                Prox_estado = Trans;
            end else begin
                Prox_estado = Reposo;
            end
        end 
        Trans: begin
            if (counter == 0) begin
                MISO = Dato[15];
            end else begin
                MISO = Dato[15];
                Prox_Dato = {Dato, MOSI};
            end
            if (Finish_protcol) begin
                Prox_estado = Reposo;
            end
            if (SS == 1) begin
                counter = 0;
            end
        end
    endcase
end

endmodule