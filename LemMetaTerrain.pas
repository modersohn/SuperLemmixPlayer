{$include lem_directives.inc}
unit LemMetaTerrain;

interface

uses
  Dialogs,
  Classes, SysUtils, GR32,
  LemRenderHelpers,
  LemNeoParser, PngInterface, LemStrings, LemTypes, Contnrs;

const
  ALIGNMENT_COUNT = 8; // 8 possible combinations of Flip + Invert + Rotate

type
  TTerrainVariableProperties = record // For properties that vary based on flip / invert
    GraphicImage:        TBitmap32;
    GraphicImageHighRes: TBitmap32;
  end;
  PTerrainVariableProperties = ^TTerrainVariableProperties;

  TTerrainMetaProperty = (tv_Width, tv_Height);
                         // Integer properties only.

   TMetaTerrain = class
    private
      fGS    : String;
      fPiece  : String;

      fVariableInfo: array[0..ALIGNMENT_COUNT-1] of TTerrainVariableProperties;
      fGeneratedVariableInfo: array[0..ALIGNMENT_COUNT-1] of Boolean;

      fIsSteel        : Boolean;
      fCyclesSinceLastUse: Integer; // to improve TNeoPieceManager.Tidy

      function GetIdentifier: String;
      function GetImageIndex(Flip, Invert, Rotate: Boolean): Integer;
      function GetGraphicImage(Flip, Invert, Rotate: Boolean): TBitmap32;
      function GetGraphicImageHighRes(Flip, Invert, Rotate: Boolean): TBitmap32;
      procedure EnsureVariationMade(Flip, Invert, Rotate: Boolean);
      procedure DeriveVariation(Flip, Invert, Rotate: Boolean);

      function GetVariableProperty(Flip, Invert, Rotate: Boolean; Index: TTerrainMetaProperty): Integer;
      procedure SetVariableProperty(Flip, Invert, Rotate: Boolean; Index: TTerrainMetaProperty; const aValue: Integer);
    public
      constructor Create;
      destructor Destroy; override;
      procedure SetGraphic(aImage: TBitmap32; aImageHighRes: TBitmap32);
      procedure ClearImages;

      procedure Load(aCollection, aPiece: String);
      procedure LoadFromImage(aImage: TBitmap32; aImageHighRes: TBitmap32; aCollection, aPiece: String; aSteel: Boolean);

      property Identifier : String read GetIdentifier;
      property GraphicImage[Flip, Invert, Rotate: Boolean]: TBitmap32 read GetGraphicImage;
      property GraphicImageHighRes[Flip, Invert, Rotate: Boolean]: TBitmap32 read GetGraphicImageHighRes;
      property GS     : String read fGS write fGS;
      property Piece  : String read fPiece write fPiece;
      property Width[Flip, Invert, Rotate: Boolean] : Integer index tv_Width read GetVariableProperty;
      property Height[Flip, Invert, Rotate: Boolean]: Integer index tv_Height read GetVariableProperty;
      property IsSteel       : Boolean read fIsSteel write fIsSteel;
      property CyclesSinceLastUse: Integer read fCyclesSinceLastUse write fCyclesSinceLastUse;
  end;

  TMetaTerrains = class(TObjectList)
    private
      function GetItem(Index: Integer): TMetaTerrain;
    public
      constructor Create;
      function Add(Item: TMetaTerrain): Integer; overload;
      function Add: TMetaTerrain; overload;
      property Items[Index: Integer]: TMetaTerrain read GetItem; default;
      property List;
  end;

implementation

uses
  GameControl;

{ TMetaTerrain }

constructor TMetaTerrain.Create;
begin
  inherited;
  fVariableInfo[0].GraphicImage := TBitmap32.Create;

  if GameParams.HighResolution then
    fVariableInfo[0].GraphicImageHighRes := TBitmap32.Create;
end;

destructor TMetaTerrain.Destroy;
var
  i: Integer;
begin
  for i := 0 to ALIGNMENT_COUNT-1 do
  begin
    fVariableInfo[i].GraphicImage.Free;
    fVariableInfo[i].GraphicImageHighRes.Free;
  end;
  inherited;
