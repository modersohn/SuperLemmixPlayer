{$include lem_directives.inc}

unit LemStrings;

interface

uses
  LemCore;

const
  // Important paths
  SFGraphics = 'gfx\';
    SFGraphicsGame = SFGraphics + 'game\';
    SFGraphicsCursor = SFGraphics + 'cursor\';
    SFGraphicsCursorHighRes = SFGraphics + 'cursor-hr\';
    SFGraphicsHelpers = SFGraphics + 'helpers\';
    SFGraphicsHelpersHighRes = SFGraphics + 'helpers-hr\';
    SFGraphicsMasks = SFGraphics + 'mask\';
    SFGraphicsMenu = SFGraphics + 'menu\';
    SFGraphicsPanel = SFGraphics + 'panel\';
    SFGraphicsPanelHighRes = SFGraphics + 'panel-hr\';

  SFStyles = 'styles\';
      SFDefaultStyle = 'default';
      SFPiecesTerrain = '\terrain\';
      SFPiecesTerrainHighRes = '\terrain-hr\';
      SFPiecesObjects = '\objects\';
      SFPiecesObjectsHighRes = '\objects-hr\';
      SFPiecesBackgrounds = '\backgrounds\';
      SFPiecesBackgroundsHighRes = '\backgrounds-hr\';
      SFPiecesLemmings = '\lemmings\';
      SFPiecesLemmingsHighRes = '\lemmings-hr\';
      SFPiecesEffects = '\effects\';
      SFIcons = '\icons\';
      SFTheme = 'theme.nxtm';

  SFLevels = 'levels\';
  SFReplays = 'replays\';

  SFSounds = 'sound\';
  SFMusic = 'music\';

  SFData = 'data\';
      SFDataTranslation = SFData + 'translation\';

  SFSaveData = 'settings\';

  SFTemp = 'temp\';

  // Sound effect files
  SFX_BUILDER_WARNING = 'ting';
  SFX_ASSIGN_SKILL = 'mousepre';
  SFX_ASSIGN_FAIL = 'assignfail';
  SFX_YIPPEE = 'yippee';
  SFX_OING = 'oing';
  SFX_SPLAT = 'splat';
  SFX_LETSGO = 'letsgo';
  SFX_ENTRANCE = 'door';
  SFX_EXIT_OPEN = 'exitopen';
  SFX_VAPORIZING = 'fire';
  SFX_FREEZING = 'ice';
  SFX_VINETRAPPING = 'weedgulp';
  SFX_DROWNING = 'glug';
  SFX_EXPLOSION = 'explode';
  SFX_HITS_STEEL = 'chink';
  SFX_OHNO = 'ohno';
  SFX_SKILLBUTTON = 'changeop';
  SFX_CHANGE_RR = 'changerr';
  SFX_PICKUP = 'oing2';
  SFX_COLLECT = 'collect';
  SFX_ALLCOLLECT = 'allcollect';
  SFX_APPLAUSE = 'applause';
  SFX_SWIMMING = 'splash';
  SFX_FALLOUT = 'die';
  SFX_FIXING = 'wrench';
  SFX_ZOMBIE = 'zombie';
  SFX_ZOMBIE_OHNO = 'zombieohno';
  SFX_ZOMBIE_DIE = 'zombiedie';
  SFX_ZOMBIE_SPLAT = 'zombiesplat';
  SFX_ZOMBIE_PICKUP = 'zombiepickup';
  SFX_ZOMBIE_LAUGH = 'zombielaugh';
  SFX_ZOMBIE_LOLZ = 'zombielolz';
  SFX_ZOMBIE_EXIT = 'zombieyippee';
  SFX_TIMEUP = 'timeup';
  SFX_SPEAR_THROW = 'throw';
  SFX_GRENADE_THROW = 'grenade';
  SFX_SPEAR_HIT = 'spearhit';
  //SFX_BAT_SWISH = 'batswish';   // Batter
  //SFX_BAT_HIT = 'bathit';      // Batter
  SFX_LASER = 'laser';
  //SFX_PROPELLER = 'propeller'; // Propeller
  SFX_BALLOON_INFLATE = 'balloon';
  SFX_BALLOON_POP = 'balloonpop';
  SFX_JUMP = 'jump';
  SFX_BYE = 'bye';
  SFX_OK = 'OK';

