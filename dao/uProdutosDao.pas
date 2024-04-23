unit uProdutosDao;

interface

uses SqlExpr, SimpleDS, Db , Classes, SysUtils, DateUtils,
     DBClient, Provider, UProdutos, FireDAC.Comp.Client, FireDAC.Phys.MySQL;

type

   TProdutosDao = Class
      private
         vConexao: TFDConnection;
      public
         constructor Create(pConexao : TFDConnection);
         function RetornaProduto(pCondicao: String): TProdutos;
      end;
implementation

uses
   uConexao;

constructor TProdutosDao.Create(pConexao: TFDConnection);
begin
   Self.vConexao := pConexao;
end;

function TProdutosDao.RetornaProduto(pCondicao: String): TProdutos;
var
   xQry: TFDQuery;
begin
   try
      try
         Result := nil;
         xQry := nil;

         xQry := TFDQuery.Create(nil);
         xQry.Connection := vConexao;
         xQry.Close;
         xQry.SQL.Text := 'SELECT * FROM PRODUTOS';

         if pCondicao <> '' then
            if Pos('WHERE', UpperCase(pCondicao)) > 0 then
               xQry.SQL.Add(pCondicao)
            else
               xQry.SQL.Add(' WHERE ' + pCondicao);

         xQry.Open;

         if xQry.IsEmpty then
            Exit;

         Result := TProdutos.Create;
         Result.CodProd := xQry.FieldByName('CodProd').AsInteger;
         Result.Descricao := xQry.FieldByName('Descricao').AsString;
         Result.PrecoVenda := xQry.FieldByName('PrecoVenda').AsFloat;
      finally
         if xQry <> nil then
         begin
            xQry.Close;
            FreeAndNil(xQry);
         end;
      end;
   except
      on E: Exception do
         raise Exception.Create(
            'N�o foi poss�vel retornar o registro da tabela PRODUTOS. '+
            E.Message);
   end;
end;

end.
