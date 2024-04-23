program ProjectFMX;

uses
  System.StartUpCopy,
  FMX.Forms,
  untPrincipal in 'untPrincipal.pas' {TfrmPrincipal},
  uPedidosVenda in 'View\uPedidosVenda.pas' {frmPedidosVenda},
  uCabecalhoPedidoController in 'controller\uCabecalhoPedidoController.pas',
  uClienteController in 'controller\uClienteController.pas',
  uItensPedidoController in 'controller\uItensPedidoController.pas',
  uProdutosController in 'controller\uProdutosController.pas',
  uCabecalhoPedido in 'model\uCabecalhoPedido.pas',
  uCliente in 'model\uCliente.pas',
  uConexao in 'model\uConexao.pas',
  uItensPedido in 'model\uItensPedido.pas',
  uProdutos in 'model\uProdutos.pas',
  uCabecalhoPedidoDao in 'dao\uCabecalhoPedidoDao.pas',
  uClienteDao in 'dao\uClienteDao.pas',
  uItensPedidoDao in 'dao\uItensPedidoDao.pas',
  uProdutosDao in 'dao\uProdutosDao.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
