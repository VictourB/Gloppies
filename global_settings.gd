extends Node

var gloppie_skin_index = 0 

var music_enabled : bool
var sfx_enabled : bool
var fullscreen : bool

var music_volume : float
var sfx_volume : float

const GREENSK = preload("res://Player/player_green_skin.tres")
const BLUESK = preload("res://Player/player_blue_skin.tres")
const ORANSK = preload("res://Player/player_orange_skin.tres")
const PEASK = preload("res://Player/player_peach_skin.tres")
const PINSK = preload("res://Player/player_pink_skin.tres")

var skins = [GREENSK,BLUESK,ORANSK,PEASK,PINSK]
