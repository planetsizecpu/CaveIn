Red [Needs: 'View
	Title:   "Cave-In"
	Author:  "@planetsizecpu"
	File:    "Cave.red"
] 

; Credit to @rebolek for help on "make face" syntax & browser behavior
; Credit to @toomasv for "play" music dialect porting (not implemented yet) & browser behavior
; Credit to @gltewald for help on png files transparency
; Credit to @endo64 for help on difficulty level

system/view/auto-sync?:  yes

; Load librarys
#include %loadlevel.red
#include %makegame.red
	
; Game data & defaults object
GameData: make object! [
	Levels: ["L1" "L2" "L3" "L4" "L5" "L6" "L7" "L8" "L9" "L10"] 
	GameRate: 0:00:00.005 
	CaveName: "cave"
	CaveFace: object []
	PlayerFace: object [image: []] ;image must be defined to avoid error when compile to release mode
	Items: [] 
	Curlevel: "" 
	Stock: 0 
	Goldbags: 0
	Gravity: 3
	Antigravity: 3
	DropGravity: 3
	Slide: false
	StepValue: 2
	Inertia: 0.5
	MaxInertia: 2.0
	AddInertia: 0.02
	CeilingDist: 25
	ThiefDeadDelay: 0.1
	SpiderDeadDelay: 0.01
	AgentDeadDelay: 0.03
	AgentRate: 0:00:00.05
	KnockAltitude: 10
	FallingFaceAltitude: 15
	GetupAltitude: 40
	DeadAltitude: 60
	KartStopDelay: 100
	LifterStopDelay: 100
	TerrainColor: 187.145.0.0
	StairsColor1: 68.68.68.0
	StairsColor2: 127.127.127.0
	HandleColor: 195.195.195.0
	LifterCable: 128.64.64.0
	ThiefGetup: [ThiefGetup-X1 ThiefGetup-X2]
	ThiefDead: [ThiefDead-X1 ThiefDead-X2 ThiefDead-X3 ThiefDead-X4]
	AgentGetup: [AgentGetup-X1 AgentGetup-X2]
	AgentDead: [AgentDead-X1 AgentDead-X2 AgentDead-X3 AgentDead-X4]
	FAgentGetup: [FAgentGetup-X1 FAgentGetup-X2]
	FAgentDead: [FAgentDead-X1 FAgentDead-X2 FAgentDead-X3 FAgentDead-X4]
	SpiderDead: [SpiderDead-X1 SpiderDead-X2 SpiderDead-X3 SpiderDead-X4]
	DropDead: [DropDead-X1 DropDead-X2 DropDead-X3 DropDead-X4]
]

; Set game screen layout
GameScr: layout [
	title "Cave-In"
	size 800x750
	origin 0x0
	space 0x0
	
	; Info field is used for event management!
	at 10x610 info: base 780x30 orange blue font [name: "Arial" size: 14 style: 'bold] focus 
	rate GameData/GameRate on-time [
		info/rate: none 
		if CheckStatus [alert "END OF GAME" quit] 
		info/rate: GameData/GameRate
	]
	below
	at 10x655  Glevel: text 100x21 orange blue font [name: "Arial" size: 14 style: 'bold]
	at 150x655 Glives: text 100x21 orange blue font [name: "Arial" size: 14 style: 'bold]
	at 290x655 Gstock: text 100x21 orange blue font [name: "Arial" size: 14 style: 'bold]
	at 430x655 Ggbags: text 100x21 orange blue font [name: "Arial" size: 14 style: 'bold]										
	at 10x685  Gdeasy: radio orange blue "Easy"   on-change [CheckDifficulty]
	at 150x685  Gdnorm: radio orange blue "Normal" on-change [CheckDifficulty]
	at 290x685  Gddiff: radio orange blue "Difficult" on-change [CheckDifficulty]
	at 430x685  Gdexpe: radio orange blue "Expert" on-change [CheckDifficulty]
]

; Open browser to red-lang HQ
OpenBrowser: function [face event][
	if event/type = 'up [
		if (event/offset > 600x525) and (event/offset < 800x570) [
			print "Thanks for visiting us!"
			browse http://www.red-lang.org
		]
	]
]

; Check for agents rate adder
CheckDifficulty: function [][
	if Gdeasy/data [GameData/AgentRate: 0:00:00.07 SetAgentsRate GameData/AgentRate]
	if Gdnorm/data [GameData/AgentRate: 0:00:00.05 SetAgentsRate GameData/AgentRate]
	if Gddiff/data [GameData/AgentRate: 0:00:00.04 SetAgentsRate GameData/AgentRate]
	if Gdexpe/data [GameData/AgentRate: 0:00:00.03 SetAgentsRate GameData/AgentRate]
]

; View splash screen
view/options [size 800x600 	
	  at 1x1 Splash: image 800x600 %DATA/cave-in.jpg 
	  at 650x450 button 100x50 red brick "P L A Y" on-click [unview]] [actors: context [on-up: func [face event][OpenBrowser face event]]]

; Level loading & play
GameData/Curlevel: first GameData/Levels
LoadDfltImages
LoadLevel GameData/Curlevel
MakeGame
view/options GameScr [actors: context [on-key: func [face event][CheckKeyboard face event/key]]]