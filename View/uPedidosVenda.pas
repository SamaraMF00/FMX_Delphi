unit uPedidosVenda;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, FMX.Objects, System.Rtti,
  FMX.Grid.Style, FMX.ScrollBox, FMX.Grid, Winapi.Windows, FMX.ExtCtrls,
  Data.DB, Datasnap.DBClient, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope, FireDAC.UI.Intf,
  FireDAC.FMXUI.Wait, FireDAC.Stan.Intf, FireDAC.Comp.UI;

type
  TfrmPedidosVenda = class(TForm)
    pnlFundo: TPanel;
    pnlTopo: TPanel;
    pnlItens: TPanel;
    pnlBotoes: TPanel;
    edtNumPedido: TEdit;
    edtCodCliente: TEdit;
    edtNomeCliente: TEdit;
    lblNumPedido: TLabel;
    lblCodCliente: TLabel;
    lneEdtNumPedido: TLine;
    lneEdtCliente: TLine;
    lneEdtNomeCliente: TLine;
    pnlCampos: TPanel;
    btnAdicionar: TSpeedButton;
    imgInserir: TImage;
    lblProduto: TLabel;
    edtCodProd: TEdit;
    lneEdtProduto: TLine;
    lneEdtDescricao: TLine;
    edtDescricao: TEdit;
    lneEdtQuantidade: TLine;
    lneEdtVlrUnitario: TLine;
    lblProduto1: TLabel;
    edtQuantidade: TEdit;
    lblVlrUnitario: TLabel;
    edtVlrUnitario: TEdit;
    dbgProdutos: TGrid;
    pnlLogo: TPanel;
    imgLogo: TImage;
    txtVendas: TText;
    btnConsulta: TSpeedButton;
    btnDeletar: TSpeedButton;
    btnInserir: TSpeedButton;
    btnCancelar: TSpeedButton;
    btnGravar: TSpeedButton;
    rctInserir: TRectangle;
    txtInserir: TText;
    rctGravar: TRectangle;
    txtGravar: TText;
    rctDeletar: TRectangle;
    txtDeletar: TText;
    rctConsultar: TRectangle;
    txtConsultar: TText;
    rctCancelar: TRectangle;
    txtCancelar: TText;
    lblTotalPedido: TLabel;
    dsProdutos: TDataSource;
    cdsProdutos: TClientDataSet;
    cdsProdutosCodProd: TIntegerField;
    cdsProdutosDescricao: TStringField;
    cdsProdutosQuantidade: TIntegerField;
    cdsProdutosVlrUnitario: TFloatField;
    cdsProdutosVlrTotal: TFloatField;
    bndsrcdb: TBindSourceDB;
    bndngslst: TBindingsList;
    lnkgrdtdtsrcBindSourceDB: TLinkGridToDataSource;
    fdgxwtcrsr1: TFDGUIxWaitCursor;
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure edtNumPedidoEnter(Sender: TObject);
    procedure edtNumPedidoKeyUp(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure edtCodClienteEnter(Sender: TObject);
    procedure edtCodClienteExit(Sender: TObject);
    procedure edtCodClienteKeyUp(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure edtCodProdEnter(Sender: TObject);
    procedure edtCodProdExit(Sender: TObject);
    procedure edtCodProdKeyUp(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure edtQuantidadeKeyUp(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure edtVlrUnitarioExit(Sender: TObject);
    procedure edtVlrUnitarioKeyUp(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure btnAdicionarClick(Sender: TObject);
    procedure dbgProdutosCellDblClick(const Column: TColumn;
      const Row: Integer);
    procedure btnInserirClick(Sender: TObject);
    procedure btnDeletarClick(Sender: TObject);
    procedure btnConsultaClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
  private
    { Private declarations }
     vOpcaoTela: string;
     vKey: Word;
     vAlteracao: Boolean;
     vValorTotal: Double;

    function somenteNumeros(pKey: char): Boolean;
    procedure tratamentoTela;
    procedure buscaCliente(pCodCliente: string);
    procedure buscaProduto;
    function validaCampos: Boolean;
    function validaCodCliente: Boolean;
    function validaCodProd: Boolean;
    function validaQuantidade: Boolean;
    function validaVlrUnitario: Boolean;
    procedure adicionaProduto;
    procedure limpaCampos;
    function salvarDados: Boolean;
    procedure consultaPedido;
    function validaNumPedido: Boolean;
    function buscaNumPedido: Integer;
    procedure deletarPedido;
  public
    { Public declarations }
  end;

implementation

uses
   uClienteController, uCliente, uProdutos, uProdutosController, uCabecalhoPedido,
   uItensPedido, uCabecalhoPedidoController, uItensPedidoController;

{$R *.fmx}

procedure TfrmPedidosVenda.btnAdicionarClick(Sender: TObject);
begin
   if validaCampos then
      adicionaProduto;
end;

procedure TfrmPedidosVenda.btnCancelarClick(Sender: TObject);
begin
   vOpcaoTela := 'C';
   tratamentoTela;
end;

procedure TfrmPedidosVenda.btnConsultaClick(Sender: TObject);
begin
   vOpcaoTela := 'P';
   tratamentoTela;
end;

procedure TfrmPedidosVenda.btnDeletarClick(Sender: TObject);
begin
   if vOpcaoTela = 'P' then
      deletarPedido
   else
   begin
      vOpcaoTela := 'E';
      tratamentoTela;
   end;
end;

procedure TfrmPedidosVenda.btnGravarClick(Sender: TObject);
begin
   vOpcaoTela := 'G';
   begin
      if salvarDados then
         tratamentoTela;
   end;
end;

procedure TfrmPedidosVenda.btnInserirClick(Sender: TObject);
begin
   vOpcaoTela := 'I';
   tratamentoTela;
   edtNumPedido.Text := IntToStr(buscaNumPedido + 1);
end;

procedure TfrmPedidosVenda.dbgProdutosCellDblClick(const Column: TColumn;
  const Row: Integer);
begin
   vAlteracao := True;
   edtCodProd.Text := IntToStr(cdsProdutos.FieldByName('CodProd').AsInteger);
   edtDescricao.Text := cdsProdutos.FieldByName('Descricao').AsString;
   edtQuantidade.Text := cdsProdutos.FieldByName('Quantidade').AsString;
   edtVlrUnitario.Text := FormatFloat('###,##0.00', cdsProdutos.FieldByName('VlrUnitario').AsFloat);
   edtCodProd.Enabled := False;
   vValorTotal := vValorTotal - cdsProdutos.FieldByName('VlrTotal').AsFloat;
end;

procedure TfrmPedidosVenda.edtCodClienteEnter(Sender: TObject);
begin
  vKey := 0;
end;

procedure TfrmPedidosVenda.edtCodClienteExit(Sender: TObject);
begin
   if (vKey = 13) and (edtCodCliente.Text <> '') then
      buscaCliente(edtCodCliente.Text);
end;

procedure TfrmPedidosVenda.edtCodClienteKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
   if not SomenteNumeros(KeyChar) then
      KeyChar := #0;
   if edtCodCliente.Text = '' then
      edtNomeCliente.Text := '';
end;

procedure TfrmPedidosVenda.edtCodProdEnter(Sender: TObject);
begin
   vKey := 0;
end;

procedure TfrmPedidosVenda.edtCodProdExit(Sender: TObject);
begin
   if (vKey = 13) and (edtCodProd.Text <> '') then
      buscaProduto;
end;

procedure TfrmPedidosVenda.edtCodProdKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
   if not SomenteNumeros(KeyChar) then
      KeyChar := #0;
   if edtCodProd.Text = '' then
      edtDescricao.Text := '';
end;

procedure TfrmPedidosVenda.edtNumPedidoEnter(Sender: TObject);
begin
  vKey := 0;
end;

procedure TfrmPedidosVenda.edtNumPedidoKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
   if not SomenteNumeros(KeyChar) then
      KeyChar := #0;
end;

procedure TfrmPedidosVenda.edtQuantidadeKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
   if not SomenteNumeros(KeyChar) then
      KeyChar := #0;
end;

procedure TfrmPedidosVenda.edtVlrUnitarioExit(Sender: TObject);
begin
   if StrToFloatDef(edtVlrUnitario.Text, 0) > 0 then
      edtVlrUnitario.Text := FormatFloat('###,##0.00', StrToFloat(edtVlrUnitario.Text));
end;

procedure TfrmPedidosVenda.edtVlrUnitarioKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
   if not SomenteNumeros(KeyChar) then
      KeyChar := #0;
end;

function TfrmPedidosVenda.SomenteNumeros(pKey: char): Boolean;
begin
   Result := True;

   if (pKey in ['0'..'9', ','] = false) and
      (Word(pKey) <> VK_Back) and
      (Word(pKey) <> VK_Return) then
      Result := False;
end;

procedure TfrmPedidosVenda.FormCreate(Sender: TObject);
begin
   vOpcaoTela := '';
   vValorTotal := 0;
   tratamentoTela;
end;

procedure TfrmPedidosVenda.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
   vKey := Key;

   case vKey of
      VK_RETURN:
      begin
         if (sender = dbgProdutos) then
            dbgProdutosCellDblClick(dbgProdutos.Columns[0], dbgProdutos.Row)
         else
         if sender = edtNumPedido then
         begin
            if (vOpcaoTela = 'P') then
               consultaPedido
            else
               deletarPedido;
         end
         else
           keybd_event(VK_TAB, 0, 0, 0);
      end;

      VK_ESCAPE: Close;

      VK_UP :
      begin
         vKey := VK_CLEAR;
         if (sender <> dbgProdutos)then
           keybd_event(VK_TAB, 0, 0, 0)
      end;

      VK_DELETE:
      begin
        vValorTotal := vValorTotal - cdsProdutos.FieldByName('VlrTotal').AsFloat;
        lblTotalPedido.Text := 'R$ ' + FormatFloat('0.00', vValorTotal);
        cdsProdutos.Delete;
      end;
   end;
end;

procedure TfrmPedidosVenda.tratamentoTela;
begin
   if vOpcaoTela = 'I' then
   begin
      btnConsulta.Enabled := False;
      pnlCampos.Enabled := True;
      pnlTopo.Enabled := True;
      edtNumPedido.Enabled := False;
      edtNomeCliente.Enabled := False;
      edtDescricao.Enabled := False;
      btnCancelar.Enabled := True;
      btnGravar.Enabled := True;
      edtCodProd.Enabled := True;
      edtCodCliente.Enabled := True;
      edtQuantidade.Enabled := True;
      edtVlrUnitario.Enabled := True;
      btnAdicionar.Enabled := True;
      btnInserir.Enabled := False;
      btnDeletar.Enabled := False;
      dbgProdutos.Enabled := True;

      if edtCodCliente.CanFocus then
         edtCodCliente.SetFocus;
   end
   else
   if vOpcaoTela = 'P' then
   begin
      pnlCampos.Enabled := True;
      pnlTopo.Enabled := True;
      btnGravar.Enabled := False;
      btnInserir.Enabled := False;
      edtNumPedido.Enabled := True;
      btnCancelar.Enabled := True;
      btnConsulta.Enabled := False;
      dbgProdutos.Enabled := False;
      btnDeletar.Enabled := True;

      if edtNumPedido.CanFocus then
         edtNumPedido.SetFocus;
   end
   else
   if vOpcaoTela = 'E' then
   begin
      pnlCampos.Enabled := True;
      pnlTopo.Enabled := True;
      btnGravar.Enabled := False;
      btnCancelar.Enabled := True;
      btnInserir.Enabled := False;
      edtNumPedido.Enabled := True;
      btnConsulta.Enabled := False;
      dbgProdutos.Enabled := False;
      btnDeletar.Enabled := False;

      if edtNumPedido.CanFocus then
         edtNumPedido.SetFocus;
   end
   else
   begin
      limpaCampos;
      edtNomeCliente.Enabled := False;
      edtDescricao.Enabled := False;
      pnlCampos.Enabled := False;
      pnlTopo.Enabled := False;
      pnlBotoes.Enabled := True;
      btnGravar.Enabled := False;
      btnCancelar.Enabled := False;
      btnInserir.Enabled := True;
      btnConsulta.Enabled := True;
      edtCodProd.Enabled := False;
      edtCodCliente.Enabled := False;
      edtQuantidade.Enabled := False;
      edtVlrUnitario.Enabled := False;
      btnAdicionar.Enabled := False;
      edtNumPedido.Enabled := False;
      dbgProdutos.Enabled := False;
      btnDeletar.Enabled := True;
   end;
end;

procedure TfrmPedidosVenda.buscaCliente(pCodCliente: string);
var
   xCliente: TCliente;
begin
   try
      try
         xCliente := nil;
         xCliente := TClienteController.get.buscaCliente(pCodCliente);

         if xCliente <> nil then
            edtNomeCliente.Text := xCliente.Nome
         else
            MessageDlg('Cliente n�o cadastrado!', TMsgDlgType.mtWarning,[TMsgDlgBtn.mbOk],0);
      finally
         if xCliente <> nil then
            FreeAndNil(xCliente);
      end;
   except
      on E : Exception do
         MessageDlg(e.Message, TMsgDlgType.mtError, [TMsgDlgBtn.mbOk],0);
   end;
end;

procedure TfrmPedidosVenda.buscaProduto;
var
   xProdutos: TProdutos;
begin
   try
      try
         xProdutos := nil;
         xProdutos := TProdutosController.get.buscaProduto(edtCodProd.Text);

         if xProdutos <> nil then
         begin
            edtDescricao.Text := xProdutos.Descricao;
            edtVlrUnitario.Text := FormatFloat('###,##0.00', xProdutos.PrecoVenda);
         end
         else
            MessageDlg('Produto n�o cadastrado!', TMsgDlgType.mtWarning,[TMsgDlgBtn.mbOk],0);
      finally
         if xProdutos <> nil then
            FreeAndNil(xProdutos);
      end;
   except
      on E : Exception do
         MessageDlg(e.Message, TMsgDlgType.mtError,[TMsgDlgBtn.mbOk],0);
   end;
end;

function TfrmPedidosVenda.validaCampos: Boolean;
var
   xMsgmCampoVazio: string;
begin
   Result := False;

   if (not validaCodCliente) or
      (not validaCodProd) or
      (not validaQuantidade) or
      (not validaVlrUnitario) then
      Exit;

   Result := True;
end;

function TfrmPedidosVenda.validaCodProd: Boolean;
begin
   Result := False;

   if (edtCodProd.Text = '') or (edtDescricao.Text = '') then
   begin
      MessageDlg('Digite um c�digo de produto v�lido!', TMsgDlgType.mtWarning,[TMsgDlgBtn.mbOk],0);
      if edtCodProd.CanFocus then
         edtCodProd.SetFocus;
      Exit;
   end;

   Result := True;
end;

function TfrmPedidosVenda.validaCodCliente: Boolean;
begin
   Result := False;

   if (edtCodCliente.Text = '') or (edtNomeCliente.Text = '') then
   begin
      MessageDlg('Digite um c�digo de cliente v�lido!', TMsgDlgType.mtWarning,[TMsgDlgBtn.mbOk],0);
      if edtCodCliente.CanFocus then
         edtCodCliente.SetFocus;
      Exit;
   end;

   Result := True;
end;

function TfrmPedidosVenda.validaQuantidade: Boolean;
begin
   Result := False;

   if (edtQuantidade.Text = '') or (edtQuantidade.Text = '0') then
   begin
      MessageDlg('Quantidade deve ser maior que 0.', TMsgDlgType.mtWarning,[TMsgDlgBtn.mbOk],0);
      if edtQuantidade.CanFocus then
         edtQuantidade.SetFocus;
      Exit;
   end;

   Result := True;
end;

function TfrmPedidosVenda.validaVlrUnitario: Boolean;
begin
   Result := False;

   if StrToFloatDef(edtVlrUnitario.Text, 0) = 0 then
   begin
      MessageDlg('Valor unit�rio deve ser maior que 0.', TMsgDlgType.mtWarning,[TMsgDlgBtn.mbOk],0);
      if edtVlrUnitario.CanFocus then
         edtVlrUnitario.SetFocus;
      Exit;
   end;

   Result := True;
end;

function TfrmPedidosVenda.validaNumPedido: Boolean;
begin
   Result := False;

   if (edtNumPedido.Text = '') then
   begin
      MessageDlg('Digite o n�mero do pedido para consulta.', TMsgDlgType.mtWarning,[TMsgDlgBtn.mbOk],0);
      if edtNumPedido.CanFocus then
         edtNumPedido.SetFocus;
      Exit;
   end;

   Result := True;
end;

procedure TfrmPedidosVenda.adicionaProduto;
begin
   cdsProdutos.DisableControls;

   if vAlteracao then
      cdsProdutos.Edit
   else
      cdsProdutos.Append;

   cdsProdutos.FieldByName('CodProd').AsInteger := StrToInt(edtCodProd.Text);
   cdsProdutos.FieldByName('Descricao').AsString := edtDescricao.Text;
   cdsProdutos.FieldByName('Quantidade').AsInteger := StrToInt(edtQuantidade.Text);
   cdsProdutos.FieldByName('VlrUnitario').AsFloat := StrToFloat(edtVlrUnitario.Text);
   cdsProdutos.FieldByName('VlrTotal').AsFloat := StrToFloat(edtQuantidade.Text) * StrToFloat(edtVlrUnitario.Text);
   cdsProdutos.Post;
   cdsProdutos.EnableControls;

   vValorTotal := vValorTotal + cdsProdutos.FieldByName('VlrTotal').AsFloat;
   lblTotalPedido.Text := 'R$ ' + FormatFloat('0.00',vValorTotal);
   vAlteracao := False;
   edtCodProd.Enabled := True;
   edtCodProd.Text := '';
   edtDescricao.Text := '';
   edtQuantidade.Text := '';
   edtVlrUnitario.Text := '';
end;

procedure TfrmPedidosVenda.limpaCampos;
begin
   edtNumPedido.Text := '';
   edtCodCliente.Text := '';
   edtNomeCliente.Text := '';
   edtCodProd.Text := '';
   edtDescricao.Text := '';
   edtQuantidade.Text := '';
   edtVlrUnitario.Text := '';
   lblTotalPedido.Text := '';
   vValorTotal := 0;

   cdsProdutos.DisableControls;
   cdsProdutos.EmptyDataSet;
   cdsProdutos.EnableControls;
end;

function TfrmPedidosVenda.salvarDados: Boolean;
begin
   try
      Result := False;

      if cdsProdutos.IsEmpty then
      begin
         MessageDlg('Insira ao menos um produto para prosseguir.', TMsgDlgType.mtWarning,[TMsgDlgBtn.mbOk],0);
         Exit;
      end
      else
      if not validaCodCliente then
         Exit;

      if TCabecalhoPedidoController.get.GravaPedido(StrToInt(edtCodCliente.Text),
         vValorTotal) then
         if not TItensPedidoController.get.GravaItensPedido(buscaNumPedido, cdsProdutos) then
            Exit;

      MessageDlg('Pedido gravado com sucesso.', TMsgDlgType.mtInformation,[TMsgDlgBtn.mbOk],0);
      Result := True;
   except
      on E : Exception do
         MessageDlg(e.Message, TMsgDlgType.mtError,[TMsgDlgBtn.mbOk],0);
   end;
end;

procedure TfrmPedidosVenda.consultaPedido;
var
   xCabecalhoPedido: TCabecalhoPedido;
begin
   try
      try
         xCabecalhoPedido := nil;

         if not validaNumPedido then
            Exit;

         xCabecalhoPedido := TCabecalhoPedido.Create;
         xCabecalhoPedido := TCabecalhoPedidoController.get.BuscaPedido(edtNumPedido.Text);

         if xCabecalhoPedido = nil then
         begin
            MessageDlg('Pedido n�o cadastrado.', TMsgDlgType.mtWarning,[TMsgDlgBtn.mbOk],0);
            Exit;
         end;

         edtNumPedido.Text := IntToStr(xCabecalhoPedido.NumPedido);
         buscaCliente(IntToStr(xCabecalhoPedido.CodCliente));
         edtCodCliente.Text := IntToStr(xCabecalhoPedido.CodCliente);
         lblTotalPedido.Text := 'R$ ' + FormatFloat('0.00', xCabecalhoPedido.ValorTotal);
         TItensPedidoController.get.BuscaItensPedido(IntToStr(xCabecalhoPedido.NumPedido), cdsProdutos);
      finally
         if xCabecalhoPedido <> nil then
            FreeAndNil(xCabecalhoPedido);
      end;
   except
      on E : Exception do
         MessageDlg(e.Message, TMsgDlgType.mtError,[TMsgDlgBtn.mbOk],0);
   end;
end;

function TfrmPedidosVenda.buscaNumPedido: Integer;
begin
   Result := TCabecalhoPedidoController.get.BuscaUltimoPedido;
end;

procedure TfrmPedidosVenda.deletarPedido;
var
   xCabecalhoPedido: TCabecalhoPedido;
begin
   try
      try
         xCabecalhoPedido := nil;

         if not validaNumPedido then
            Exit;

         xCabecalhoPedido := TCabecalhoPedido.Create;
         xCabecalhoPedido := TCabecalhoPedidoController.get.BuscaPedido(edtNumPedido.Text);

         if xCabecalhoPedido = nil then
         begin
            MessageDlg('Pedido n�o cadastrado.', TMsgDlgType.mtWarning,[TMsgDlgBtn.mbOk],0);
            Exit;
         end;

         if MessageDlg('Confirma exclus�o do pedido ' + edtNumPedido.Text + '?',
            TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = mrYes then
         begin
            TItensPedidoController.get.DeletarItensPedido(edtNumPedido.Text);
            TCabecalhoPedidoController.get.DeletarCabecalhoPedido(edtNumPedido.Text);
            MessageDlg('Pedido deletado com sucesso.', TMsgDlgType.mtInformation,[TMsgDlgBtn.mbOk],0);
            vOpcaoTela := '';
            tratamentoTela;
         end;
      finally
         if xCabecalhoPedido <> nil then
            FreeAndNil(xCabecalhoPedido);
      end;
   except
      on E : Exception do
         MessageDlg(e.Message, TMsgDlgType.mtError,[TMsgDlgBtn.mbOk],0);
   end;
end;


end.
