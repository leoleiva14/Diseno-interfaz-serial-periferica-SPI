// -----------------------------------------------------------------------------
// Testbench para el SPI en Verilog
// Autor: Leonardo Leiva Vasquez
// Carnet: C14172
// Año: 2023
// -----------------------------------------------------------------------------

`include "Tester.v"
`include "Receptor.v"
`include "Transmisor.v"
module testbench(
    input wire trans,        
    input wire CKP,        
    input wire CPH,        
    input wire CLK,        
    input wire Reset,        
    input wire SCK,       
    input wire MOSI,      
    input wire MISO,
    input wire CS,
    input wire SS      
);

// -------------
// Inicialización
// -------------
initial begin
    $dumpfile("resultados.vcd");
    $dumpvars;
end
wire SLAVE2;
wire SLAVE3;
wire CS_SS;

// ------------------
// Instancias de Módulos
// ------------------

// Instancia del módulo Transmisor
    
    Transmisor transmisor (
        .trans(trans),
        .CLK(CLK),
        .Reset(Reset),
        .CKP(CKP),
        .CPH(CPH),
        .CS(CS_SS),
        .SCK(SCK),
        .MOSI(MOSI),
        .MISO(MISO)
    );

    tester probador (
        .trans(trans),
        .CKP(CKP),
        .CPH(CPH),
        .CLK(CLK),
        .Reset(Reset),
        .SCK(SCK)
    );

    // Instancias del módulo receptor
    Receptor receptor1 (
        .trans(trans),
        .CKP(CKP),
        .CPH(CPH),
        .MISO(SLAVE2),  // Conectado al CS del transmisor
        .SCK(SCK),
        .MOSI(MOSI),
        .SS(CS_SS)
    );

    Receptor receptor2 (
        .trans(trans),
        .CKP(CKP),
        .CPH(CPH),
        .MISO(SLAVE3),  // Conectado al CS del transmisor
        .SCK(SCK),
        .MOSI(SLAVE2),
        .SS(CS_SS)
    );

    Receptor receptor3 (
        .trans(trans),
        .CKP(CKP),
        .CPH(CPH),
        .MISO(MISO),  // Conectado al CS del transmisor
        .SCK(SCK),
        .MOSI(SLAVE3),
        .SS(CS_SS)
    );

endmodule