resourcestring
  SProgramName = 'SuperLemmix Player';
  SDummyString = '';

  {-------------------------------------------------------------------------------
    PreviewScreen
  -------------------------------------------------------------------------------}
  SPreviewSave = ' To Be Saved';
  SPreviewReleaseRate = 'Release Rate ';
  SPreviewSpawnInterval = 'Spawn Interval ';
  SPreviewRRLocked = ' (Locked)';
  SPreviewTimeLimit = 'Time Limit ';
  SPreviewGroup = 'Group: ';
  SPreviewAuthor = 'By ';

  {-------------------------------------------------------------------------------
    Game Screen Info Panel
  -------------------------------------------------------------------------------}

  SAthlete = 'Athlete';
  STriathlete = 'Triathlete';
  SQuadathlete = 'Superstar';
  SQuintathlete = 'Legend';

  SWalker = 'Walker';
  SAscender = 'Ascender';
  SDigger = 'Digger';
  SClimber = 'Climber';
  SDrowner = 'Drowner';
  SHoister = 'Hoister';
  SBuilder = 'Builder';
  SBasher = 'Basher';
  SMiner = 'Miner';
  SFaller = 'Faller';
  SFloater = 'Floater';
  SSplatter = 'Splatter';
  SExiter = 'Exiter';
  SVaporizer = 'Vaporizer';
  SVinetrapper = 'Vinetrapper';
  SBlocker = 'Blocker';
  SShrugger = 'Shrugger';
  STimebomber = 'Timebomber';
  SExploder = 'Exploder';
  SLadderer = 'Ladderer';
  SPlatformer = 'Platformer';
  SStacker = 'Stacker';
  SFreezer = 'Freezer';
  SSwimmer = 'Swimmer';
  SGlider = 'Glider';
  SDisarmer = 'Disarmer';
  SCloner = 'Cloner';
  SFencer = 'Fencer';
  SReacher = 'Reacher';
  SShimmier = 'Shimmier';
  STurner = 'Turner';
  SJumper = 'Jumper';
  SDehoister = 'Dehoister';
  SSlider = 'Slider';
  SDangler = 'Dangler';
  SSpearer = 'Spearer';
  SGrenader = 'Grenader';
  SLooker = 'Looker';
  SLaserer = 'Laserer';
  //SPropeller = 'Propeller'; // Propeller
  SZombie = 'Zombie';
  SNeutral = 'Neutral';
  SNeutralZombie = 'N-Zombie';
  SRival = 'Rival';
  SInvincible = 'Invincible';
  SBallooner = 'Ballooner';
  SDrifter = 'Drifter';
  //SBatter = 'Batter';  // Batter
  SSleeper = 'Sleeper';

  SRadiator = 'Radiator';
  SSlowfreezer = 'Slowfreezer';

  {-------------------------------------------------------------------------------
    Postview Screen
  -------------------------------------------------------------------------------}
  SYourTimeIsUp =
    'Your time is up!';

  STalismanUnlocked =
    'You unlocked a talisman!';

  SYouRescued = 'You rescued ';
  SYouNeeded =  'You needed  ';
  SYourRecord = 'Your record ';

  SYourTime =       'Your time taken is  ';
  SYourTimeRecord = 'Your record time is ';
  SYourFewestSkills = 'Your fewest total skills is ';

  SOptionNextLevel = 'Next level';
  SOptionRetryLevel = 'Retry level';
  SOptionToMenu = 'Exit to menu';
  SOptionContinue = 'Continue';
  SOptionLevelSelect = 'Select level';
  SOptionLoadReplay = 'Load replay';
  SOptionSaveReplay = 'Save replay';

const
  // Needs to match TBasicLemmingAction in LemCore
  LemmingActionStrings: array[TBasicLemmingAction] of string = (
    SDummyString, // 1
    SWalker,      // 2
    SDummyString, // 3
    SAscender,    // 4
    SDigger,      // 5
    SClimber,     // 6
    SDrowner,     // 7
    SHoister,     // 8
    SBuilder,     // 9
    SBasher,      // 10
    SMiner,       // 11
    SFaller,      // 12
    SFloater,     // 13
    SSplatter,    // 14
    SExiter,      // 15
    SVaporizer,   // 16
    SVinetrapper, // 17
    SBlocker,     // 18
    SShrugger,    // 19
    STimebomber,  // 20
    STimebomber,  // 21
    SExploder,    // 22
    SExploder,    // 23
    SDummyString, // 24
    SPlatformer,  // 25
    SStacker,     // 26
    SFreezer,     // 27
    SFreezer,     // 28
    SFreezer,     // 29
    SFreezer,     // 30
    SSwimmer,     // 31
    SGlider,      // 32
    SDisarmer,    // 33
    SCloner,      // 34
    SFencer,      // 35
    SReacher,     // 36
    SShimmier,    // 37
    STurner,      // 38
    SJumper,      // 39
    SDehoister,   // 40
    SSlider,      // 41
    SDangler,     // 42
    SSpearer,     // 43
    SGrenader,    // 44
    SLooker,      // 45
    SLaserer,     // 46
    SBallooner,   // 47
    SLadderer,    // 48
    SDrifter,     // 49
    //SBatter,  // Batter
    SSleeper      // 50
    //SPropeller,   // 47  // Propeller
  );

implementation

end.


