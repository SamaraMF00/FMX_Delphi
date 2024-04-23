unit uProdutosController;

interface

uses
   SysUtils, uProdutos, uProdutosDao;

type

   TProdutosController = class
      private

      public
         constructor create;
         function BuscaProduto(pCodProd: string): TProdutos;
      published
         class function get: TProdutosController;
   end;

implementation

uses
   uConexao;

var
   _instance: TProdutosController;

constructor TProdutosController.Create;
begin
   inherited Create;
end;

class function TProdutosController.get: TProdutosController;
begin
   if _instance = nil then
      _instance := TProdutosController.Create;

   Result := _instance;
end;

function TProdutosController.BuscaProduto(pCodProd: string): TProdutos;
var
   xProdutosDao: TProdutosDao;
   xConexao: TConexao;
begin
   try
      try
         Result := nil;
         xProdutosDao := nil;
         xConexao := nil;

         xConexao := TConexao.create;

         xProdutosDao := TProdutosDao.Create(xConexao.getConexao);

         Result := xProdutosDao.RetornaProduto('CodProd = '+ pCodProd);
      finally
         if xProdutosDao <> nil then
            FreeAndNil(xProdutosDao);
         if xConexao <> nil then
            FreeAndNil(xConexao);
      end;
   except
      on E : Exception do
      begin
         Raise Exception.Create(
            'Falha ao retornar dados do produto [Controller]. '+e.Message);
      end;
   end;
end;

end.
