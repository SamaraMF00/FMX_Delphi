unit untPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  Data.FMTBcd, Data.DB, Data.SqlExpr, FMX.Controls.Presentation, FMX.MultiView,
  FMX.Objects, FMX.StdCtrls, FMX.Ani, FMX.Layouts, FMX.Effects, FMX.Edit;

type
  TfrmPrincipal = class(TForm)
    tbcPrincipal: TTabControl;
    StyleBook1: TStyleBook;
    tabInicio: TTabItem;
    mtvMenu: TMultiView;
    recFundo: TRectangle;
    btnHome: TSpeedButton;
    btnVenda: TSpeedButton;
    btnSair: TSpeedButton;
    imgHome: TImage;
    imgVenda: TImage;
    imgSair: TImage;
    txtHome: TText;
    txtVenda: TText;
    textSair: TText;
    claStartShowing: TColorAnimation;
    claStartHiding: TColorAnimation;
    layFundo: TLayout;
    recPrincipal: TRectangle;
    imgLogo: TImage;
    btnInicio: TSpeedButton;
    imgInicio: TImage;
    txtInicio: TText;
    procedure btnSairClick(Sender: TObject);
    procedure mtvMenuStartHiding(Sender: TObject);
    procedure mtvMenuStartShowing(Sender: TObject);
    procedure claStartHidingFinish(Sender: TObject);
    procedure claStartShowingFinish(Sender: TObject);
    procedure btnVendasClick(Sender: TObject);
    procedure btnInicioClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  uPedidosVenda;

{$R *.fmx}

procedure TfrmPrincipal.btnInicioClick(Sender: TObject);
begin
  tbcPrincipal.ActiveTab := tabInicio;
end;

procedure TfrmPrincipal.btnSairClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmPrincipal.claStartHidingFinish(Sender: TObject);
begin
  claStartShowing.Enabled := False;
end;

procedure TfrmPrincipal.claStartShowingFinish(Sender: TObject);
begin
  claStartHiding.Enabled := False;
end;

procedure TfrmPrincipal.mtvMenuStartHiding(Sender: TObject);
begin
  claStartHiding.Enabled := True;
end;

procedure TfrmPrincipal.mtvMenuStartShowing(Sender: TObject);
begin
  claStartShowing.Enabled := True;
end;

procedure TfrmPrincipal.btnVendasClick(Sender: TObject);
  Var
    frmVendas: TfrmPedidosVenda;
begin
  frmVendas := TfrmPedidosVenda.Create(Self);

  Try
    frmVendas.ShowModal;
  Finally
    FreeAndNil(frmVendas);
  End;
end;

end.
