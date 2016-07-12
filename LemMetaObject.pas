{$include lem_directives.inc}

unit LemMetaObject;

interface

uses
  Classes, SysUtils,
  Contnrs, UTools;

const
  // Object Animation Types
  oat_None                     = 0;    // the object is not animated
  oat_Triggered                = 1;    // the object is triggered by a lemming
  oat_Continuous               = 2;    // the object is always moving
  oat_Once                     = 3;    // the object is animated once at the beginning (entrance only)

  // Object Trigger Effects
  ote_None                     = 0;    // no effect (harmless)
  ote_Exit                     = 1;    // lemming reaches the exit
  ote_BlockerLeft              = 2;    // not used in DOS metadata, but reserved for 2D-objectmap
  ote_BlockerRight             = 3;    // not used in DOS metadata, but reserved for 2D-objectmap
  ote_TriggeredTrap            = 4;    // trap that animates once and kills a lemming
  ote_Drown                    = 5;    // used for watertype objects
  ote_Vaporize                 = 6;    // desintegration
  ote_OneWayWallLeft           = 7;    // bash en mine restriction (arrows)
  ote_OneWayWallRight          = 8;    // bash en mine restriction (arrows)
  ote_Steel                    = 9;    // not used by DOS metadata, but reserved for 2D-objectmap

  // Object Sound Effects
  ose_None                     = 0;     // no sound effect
  ose_SkillSelect              = 1;     // the sound you get when you click on one of the skill icons at the bottom of the screen
  ose_Entrance                 = 2;     // entrance opening (sounds like "boing")
  ose_LevelIntro               = 3;     // level intro (the "let's go" sound)
  ose_SkillAssign              = 4;     // the sound you get when you assign a skill to lemming
  ose_OhNo                     = 5;     // the "oh no" sound when a lemming is about to explode
  ose_ElectroTrap              = 6;     // sound effect of the electrode trap and zap trap,
  ose_SquishingTrap            = 7;     // sound effect of the rock squishing trap, pillar squishing trap, and spikes trap
  ose_Splattering              = 8;     // the "aargh" sound when the lemming fall down too far and splatters
  ose_RopeTrap                 = 9;     // sound effect of the rope trap and slicer trap
  ose_HitsSteel                = 10;    // sound effect when a basher/miner/digger hits steel
  ose_Unknown                  = 11;    // ? (not sure where used in game)
  ose_Explosion                = 12;    // sound effect of a lemming explosion
  ose_SpinningTrap             = 13;    // sound effect of the spinning-trap-of-death, coal pits, and fire shooters (when a lemming touches the object and dies)
  ose_TenTonTrap               = 14;    // sound effect of the 10-ton trap
  ose_BearTrap                 = 15;    // sound effect of the bear trap
  ose_Exit                     = 16;    // sound effect of a lemming exiting
  ose_Drowning                 = 17;    // sound effect of a lemming dropping into water and drowning
  ose_BuilderWarning           = 18;    // sound effect for the last 3 bricks a builder is laying down
  ose_FireTrap                 = 19;
  ose_Slurp                    = 20;
  ose_Vaccuum                  = 21;
  ose_Weed                     = 22;

