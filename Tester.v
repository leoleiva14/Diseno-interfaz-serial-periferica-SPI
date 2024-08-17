// -----------------------------------------------------------------------------
// Módulo Tester para la simulación de SPI en Verilog
// Autor: Leonardo Leiva Vasquez
// Carnet: C14172
// Año: 2023
// -----------------------------------------------------------------------------
module tester(
    output reg trans,
    output reg CLK,
    output reg Reset,
    output reg CKP,
    output reg CPH,
    input wire SCK
);



initial begin
    // -------------------------
    // Establecer valores iniciales
    // -------------------------
    CLK = 0;
    Reset = 1;
    CKP = 0;
    CPH = 0;
    trans = 0;
    #20;


    // -------------------------
    // Simula un proceso de escritura:
    // -------------------------
    
    // Inicio de transmisión
    Reset = 0;      
    #28;


// Configuración 1: CKP=0, CPH=1
    CKP =0;
    CPH = 1;
    #20;
    trans =1;
    #138;
    trans =0;
    #50;

// Configuración 1: CKP=1, CPH=0
    CKP = 1;
    CPH = 0;
    #50;
    trans =1;
    #138;
    trans = 0;
    #50;

// Configuración 1: CKP=0, CPH=0
    CKP = 0;
    CPH = 0;
    #50;
    trans =1;
    #138;
    trans = 0;
    #50;

// Configuración 1: CKP=1, CPH=1
    CKP = 1;
    CPH = 1;
    #50;
    trans =1;
    #138;
    trans = 0;
    #50;

// Cambio de polaridad de CKP
    CKP = 0;
    #30;
    CKP = 1;
    #30
    CKP = 0;
    #30;
    CKP =1;
    #50 
    
    $finish;
    
end
always begin
    #1 CLK = ~CLK;
end
endmodule