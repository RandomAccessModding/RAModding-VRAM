extends Node

const AUTHORNAME_MODNAME_DIR := "RAModding-VRAM"
const AUTHORNAME_MODNAME_LOG_NAME := "RAModding-VRAM:Main"

var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""

# TODO across the board, find a way to make it so not *every* instance of *every* enemy has a reference to the skinmanager

func _init(mod_loader = ModLoader) -> void:
	mod_dir_path = ModLoaderMod.get_unpacked_dir().path_join(AUTHORNAME_MODNAME_DIR)
	# Add globals
	_add_child_class("res://mods-unpacked/RAModding-VRAM/UpgradesHelper.gd", "UpgradesHelper")
	_add_child_class("res://mods-unpacked/RAModding-VRAM/SkinManager.gd", "SkinManager")
	# Add extensions
	install_script_extensions()
	# Add translations
	add_translations()


func install_script_extensions() -> void:
	extensions_dir_path = mod_dir_path.path_join("extensions")
	# -------- BOTS --------
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("Scripts/Hosts/ChainBot/ChainBot.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("Scripts/Hosts/ShotgunBot/ShotgunBot.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("Scripts/Hosts/FlameBot/FlameBot.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("Scripts/Hosts/WheelBot/WheelBot.gd"))
	# -------- GLOBALS / AUTOLOAD --------
	# Currently, this cannot be patched. Patching it causes it to take first priority as an autoload,
	#then it loads the bots, causing their patches to fail. 
	# ModLoaderMod.install_script_extension(extensions_dir_path.path_join("Globals/GameManager.gd"))
	# -------- MISC --------
#	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("Scripts/Hosts/Enemy.gd"))
#	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("Scripts/Player/Player.gd"))
#	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("Scripts/Player/UpgradeManager.gd"))
	


func add_translations() -> void:
	translations_dir_path = mod_dir_path.path_join("translations")


func _add_child_class(child_path : String, child_name : String):
	var child = load(child_path).new()
	child.name = child_name
	add_child(child)

func _ready() -> void:
	ModLoaderLog.info("Ready!", AUTHORNAME_MODNAME_LOG_NAME)
	print("Modded! Woohoo!")
	#print(UpgradesHelper.register_upgrade("test", "res://icon.png"))