type
  {-------------------------------------------------------------------------------
    This class describes interactive objects
  -------------------------------------------------------------------------------}
  TMetaObjectSizeSetting = (mos_None, mos_Horizontal, mos_Vertical, mos_Both);

  TMetaObject = class
  private
  protected
    fGS    : String;
    fPiece  : String;
    fAnimationType                : Integer; // oat_xxxx
    fStartAnimationFrameIndex     : Integer; // frame with which the animation starts?
    fAnimationFrameCount          : Integer; // number of animations
    fWidth                        : Integer; // the width of the bitmap
    fHeight                       : Integer; // the height of the bitmap
    fAnimationFrameDataSize       : Integer; // DOS only: the datasize in bytes of one frame
    fMaskOffsetFromImage          : Integer; // DOS only: the datalocation of the mask-bitmap relative to the animation
    fTriggerLeft                  : Integer; // x-offset of triggerarea (if triggered)
    fTriggerTop                   : Integer; // y-offset of triggerarea (if triggered)
    fTriggerPointX                : Integer; // trigger "point", for two-way-teleports / single teleports
    fTriggerPointY                : Integer; // ^
    fTriggerPointW                : Integer;
    fTriggerPointH                : Integer;
    fTriggerWidth                 : Integer; // width of triggerarea (if triggered)
    fTriggerHeight                : Integer; // height of triggerarea (if triggered)
    fTriggerEffect                : Integer; // ote_xxxx see dos doc
    fTriggerNext                  : Integer;
    fAnimationFramesBaseLoc       : Integer; // DOS only: data location of first frame in file (vgagr??.dat)
    fPreviewFrameIndex            : Integer; // index of preview (previewscreen)
    fSoundEffect                  : Integer; // ose_xxxx what sound to play
    fRandomStartFrame             : Boolean;
    fResizability                 : TMetaObjectSizeSetting;
    function GetIdentifier: String;
    function GetCanResize(aDir: TMetaObjectSizeSetting): Boolean;
  public
    procedure Assign(Source: TMetaObject);
  published
    property Identifier : String read GetIdentifier;
    property GS     : String read fGS write fGS;
    property Piece  : String read fPiece write fPiece;
    property AnimationType            : Integer read fAnimationType write fAnimationType;
    property StartAnimationFrameIndex : Integer read fStartAnimationFrameIndex write fStartAnimationFrameIndex;
    property AnimationFrameCount      : Integer read fAnimationFrameCount write fAnimationFrameCount;
    property Width                    : Integer read fWidth write fWidth;
    property Height                   : Integer read fHeight write fHeight;
    property AnimationFrameDataSize   : Integer read fAnimationFrameDataSize write fAnimationFrameDataSize;
    property MaskOffsetFromImage      : Integer read fMaskOffsetFromImage write fMaskOffsetFromImage;
    property TriggerLeft              : Integer read fTriggerLeft write fTriggerLeft;
    property TriggerTop               : Integer read fTriggerTop write fTriggerTop;
    property TriggerPointX            : Integer read fTriggerPointX write fTriggerPointX;
    property TriggerPointY            : Integer read fTriggerPointY write fTriggerPointY;
    property TriggerPointW            : Integer read fTriggerPointW write fTriggerPointW;
    property TriggerPointH            : Integer read fTriggerPointH write fTriggerPointH;
    property TriggerWidth             : Integer read fTriggerWidth write fTriggerWidth;
    property TriggerHeight            : Integer read fTriggerHeight write fTriggerHeight;
    property TriggerEffect            : Integer read fTriggerEffect write fTriggerEffect;
    property TriggerNext              : Integer read fTriggerNext write fTriggerNext;
    property AnimationFramesBaseLoc   : Integer read fAnimationFramesBaseLoc write fAnimationFramesBaseLoc;
    property PreviewFrameIndex        : Integer read fPreviewFrameIndex write fPreviewFrameIndex;
    property SoundEffect              : Integer read fSoundEffect write fSoundEffect;
    property RandomStartFrame         : Boolean read fRandomStartFrame write fRandomStartFrame;
    property Resizability             : TMetaObjectSizeSetting read fResizability write fResizability;
    property CanResizeHorizontal      : Boolean index mos_Horizontal read GetCanResize;
    property CanResizeVertical        : Boolean index mos_Vertical read GetCanResize;
  end;

  TMetaObjects = class(TObjectList)
    private
      function GetItem(Index: Integer): TMetaObject;
    public
      constructor Create;
      function Add: TMetaObject;
      function Insert(Index: Integer): TMetaObject;
      property Items[Index: Integer]: TMetaObject read GetItem; default;
      property List;
  end;

implementation

procedure TMetaObject.Assign(Source: TMetaObject);
var
  M: TMetaObject absolute Source;
begin

  fAnimationType                := M.fAnimationType;
  fStartAnimationFrameIndex     := M.fStartAnimationFrameIndex;
  fAnimationFrameCount          := M.fAnimationFrameCount;
  fWidth                        := M.fWidth;
  fHeight                       := M.fHeight;
  fAnimationFrameDataSize       := M.fAnimationFrameDataSize;
  fMaskOffsetFromImage          := M.fMaskOffsetFromImage;
  fTriggerLeft                  := M.fTriggerLeft;
  fTriggerTop                   := M.fTriggerTop;
  fTriggerWidth                 := M.fTriggerWidth;
  fTriggerHeight                := M.fTriggerHeight;
  fTriggerEffect                := M.fTriggerEffect;
  fTriggerNext                  := M.fTriggerNext;
  fAnimationFramesBaseLoc       := M.fAnimationFramesBaseLoc;
  fPreviewFrameIndex            := M.fPreviewFrameIndex;
  fSoundEffect                  := M.fSoundEffect;

end;

function TMetaObject.GetIdentifier: String;
begin
  Result := LowerCase(fGS + ':' + fPiece);
end;

function TMetaObject.GetCanResize(aDir: TMetaObjectSizeSetting): Boolean;
begin
  if fResizability = mos_none then
    Result := false
  else
    Result := (aDir = fResizability) or (fResizability = mos_Both);
end;

{ TMetaObjects }

constructor TMetaObjects.Create;
var
  aOwnsObjects: Boolean;
begin
  aOwnsObjects := true;
  inherited Create(aOwnsObjects);
end;

function TMetaObjects.Add: TMetaObject;
begin
  Result := TMetaObject.Create;
  inherited Add(Result);
end;

function TMetaObjects.Insert(Index: Integer): TMetaObject;
begin
  Result := TMetaObject.Create;
  inherited Insert(Index, Result);
end;

function TMetaObjects.GetItem(Index: Integer): TMetaObject;
begin
  Result := inherited Get(Index);
end;

end.