end;

procedure TMetaTerrain.Load(aCollection, aPiece: String);
var
  Parser: TParser;
begin
  ClearImages;

  if not DirectoryExists(AppPath + SFStyles + aCollection + SFPiecesTerrain) then
    raise Exception.Create('TMetaTerrain.Load: Collection "' + aCollection + '" does not exist or lacks terrain.');
  SetCurrentDir(AppPath + SFStyles + aCollection + SFPiecesTerrain);

  fGS := Lowercase(aCollection);
  fPiece := Lowercase(aPiece);

  if FileExists(aPiece + '.nxmt') then
  begin
    Parser := TParser.Create;
    try
      Parser.LoadFromFile(aPiece + '.nxmt');
      fIsSteel := Parser.MainSection.Line['steel'] <> nil;
    finally
      Parser.Free;
    end;
  end;

  TPngInterface.LoadPngFile(aPiece + '.png', fVariableInfo[0].GraphicImage);

  if GameParams.HighResolution then
  begin
    if FileExists(AppPath + SFStyles + aCollection + SFPiecesTerrainHighRes + aPiece + '.png') then
      TPngInterface.LoadPngFile(AppPath + SFStyles + aCollection + SFPiecesTerrainHighRes + aPiece + '.png', fVariableInfo[0].GraphicImageHighRes)
    else
      Upscale(fVariableInfo[0].GraphicImage, umPixelart, fVariableInfo[0].GraphicImageHighRes);
  end;

  fGeneratedVariableInfo[0] := true;
end;

procedure TMetaTerrain.LoadFromImage(aImage: TBitmap32; aImageHighRes: TBitmap32; aCollection, aPiece: String; aSteel: Boolean);
begin
  ClearImages;
  fVariableInfo[0].GraphicImage.Assign(aImage);

  if GameParams.HighResolution then
  begin
    if aImageHighRes <> nil then
      fVariableInfo[0].GraphicImageHighRes.Assign(aImageHighRes)
    else
      Upscale(aImage, umPixelArt, fVariableInfo[0].GraphicImageHighRes);
  end;

  fGeneratedVariableInfo[0] := true;

  fGS := Lowercase(aCollection);
  fPiece := Lowercase(aPiece);
  fIsSteel := aSteel;
end;

procedure TMetaTerrain.ClearImages;
var
  i: Integer;
begin
  for i := 0 to ALIGNMENT_COUNT-1 do
  begin
    if fVariableInfo[i].GraphicImage <> nil then fVariableInfo[i].GraphicImage.Clear;
    if fVariableInfo[i].GraphicImageHighRes <> nil then fVariableInfo[i].GraphicImageHighRes.Clear;

    fGeneratedVariableInfo[i] := false;
  end;
end;

procedure TMetaTerrain.SetGraphic(aImage: TBitmap32; aImageHighRes: TBitmap32);
begin
  ClearImages;
  fVariableInfo[0].GraphicImage.Assign(aImage);

  if GameParams.HighResolution then
  begin
    if aImageHighRes <> nil then
      fVariableInfo[0].GraphicImageHighRes.Assign(aImageHighRes)
    else
      Upscale(aImage, umPixelArt, fVariableInfo[0].GraphicImageHighRes);
  end;

  fGeneratedVariableInfo[0] := true;
end;

procedure TMetaTerrain.SetVariableProperty(Flip, Invert, Rotate: Boolean;
  Index: TTerrainMetaProperty; const aValue: Integer);
begin
  EnsureVariationMade(Flip, Invert, Rotate);
  with fVariableInfo[GetImageIndex(Flip, Invert, Rotate)] do
  begin
    case Index of
      tv_Width: ; // remove this later, it's just here so the "else" doesn't give a syntax error
      else raise Exception.Create('TMetaTerrain.SetVariableProperty given invalid value.');
    end;
  end;
end;

function TMetaTerrain.GetImageIndex(Flip, Invert, Rotate: Boolean): Integer;
begin
  Result := 0;
  if Flip then Inc(Result, 1);
  if Invert then Inc(Result, 2);
  if Rotate then Inc(Result, 4);
