extends Node

const AUTHORNAME_MODNAME_DIR := "RAModding-VRAM"
const AUTHORNAME_MODNAME_LOG_NAME := "RAModding-VRAM:Main"

var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""


func _init(mod_loader = ModLoader) -> void:
	mod_dir_path = ModLoaderMod.get_unpacked_dir().path_join(AUTHORNAME_MODNAME_DIR)
	# Add extensions
	install_script_extensions(mod_loader)
	# Add translations
	add_translations()


func install_script_extensions(mod_loader : ModLoader) -> void:
	extensions_dir_path = mod_dir_path.path_join("extensions")
#	mod_loader.install_script_extension(extensions_dir_path.path_join("Scripts/Upgrades.gd"))


func add_translations() -> void:
	translations_dir_path = mod_dir_path.path_join("translations")


func _ready() -> void:
	ModLoaderLog.info("Ready!", AUTHORNAME_MODNAME_LOG_NAME)
	print("Modded! Woohoo!")