end;

function TMetaTerrain.GetGraphicImage(Flip, Invert, Rotate: Boolean): TBitmap32;
var
  i: Integer;
begin
  EnsureVariationMade(Flip, Invert, Rotate);
  i := GetImageIndex(Flip, Invert, Rotate);
  Result := fVariableInfo[i].GraphicImage;
end;

function TMetaTerrain.GetGraphicImageHighRes(Flip, Invert, Rotate: Boolean): TBitmap32;
var
  i: Integer;
begin
  EnsureVariationMade(Flip, Invert, Rotate);
  i := GetImageIndex(Flip, Invert, Rotate);
  Result := fVariableInfo[i].GraphicImageHighRes;
end;

function TMetaTerrain.GetVariableProperty(Flip, Invert, Rotate: Boolean;
  Index: TTerrainMetaProperty): Integer;
begin
  EnsureVariationMade(Flip, Invert, Rotate);
  with fVariableInfo[GetImageIndex(Flip, Invert, Rotate)] do
  begin
    case Index of
      tv_Width: Result := GraphicImage.Width;
      tv_Height: Result := GraphicImage.Height;
      else raise Exception.Create('TMetaTerrain.GetVariableProperty given invalid value.');
    end;
  end;
end;

procedure TMetaTerrain.EnsureVariationMade(Flip, Invert, Rotate: Boolean);
var
  i: Integer;
begin
  i := GetImageIndex(Flip, Invert, Rotate);
  if not fGeneratedVariableInfo[i] then
    DeriveVariation(Flip, Invert, Rotate);
end;

procedure TMetaTerrain.DeriveVariation(Flip, Invert, Rotate: Boolean);
var
  i: Integer;
  BMP: TBitmap32;

  procedure CloneFromStandard;
  var
    GfxBmp, HrGfxBmp: TBitmap32;
  begin
    GfxBmp := fVariableInfo[i].GraphicImage;
    HrGfxBmp := fVariableInfo[i].GraphicImageHighRes;
    fVariableInfo[i] := fVariableInfo[0];
    fVariableInfo[i].GraphicImage := GfxBmp;
    fVariableInfo[i].GraphicImageHighRes := HrGfxBmp;
  end;
begin
  i := GetImageIndex(Flip, Invert, Rotate);
  CloneFromStandard;

  if fVariableInfo[i].GraphicImage = nil then fVariableInfo[i].GraphicImage := TBitmap32.Create;
  BMP := fVariableInfo[i].GraphicImage;
  BMP.Assign(fVariableInfo[0].GraphicImage);
  if Rotate then BMP.Rotate90;
  if Flip then BMP.FlipHorz;
  if Invert then BMP.FlipVert;

  if GameParams.HighResolution then
  begin
    if fVariableInfo[i].GraphicImageHighRes = nil then fVariableInfo[i].GraphicImageHighRes := TBitmap32.Create;
    BMP := fVariableInfo[i].GraphicImageHighRes;
    BMP.Assign(fVariableInfo[0].GraphicImageHighRes);
    if Rotate then BMP.Rotate90;
    if Flip then BMP.FlipHorz;
    if Invert then BMP.FlipVert;
  end;

  fGeneratedVariableInfo[i] := true;
end;

function TMetaTerrain.GetIdentifier: String;
begin
  Result := LowerCase(fGS + ':' + fPiece);
end;

{ TMetaTerrains }

constructor TMetaTerrains.Create;
var
  aOwnsObjects: Boolean;
begin
  aOwnsObjects := true;
  inherited Create(aOwnsObjects);
end;

function TMetaTerrains.Add(Item: TMetaTerrain): Integer;
begin
  Result := inherited Add(Item);
end;

function TMetaTerrains.Add: TMetaTerrain;
begin
  Result := TMetaTerrain.Create;
  inherited Add(Result);
end;

function TMetaTerrains.GetItem(Index: Integer): TMetaTerrain;
begin
  Result := inherited Get(Index);
end;

end.

